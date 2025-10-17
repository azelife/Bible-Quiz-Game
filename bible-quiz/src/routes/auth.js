/**
 * Authentication route handlers
 */

import { jsonResponse, errorResponse } from '../utils/response.js';
import { verifyPassword, createSession, destroySession } from '../utils/auth.js';

/**
 * Main auth router
 */
export async function handleAuth(request, env) {
  const url = new URL(request.url);
  const path = url.pathname;

  if (path === '/api/auth/login' && request.method === 'POST') {
    return await handleLogin(request, env);
  }

  if (path === '/api/auth/logout' && request.method === 'POST') {
    return await handleLogout(request, env);
  }

  if (path === '/api/auth/verify' && request.method === 'GET') {
    return await handleVerify(request, env);
  }

  return errorResponse('Auth route not found', 404);
}

/**
 * POST /api/auth/login
 * Authenticates user and creates session
 */
async function handleLogin(request, env) {
  try {
    const body = await request.json();
    const { username, password } = body;

    console.log('Login attempt for username:', username);

    // Validate input
    if (!username || !password) {
      console.log('Validation failed: missing username or password');
      return errorResponse('Username and password required', 400);
    }

    // Fetch user from database
    console.log('Querying database for user:', username);
    
    const user = await env.DB.prepare(
      'SELECT id, username, password_hash, salt, role, game_instance_id FROM users WHERE username = ?'
    ).bind(username).first();

    console.log('Database query result:', user ? 'User found' : 'User NOT found');
    
    if (user) {
      console.log('User details:', {
        id: user.id,
        username: user.username,
        role: user.role,
        game_instance_id: user.game_instance_id,
        has_password_hash: !!user.password_hash,
        has_salt: !!user.salt
      });
    } else {
      console.log('No user found with username:', username);
      
      // Let's check what users exist in the database
      const allUsers = await env.DB.prepare(
        'SELECT id, username, role FROM users LIMIT 10'
      ).all();
      
      console.log('Available users in database:', allUsers.results);
    }

    if (!user) {
      return errorResponse('Invalid credentials', 401);
    }

    // Verify password
    console.log('Verifying password...');
    const passwordValid = await verifyPassword(password, user.password_hash, user.salt);
    console.log('Password verification result:', passwordValid);
    
    if (!passwordValid) {
      return errorResponse('Invalid credentials', 401);
    }

    // Create session
    console.log('Creating session for user:', user.id);
    const sessionId = await createSession(user.id, env);
    console.log('Session created:', sessionId);

    // Initialize game state if not exists
    const existingState = await env.DB.prepare(
      'SELECT id FROM game_state WHERE game_instance_id = ?'
    ).bind(user.game_instance_id).first();

    console.log('Game state exists:', !!existingState);

    if (!existingState) {
      console.log('Initializing game state for instance:', user.game_instance_id);
      
      await env.DB.prepare(`
        INSERT INTO game_state (game_instance_id)
        VALUES (?)
      `).bind(user.game_instance_id).run();

      // Initialize team members (12 slots per team)
      const memberInserts = [];
      for (let i = 1; i <= 12; i++) {
        memberInserts.push(
          env.DB.prepare(
            'INSERT INTO team_members (game_instance_id, team, member_number) VALUES (?, ?, ?)'
          ).bind(user.game_instance_id, 'A', i).run(),
          env.DB.prepare(
            'INSERT INTO team_members (game_instance_id, team, member_number) VALUES (?, ?, ?)'
          ).bind(user.game_instance_id, 'B', i).run()
        );
      }
      await Promise.all(memberInserts);
      console.log('Game state and team members initialized');
    }

    // Set session cookie
    const sessionCookie = `session_id=${sessionId}; HttpOnly; Secure; SameSite=Strict; Max-Age=${8 * 3600}; Path=/`;

    console.log('Login successful for user:', username);

    return jsonResponse({
      success: true,
      role: user.role,
      game_instance_id: user.game_instance_id
    }, {
      headers: { 'Set-Cookie': sessionCookie }
    });

  } catch (error) {
    console.error('Login error:', error);
    console.error('Error stack:', error.stack);
    return errorResponse('Login failed', 500);
  }
}

/**
 * POST /api/auth/logout
 * Destroys session
 */
async function handleLogout(request, env) {
  try {
    const cookies = request.headers.get('Cookie') || '';
    const sessionId = cookies.split(';').find(c => c.trim().startsWith('session_id='))
      ?.split('=')[1];

    if (sessionId) {
      await destroySession(sessionId, env);
    }

    // Clear cookie
    const clearCookie = 'session_id=; HttpOnly; Secure; SameSite=Strict; Max-Age=0; Path=/';

    return jsonResponse(
      { success: true, message: 'Logged out successfully' },
      { headers: { 'Set-Cookie': clearCookie } }
    );

  } catch (error) {
    console.error('Logout error:', error);
    return errorResponse('Logout failed', 500);
  }
}

/**
 * GET /api/auth/verify
 * Verifies current session validity
 */
async function handleVerify(request, env) {
  try {
    const cookies = request.headers.get('Cookie') || '';
    const sessionId = cookies.split(';').find(c => c.trim().startsWith('session_id='))
      ?.split('=')[1];

    if (!sessionId) {
      return errorResponse('No session found', 401);
    }

    // Verify session
    const session = await env.DB.prepare(`
      SELECT s.id, s.user_id, s.expires_at, u.role, u.game_instance_id
      FROM sessions s
      JOIN users u ON s.user_id = u.id
      WHERE s.id = ? AND s.expires_at > datetime('now')
    `).bind(sessionId).first();

    if (!session) {
      return errorResponse('Session expired', 401);
    }

    // Update last activity
    await env.DB.prepare(
      'UPDATE sessions SET last_activity = datetime("now") WHERE id = ?'
    ).bind(sessionId).run();

    return jsonResponse({
      valid: true,
      role: session.role,
      game_instance_id: session.game_instance_id
    });

  } catch (error) {
    console.error('Verify error:', error);
    return errorResponse('Verification failed', 500);
  }
}
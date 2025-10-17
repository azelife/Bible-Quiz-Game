/**
 * Test/Fix Password Hashing
 */

import { hashPassword, verifyPassword, generateSalt } from './utils/auth.js';
import { jsonResponse } from './utils/response.js';

export async function handlePasswordTest(request, env) {
  try {
    const url = new URL(request.url);
    const username = url.searchParams.get('username');
    const password = url.searchParams.get('password');

    if (!username || !password) {
      return jsonResponse({ error: 'Need username and password params' }, { status: 400 });
    }

    const user = await env.DB.prepare(
      'SELECT id, username, password_hash, salt FROM users WHERE username = ?'
    ).bind(username).first();

    if (!user) {
      return jsonResponse({ error: 'User not found' }, { status: 404 });
    }

    const currentValid = await verifyPassword(password, user.password_hash, user.salt);
    const newHash = await hashPassword(password, user.salt);
    const newSalt = generateSalt();
    const freshHash = await hashPassword(password, newSalt);

    return jsonResponse({
      username: user.username,
      current_password_valid: currentValid,
      hashes_match: newHash === user.password_hash,
      recommendation: currentValid 
        ? 'Password is correct!' 
        : 'Password does not match. Use /api/test/reset-password to fix.'
    });
  } catch (error) {
    console.error('Password test error:', error);
    return jsonResponse({ error: error.message }, { status: 500 });
  }
}

export async function handlePasswordReset(request, env) {
  try {
    const body = await request.json();
    const { username, password } = body;

    console.log('Reset password request:', { username, hasPassword: !!password });

    if (!username || !password) {
      return jsonResponse({ error: 'Username and password required' }, { status: 400 });
    }

    const salt = generateSalt();
    const hash = await hashPassword(password, salt);

    console.log('Generated hash and salt for:', username);

    const result = await env.DB.prepare(
      'UPDATE users SET password_hash = ?, salt = ? WHERE username = ?'
    ).bind(hash, salt, username).run();

    console.log('Update result:', result);

    if (result.changes === 0) {
      return jsonResponse({ error: 'User not found' }, { status: 404 });
    }

    const verification = await verifyPassword(password, hash, salt);

    return jsonResponse({
      success: true,
      username,
      verification_test: verification,
      message: 'Password reset successfully!'
    });

  } catch (error) {
    console.error('Password reset error:', error);
    return jsonResponse({ error: error.message }, { status: 500 });
  }
}
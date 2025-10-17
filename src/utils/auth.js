/**
 * Authentication utilities for Cloudflare Workers
 * Uses Web Crypto API instead of Node.js crypto
 */

/**
 * Convert string to Uint8Array
 */
function stringToUint8Array(str) {
  return new TextEncoder().encode(str);
}

/**
 * Convert hex string to Uint8Array
 */
function hexToUint8Array(hex) {
  const bytes = new Uint8Array(hex.length / 2);
  for (let i = 0; i < hex.length; i += 2) {
    bytes[i / 2] = parseInt(hex.substr(i, 2), 16);
  }
  return bytes;
}

/**
 * Convert Uint8Array to hex string
 */
function uint8ArrayToHex(arr) {
  return Array.from(arr)
    .map(b => b.toString(16).padStart(2, '0'))
    .join('');
}

/**
 * Hash password using PBKDF2 with Web Crypto API
 * @param {string} password - Plain text password
 * @param {string} saltHex - Salt as hex string
 * @returns {Promise<string>} - Password hash as hex string
 */
export async function hashPassword(password, saltHex) {
  const passwordBuffer = stringToUint8Array(password);
  const saltBuffer = hexToUint8Array(saltHex);
  
  // Import password as key material
  const keyMaterial = await crypto.subtle.importKey(
    'raw',
    passwordBuffer,
    { name: 'PBKDF2' },
    false,
    ['deriveBits']
  );
  
  // Derive key using PBKDF2
  const derivedBits = await crypto.subtle.deriveBits(
    {
      name: 'PBKDF2',
      salt: saltBuffer,
      iterations: 100000,
      hash: 'SHA-512'
    },
    keyMaterial,
    512 // 64 bytes = 512 bits
  );
  
  return uint8ArrayToHex(new Uint8Array(derivedBits));
}

/**
 * Verify password using PBKDF2
 * @param {string} password - Plain text password
 * @param {string} hash - Stored password hash (hex string)
 * @param {string} salt - Stored salt (hex string)
 * @returns {Promise<boolean>} - True if password matches
 */
export async function verifyPassword(password, hash, salt) {
  const derivedHash = await hashPassword(password, salt);
  return derivedHash === hash;
}

/**
 * Generate random salt using Web Crypto API
 * @returns {string} - Salt as hex string (64 characters)
 */
export function generateSalt() {
  const saltBuffer = crypto.getRandomValues(new Uint8Array(32));
  return uint8ArrayToHex(saltBuffer);
}

/**
 * Generate UUID v4 using Web Crypto API
 * @returns {string} - UUID string
 */
export function generateUUID() {
  return crypto.randomUUID();
}

/**
 * Create new session
 * @param {number} userId - User ID
 * @param {object} env - Cloudflare environment bindings
 * @returns {Promise<string>} - Session ID (UUID)
 */
export async function createSession(userId, env) {
  const sessionId = generateUUID();
  const expiresAt = new Date(Date.now() + 8 * 60 * 60 * 1000); // 8 hours
  
  await env.DB.prepare(`
    INSERT INTO sessions (id, user_id, expires_at)
    VALUES (?, ?, ?)
  `).bind(sessionId, userId, expiresAt.toISOString()).run();
  
  return sessionId;
}

/**
 * Destroy session
 * @param {string} sessionId - Session ID
 * @param {object} env - Cloudflare environment bindings
 */
export async function destroySession(sessionId, env) {
  await env.DB.prepare(
    'DELETE FROM sessions WHERE id = ?'
  ).bind(sessionId).run();
}

/**
 * Verify session and return user data
 * @param {Request} request - HTTP request
 * @param {object} env - Cloudflare environment bindings
 * @returns {Promise<object|null>} - Session object or null if invalid
 */
export async function verifySession(request, env) {
  const cookies = request.headers.get('Cookie') || '';
  const sessionId = cookies.split(';')
    .find(c => c.trim().startsWith('session_id='))
    ?.split('=')[1];
  
  if (!sessionId) return null;
  
  const session = await env.DB.prepare(`
    SELECT s.id, s.user_id, u.role, u.game_instance_id, u.username
    FROM sessions s
    JOIN users u ON s.user_id = u.id
    WHERE s.id = ? AND s.expires_at > datetime('now')
  `).bind(sessionId).first();
  
  if (!session) return null;
  
  // Update last activity
  await env.DB.prepare(
    'UPDATE sessions SET last_activity = datetime("now") WHERE id = ?'
  ).bind(sessionId).run();
  
  return session;
}

/**
 * Extract session ID from request cookies
 * @param {Request} request - HTTP request
 * @returns {string|null} - Session ID or null
 */
export function getSessionId(request) {
  const cookies = request.headers.get('Cookie') || '';
  const sessionId = cookies.split(';')
    .find(c => c.trim().startsWith('session_id='))
    ?.split('=')[1];
  return sessionId || null;
}

/**
 * Check if user has required role
 * @param {object} session - Session object
 * @param {string} requiredRole - Required role ('controller' or 'viewer')
 * @returns {boolean} - True if user has required role
 */
export function hasRole(session, requiredRole) {
  if (!session) return false;
  if (requiredRole === 'viewer') {
    // Both controllers and viewers can view
    return session.role === 'controller' || session.role === 'viewer';
  }
  return session.role === requiredRole;
}

/**
 * Refresh session expiration
 * @param {string} sessionId - Session ID
 * @param {object} env - Cloudflare environment bindings
 */
export async function refreshSession(sessionId, env) {
  const newExpiresAt = new Date(Date.now() + 8 * 60 * 60 * 1000);
  
  await env.DB.prepare(`
    UPDATE sessions 
    SET expires_at = ?, last_activity = datetime('now')
    WHERE id = ?
  `).bind(newExpiresAt.toISOString(), sessionId).run();
}

/**
 * Clean up expired sessions (for cron job)
 * @param {object} env - Cloudflare environment bindings
 * @returns {Promise<number>} - Number of sessions deleted
 */
export async function cleanupExpiredSessions(env) {
  const result = await env.DB.prepare(
    "DELETE FROM sessions WHERE expires_at < datetime('now')"
  ).run();
  
  return result.changes || 0;
}

/**
 * Get all active sessions for a user
 * @param {number} userId - User ID
 * @param {object} env - Cloudflare environment bindings
 * @returns {Promise<Array>} - Array of session objects
 */
export async function getUserSessions(userId, env) {
  const sessions = await env.DB.prepare(`
    SELECT id, expires_at, last_activity
    FROM sessions
    WHERE user_id = ? AND expires_at > datetime('now')
    ORDER BY last_activity DESC
  `).bind(userId).all();
  
  return sessions.results || [];
}

/**
 * Destroy all sessions for a user (logout from all devices)
 * @param {number} userId - User ID
 * @param {object} env - Cloudflare environment bindings
 * @returns {Promise<number>} - Number of sessions deleted
 */
export async function destroyAllUserSessions(userId, env) {
  const result = await env.DB.prepare(
    'DELETE FROM sessions WHERE user_id = ?'
  ).bind(userId).run();
  
  return result.changes || 0;
}
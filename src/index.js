/**
 * Bible Quiz Dashboard - Main Worker Entry Point
 * Cloudflare Workers + D1 + Static Assets
 */

import { handleAuth } from './routes/auth.js';
import { handleControl } from './routes/control.js';
import { handleViewer } from './routes/viewer.js';
import { handleAdmin } from './routes/admin.js';
import { handlePasswordTest, handlePasswordReset } from './test-password.js';
import { errorResponse } from './utils/response.js';
import { verifySession } from './utils/auth.js';

export default {
  /**
   * Main request handler
   */
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const path = url.pathname;

    // CORS headers for API requests
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    };

    // Handle preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    try {
      // Password testing routes (REMOVE THESE IN PRODUCTION!)
      if (path === '/api/test/password' && request.method === 'GET') {
        const response = await handlePasswordTest(request, env);
        Object.entries(corsHeaders).forEach(([k, v]) => response.headers.set(k, v));
        return response;  // ← Make sure this returns!
      }

      if (path === '/api/test/reset-password' && request.method === 'POST') {
        const response = await handlePasswordReset(request, env);
        Object.entries(corsHeaders).forEach(([k, v]) => response.headers.set(k, v));
        return response;  // ← Make sure this returns!
      }

      // Route API requests
      if (path.startsWith('/api/auth/')) {
        const response = await handleAuth(request, env);
        Object.entries(corsHeaders).forEach(([k, v]) => response.headers.set(k, v));
        return response;
      }

      if (path.startsWith('/api/control/')) {
        const session = await verifySession(request, env);
        if (!session || session.role !== 'controller') {
          return errorResponse('Unauthorized', 401);
        }
        const response = await handleControl(request, env, session);
        Object.entries(corsHeaders).forEach(([k, v]) => response.headers.set(k, v));
        return response;
      }

      if (path.startsWith('/api/viewer/')) {
        const session = await verifySession(request, env);
        if (!session) {
          return errorResponse('Unauthorized', 401);
        }
        const response = await handleViewer(request, env, session);
        Object.entries(corsHeaders).forEach(([k, v]) => response.headers.set(k, v));
        return response;
      }

      if (path.startsWith('/api/admin/')) {
        const session = await verifySession(request, env);
        if (!session || session.role !== 'controller') {
          return errorResponse('Unauthorized', 401);
        }
        const response = await handleAdmin(request, env, session);
        Object.entries(corsHeaders).forEach(([k, v]) => response.headers.set(k, v));
        return response;
      }

      // Let Cloudflare serve static assets from /public
      // This includes: index.html, control.html, viewer.html, CSS, JS
      return env.ASSETS.fetch(request);

    } catch (error) {
      console.error('Worker error:', error);
      return errorResponse('Internal server error', 500);
    }
  },

  /**
   * Cron trigger for cleanup (runs daily at 2 AM)
   */
  async scheduled(event, env, ctx) {
    try {
      // Delete expired sessions
      await env.DB.prepare(
        "DELETE FROM sessions WHERE expires_at < datetime('now')"
      ).run();

      // Delete old undo history (keep last 24 hours)
      await env.DB.prepare(
        "DELETE FROM undo_history WHERE created_at < datetime('now', '-1 day')"
      ).run();

      console.log('Cleanup completed successfully');
    } catch (error) {
      console.error('Cleanup error:', error);
    }
  }
};
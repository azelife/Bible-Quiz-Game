/**
 * Response utilities for Cloudflare Workers
 * Standardized JSON responses and error handling
 */

/**
 * Create a JSON response
 * @param {object} data - Response data
 * @param {object} options - Response options (status, headers)
 * @returns {Response} - Cloudflare Response object
 */
export function jsonResponse(data, options = {}) {
  return new Response(JSON.stringify(data), {
    status: options.status || 200,
    headers: {
      'Content-Type': 'application/json',
      'Cache-Control': 'no-store, no-cache, must-revalidate',
      ...options.headers
    }
  });
}

/**
 * Create an error response
 * @param {string} message - Error message
 * @param {number} status - HTTP status code (default: 400)
 * @returns {Response} - Cloudflare Response object
 */
export function errorResponse(message, status = 400) {
  return jsonResponse(
    { 
      success: false, 
      error: message 
    },
    { status }
  );
}

/**
 * Create a success response
 * @param {object} data - Success data
 * @param {string} message - Success message (optional)
 * @returns {Response} - Cloudflare Response object
 */
export function successResponse(data = {}, message = null) {
  const response = { 
    success: true,
    ...data
  };
  
  if (message) {
    response.message = message;
  }
  
  return jsonResponse(response);
}

/**
 * Create a validation error response
 * @param {Array<string>} errors - Array of validation error messages
 * @returns {Response} - Cloudflare Response object
 */
export function validationErrorResponse(errors) {
  return jsonResponse(
    {
      success: false,
      error: 'Validation failed',
      errors: errors
    },
    { status: 422 }
  );
}

/**
 * Create an unauthorized response
 * @param {string} message - Error message (default: 'Unauthorized')
 * @returns {Response} - Cloudflare Response object
 */
export function unauthorizedResponse(message = 'Unauthorized') {
  return errorResponse(message, 401);
}

/**
 * Create a forbidden response
 * @param {string} message - Error message (default: 'Forbidden')
 * @returns {Response} - Cloudflare Response object
 */
export function forbiddenResponse(message = 'Forbidden') {
  return errorResponse(message, 403);
}

/**
 * Create a not found response
 * @param {string} message - Error message (default: 'Not found')
 * @returns {Response} - Cloudflare Response object
 */
export function notFoundResponse(message = 'Not found') {
  return errorResponse(message, 404);
}

/**
 * Create a server error response
 * @param {string} message - Error message (default: 'Internal server error')
 * @returns {Response} - Cloudflare Response object
 */
export function serverErrorResponse(message = 'Internal server error') {
  return errorResponse(message, 500);
}

/**
 * Create a redirect response
 * @param {string} url - Redirect URL
 * @param {number} status - HTTP status code (default: 302)
 * @returns {Response} - Cloudflare Response object
 */
export function redirectResponse(url, status = 302) {
  return new Response(null, {
    status: status,
    headers: {
      'Location': url
    }
  });
}

/**
 * Create CORS headers
 * @param {string} origin - Allowed origin (default: '*')
 * @returns {object} - CORS headers object
 */
export function corsHeaders(origin = '*') {
  return {
    'Access-Control-Allow-Origin': origin,
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Access-Control-Max-Age': '86400',
  };
}

/**
 * Create a preflight response (for OPTIONS requests)
 * @param {string} origin - Allowed origin (default: '*')
 * @returns {Response} - Cloudflare Response object
 */
export function preflightResponse(origin = '*') {
  return new Response(null, {
    status: 204,
    headers: corsHeaders(origin)
  });
}

/**
 * Wrap response with CORS headers
 * @param {Response} response - Original response
 * @param {string} origin - Allowed origin (default: '*')
 * @returns {Response} - Response with CORS headers
 */
export function withCors(response, origin = '*') {
  const newHeaders = new Headers(response.headers);
  Object.entries(corsHeaders(origin)).forEach(([key, value]) => {
    newHeaders.set(key, value);
  });
  
  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers: newHeaders
  });
}
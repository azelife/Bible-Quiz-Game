/**
 * User Password Hash Generator
 * Run: node generate-users.js
 * 
 * This script generates Argon2id password hashes for manual insertion into D1
 */

const crypto = require('crypto');

/**
 * Hash password using PBKDF2 (Node.js compatible alternative to Argon2id)
 * Cloudflare Workers will use Web Crypto API
 */
async function hashPassword(password, salt) {
  return new Promise((resolve, reject) => {
    crypto.pbkdf2(password, salt, 100000, 64, 'sha512', (err, derivedKey) => {
      if (err) reject(err);
      resolve(derivedKey.toString('hex'));
    });
  });
}

/**
 * Generate user credentials
 */
async function generateUser(username, password, role, gameInstanceId) {
  // Generate random salt (32 bytes)
  const salt = crypto.randomBytes(32).toString('hex');
  
  // Hash password
  const passwordHash = await hashPassword(password, salt);
  
  // Generate SQL INSERT statement
  const sql = `INSERT INTO users (username, password_hash, salt, role, game_instance_id) VALUES ('${username}', '${passwordHash}', '${salt}', '${role}', '${gameInstanceId}');`;
  
  console.log('\n' + '='.repeat(80));
  console.log(`User: ${username}`);
  console.log(`Role: ${role}`);
  console.log(`Game Instance: ${gameInstanceId}`);
  console.log('='.repeat(80));
  console.log('\nSQL Command (run in D1 console):');
  console.log(sql);
  console.log('\n');
}

/**
 * Generate UUID v4
 */
function generateUUID() {
  return crypto.randomUUID();
}

// ============================================================================
// CONFIGURATION - Edit these to create your users
// ============================================================================

async function main() {
  console.log('\n🔐 Bible Quiz Dashboard - User Generator\n');
  
  // Generate unique game instance IDs
  const instance1 = generateUUID();
  const instance2 = generateUUID();
  
  console.log('Generated Game Instance IDs:');
  console.log(`Instance 1: ${instance1}`);
  console.log(`Instance 2: ${instance2}`);
  
  // Example users - CHANGE THESE VALUES
  await generateUser(
    'user1',           // Username
    'user1pass',        // Password (CHANGE THIS!)
    'controller',            // Role: 'controller' or 'viewer'
    instance1                // Game instance ID
  );
  
  await generateUser(
    'user1v',
    'user1pass1',          // Password (CHANGE THIS!)
    'viewer',
    instance1                // Same instance = shared game
  );
  
  await generateUser(
    'user2',
    'user2pass',       // Password (CHANGE THIS!)
    'controller',
    instance2                // Different instance = isolated game
  );
  
  await generateUser(
    'user2v',
    'user2pass1',        // Password (CHANGE THIS!)
    'viewer',
    instance2
  );
  
  console.log('✅ User generation complete!\n');
  console.log('📝 Copy the SQL commands above and run them in your D1 console:');
  console.log('   npx wrangler d1 execute bible-quiz-db --command="<SQL_HERE>"\n');
}

main().catch(console.error);
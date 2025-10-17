/**
 * Generate Users with Secure Passwords
 * Run with: node scripts/generate_users.js
 */

import crypto from 'crypto';

/**
 * Hash password using PBKDF2 with 100,000 iterations
 */
function hashPassword(password, salt) {
  return crypto.pbkdf2Sync(
    password,
    Buffer.from(salt, 'hex'),
    100000,
    32,
    'sha256'
  ).toString('hex');
}

/**
 * Generate random salt
 */
function generateSalt() {
  return crypto.randomBytes(32).toString('hex');
}

/**
 * Generate SQL for user creation
 */
function generateUser(username, password, role, gameInstanceId) {
  const salt = generateSalt();
  const passwordHash = hashPassword(password, salt);

  return {
    username,
    passwordHash,
    salt,
    role,
    gameInstanceId,
    sql: `INSERT INTO users (username, password_hash, salt, role, game_instance_id)
VALUES ('${username}', '${passwordHash}', '${salt}', '${role}', '${gameInstanceId}');`
  };
}

/**
 * Generate UUID
 */
function generateUUID() {
  return crypto.randomUUID();
}

// Example usage
console.log('=== Bible Quiz Dashboard - User Generation ===\n');

// Generate game instance IDs
const gameInstance1 = generateUUID();
const gameInstance2 = generateUUID();

console.log('Generated Game Instance IDs:');
console.log(`Instance 1: ${gameInstance1}`);
console.log(`Instance 2: ${gameInstance2}\n`);

// Generate users for Instance 1
console.log('=== INSTANCE 1 USERS ===\n');

const controller1 = generateUser('controller1', 'SecurePass123!', 'controller', gameInstance1);
console.log('Controller User:');
console.log(`Username: ${controller1.username}`);
console.log(`Password: SecurePass123!`);
console.log(`Role: ${controller1.role}`);
console.log(`Game Instance: ${controller1.gameInstanceId}`);
console.log('\nSQL:');
console.log(controller1.sql);
console.log('\n---\n');

const viewer1 = generateUser('viewer1', 'ViewPass456!', 'viewer', gameInstance1);
console.log('Viewer User:');
console.log(`Username: ${viewer1.username}`);
console.log(`Password: ViewPass456!`);
console.log(`Role: ${viewer1.role}`);
console.log(`Game Instance: ${viewer1.gameInstanceId}`);
console.log('\nSQL:');
console.log(viewer1.sql);
console.log('\n---\n');

// Generate users for Instance 2
console.log('=== INSTANCE 2 USERS ===\n');

const controller2 = generateUser('controller2', 'AdminPass789!', 'controller', gameInstance2);
console.log('Controller User:');
console.log(`Username: ${controller2.username}`);
console.log(`Password: AdminPass789!`);
console.log(`Role: ${controller2.role}`);
console.log(`Game Instance: ${controller2.gameInstanceId}`);
console.log('\nSQL:');
console.log(controller2.sql);
console.log('\n---\n');

const viewer2 = generateUser('viewer2', 'WatchPass101!', 'viewer', gameInstance2);
console.log('Viewer User:');
console.log(`Username: ${viewer2.username}`);
console.log(`Password: WatchPass101!`);
console.log(`Role: ${viewer2.role}`);
console.log(`Game Instance: ${viewer2.gameInstanceId}`);
console.log('\nSQL:');
console.log(viewer2.sql);
console.log('\n---\n');

// Generate combined SQL file
console.log('=== COMPLETE SQL SCRIPT ===\n');
console.log('-- Bible Quiz Dashboard - User Creation');
console.log('-- Generated: ' + new Date().toISOString());
console.log('\n-- Instance 1 Users');
console.log(controller1.sql);
console.log(viewer1.sql);
console.log('\n-- Instance 2 Users');
console.log(controller2.sql);
console.log(viewer2.sql);

console.log('\n=== CREDENTIALS SUMMARY ===');
console.log('\nInstance 1:');
console.log(`  Controller: controller1 / SecurePass123!`);
console.log(`  Viewer: viewer1 / ViewPass456!`);
console.log('\nInstance 2:');
console.log(`  Controller: controller2 / AdminPass789!`);
console.log(`  Viewer: viewer2 / WatchPass101!`);
console.log('\n⚠️  SAVE THESE CREDENTIALS SECURELY!');
console.log('⚠️  Change passwords after first login!\n');
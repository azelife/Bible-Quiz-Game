# Bible Quiz Dashboard - Complete Deployment Guide

## Prerequisites Checklist

- ✅ Node.js 18+ installed
- ✅ Cloudflare account created
- ✅ Wrangler CLI logged in
- ✅ All project files in place

---

## Step-by-Step Deployment

### Step 1: Project Setup

```bash
# Navigate to your project directory
cd bible-quiz-dashboard

# Install dependencies
npm install

# Verify Wrangler is working
npx wrangler --version
```

### Step 2: Create D1 Database

```bash
# Create the database
npx wrangler d1 execute bible-quiz-db --file=bible-quiz-schema.sql

# Output will look like:
# ✅ Successfully created DB 'bible-quiz-db' in region WNAM
# 
# [[d1_databases]]
# binding = "DB"
# database_name = "bible-quiz-db"
# database_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

**IMPORTANT:** Copy the `database_id` from the output!

### Step 3: Update wrangler.jsonc

Open `wrangler.jsonc` and update the D1 configuration:

```jsonc
{
  // ... other config ...
  "d1_databases": [
    {
      "binding": "DB",
      "database_name": "bible-quiz-db",
      "database_id": "PASTE_YOUR_DATABASE_ID_HERE"  // ← UPDATE THIS
    }
  ]
}
```

### Step 4: Initialize Database Schema

```bash
# Execute the schema SQL
npx wrangler d1 execute bible-quiz-db bible-quiz.schema.sql

# You should see output like:
# 🌀 Executing on remote database bible-quiz-db (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx):
# 🌀 To execute on your local development database, pass the --local flag to 'wrangler d1 execute'
# ✅ Executed 8 commands in 0.123s
```

Verify tables were created:

```bash
npx wrangler d1 execute bible-quiz-db --command="SELECT name FROM sqlite_master WHERE type='table'"

# Expected output:
# ┌──────────────────┐
# │ name             │
# ├──────────────────┤
# │ users            │
# │ sessions         │
# │ questions        │
# │ team_members     │
# │ game_state       │
# │ answer_log       │
# │ undo_history     │
# │ skip_log         │
# │*and one other*   │
# └──────────────────┘
```

### Step 5: Generate User Accounts

```bash
# Run the password generator
node generate-users.js
```

**Sample Output:**
```
🔐 Bible Quiz Dashboard - User Generator

Generated Game Instance IDs:
Instance 1: a1b2c3d4-e5f6-7890-abcd-ef1234567890
Instance 2: b2c3d4e5-f6g7-8901-bcde-f12345678901

================================================================================
User: controller1
Role: controller
Game Instance: a1b2c3d4-e5f6-7890-abcd-ef1234567890
================================================================================

SQL Command (run in D1 console):
INSERT INTO users (username, password_hash, salt, role, game_instance_id) VALUES ('controller1', 'a1b2c3...', 'd4e5f6...', 'controller', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890');
```

**Copy each SQL command and execute:**

```bash
# Execute for each user (replace with your actual SQL)
npx wrangler d1 execute bible-quiz-db --command="INSERT INTO users ..."
```

Verify users were created:

```bash
npx wrangler d1 execute bible-quiz-db --command="SELECT username, role FROM users"
```

### Step 6: Import Sample Questions

1. Start the development server:
```bash
npm run dev
```

2. Open browser: `http://localhost:8787`

3. Login with controller credentials

4. Navigate to Admin page: `http://localhost:8787/admin.html`

5. Upload `sample_questions.csv`

6. Verify import success

### Step 7: Test Locally

**Test Controller Dashboard:**
- Login as controller
- Select question type (Quiz/Recitation/Character)
- Load a question
- Start timer
- Request/reveal hints
- Submit answer

**Test Viewer Dashboard:**
- Login as viewer (or use same controller session)
- Open `/viewer.html`
- Verify real-time updates from control dashboard

### Step 8: Deploy to Production

```bash
# Deploy the Worker
npx wrangler deploy

# Output will show your Worker URL:
# ✨ Successfully published your script to
#    https://bible-quiz-dashboard.YOUR-SUBDOMAIN.workers.dev
```

### Step 9: Configure Custom Domain (Optional)

1. Go to Cloudflare Dashboard
2. Navigate to Workers & Pages → bible-quiz-dashboard
3. Click "Custom Domains" tab
4. Add your domain: `quiz.yourdomain.com`
5. DNS records will be automatically configured

### Step 10: Set Up Turnstile (Optional - Production Security)

1. Go to Cloudflare Dashboard → Turnstile
2. Create a new site
3. Copy the Site Key and Secret Key
4. Update `public/index.html` with Site Key:

```html
<!-- Before closing </head> tag -->
<script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>

<!-- In the form -->
<div class="cf-turnstile" data-sitekey="YOUR_SITE_KEY"></div>
```

5. Set the Secret Key as a Wrangler secret:

```bash
npx wrangler secret put TURNSTILE_SECRET_KEY
# When prompted, enter your secret key
```

6. Redeploy:

```bash
npx wrangler deploy
```

---

## Post-Deployment Verification

### 1. Test Authentication

```bash
# Test login endpoint
curl -X POST https://your-worker.workers.dev/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"controller1","password":"YOUR_PASSWORD"}'
```

Expected response:
```json
{
  "success": true,
  "role": "controller",
  "game_instance_id": "a1b2c3d4-..."
}
```

### 2. Test Game State

```bash
# Get game state (requires session cookie)
curl -X GET https://your-worker.workers.dev/api/viewer/state \
  -H "Cookie: session_id=YOUR_SESSION_ID"
```

### 3. Monitor Logs

```bash
# Watch live logs
npx wrangler tail

# Filter for errors only
npx wrangler tail --format=json | grep "error"
```

---

## Database Management

### Backup Questions

```bash
# Export all questions to CSV
npx wrangler d1 execute bible-quiz-db --command="SELECT * FROM questions" --json > backup_questions.json
```

### Reset Game State

```bash
# Reset game state for a specific instance
npx wrangler d1 execute bible-quiz-db --command="UPDATE game_state SET current_question_number=NULL, team_a_quiz_score=0, team_a_recitation_score=0, team_a_character_score=0, team_b_quiz_score=0, team_b_recitation_score=0, team_b_character_score=0 WHERE game_instance_id='YOUR_INSTANCE_ID'"
```

### Clean Old Sessions

```bash
# Delete expired sessions
npx wrangler d1 execute bible-quiz-db --command="DELETE FROM sessions WHERE expires_at < datetime('now')"
```

---

## Troubleshooting

### Issue: "Database not found" error

**Solution:**
- Verify `database_id` in `wrangler.jsonc` matches your D1 database
- Run: `npx wrangler d1 list` to see all databases
- Ensure binding name is "DB" (capital letters)

### Issue: Login fails with correct credentials

**Solution:**
```bash
# Check if user exists
npx wrangler d1 execute bible-quiz-db --command="SELECT username, role FROM users WHERE username='controller1'"

# If no results, regenerate and insert user
node generate-users.js
```

### Issue: Viewer dashboard not updating

**Solution:**
- Check browser console for network errors
- Verify session is valid: open DevTools → Application → Cookies
- Check Worker logs: `npx wrangler tail`
- Ensure CORS headers are present in API responses

### Issue: Timer not working correctly

**Solution:**
- Verify system clock is accurate
- Check JavaScript console for errors
- Ensure `timer_started_at` is being saved: 
  ```bash
  npx wrangler d1 execute bible-quiz-db --command="SELECT timer_started_at FROM game_state"
  ```

### Issue: CSV import fails

**Solution:**
- Verify CSV format matches template
- Check for special characters (use UTF-8 encoding)
- Ensure no extra commas or quotes
- Review error messages in import response

### Issue: "Worker exceeded CPU time limit"

**Solution:**
- Reduce polling frequency in viewer dashboard (increase from 2s to 5s)
- Optimize database queries (add indexes if needed)
- Check for infinite loops in timer code

---

## Performance Optimization

### 1. Add Database Indexes

```bash
# Index on frequently queried columns
npx wrangler d1 execute bible-quiz-db --command="CREATE INDEX idx_questions_lookup ON questions(game_instance_id, question_type, question_number)"

npx wrangler d1 execute bible-quiz-db --command="CREATE INDEX idx_sessions_expires ON sessions(expires_at)"
```

### 2. Enable Caching (Optional)

Add to `wrangler.jsonc`:
```jsonc
{
  "routes": [
    {
      "pattern": "quiz.yourdomain.com/*",
      "custom_domain": true
    }
  ],
  "compatibility_flags": [
    "nodejs_compat",
    "global_fetch_strictly_public",
    "cache_api_enabled"
  ]
}
```

### 3. Optimize Static Assets

- Minify CSS/JS files
- Use WebP for images (if adding any)
- Enable Cloudflare's Auto Minify in dashboard

---

## Scaling Considerations

### Multiple Game Instances

Each user automatically gets their own `game_instance_id`. To create separate tournaments:

1. Generate new users with unique game_instance_ids
2. Import different questions for each instance
3. Users with same game_instance_id share the same game state

### Concurrent Users

Cloudflare Workers handle:
- **Free Plan:** 100,000 requests/day
- **Paid Plan:** 10 million requests/month + $0.50 per million after

For heavy usage, consider:
- Upgrading to Workers Paid plan
- Increasing D1 storage (25GB on Paid)
- Setting up multiple Worker instances

---

## Maintenance Schedule

### Daily
- Monitor `npx wrangler tail` for errors
- Check D1 database size: Dashboard → D1 → bible-quiz-db

### Weekly
- Review answer_log for patterns
- Clean old undo_history (auto-cleaned by cron)

### Monthly
- Backup questions database
- Review and update questions
- Check for Worker updates: `npm outdated`

---

## Security Best Practices

1. **Change Default Passwords** - Regenerate users with strong passwords
2. **Enable Turnstile** - Prevent brute-force login attempts
3. **Regular Updates** - Keep Wrangler and dependencies updated
4. **Monitor Logs** - Watch for suspicious activity
5. **Rotate Secrets** - Change Turnstile keys periodically
6. **Use HTTPS Only** - Cloudflare enforces this automatically

---

## Support & Resources

- **Cloudflare Workers Docs:** https://developers.cloudflare.com/workers/
- **D1 Database Docs:** https://developers.cloudflare.com/d1/
- **Wrangler CLI Docs:** https://developers.cloudflare.com/workers/wrangler/
- **Check Worker Logs:** `npx wrangler tail`
- **Check D1 Status:** Cloudflare Dashboard → D1

---

## Success Checklist

- ✅ D1 database created and schema initialized
- ✅ Users created and can login
- ✅ Questions imported successfully
- ✅ Control dashboard loads and functions
- ✅ Viewer dashboard updates in real-time
- ✅ Timer works correctly
- ✅ Scoring calculates properly
- ✅ Worker deployed to production
- ✅ Custom domain configured (optional)
- ✅ Turnstile enabled (optional)

**Your Bible Quiz Dashboard is now live! 🎉**
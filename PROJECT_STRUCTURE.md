# Bible Quiz Dashboard - Project Structure

## Directory Layout

bible-quiz-dashboard/
├── .editorconfig
├── .gitignore
├── .prettierrc
├── DEPLOYMENT_GUIDE.md
├── PROJECT_STRUCTURE.md
├── README.md
├── bible-quiz-schema.sql
├── generate-users.js
├── package.json
├── package-lock.json
├── sample-questions.csv
├── vitest.config.js
├── wrangler.jsonc
│
├── .vscode/
│   └── settings.json
│
├── .wrangler/
│
│
├── public/
│   ├── index.html
│   ├── control.html
│   ├── viewer.html
│   └── admin.html
│
├── script/
│   └── generate-users.js
│
├── src/
│   ├── index.js
│   │
│   ├── routes/
│   │   ├── admin.js
│   │   ├── auth.js
│   │   ├── control.js
│   │   └── viewer.js
│   │
│   ├── utils/
│   │   ├── auth.js
│   │   └── response.js
│   │
│   └── test-password.js
│
└── test/
    └── index.spec.js

## Setup Instructions

### 1. Initialize Project
```bash
# Clone/create project directory
mkdir bible-quiz-dashboard
cd bible-quiz-dashboard

# Initialize npm
npm init -y

# Install development dependencies
npm install -D wrangler
```

### 2. Configure Wrangler
- Copy `wrangler.jsonc` to project root
- Update `database_id` with your D1 database ID

### 3. Create D1 Database
```bash
# Create database
npx wrangler d1 create bible-quiz-db

# Note the database_id from output
# Update wrangler.jsonc with this ID

# Execute schema
npx wrangler d1 execute bible-quiz-db --file=schema.sql
```

### 4. Generate User Accounts
```bash
# Run password generator
node generate-users.js

# Copy the generated SQL commands
# Execute each one:
npx wrangler d1 execute bible-quiz-db --command="INSERT INTO users ..."
```

### 5. Create Directory Structure
```bash
mkdir -p src/routes src/utils public/css public/js
```

### 6. Copy Source Files
- Place all `src/*.js` files in respective directories
- Place `public/index.html` in public folder

### 7. Development Testing
```bash
# Start local development server
npx wrangler dev

# Access at: http://localhost:8787
```

### 8. Deploy to Production
```bash
# Deploy Worker
npx wrangler deploy

# Access at: your-worker.workers.dev
```

## API Endpoints Reference

### Authentication
- `POST /api/auth/login` - Login with username/password
- `POST /api/auth/logout` - End session
- `GET /api/auth/verify` - Check session validity

### Control Dashboard (Role: controller)
- `GET /api/control/state` - Get full game state
- `POST /api/control/game-type/select` - Set question type
- `POST /api/control/team/select` - Set active team
- `POST /api/control/members/update` - Update team member names/visibility
- `POST /api/control/score-display/toggle` - Toggle score breakdown
- `POST /api/control/question/load` - Load question by number
- `POST /api/control/hint/request` - Mark hint as requested
- `POST /api/control/hint/reveal` - Reveal hint text
- `POST /api/control/timer/start` - Start countdown timer
- `POST /api/control/timer/reset` - Reset timer
- `POST /api/control/answer/submit` - Submit answer (correct/wrong)
- `POST /api/control/question/skip` - Skip to bonus round
- `POST /api/control/action/undo` - Undo last action
- `POST /api/control/game/end` - End game and show breakdown
- `POST /api/control/theme/toggle` - Toggle dark mode
- `POST /api/control/state/save` - Manual save state

### Viewer Dashboard (Role: viewer or controller)
- `GET /api/viewer/state` - Get public game state (filtered)

### Admin (Role: controller)
- `POST /api/admin/import/upload` - Upload CSV questions
- `GET /api/admin/questions/list` - List all questions
- `DELETE /api/admin/questions/delete` - Delete specific question

## Database Tables

### users
- Stores usernames, password hashes, roles, game instance IDs

### sessions
- Active session management with expiration

### questions
- Question bank (isolated per game_instance_id)

### team_members
- Team member names and visibility (12 per team)

### game_state
- Current game state (question, scores, timer, settings)

### answer_log
- Historical record of all answers

### undo_history
- State snapshots for undo functionality

### skip_log
- Record of skipped questions

## Next Steps

### Immediate Priority
1. ✅ Database schema created
2. ✅ Password generator ready
3. ✅ Worker backend complete
4. ✅ Login page complete
5. ⏳ **Control Dashboard HTML/CSS/JS** (NEXT)
6. ⏳ Viewer Dashboard HTML/CSS/JS
7. ⏳ Admin import page

### Testing Checklist
- [ ] User authentication flow
- [ ] Question loading/display
- [ ] Hint request/reveal system
- [ ] Timer accuracy
- [ ] Score calculation
- [ ] Answer submission
- [ ] Skip functionality
- [ ] Undo mechanism
- [ ] Multi-user isolation
- [ ] Dark mode toggle
- [ ] CSV import validation

## Environment Variables (Secrets)

```bash
# Set Turnstile secret (production only)
npx wrangler secret put TURNSTILE_SECRET_KEY

# When prompted, enter your Cloudflare Turnstile secret key
```

## Common Commands

```bash
# Local development
npx wrangler dev

# Deploy to production
npx wrangler deploy

# View D1 database
npx wrangler d1 execute bible-quiz-db --command="SELECT * FROM users"

# Tail live logs
npx wrangler tail

# Delete and recreate database (CAREFUL!)
npx wrangler d1 delete bible-quiz-db
npx wrangler d1 create bible-quiz-db
npx wrangler d1 execute bible-quiz-db --file=schema.sql
```

## Security Notes

1. **Password Hashing**: Uses PBKDF2 with 100,000 iterations
2. **Session Management**: HttpOnly, Secure, SameSite=Strict cookies
3. **Turnstile**: Bot protection on login (production)
4. **Role-Based Access**: Controllers have full access, viewers read-only
5. **Game Isolation**: Each user instance has isolated game state

## Performance Optimization

- **Polling**: Viewer dashboard polls every 2 seconds
- **Auto-save**: Control dashboard saves every 5 seconds
- **D1 Indexes**: Ensure indexes on frequently queried columns
- **Static Assets**: Served directly by Cloudflare edge network

## Troubleshooting

### Issue: "Database not found"
- Verify `database_id` in wrangler.jsonc matches D1 database
- Run: `npx wrangler d1 list` to see all databases

### Issue: "Session expired immediately"
- Check system clock is accurate
- Verify timezone handling in Worker

### Issue: "Questions not loading"
- Ensure CSV import completed successfully
- Check `game_instance_id` matches between user and questions

### Issue: "CORS errors"
- Verify API routes return proper CORS headers
- Check fetch credentials: 'include' in frontend

## License
This project is created for Bible quiz management purposes.
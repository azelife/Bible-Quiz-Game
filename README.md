# 📖 Bible Quiz Dashboard System

A real-time Bible quiz management system built with Cloudflare Workers, D1 database, and vanilla JavaScript. Features isolated game instances, three question types (Bible Quiz, Recitation, Character), real-time updates, and comprehensive game controls.

## ✨ Features

- **Three Question Types**: Bible Quiz, Recitation, Character
- **Real-time Updates**: Polling-based synchronization (2-second intervals)
- **Isolated Game Instances**: Each user gets their own game state
- **Progressive Hint System**: Request hints before revealing them
- **Dual Dashboards**: Separate control and viewing interfaces
- **Timer System**: 60-second main timer, 30-second bonus timer
- **Score Tracking**: Aggregate and breakdown views
- **Undo Functionality**: Revert last action
- **Dark Mode**: Synchronized across dashboards
- **CSV Import**: Bulk question upload
- **Session Management**: Secure 8-hour sessions

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ installed
- Cloudflare account
- Wrangler CLI configured

### Step 1: Clone and Install

```bash
# Create project directory
mkdir bible-quiz-dashboard
cd bible-quiz-dashboard

# Initialize npm
npm init -y

# Install Wrangler
npm install -D wrangler

# Login to Cloudflare
npx wrangler login
```

### Step 2: Create D1 Database

```bash
# Create database
npx wrangler d1 create bible-quiz-db

# Copy the database_id from output
# Update wrangler.jsonc with this ID
```

### Step 3: Create Project Structure

```bash
# Create directories
mkdir -p src/routes src/utils public/css public/js

# Create schema file
touch schema.sql
```

### Step 4: Add Files

Copy the following files to your project (provided in artifacts):

```
bible-quiz-dashboard/
├── wrangler.jsonc
├── package.json
├── generate-users.js
├── sample_questions.csv
├── schema.sql
├── src/
│   ├── index.js
│   ├── routes/
│   │   ├── auth.js
│   │   ├── control.js
│   │   ├── viewer.js
│   │   └── admin.js
│   └── utils/
│       ├── response.js
│       ├── auth.js
│       └── turnstile.js
└── public/
    └── index.html
```

### Step 5: Initialize Database

```bash
# Execute schema
npx wrangler d1 execute bible-quiz-db --file=schema.sql
```

### Step 6: Create Users

```bash
# Generate password hashes
node generate-users.js

# Copy the output SQL commands and execute them
npx wrangler d1 execute bible-quiz-db --command="INSERT INTO users ..."
```

### Step 7: Import Sample Questions

```bash
# You'll do this through the admin interface after starting the app
# Use sample_questions.csv as a template
```

### Step 8: Start Development Server

```bash
npm run dev

# Access at: http://localhost:8787
```

### Step 9: Deploy to Production

```bash
npm run deploy

# Your app will be available at: your-worker.workers.dev
```

## 🎮 Usage Guide

### Login

1. Navigate to the login page
2. Enter username and password (created in Step 6)
3. Controllers are redirected to `/control.html`
4. Viewers are redirected to `/viewer.html`

### Control Dashboard Workflow

1. **Select Question Type**: Choose Quiz, Recitation, or Character
2. **Select Active Team**: Team A or Team B
3. **Load Question**: Enter question number and click "Load Question"
4. **Start Timer**: 60 seconds for main round
5. **Manage Hints**: 
   - Click "Mark as Requested" to show "Hint Requested..." on viewer
   - Click "Reveal Hint" to show actual hint text
6. **Submit Answer**: Click ✓ Correct or ✗ Wrong
7. **Bonus Round**: If wrong, enable bonus for opposing team (30 seconds)
8. **Skip Question**: Awards bonus points to opposing team
9. **Undo**: Revert last action if needed

### CSV Import Format

```csv
question_type,question_number,question_text,answer,hint_1,hint_2,hint_3,hint_4,points,bonus_points,bonus_hint_points
quiz,1,Who was the first king of Israel?,"Saul (1 Samuel 10:1)",He was from Benjamin,Samuel anointed him,He was tall,He disobeyed,5,2,1
```

**Required Fields**: `question_type`, `question_number`, `question_text`, `answer`

**Optional Fields**: `hint_1` through `hint_4`, `points`, `bonus_points`, `bonus_hint_points`

## 🏗️ Architecture

### Technology Stack

- **Frontend**: Vanilla HTML/CSS/JavaScript
- **Backend**: Cloudflare Workers
- **Database**: Cloudflare D1 (SQLite)
- **Security**: PBKDF2 password hashing, HttpOnly cookies
- **Real-time**: Polling (2-second viewer updates, 5-second control auto-save)

### Database Schema

#### Core Tables
- `users` - Authentication and game instance assignment
- `sessions` - Active session management
- `game_state` - Current game state per instance
- `questions` - Question bank (isolated per instance)
- `team_members` - Team roster (12 per team)

#### Logging Tables
- `answer_log` - Historical answer records
- `undo_history` - State snapshots for undo
- `skip_log` - Skipped question tracking

### API Routes

**Authentication**
- `POST /api/auth/login`
- `POST /api/auth/logout`
- `GET /api/auth/verify`

**Control (Controllers Only)**
- `GET /api/control/state`
- `POST /api/control/game-type/select`
- `POST /api/control/team/select`
- `POST /api/control/question/load`
- `POST /api/control/hint/request`
- `POST /api/control/hint/reveal`
- `POST /api/control/answer/submit`
- ... (see PROJECT_STRUCTURE.md for full list)

**Viewer (All Authenticated Users)**
- `GET /api/viewer/state`

**Admin (Controllers Only)**
- `POST /api/admin/import/upload`
- `GET /api/admin/questions/list`

## 🔒 Security

- **Password Hashing**: PBKDF2 with 100,000 iterations
- **Session Cookies**: HttpOnly, Secure, SameSite=Strict
- **Role-Based Access**: Controllers have full access, viewers are read-only
- **Instance Isolation**: Each game instance is completely isolated
- **Optional Turnstile**: Bot protection on login (production)

## 🎨 Customization

### Scoring Rules

Edit in `schema.sql` or via CSV import:
- `points` - Base points for correct answer (default: 5)
- `bonus_points` - Points for bonus round (default: 2)
- `bonus_hint_points` - Deduction per hint (default: 1)

### Timer Duration

Edit in `src/routes/control.js`:
```javascript
const duration = isBonus ? 30 : 60; // seconds
```

### Polling Intervals

**Viewer Dashboard** (in `public/js/viewer.js`):
```javascript
setInterval(fetchGameState, 2000); // 2 seconds
```

**Control Auto-save** (in `public/js/control.js`):
```javascript
setInterval(autoSave, 5000); // 5 seconds
```

## 📊 Monitoring

### View Live Logs

```bash
npm run tail
```

### Query Database

```bash
# List all users
npx wrangler d1 execute bible-quiz-db --command="SELECT * FROM users"

# View game state
npx wrangler d1 execute bible-quiz-db --command="SELECT * FROM game_state"

# Check questions
npx wrangler d1 execute bible-quiz-db --command="SELECT question_type, COUNT(*) as count FROM questions GROUP BY question_type"
```

## 🐛 Troubleshooting

### Login Issues
- Verify user exists: `SELECT * FROM users WHERE username='your_username'`
- Check session expiration: Sessions last 8 hours
- Clear browser cookies and retry

### Questions Not Loading
- Ensure `game_instance_id` matches between user and questions
- Check CSV import errors in response
- Verify question type selection

### Real-time Updates Not Working
- Check browser console for network errors
- Verify Worker is running: `npm run dev`
- Ensure CORS headers are set correctly

### Timer Inaccurate
- Check system clock accuracy
- Verify `timer_started_at` is being saved correctly
- Look for JavaScript console errors

## 📝 Development Roadmap

- [ ] **Control Dashboard UI** (NEXT PRIORITY)
- [ ] **Viewer Dashboard UI**
- [ ] **Admin Import Page**
- [ ] Turnstile integration
- [ ] Sound effects
- [ ] Animations and transitions
- [ ] Mobile responsive design
- [ ] Export game results as PDF
- [ ] Question analytics dashboard

## 🤝 Contributing

This is a custom project for Bible quiz management. Feel free to fork and adapt for your needs.

## 📄 License

MIT License - Free to use and modify

## 🆘 Support

For issues, check:
1. Browser console for JavaScript errors
2. Worker logs: `npm run tail`
3. D1 database contents
4. Network tab in DevTools

---


**Built with ❤️ using Cloudflare Workers**




google-site-verification: google70afeed1c0476b8b.html

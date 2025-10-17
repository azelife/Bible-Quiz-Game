📖 Bible Quiz Dashboard

A Cloudflare Workers–powered Bible Quiz Management System designed for real-time hosting, scoring, and session control of quiz or recitation games.
It provides full deployment automation using Wrangler CLI and Cloudflare D1, allowing organisers to run cloud-based quiz events with ease.

🌍 Overview

The Bible Quiz Dashboard enables controllers, viewers, and administrators to collaborate seamlessly in a live Bible quiz environment.
Built with scalability and simplicity in mind, it provides secure user authentication, automated scoring, and instant data synchronisation between dashboards — all without maintaining a traditional server.

This repository is completely free to use, test, modify, and contribute to.
Developers are encouraged to submit pull requests, propose new features, or improve existing functionalities.

⚙️ Features

🔐 Secure Authentication using Cloudflare D1 with salted password hashes

📊 Real-time Dashboard for controllers and viewers

📦 CSV Question Import and export support

🧩 Multi-Instance Game Mode (each group has a unique game instance)

⏱️ Integrated Timer and Scoring System

💾 Persistent Game State stored in Cloudflare D1

🌐 Serverless Deployment via Cloudflare Workers (free tier compatible)

🛡️ Optional Cloudflare Turnstile Integration for CAPTCHA protection

🚀 Quick Deployment
Prerequisites

Ensure you have the following:

Node.js 18 or later

A Cloudflare account

Wrangler CLI installed and logged in

Setup Steps
# Clone the repository
git clone https://github.com/YOUR_USERNAME/bible-quiz-dashboard.git
cd bible-quiz-dashboard

# Install dependencies
npm install

# Create your database
npx wrangler d1 create bible-quiz-db


Follow the included deployment guide (DEPLOYMENT.md or the main documentation) to configure your wrangler.jsonc, initialise the database schema, and deploy to production.

Once completed, access your Worker via the published URL:

https://bible-quiz-dashboard.YOUR-SUBDOMAIN.workers.dev

🧠 Usage

Controller Dashboard: Used by quiz moderators to manage sessions, start timers, reveal hints, and update scores.

Viewer Dashboard: Displays real-time updates of the game state and results to participants or an audience.

Admin Panel: Handles user management, database checks, and content imports.

To start a quiz session locally:

npm run dev


Open your browser and navigate to:

http://localhost:8787

🧩 Contributing

Contributions are welcome and highly encouraged.
If you wish to propose an improvement or feature:

Fork this repository

Create a new branch: git checkout -b feature-name

Commit your changes: git commit -m "Add new feature or fix"

Push your branch: git push origin feature-name

Open a Pull Request describing your improvement

All approved updates will be merged after functional verification.

📜 Licence

This project is released under the MIT Licence, granting users the right to freely use, modify, and distribute the code for personal or public projects.
Attribution is appreciated but not mandatory.

📚 Documentation

Detailed setup and configuration steps are available in the Deployment Guide included with this repository.
Refer to:

Cloudflare Workers documentation: https://developers.cloudflare.com/workers/

D1 Database documentation: https://developers.cloudflare.com/d1/

Wrangler CLI guide: https://developers.cloudflare.com/workers/wrangler/

💬 Support

For technical questions or feedback:

Open a GitHub Issue in this repository.

Join Cloudflare’s community forums for general Worker or D1 queries.

✅ Project Highlights

Built for serverless environments

Fully deployable on Cloudflare free plan

Designed for educational and interactive use

Open for community-driven development

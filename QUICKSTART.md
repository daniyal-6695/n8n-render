# Quick Start Guide - Computer Automation Agent

This guide will help you get your Computer Automation Agent up and running in minutes.

## 🚀 5-Minute Quick Start

### Step 1: Deploy to Render (Recommended for Production)

1. **Fork this repository** to your GitHub account

2. **Sign up/Login to Render**: https://render.com

3. **Create a new Web Service**:
   - Click "New +" → "Web Service"
   - Connect your GitHub account
   - Select your forked `n8n-render` repository
   - Render will auto-detect the Dockerfile

4. **Configure the service**:
   - Name: `my-automation-agent` (or any name you prefer)
   - Region: Choose closest to you
   - Instance Type: Free tier works great to start
   - Environment Variables (add these):
     ```
     N8N_BASIC_AUTH_ACTIVE=true
     N8N_BASIC_AUTH_USER=admin
     N8N_BASIC_AUTH_PASSWORD=your-secure-password-here
     N8N_HOST=0.0.0.0
     N8N_PORT=5678
     N8N_PROTOCOL=https
     ```

5. **Deploy**: Click "Create Web Service"
   - Wait 2-3 minutes for deployment
   - Access your agent at the provided URL

### Step 2: Access Your Automation Agent

1. Open your Render app URL (e.g., `https://my-automation-agent.onrender.com`)
2. Login with the credentials you set:
   - Username: `admin` (or what you configured)
   - Password: Your password from environment variables

### Step 3: Import Your First Workflow

1. **Click on "Workflows"** in the left sidebar
2. **Click "Import from File"** or "Import from URL"
3. **Start with the Getting Started workflow**:
   - Navigate to the workflow files in your repository
   - Or manually create and paste the workflow JSON
4. **Click "Save"** and then **"Activate"** the workflow

### Step 4: Test Your First Automation

1. Open the "Getting Started" workflow
2. Click **"Execute Workflow"** button
3. See the agent in action! 🎉

## 📱 Local Development Setup

If you prefer to run locally first:

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/n8n-render.git
cd n8n-render

# 2. Install n8n
npm install

# 3. Run the setup script
chmod +x setup-agent.sh
./setup-agent.sh

# 4. Create a local .env file
cp .env.example .env
# Edit .env with your settings

# 5. Start n8n
npm start

# 6. Open in browser
# Navigate to http://localhost:5678
```

## 🎯 What You Get Out of the Box

Your automation agent comes pre-configured with:

✅ **8 Ready-to-Use Workflows**:
1. Getting Started - Demo and introduction
2. File Management - Auto-organize files by type
3. System Monitoring - CPU, memory, disk alerts
4. Scheduled Tasks - Backups and maintenance
5. Data Processing - CSV/JSON transformation
6. Web Automation - Scraping and monitoring
7. API Integration - Connect multiple services
8. Email Automation - Process and categorize emails

✅ **Pre-configured Directory Structure**:
- `/home/node/files/` - File organization
- `/home/node/data/` - Data processing
- `/home/node/backups/` - Automated backups
- `/home/node/logs/` - System logs

✅ **Professional Documentation**:
- Main README with full overview
- Workflow-specific documentation
- Configuration guide
- This quick start guide

## 🔧 First Automation Ideas

### 1. Automate File Organization (5 minutes)

```
1. Import "file-management.json"
2. Activate the workflow
3. Upload files to your watched directory
4. Watch them automatically organize by type!
```

### 2. Monitor Your System (3 minutes)

```
1. Import "system-monitoring.json"
2. Adjust thresholds if needed
3. Activate the workflow
4. Get alerts when resources run high
```

### 3. Schedule Daily Backups (5 minutes)

```
1. Import "scheduled-tasks.json"
2. Configure backup directories
3. Set your preferred time
4. Activate and forget it!
```

### 4. Process Data Files (10 minutes)

```
1. Import "data-processing.json"
2. Place a CSV file in /data/input
3. Execute the workflow
4. Find processed data in /data/output
```

## 🛠️ Common Customizations

### Change a Schedule

1. Open any workflow with a schedule
2. Click on the "Schedule Trigger" node
3. Modify the interval or cron expression
4. Save and re-activate

### Add Email Notifications

1. Go to Settings → Credentials
2. Add SMTP credentials
3. Add "Send Email" node to any workflow
4. Connect it to trigger on events

### Connect to External APIs

1. Import "api-integration.json"
2. Configure your API credentials
3. Modify the HTTP Request nodes
4. Test and activate

## 📊 Monitoring Your Agent

### Check Workflow Executions

1. Click "Executions" in the left sidebar
2. See all workflow runs
3. Click any execution to see details
4. Debug issues in real-time

### View Logs

Access logs in:
- n8n UI: Settings → Executions
- File system: `/home/node/logs/`
- Render Dashboard: Logs tab

## 🆘 Troubleshooting

### Workflow Not Running?
- ✅ Check if workflow is activated (toggle in top right)
- ✅ Verify trigger settings (schedule, webhook, etc.)
- ✅ Check execution logs for errors

### Can't Access n8n?
- ✅ Verify Render app is running
- ✅ Check environment variables are set
- ✅ Confirm basic auth credentials

### Files Not Processing?
- ✅ Verify directory paths exist
- ✅ Check file permissions
- ✅ Review workflow execution logs

## 🎓 Next Steps

### Learn More
- 📖 Read the full [README.md](README.md)
- 📚 Review [CONFIGURATION.md](CONFIGURATION.md)
- 🔗 Explore [n8n Documentation](https://docs.n8n.io)

### Customize Your Agent
- Modify existing workflows
- Create new custom workflows
- Add more integrations
- Set up webhooks for real-time triggers

### Share and Contribute
- Share your workflows with the community
- Contribute improvements
- Report issues and suggestions

## 💡 Pro Tips

1. **Start Small**: Begin with one workflow, master it, then add more
2. **Test First**: Use "Execute Workflow" before activating schedules
3. **Monitor Resources**: Check system usage if running many workflows
4. **Backup Regularly**: Export your workflows periodically
5. **Secure Credentials**: Always use n8n's credential system
6. **Read Logs**: Execution logs are your best debugging tool

## 🎉 You're Ready!

Your Computer Automation Agent is now ready to automate your tasks!

**Need Help?**
- Check [n8n Community Forum](https://community.n8n.io)
- Review [workflow documentation](workflows/README.md)
- Open an issue on GitHub

**Happy Automating!** 🤖✨

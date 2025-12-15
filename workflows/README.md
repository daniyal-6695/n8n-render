# n8n Computer Automation Agent Workflows

This directory contains pre-configured workflow templates for automating computer tasks using n8n.

## Available Workflows

### 1. File Management Automation (`file-management.json`)
- Automatically organize files based on type, date, or custom rules
- Monitor directories for new files and process them
- Bulk file operations (rename, move, copy)

### 2. System Monitoring (`system-monitoring.json`)
- Monitor system resources (CPU, memory, disk)
- Send alerts when thresholds are exceeded
- Generate daily/weekly system reports

### 3. Scheduled Tasks Automation (`scheduled-tasks.json`)
- Run periodic backups
- Clean up temporary files
- Execute scripts at scheduled intervals

### 4. Data Processing Pipeline (`data-processing.json`)
- Process CSV/JSON files automatically
- Transform and enrich data
- Export results to various formats

### 5. Web Automation (`web-automation.json`)
- Scrape websites on schedule
- Monitor website changes
- Submit forms automatically
- Download files from web sources

### 6. Email Automation (`email-automation.json`)
- Process incoming emails
- Send scheduled reports
- Auto-respond to emails based on rules

### 7. API Integration Hub (`api-integration.json`)
- Connect multiple APIs
- Sync data between services
- Trigger actions based on API events

## How to Import Workflows

1. Access your n8n instance at `http://localhost:5678` (or your configured URL)
2. Go to **Workflows** in the left sidebar
3. Click **Import from File**
4. Select a workflow JSON file from this directory
5. Activate the workflow

## Customizing Workflows

Each workflow template can be customized to fit your specific needs:
- Modify trigger conditions
- Add/remove nodes
- Change scheduling intervals (see [Cron Scheduling Guide](../CRON-GUIDE.md))
- Update credentials and connections

## Environment Variables

Set these environment variables in your `.env` file or Render dashboard:

```
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=your_username
N8N_BASIC_AUTH_PASSWORD=your_password
N8N_HOST=your-app-url.onrender.com
N8N_PORT=5678
N8N_PROTOCOL=https
WEBHOOK_URL=https://your-app-url.onrender.com/
```

## Getting Started

For first-time setup, import the `getting-started.json` workflow which demonstrates basic automation concepts.

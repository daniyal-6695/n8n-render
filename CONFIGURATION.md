# Computer Automation Agent - Configuration Guide

## Overview

The Computer Automation Agent is built on n8n and provides a comprehensive automation framework for computer tasks. This guide explains how to configure and customize the agent for your specific needs.

## Core Components

### 1. Workflow Engine (n8n)
The foundation of the automation agent, providing:
- Visual workflow builder
- 300+ pre-built integrations
- Custom code execution (JavaScript/Python)
- Webhook support
- Scheduling capabilities

### 2. Pre-configured Workflows
Ready-to-use automation templates for:
- File management and organization
- System resource monitoring
- Scheduled maintenance tasks
- Data processing pipelines
- Web scraping and automation
- API integrations

### 3. Directory Structure
Organized file system for:
- Input/output data handling
- Backup storage
- Log management
- Workflow storage

## Installation & Setup

### First-time Setup

1. **Deploy the Application**
   ```bash
   # For local development
   npm install
   ./setup-agent.sh
   npm start
   
   # For Docker
   docker build -t n8n-automation-agent .
   docker run -p 5678:5678 n8n-automation-agent
   ```

2. **Access the n8n Interface**
   - Navigate to `http://localhost:5678`
   - Log in with credentials from `.env` file

3. **Import Workflows**
   - Click "Workflows" → "Import from File"
   - Select workflows from `/workflows` directory
   - Import all provided templates

4. **Configure Credentials**
   - Set up any required API keys
   - Configure email settings (if using email automation)
   - Add webhook URLs for integrations

## Workflow Configuration

### Getting Started Workflow

**Purpose**: Introduction and capability demonstration

**Configuration**:
- No configuration needed
- Click "Execute Workflow" to test
- Review output to verify setup

### File Management Workflow

**Purpose**: Automatic file organization and cleanup

**Configuration Steps**:
1. Update watch directory path:
   - Default: `/home/node/files/incoming`
   - Change in "Watch Folder" node

2. Configure category folders:
   - Default: `/home/node/files/organized/{category}`
   - Modify in "Move to Category Folder" node

3. Set cleanup schedule:
   - Default: Every hour
   - Change in "Every Hour" trigger node

4. Adjust retention period:
   - Default: 7 days
   - Modify in "Filter Old Files" code node

**Customization Example**:
```javascript
// In "Filter Old Files" node
// Change retention from 7 to 30 days
const thirtyDaysAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
```

### System Monitoring Workflow

**Purpose**: Monitor system resources and send alerts

**Configuration Steps**:
1. Adjust monitoring frequency:
   - Default: Every 5 minutes
   - Change in "Every 5 Minutes" trigger node

2. Set alert thresholds:
   ```javascript
   // In "Check Thresholds" node
   const CPU_THRESHOLD = 80;      // Change to your needs
   const MEMORY_THRESHOLD = 85;    // Change to your needs
   const DISK_THRESHOLD = 90;      // Change to your needs
   ```

3. Configure alert destinations:
   - Add email node for email alerts
   - Add Slack/Discord node for chat notifications
   - Modify "Log Alert" node for custom logging

**Advanced Setup**:
```javascript
// Add custom metrics
const uptime = execSync('uptime -p').toString().trim();
const processes = execSync('ps aux | wc -l').toString().trim();
```

### Scheduled Tasks Workflow

**Purpose**: Automated backups and maintenance

**Configuration Steps**:
1. Set backup schedule:
   - Default: Daily at 2 AM
   - Modify cron expression: `0 2 * * *`
   - Change in "Daily at 2 AM" trigger node

2. Configure backup directories:
   ```bash
   # In "Run Backup" node
   # Add custom directories to backup
   cp -r /your/custom/dir "$BACKUP_DIR/custom"
   ```

3. Adjust retention:
   ```bash
   # In "Cleanup Old Backups" node
   # Change from 7 to 14 days
   find "$BACKUP_ROOT" -name "*.tar.gz" -type f -mtime +14 -delete
   ```

### Data Processing Workflow

**Purpose**: Process and transform data files

**Configuration Steps**:
1. Set input file path:
   - Default: `/home/node/data/input/data.csv`
   - Change in "Read CSV File" node

2. Customize transformation logic:
   ```javascript
   // In "Transform Data" node
   // Add custom transformations
   const transformed = {
     ...data,
     customField: calculateCustomValue(data),
     timestamp: new Date().toISOString()
   };
   ```

3. Configure output format:
   - CSV: Use "Convert to CSV" node
   - JSON: Use "Write File" with JSON.stringify
   - Excel: Add "Spreadsheet File" node

### Web Automation Workflow

**Purpose**: Web scraping and monitoring

**Configuration Steps**:
1. Add URLs to monitor:
   ```javascript
   // In "Set URLs to Monitor" node
   const urlsToMonitor = [
     "https://yoursite.com/page1",
     "https://yoursite.com/page2"
   ];
   ```

2. Customize data extraction:
   ```javascript
   // In "Parse HTML" node
   // Extract specific elements
   const prices = [];
   $('.price').each((i, elem) => {
     prices.push($(elem).text());
   });
   ```

3. Set scraping schedule:
   - Default: Every 6 hours
   - Change in "Every 6 Hours" trigger node

## Environment Variables

### Essential Variables

```bash
# Authentication
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=your_username
N8N_BASIC_AUTH_PASSWORD=your_secure_password

# Host Configuration
N8N_HOST=your-app-url.onrender.com
N8N_PROTOCOL=https
WEBHOOK_URL=https://your-app-url.onrender.com/

# Execution Settings
EXECUTIONS_MODE=regular
EXECUTIONS_DATA_SAVE_ON_ERROR=all
EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
```

### Optional Variables

```bash
# Email Configuration
N8N_SMTP_HOST=smtp.gmail.com
N8N_SMTP_PORT=587
N8N_SMTP_USER=your-email@gmail.com
N8N_SMTP_PASS=your-app-password

# Timezone
GENERIC_TIMEZONE=America/New_York

# Logging
N8N_LOG_LEVEL=info
N8N_LOG_OUTPUT=console,file

# Custom Automation Settings
AUTOMATION_BACKUP_ENABLED=true
AUTOMATION_MONITORING_ENABLED=true
```

## Advanced Customization

### Creating Custom Workflows

1. **Start with a Template**:
   - Duplicate an existing workflow
   - Modify nodes to fit your needs

2. **Add Custom Nodes**:
   - Use Code node for JavaScript/Python
   - Use Execute Command for shell scripts
   - Use HTTP Request for API calls

3. **Connect External Services**:
   - Add credentials in Settings → Credentials
   - Use service-specific nodes (Slack, Google Sheets, etc.)

### Example: Custom Notification System

```javascript
// Create a reusable function node
function sendNotification(message, level = 'info') {
  const webhook = 'YOUR_WEBHOOK_URL';
  const payload = {
    text: message,
    level: level,
    timestamp: new Date().toISOString()
  };
  
  return $http.post(webhook, payload);
}

// Use in workflow
return sendNotification('Backup completed successfully', 'success');
```

### Example: Advanced File Processing

```javascript
// Process multiple file types
const fs = require('fs');
const path = require('path');

function processFile(filePath) {
  const ext = path.extname(filePath).toLowerCase();
  
  switch(ext) {
    case '.csv':
      return processCSV(filePath);
    case '.json':
      return processJSON(filePath);
    case '.xml':
      return processXML(filePath);
    default:
      return { error: 'Unsupported file type' };
  }
}
```

## Monitoring & Maintenance

### Viewing Execution History
1. Go to "Executions" in n8n UI
2. Filter by workflow, status, or date
3. Click on execution to see detailed logs

### Debugging Workflows
1. Use "Execute Workflow" for testing
2. Enable "Save Execution Progress" in workflow settings
3. Check each node's output data
4. Review error messages in execution logs

### Performance Optimization
1. Limit concurrent executions
2. Use pagination for large datasets
3. Implement error handling
4. Add timeouts for long-running operations

## Security Best Practices

1. **Authentication**:
   - Always enable basic auth in production
   - Use strong passwords
   - Consider IP whitelisting

2. **Credentials**:
   - Never hardcode API keys in workflows
   - Use n8n's credential system
   - Rotate credentials regularly

3. **Webhooks**:
   - Use HTTPS only
   - Implement webhook authentication
   - Validate incoming data

4. **File Operations**:
   - Validate file paths
   - Sanitize file names
   - Set appropriate permissions

## Troubleshooting

### Common Issues

**Workflow not triggering**:
- Verify workflow is activated
- Check trigger configuration
- Review system time and timezone

**File operations failing**:
- Check directory permissions
- Verify paths are correct
- Ensure sufficient disk space

**High resource usage**:
- Reduce execution frequency
- Optimize data processing
- Limit concurrent workflows

**Webhook not receiving data**:
- Verify webhook URL
- Check firewall settings
- Test with curl/Postman

## Getting Help

- **Documentation**: [n8n Docs](https://docs.n8n.io)
- **Community**: [n8n Forum](https://community.n8n.io)
- **Examples**: Browse workflow templates in `/workflows`
- **Support**: Open an issue on GitHub

## Next Steps

1. Import and test all workflow templates
2. Customize workflows for your use case
3. Set up monitoring and alerts
4. Schedule regular backups
5. Create custom workflows as needed

Happy Automating! 🤖

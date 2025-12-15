# n8n Computer Automation Agent

A powerful self-hosted automation platform on Render with pre-configured workflows for computer task automation.

## 🤖 What is the Computer Automation Agent?

This is an enhanced n8n deployment that comes with ready-to-use automation workflows designed to handle various computer tasks:

- **File Management**: Automatically organize, categorize, and clean up files
- **System Monitoring**: Monitor CPU, memory, and disk usage with alerts
- **Scheduled Tasks**: Run backups, cleanups, and maintenance tasks
- **Data Processing**: Process CSV/JSON files with transformations
- **Web Automation**: Scrape websites, monitor changes, and submit forms
- **API Integration**: Connect and sync data between multiple services

## 🚀 Quick Start

### Deploy to Render

1. Fork this repository
2. Connect your GitHub account to Render
3. Create a new Web Service
4. Point it to your forked repository
5. Render will automatically deploy using the Dockerfile

### Local Development

```bash
# Clone the repository
git clone https://github.com/yourusername/n8n-render.git
cd n8n-render

# Install dependencies
npm install

# Run the setup script
./setup-agent.sh

# Start n8n
npm start
```

Access n8n at `http://localhost:5678`

## 📋 Pre-configured Workflows

The automation agent comes with these ready-to-use workflows:

### 1. Getting Started (`getting-started.json`)
Introduction workflow that demonstrates the agent's capabilities.

### 2. File Management (`file-management.json`)
- Monitors directories for new files
- Automatically categorizes files by type (images, documents, videos, etc.)
- Moves files to organized folders
- Cleans up old temporary files

### 3. System Monitoring (`system-monitoring.json`)
- Monitors CPU, memory, and disk usage every 5 minutes
- Generates alerts when thresholds are exceeded
- Logs alerts to files for review

### 4. Scheduled Tasks (`scheduled-tasks.json`)
- Daily backups at 2 AM
- Weekly maintenance on Sundays
- Automatic cleanup of old files and logs
- System reports generation

### 5. Web Automation (`web-automation.json`)
- Scheduled web scraping
- Website monitoring for changes
- Form submission automation
- Data extraction from web pages

### 6. Data Processing (`data-processing.json`)
- CSV/JSON file processing
- Data transformation and enrichment
- Validation and filtering
- Automated report generation

## 🛠️ Configuration

### Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
```

Key configurations:
- `N8N_BASIC_AUTH_USER`: Username for n8n access
- `N8N_BASIC_AUTH_PASSWORD`: Password for n8n access
- `N8N_HOST`: Your Render app URL
- `WEBHOOK_URL`: Base URL for webhooks

See `.env.example` for all available options.

### Importing Workflows

1. Access your n8n instance
2. Go to **Workflows** → **Import from File**
3. Select a workflow JSON file from the `/workflows` directory
4. Configure any credentials needed (API keys, email settings, etc.)
5. Activate the workflow

## 📖 Usage Examples

### Automate File Organization

1. Import `file-management.json`
2. Configure the watch directory path
3. Activate the workflow
4. Files added to the watch directory will be automatically organized

### Monitor System Resources

1. Import `system-monitoring.json`
2. Adjust alert thresholds if needed
3. Activate the workflow
4. Receive alerts when resources exceed thresholds

### Schedule Automated Backups

1. Import `scheduled-tasks.json`
2. Configure backup directories
3. Set your preferred schedule
4. Activate the workflow

### Process Data Files

1. Import `data-processing.json`
2. Place CSV files in `/home/node/data/input`
3. Run the workflow manually or on schedule
4. Find processed files in `/home/node/data/output`

## 🏗️ Directory Structure

```
/home/node/
├── files/
│   ├── incoming/          # Watch folder for new files
│   └── organized/         # Organized files by category
│       ├── images/
│       ├── documents/
│       ├── videos/
│       └── ...
├── data/
│   ├── input/            # Input data files
│   ├── output/           # Processed data
│   └── reports/          # Generated reports
├── backups/              # Automated backups
├── logs/                 # Log files and alerts
└── workflows/            # Workflow templates
```

## 🔧 Customization

Each workflow can be customized:

1. **Modify Triggers**: Change schedules, add webhooks, or file watchers
2. **Add Nodes**: Extend workflows with additional processing steps
3. **Configure Credentials**: Add API keys for external services
4. **Adjust Logic**: Modify JavaScript code in Code nodes
5. **Set Thresholds**: Update monitoring limits and conditions

## 🔐 Security

- Enable basic authentication in production
- Use HTTPS for all webhook URLs
- Store sensitive credentials in n8n's credential system
- Regularly update n8n to get security patches
- Limit file access permissions appropriately

## 📚 Additional Resources

- [n8n Documentation](https://docs.n8n.io)
- [n8n Community Forum](https://community.n8n.io)
- [Workflow Templates](./workflows/README.md)
- [n8n Nodes Reference](https://docs.n8n.io/nodes/)

## 🐛 Troubleshooting

### Workflows not running
- Check if workflows are activated
- Verify trigger configurations
- Review execution logs in n8n UI

### File operations failing
- Verify directory permissions
- Check path configurations
- Ensure directories exist

### High resource usage
- Reduce monitoring frequency
- Limit concurrent executions
- Optimize workflow logic

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Add new workflow templates
- Improve existing workflows
- Update documentation
- Report issues

## 📄 License

MIT License - Feel free to use and modify as needed.

## 🆘 Support

For issues and questions:
- Check the [n8n documentation](https://docs.n8n.io)
- Visit the [n8n community forum](https://community.n8n.io)
- Open an issue in this repository

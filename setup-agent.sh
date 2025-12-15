#!/bin/bash

# Computer Automation Agent Setup Script
# This script initializes the required directory structure for the automation agent

echo "🤖 Initializing Computer Automation Agent..."

# Create directory structure
echo "📁 Creating directory structure..."

# File management directories
mkdir -p /home/node/files/incoming
mkdir -p /home/node/files/organized/{images,documents,videos,audio,archives,executables,other}
mkdir -p /home/node/temp

# Data processing directories
mkdir -p /home/node/data/input
mkdir -p /home/node/data/output
mkdir -p /home/node/data/reports
mkdir -p /home/node/data/web-scraping

# Backup and logs
mkdir -p /home/node/backups
mkdir -p /home/node/logs/alerts
mkdir -p /home/node/reports

# n8n configuration
mkdir -p /home/node/.n8n/workflows
mkdir -p /home/node/.n8n/credentials

echo "✅ Directory structure created"

# Set permissions
echo "🔒 Setting permissions..."
chmod -R 755 /home/node/files
chmod -R 755 /home/node/data
chmod -R 755 /home/node/backups
chmod -R 755 /home/node/logs
chmod -R 700 /home/node/.n8n

echo "✅ Permissions set"

# Create sample data file
echo "📝 Creating sample data file..."
cat > /home/node/data/input/sample-data.csv << 'EOF'
name,amount,quantity,date
Item A,150.50,5,2025-01-01
Item B,75.25,10,2025-01-02
Item C,200.00,3,2025-01-03
Item D,50.75,8,2025-01-04
Item E,1200.00,2,2025-01-05
EOF

echo "✅ Sample data file created"

# Display completion message
echo ""
echo "✨ Computer Automation Agent initialization complete!"
echo ""
echo "📋 Directory Structure:"
echo "   - File Management: /home/node/files/"
echo "   - Data Processing: /home/node/data/"
echo "   - Backups: /home/node/backups/"
echo "   - Logs: /home/node/logs/"
echo "   - Reports: /home/node/reports/"
echo ""
echo "🚀 Next Steps:"
echo "   1. Start n8n: npm start"
echo "   2. Access n8n UI: http://localhost:5678"
echo "   3. Import workflows from /workflows directory"
echo "   4. Configure credentials and activate workflows"
echo ""
echo "📖 Documentation: See README.md and workflows/README.md"
echo ""

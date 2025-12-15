# Testing Guide - Computer Automation Agent

This guide helps you test and verify that the Computer Automation Agent is working correctly.

## Pre-deployment Testing

### 1. Validate JSON Workflows

All workflow files should be valid JSON:

```bash
# Test all workflows
for file in workflows/*.json; do
  python3 -m json.tool "$file" > /dev/null && echo "✓ $(basename $file)" || echo "✗ $(basename $file)"
done
```

Expected output: ✓ for all 8 workflow files

### 2. Check Dockerfile

Build the Docker image locally:

```bash
docker build -t n8n-automation-agent .
```

Expected: Build completes without errors

### 3. Verify Setup Script

Run the setup script:

```bash
chmod +x setup-agent.sh
./setup-agent.sh
```

Expected: Directory structure created successfully

## Post-deployment Testing

### 1. Access n8n Interface

**Test URL Access**:
- Navigate to your deployment URL
- You should see the n8n login page

**Expected**: 
- HTTPS connection (if deployed to Render)
- Basic auth prompt appears
- Login works with configured credentials

### 2. Import and Test Workflows

#### Test 1: Getting Started Workflow

**Steps**:
1. Import `workflows/getting-started.json`
2. Open the workflow
3. Click "Execute Workflow"

**Expected Result**:
```json
{
  "timestamp": "2025-XX-XX...",
  "message": "Automation agent is active",
  "capabilities": [
    "File Management",
    "Scheduled Tasks",
    ...
  ]
}
```

**Pass Criteria**: Workflow executes successfully with output showing agent capabilities

---

#### Test 2: File Management Workflow

**Steps**:
1. Import `workflows/file-management.json`
2. Create test directories:
   ```bash
   mkdir -p /home/node/files/incoming
   mkdir -p /home/node/files/temp
   ```
3. Create test files:
   ```bash
   touch /home/node/files/temp/old-file-$(date -d '10 days ago' +%Y%m%d).txt
   echo "test" > /home/node/files/incoming/test.jpg
   ```
4. Activate the workflow

**Expected Result**:
- New files moved to appropriate category folders
- Old temp files cleaned up

**Pass Criteria**: 
- Files correctly categorized
- Old files deleted
- No errors in execution log

---

#### Test 3: System Monitoring Workflow

**Steps**:
1. Import `workflows/system-monitoring.json`
2. Review threshold settings
3. Activate the workflow
4. Wait 5 minutes for first execution

**Expected Result**:
```json
{
  "stats": {
    "cpu": "X.XX%",
    "memory": "Y.YY%",
    "disk": "Z%"
  },
  "alerts": []
}
```

**Pass Criteria**:
- System stats collected successfully
- No errors in execution
- If thresholds exceeded, alerts generated

---

#### Test 4: Data Processing Workflow

**Setup**:
Create test CSV file at `/home/node/data/input/data.csv`:
```csv
name,amount,quantity,date
Item A,150.50,5,2025-01-01
Item B,75.25,10,2025-01-02
```

**Steps**:
1. Import `workflows/data-processing.json`
2. Execute workflow manually

**Expected Result**:
- CSV file read successfully
- Data transformed with new fields
- Output saved to `/home/node/data/output/`
- Summary report generated

**Pass Criteria**:
- No execution errors
- Output file created
- Data correctly transformed

---

#### Test 5: Web Automation Workflow

**Steps**:
1. Import `workflows/web-automation.json`
2. Update URL in "Set URLs to Monitor" node to a test URL
3. Execute workflow manually

**Expected Result**:
- Web page fetched successfully
- HTML parsed correctly
- Data extracted and saved

**Pass Criteria**:
- HTTP request successful (200 status)
- Data extraction works
- Results saved to file

---

#### Test 6: API Integration Workflow

**Steps**:
1. Import `workflows/api-integration.json`
2. Test webhook endpoint:
   ```bash
   curl -X POST https://your-url.onrender.com/webhook/api-webhook \
     -H "Content-Type: application/json" \
     -d '{"action":"process_data","data":{"test":"value"}}'
   ```

**Expected Result**:
```json
{
  "success": true,
  "processed": {...},
  "metadata": {...}
}
```

**Pass Criteria**:
- Webhook receives request
- Request validated correctly
- Proper response returned

---

#### Test 7: Email Automation Workflow

**Prerequisites**:
- Configure email credentials in n8n

**Steps**:
1. Import `workflows/email-automation.json`
2. Configure IMAP credentials
3. Activate workflow

**Expected Result**:
- Connects to email server
- Fetches unread emails
- Categorizes emails correctly

**Pass Criteria**:
- Email connection successful
- Processing logic works
- No authentication errors

---

#### Test 8: Scheduled Tasks Workflow

**Steps**:
1. Import `workflows/scheduled-tasks.json`
2. Modify schedule for immediate testing:
   - Change cron to run in 2 minutes
3. Activate workflow
4. Wait for execution

**Expected Result**:
- Backup created in `/home/node/backups/`
- Backup compressed successfully
- Old backups cleaned

**Pass Criteria**:
- Scheduled execution triggers
- Backup file created
- Cleanup executes successfully

---

## Integration Testing

### Test Environment Variables

Verify all required env vars are set:

```bash
# In n8n UI: Settings → Environment Variables
# Or check in Render dashboard

Required:
- N8N_BASIC_AUTH_ACTIVE=true
- N8N_BASIC_AUTH_USER
- N8N_BASIC_AUTH_PASSWORD
- N8N_HOST
- N8N_PORT=5678
```

### Test Directory Structure

Verify all required directories exist:

```bash
ls -la /home/node/
# Should show:
# - files/
# - data/
# - backups/
# - logs/
# - workflows/
```

### Test Permissions

Check that n8n can write to directories:

```bash
touch /home/node/files/test-write.txt
touch /home/node/data/test-write.txt
touch /home/node/backups/test-write.txt
touch /home/node/logs/test-write.txt
```

All should succeed without permission errors.

## Performance Testing

### Memory Usage

Monitor n8n memory usage:

```bash
# Check container/process memory
docker stats  # if using Docker
# or
ps aux | grep n8n
```

**Expected**: < 500MB for basic workflows

### Concurrent Executions

1. Activate multiple workflows simultaneously
2. Trigger several manual executions
3. Monitor execution queue

**Expected**: All workflows execute successfully without hanging

### Long-running Workflows

1. Test workflows that run for extended periods
2. Monitor for timeouts or crashes

**Expected**: Workflows complete successfully or timeout gracefully

## Error Handling Testing

### Test Invalid Data

1. Feed malformed CSV to data processing workflow
2. Provide invalid URLs to web automation
3. Send malformed JSON to API webhook

**Expected**: Graceful error handling, helpful error messages

### Test Missing Files

1. Run workflows with missing input files
2. Check error messages

**Expected**: Clear error messages, no crashes

### Test Network Failures

1. Test web automation with unreachable URLs
2. Test API integration with offline services

**Expected**: Retry logic works, errors logged

## Security Testing

### Test Authentication

1. Try accessing without credentials
2. Try with wrong credentials
3. Verify HTTPS enforcement (on Render)

**Expected**: Unauthorized access blocked

### Test Webhook Security

1. Send malicious payloads to webhooks
2. Test SQL injection attempts
3. Test XSS payloads

**Expected**: Input validation prevents exploits

### Test File Operations

1. Try path traversal in file operations
2. Test with special characters in filenames

**Expected**: Security measures prevent exploitation

## Deployment Verification Checklist

After deploying to Render:

- [ ] Application is running (green status)
- [ ] URL is accessible via HTTPS
- [ ] Login works with configured credentials
- [ ] All 8 workflows import successfully
- [ ] At least 1 workflow executes successfully
- [ ] Execution logs are accessible
- [ ] Scheduled workflows trigger on time
- [ ] Webhooks are reachable from external sources
- [ ] File operations work correctly
- [ ] System monitoring shows accurate data
- [ ] Backups are being created
- [ ] Email integration works (if configured)
- [ ] No security warnings in browser
- [ ] SSL certificate is valid

## Troubleshooting Common Issues

### Issue: Workflows don't import

**Solution**: 
- Verify JSON is valid
- Check n8n version compatibility
- Try importing one at a time

### Issue: File operations fail

**Solution**:
- Check directory permissions
- Verify paths are correct
- Ensure directories exist

### Issue: Scheduled workflows don't run

**Solution**:
- Verify timezone settings
- Check cron expression syntax
- Ensure workflow is activated

### Issue: High memory usage

**Solution**:
- Reduce concurrent executions
- Optimize workflow logic
- Increase instance resources

## Test Results Template

Use this template to document your testing:

```markdown
## Test Results - [Date]

### Environment
- Deployment: [Render/Local/Docker]
- n8n Version: [version]
- Node Version: [version]

### Workflow Tests
- [ ] Getting Started: PASS/FAIL
- [ ] File Management: PASS/FAIL
- [ ] System Monitoring: PASS/FAIL
- [ ] Scheduled Tasks: PASS/FAIL
- [ ] Data Processing: PASS/FAIL
- [ ] Web Automation: PASS/FAIL
- [ ] API Integration: PASS/FAIL
- [ ] Email Automation: PASS/FAIL

### Integration Tests
- [ ] Environment Variables: PASS/FAIL
- [ ] Directory Structure: PASS/FAIL
- [ ] Permissions: PASS/FAIL

### Issues Found
1. [Issue description]
2. [Issue description]

### Overall Status
[PASS/FAIL] - Ready for production
```

## Continuous Monitoring

After deployment, monitor:

1. **Execution Success Rate**: Aim for >95%
2. **Response Time**: Workflows complete in reasonable time
3. **Resource Usage**: Stays within limits
4. **Error Logs**: Check for recurring errors
5. **Scheduled Tasks**: Verify they run on time

## Getting Help

If tests fail:
1. Check execution logs in n8n UI
2. Review error messages
3. Verify configuration
4. Check system resources
5. Consult [n8n documentation](https://docs.n8n.io)
6. Ask in [n8n community forum](https://community.n8n.io)

---

**Remember**: Not all workflows need to work immediately. Configure them one at a time, test thoroughly, and ensure each works before adding the next.

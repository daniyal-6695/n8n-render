# Cron Scheduling Guide - n8n Automation Agent

This guide explains how to use cron expressions to schedule automated tasks in your n8n automation agent.

## What is Cron?

Cron is a time-based job scheduling system. In n8n, you use cron expressions to define when workflows should automatically run.

## Cron Expression Format

```
* * * * *
│ │ │ │ │
│ │ │ │ └─── Day of Week (0-6, Sunday=0)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of Month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

## Common Cron Examples

### Every Minute
```
* * * * *
```
Use case: Real-time monitoring, frequent checks

### Every 5 Minutes
```
*/5 * * * *
```
Use case: Regular system checks, API polling

### Every Hour
```
0 * * * *
```
Use case: Hourly reports, periodic cleanup

### Every Day at Midnight
```
0 0 * * *
```
Use case: Daily backups, end-of-day reports

### Every Day at 2 AM
```
0 2 * * *
```
Use case: Maintenance tasks (low-traffic hours)

### Every Monday at 9 AM
```
0 9 * * 1
```
Use case: Weekly reports, Monday morning tasks

### Every Sunday at 3 AM
```
0 3 * * 0
```
Use case: Weekly maintenance, backups

### First Day of Month at Midnight
```
0 0 1 * *
```
Use case: Monthly reports, billing tasks

### Every Weekday at 8 AM
```
0 8 * * 1-5
```
Use case: Business hour tasks, Monday-Friday automation

### Every 15 Minutes During Business Hours
```
*/15 9-17 * * 1-5
```
Use case: Business hours monitoring

### Twice Daily (6 AM and 6 PM)
```
0 6,18 * * *
```
Use case: Morning and evening reports

### Every 6 Hours
```
0 */6 * * *
```
Use case: Regular system checks throughout the day

## n8n Schedule Trigger Configuration

### Method 1: Using Cron Expression

1. Add a **Schedule Trigger** node to your workflow
2. In the node settings, select **Cron Expression**
3. Enter your cron expression
4. Save the workflow

Example configuration:
```json
{
  "parameters": {
    "rule": {
      "interval": [
        {
          "field": "cronExpression",
          "expression": "0 2 * * *"
        }
      ]
    }
  },
  "name": "Daily at 2 AM",
  "type": "n8n-nodes-base.scheduleTrigger"
}
```

### Method 2: Using Simple Intervals

For simpler schedules, use the visual interval selector:

**Every X Minutes:**
```json
{
  "field": "minutes",
  "minutesInterval": 5
}
```

**Every X Hours:**
```json
{
  "field": "hours",
  "hoursInterval": 6
}
```

**Every Day:**
```json
{
  "field": "days",
  "daysInterval": 1
}
```

## Workflows Using Cron in This Agent

### 1. Scheduled Tasks Workflow
```
Daily at 2 AM: 0 2 * * *
└─ Runs backups and cleanup

Weekly on Sunday: 0 3 * * 0
└─ Weekly maintenance and reports
```

### 2. Email Automation Workflow
```
Weekly Summary (Monday 9 AM): 0 9 * * 1
└─ Generates and sends weekly email summary
```

## Customizing Schedules

### Change Backup Time
Edit `workflows/scheduled-tasks.json`:
```json
{
  "field": "cronExpression",
  "expression": "0 2 * * *"  // Change to your preferred time
}
```

Examples:
- `0 1 * * *` - 1 AM daily
- `0 23 * * *` - 11 PM daily
- `30 3 * * *` - 3:30 AM daily

### Change Monitoring Frequency
Edit `workflows/system-monitoring.json`:
```json
{
  "field": "minutes",
  "minutesInterval": 5  // Change interval
}
```

Examples:
- `1` - Every minute (intensive)
- `10` - Every 10 minutes
- `30` - Every 30 minutes

### Change Email Check Frequency
Edit `workflows/email-automation.json`:
```json
{
  "field": "minutes",
  "minutesInterval": 10  // Change interval
}
```

## Testing Cron Schedules

### Test Immediately
1. Open workflow in n8n UI
2. Click "Execute Workflow" button
3. Verify output

### Test with Near-Future Cron
Set a cron for 2 minutes from now:
```
# If current time is 14:30, use:
32 14 * * *  # Runs at 14:32
```

### View Next Execution
In n8n UI:
1. Open workflow
2. Check "Next Execution" time
3. Verify it matches your expectation

## Common Cron Patterns

### During Business Hours Only
```
# Every hour from 9 AM to 5 PM, Monday-Friday
0 9-17 * * 1-5

# Every 30 minutes during business hours
*/30 9-17 * * 1-5
```

### Off-Peak Hours
```
# Every hour from 6 PM to 6 AM
0 18-23,0-6 * * *

# Night-time only (11 PM to 5 AM)
0 23,0-5 * * *
```

### Multiple Times Per Day
```
# 8 AM, 12 PM, 6 PM
0 8,12,18 * * *

# Every 3 hours
0 */3 * * *
```

### Specific Days
```
# Monday and Friday at 9 AM
0 9 * * 1,5

# Weekends at noon
0 12 * * 0,6
```

## Timezone Considerations

### Set Timezone
In your `.env` file:
```bash
GENERIC_TIMEZONE=America/New_York
# or
GENERIC_TIMEZONE=Europe/London
# or
GENERIC_TIMEZONE=Asia/Kolkata
```

### Common Timezones
- `America/New_York` - EST/EDT
- `America/Los_Angeles` - PST/PDT
- `Europe/London` - GMT/BST
- `Europe/Paris` - CET/CEST
- `Asia/Tokyo` - JST
- `Asia/Kolkata` - IST
- `Asia/Dubai` - GST
- `Australia/Sydney` - AEST

### Verify Timezone
Check in n8n settings or logs to confirm the timezone is applied correctly.

## Advanced Cron Examples

### Complex Schedules

**Every Quarter (Jan, Apr, Jul, Oct) on 1st at midnight:**
```
0 0 1 1,4,7,10 *
```

**Last Day of Month:**
```
# Use a script to determine last day
# Or run daily and check if tomorrow is next month
```

**Business Days (Mon-Fri) Excluding Holidays:**
```
# Base: 0 9 * * 1-5
# Add holiday checking logic in workflow
```

### Performance Considerations

**High Frequency (Every Minute):**
- Use for critical monitoring only
- May increase resource usage
- Consider batching operations

**Low Frequency (Daily/Weekly):**
- Ideal for backups and reports
- Lower resource usage
- Better for large operations

## Debugging Cron Schedules

### Schedule Not Running

1. **Check Workflow is Activated**
   - Toggle must be ON in n8n UI

2. **Verify Cron Expression**
   - Use online cron calculator
   - Check for typos

3. **Check Timezone**
   - Verify GENERIC_TIMEZONE setting
   - Account for daylight saving time

4. **Review Execution History**
   - Check n8n execution logs
   - Look for error messages

### Workflow Running at Wrong Time

1. **Verify Timezone Setting**
   - Check `.env` file
   - Restart n8n after changes

2. **Confirm Cron Expression**
   - Double-check hour/minute values
   - Account for 24-hour format

3. **Check Server Time**
   ```bash
   date
   # or
   timedatectl
   ```

## Real-World Examples

### Daily Database Backup
```
# Every day at 2 AM
0 2 * * *

Workflow:
1. Connect to database
2. Export data
3. Compress backup
4. Upload to cloud storage
5. Delete old backups
```

### Hourly API Sync
```
# Every hour at 0 minutes
0 * * * *

Workflow:
1. Fetch data from API A
2. Transform data
3. Send to API B
4. Log results
```

### Weekly Report Generation
```
# Every Monday at 8 AM
0 8 * * 1

Workflow:
1. Query database for week's data
2. Generate charts
3. Create PDF report
4. Email to stakeholders
```

### System Health Check
```
# Every 5 minutes
*/5 * * * *

Workflow:
1. Check CPU usage
2. Check memory usage
3. Check disk space
4. Alert if threshold exceeded
```

## Best Practices

### 1. Avoid Peak Hours for Heavy Tasks
```
# Good: 2 AM for backups
0 2 * * *

# Bad: 9 AM for heavy processing
0 9 * * *
```

### 2. Stagger Multiple Workflows
```
# Backup: 2:00 AM
0 2 * * *

# Cleanup: 2:30 AM
30 2 * * *

# Report: 3:00 AM
0 3 * * *
```

### 3. Use Appropriate Frequencies
```
# Critical monitoring: Every minute
* * * * *

# Regular checks: Every 5-15 minutes
*/5 * * * *

# Maintenance: Daily or weekly
0 2 * * *
```

### 4. Test Before Production
- Start with manual execution
- Test with near-future cron
- Monitor first few automated runs

### 5. Document Your Schedules
Keep a schedule overview:
```
Workflow              | Schedule      | Description
---------------------|---------------|------------------
File Management      | Every hour    | Organize files
System Monitoring    | Every 5 min   | Check resources
Backups              | Daily 2 AM    | Backup data
Weekly Reports       | Mon 9 AM      | Generate reports
```

## Cron Expression Cheat Sheet

```
Field          | Values        | Special
---------------|---------------|----------
Minute         | 0-59          | * , - /
Hour           | 0-23          | * , - /
Day of Month   | 1-31          | * , - /
Month          | 1-12          | * , - /
Day of Week    | 0-6 (0=Sun)   | * , - /

Special Characters:
* = Any value
, = Multiple values (1,3,5)
- = Range (1-5)
/ = Step (*/5 = every 5)
```

## Quick Reference

| Frequency | Cron Expression | Use Case |
|-----------|----------------|----------|
| Every minute | `* * * * *` | Real-time monitoring |
| Every 5 minutes | `*/5 * * * *` | Frequent checks |
| Every 15 minutes | `*/15 * * * *` | Regular polling |
| Every 30 minutes | `*/30 * * * *` | Semi-frequent tasks |
| Every hour | `0 * * * *` | Hourly tasks |
| Every 6 hours | `0 */6 * * *` | Periodic sync |
| Daily at midnight | `0 0 * * *` | End-of-day tasks |
| Daily at 2 AM | `0 2 * * *` | Maintenance |
| Daily at 9 AM | `0 9 * * *` | Morning tasks |
| Weekly (Mon 9 AM) | `0 9 * * 1` | Weekly reports |
| Weekly (Sun 3 AM) | `0 3 * * 0` | Weekly cleanup |
| Monthly (1st at 12 AM) | `0 0 1 * *` | Monthly tasks |

## Online Tools

- [Crontab.guru](https://crontab.guru) - Cron expression validator
- [Cron Expression Generator](https://www.freeformatter.com/cron-expression-generator-quartz.html)
- n8n documentation - [Schedule Trigger](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.scheduletrigger/)

## Getting Help

If you need help with cron expressions:
1. Check this guide for common patterns
2. Use online cron calculators
3. Test with near-future times
4. Review n8n execution logs
5. Ask in [n8n community forum](https://community.n8n.io)

---

**Remember**: All times in cron expressions are based on your server's timezone. Set `GENERIC_TIMEZONE` in your `.env` file to control this!

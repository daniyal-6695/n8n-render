# Deployment Guide - Building SaaS Products with n8n on Render

This guide walks you through deploying n8n on Render to build production-ready SaaS products.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Quick Deploy](#quick-deploy)
3. [Database Setup](#database-setup)
4. [Environment Configuration](#environment-configuration)
5. [Custom Domain Setup](#custom-domain-setup)
6. [Production Best Practices](#production-best-practices)
7. [Scaling Your SaaS](#scaling-your-saas)
8. [Monitoring & Maintenance](#monitoring--maintenance)

## Prerequisites

- GitHub account
- Render account (free tier available)
- Basic understanding of environment variables
- Domain name (optional, for custom domain)

## Quick Deploy

### Option 1: Using render.yaml (Recommended)

1. **Fork this repository** to your GitHub account

2. **Connect to Render**
   - Log in to [Render Dashboard](https://dashboard.render.com/)
   - Click "New +" → "Blueprint"
   - Connect your GitHub repository
   - Select the forked `n8n-render` repository

3. **Review Configuration**
   - Render will detect the `render.yaml` file
   - Review the service and database configuration
   - Click "Apply" to create resources

4. **Wait for Deployment**
   - Render will create a PostgreSQL database
   - Build and deploy the n8n container
   - Wait 5-10 minutes for initial deployment

5. **Access Your Instance**
   - Navigate to the provided URL: `https://your-service-name.onrender.com`
   - Log in with the auto-generated credentials (check environment variables)

### Option 2: Manual Deployment

1. **Create PostgreSQL Database**
   - In Render Dashboard, click "New +" → "PostgreSQL"
   - Name: `n8n-db`
   - Region: Choose closest to your users
   - Plan: Starter ($7/month) or Free
   - Click "Create Database"

2. **Create Web Service**
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Configure:
     - **Name:** n8n-saas
     - **Region:** Same as database
     - **Branch:** main
     - **Environment:** Docker
     - **Plan:** Starter ($7/month) or Free

3. **Configure Environment Variables** (see below)

4. **Deploy**
   - Click "Create Web Service"
   - Monitor the build logs
   - Wait for deployment to complete

## Database Setup

### Using Render PostgreSQL

Render automatically provides connection details for PostgreSQL databases.

**Environment Variables to Set:**
```
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=[Internal Database URL from Render]
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=[Database User from Render]
DB_POSTGRESDB_PASSWORD=[Database Password from Render]
```

### Database Schema

n8n creates its schema automatically on first startup. You can also create additional tables for your SaaS application:

```sql
-- Example: Leads table for Lead Capture API
CREATE TABLE leads (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    company VARCHAR(255),
    phone VARCHAR(50),
    notes TEXT,
    source VARCHAR(100),
    status VARCHAR(50) DEFAULT 'new',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_leads_email ON leads(email);
CREATE INDEX idx_leads_status ON leads(status);
CREATE INDEX idx_leads_created_at ON leads(created_at);
```

## Environment Configuration

### Essential Variables

```bash
# Authentication (REQUIRED)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=your-admin-username
N8N_BASIC_AUTH_PASSWORD=your-secure-password

# Host Configuration (REQUIRED)
N8N_HOST=your-service-name.onrender.com
N8N_PROTOCOL=https
WEBHOOK_URL=https://your-service-name.onrender.com/

# Database (REQUIRED for production)
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=your-db-hostname
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=your-db-user
DB_POSTGRESDB_PASSWORD=your-db-password

# Security (REQUIRED)
N8N_ENCRYPTION_KEY=your-encryption-key-min-10-chars
```

### Optional Variables for SaaS Products

```bash
# Performance Optimization
EXECUTIONS_TIMEOUT=300
EXECUTIONS_TIMEOUT_MAX=3600
N8N_CONCURRENCY_PRODUCTION_LIMIT=10

# Webhook Configuration
N8N_PAYLOAD_SIZE_MAX=16

# Timezone
GENERIC_TIMEZONE=America/New_York

# Logging
N8N_LOG_LEVEL=info
N8N_LOG_OUTPUT=console

# Editor
N8N_EDITOR_BASE_URL=https://your-service-name.onrender.com

# Features
N8N_PERSONALIZATION_ENABLED=true
N8N_VERSION_NOTIFICATIONS_ENABLED=true
N8N_DIAGNOSTICS_ENABLED=false
```

## Custom Domain Setup

1. **Add Custom Domain in Render**
   - Go to your web service settings
   - Click "Custom Domain"
   - Add your domain: `app.yourdomain.com`

2. **Configure DNS**
   - Add CNAME record in your DNS provider:
     - Name: `app`
     - Value: `your-service-name.onrender.com`

3. **Update Environment Variables**
   ```
   N8N_HOST=app.yourdomain.com
   WEBHOOK_URL=https://app.yourdomain.com/
   N8N_EDITOR_BASE_URL=https://app.yourdomain.com
   ```

4. **SSL Certificate**
   - Render automatically provisions SSL certificates
   - Wait 5-10 minutes for SSL activation

## Production Best Practices

### Security

1. **Use Strong Passwords**
   - Generate secure passwords for N8N_BASIC_AUTH_PASSWORD
   - Use a password manager

2. **Encryption Key**
   - Generate a strong encryption key (min 10 characters)
   - Never share or commit this key
   ```bash
   # Generate a secure key
   openssl rand -base64 32
   ```

3. **Webhook Authentication**
   - Add authentication to webhook endpoints
   - Use API keys or JWT tokens
   - Validate all incoming data

4. **Database Security**
   - Use Render's internal database connections
   - Enable SSL for database connections
   - Regular backups

### Performance

1. **Optimize Workflows**
   - Minimize HTTP requests
   - Use batch operations
   - Cache frequently accessed data

2. **Database Indexing**
   - Add indexes for frequently queried columns
   - Monitor slow queries

3. **Execution Limits**
   - Set appropriate timeout values
   - Limit concurrent executions
   - Use queue mode for high-volume workflows

### Reliability

1. **Error Handling**
   - Add error workflow nodes
   - Implement retry logic
   - Log all errors

2. **Monitoring**
   - Check execution history regularly
   - Set up alerts for failures
   - Monitor resource usage

3. **Backups**
   - Export workflows regularly
   - Backup database daily
   - Store backups securely

## Scaling Your SaaS

### Horizontal Scaling

As your SaaS grows, upgrade your Render plan:

1. **Web Service**
   - Free: 512MB RAM, shared CPU
   - Starter: 512MB RAM, $7/month
   - Standard: 2GB RAM, $25/month
   - Pro: 4GB RAM, $85/month

2. **Database**
   - Free: 256MB RAM (temporary)
   - Starter: 256MB RAM, $7/month
   - Standard: 1GB RAM, $20/month
   - Pro: 4GB RAM, $90/month

### Optimization Strategies

1. **Workflow Optimization**
   - Split complex workflows into smaller ones
   - Use sub-workflows for reusability
   - Implement caching strategies

2. **Database Optimization**
   - Add proper indexes
   - Archive old execution data
   - Use connection pooling

3. **Queue Mode**
   - Enable queue mode for high-volume scenarios
   - Distribute workload across multiple workers

## Monitoring & Maintenance

### Health Checks

Render automatically monitors your service health.

**Custom Health Endpoint:**
Add a workflow with a webhook that returns service status.

### Logging

View logs in Render Dashboard:
- Service Logs: Real-time application logs
- Events: Deployment and scaling events

### Execution Monitoring

In n8n interface:
- View execution history
- Filter by status (success/error)
- Analyze performance metrics

### Updates

Keep n8n updated:

1. **Automatic Updates (if using latest tag)**
   - Render rebuilds on schedule
   - Or trigger manual deploy

2. **Manual Updates**
   - Change version in Dockerfile
   - Commit and push
   - Render auto-deploys

### Backup Strategy

1. **Workflow Backups**
   - Export workflows regularly
   - Store in version control
   - Test restoration process

2. **Database Backups**
   - Render provides daily backups (paid plans)
   - Export database manually for additional safety
   ```bash
   pg_dump -h hostname -U username -d n8n > backup.sql
   ```

## Troubleshooting

### Common Issues

**1. Service won't start**
- Check environment variables
- Verify database connection
- Review logs in Render Dashboard

**2. Webhooks not working**
- Verify WEBHOOK_URL is correct
- Check webhook is activated
- Test with curl or Postman

**3. Slow performance**
- Upgrade Render plan
- Optimize workflows
- Add database indexes

**4. Authentication issues**
- Verify N8N_BASIC_AUTH_* variables
- Clear browser cache
- Try incognito mode

### Getting Help

- [n8n Community Forum](https://community.n8n.io/)
- [Render Documentation](https://render.com/docs)
- [n8n Documentation](https://docs.n8n.io/)

## Cost Estimation

### Minimum Production Setup

- Web Service (Starter): $7/month
- PostgreSQL (Starter): $7/month
- **Total: $14/month**

### Recommended Production Setup

- Web Service (Standard): $25/month
- PostgreSQL (Standard): $20/month
- **Total: $45/month**

### Free Tier Limitations

- Services sleep after 15 min inactivity
- Database is temporary (deleted after 90 days)
- Not recommended for production SaaS

## Next Steps

1. Deploy your n8n instance
2. Import example workflows from `/example-workflows`
3. Customize workflows for your SaaS use case
4. Test thoroughly
5. Launch your SaaS product!

---

**Ready to build?** Start with the Quick Deploy section above! 🚀

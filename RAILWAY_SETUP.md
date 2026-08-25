# Railway Template Setup Guide

This document contains step-by-step instructions for creating and publishing the InvoicePlane template on Railway.

## Prerequisites

- Railway account (free tier is sufficient)
- Railway CLI installed (optional, for advanced operations)

## Step 1: Create Railway Project

1. Go to [railway.app](https://railway.app)
2. Click **New Project**
3. Select **Empty Project**
4. Name it `InvoicePlane`

## Step 2: Add MariaDB Service

1. In the project canvas, click **+ New**
2. Select **Database** → **MariaDB**
3. Railway auto-creates the MariaDB service with:
   - `MARIADB_URL` (connection string)
   - `MARIADB_HOST`, `MARIADB_PORT`, `MARIADB_USER`, `MARIADB_PASSWORD`, `MARIADB_DATABASE`

**Important:** Rename the service to `MariaDB` (capital M, capital DB) for proper naming conventions.

## Step 3: Add InvoicePlane Service

1. Click **+ New** → **Docker Image**
2. Enter image: `funktionslust/invoiceplane:1.6.5`
3. Name the service `InvoicePlane`

## Step 4: Configure InvoicePlane Variables

Go to the **Variables** tab of the InvoicePlane service and add:

### Auto-Generated Secrets (use Railway template functions)

```
ENCRYPTION_KEY=${{secret(43, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/")}}=
```

### Database Connection (reference MariaDB service)

```
DB_HOSTNAME=${{MariaDB.MARIADB_HOST}}
DB_USERNAME=${{MariaDB.MARIADB_USER}}
DB_PASSWORD=${{MariaDB.MARIADB_PASSWORD}}
DB_DATABASE=${{MariaDB.MARIADB_DATABASE}}
DB_PORT=${{MariaDB.MARIADB_PORT}}
```

### Application Configuration

```
IP_URL=${{RAILWAY_PUBLIC_DOMAIN}}
CI_ENV=production
ENABLE_DEBUG=false
DEFAULT_LANGUAGE=english
DEFAULT_ADMIN_EMAIL=admin@localhost
TZ=UTC
```

### Optional Security Variables

```
COOKIE_SECURE=true
X_FRAME_OPTIONS=SAMEORIGIN
ENABLE_X_CONTENT_TYPE_OPTIONS=true
SESS_MATCH_IP=true
SESS_REGENERATE_DESTROY=true
```

## Step 5: Configure Networking

1. InvoicePlane must reach MariaDB via **private network**
2. In InvoicePlane service settings, ensure `DB_HOSTNAME` uses `${{MariaDB.MARIADB_HOST}}` (resolves to `maria-db.railway.internal`)
3. **Do NOT expose MariaDB publicly** — it should only be accessible via private network

## Step 6: Add Persistent Volumes

### InvoicePlane Volumes

1. Right-click the InvoicePlane service → **Attach Volume**
2. Mount path: `/var/www/html/uploads`
3. Create a second volume:
4. Mount path: `/var/www/html/storage`

### MariaDB Volume

1. Right-click the MariaDB service → **Attach Volume**
2. Mount path: `/var/lib/mysql`

## Step 7: Configure Health Checks

### InvoicePlane Health Check

In the InvoicePlane service Settings:
- **Healthcheck Path:** `/`
- **Healthcheck Timeout:** 300 seconds

### MariaDB Health Check

MariaDB has a built-in health check. If needed:
- **Healthcheck Path:** (leave empty, uses TCP)
- **Healthcheck Timeout:** 300 seconds

## Step 8: Enable Public Networking

1. In InvoicePlane service Settings → **Networking**
2. Generate a public domain (Railway assigns `*.up.railway.app`)
3. This domain is automatically used in `IP_URL`

## Step 9: Test Deployment

1. Click **Deploy** (or it auto-deploys on variable changes)
2. Wait for both services to show **Active** status
3. Open the InvoicePlane public URL
4. The setup wizard should appear
5. Create your admin account
6. Test creating a client and an invoice

## Step 10: Publish as Template

1. Go to **Project Settings** (gear icon)
2. Scroll to **Generate Template from Project**
3. Click **Create Template**
4. Fill in template details:
   - **Name:** `InvoicePlane`
   - **Description:** `Self-hosted open source invoicing application with MariaDB`
   - **Category:** `Finance & Invoicing`
   - **Icon:** Use InvoicePlane logo (1:1 aspect ratio, transparent background)
5. Add template overview (see README.md for content)
6. Click **Publish**

## Template Variable Functions Reference

When publishing, Railway converts these to placeholders:

| Original Value | Becomes |
|----------------|---------|
| `${{secret(43, ...)}}=` | Generated placeholder |
| `${{MariaDB.MARIADB_HOST}}` | Reference placeholder |
| `${{RAILWAY_PUBLIC_DOMAIN}}` | Auto-populated on deploy |

## Post-Publication Checklist

- [ ] Template appears in Railway Marketplace
- [ ] One-click deploy works end-to-end
- [ ] Setup wizard appears on fresh deploy
- [ ] Database persists across redeployments
- [ ] Uploads persist across redeployments
- [ ] Health checks pass consistently
- [ ] README is complete and accurate
- [ ] Cost estimate is accurate (free tier)

## Troubleshooting During Setup

### "Database connection refused"
- MariaDB may still be initializing (first deploy takes 30-60s)
- Check that `DB_HOSTNAME` resolves correctly
- Verify MariaDB service is **Active**

### "IP_URL not set correctly"
- `${{RAILWAY_PUBLIC_DOMAIN}}` only resolves after the first deploy
- Deploy once, then verify the URL is correct
- Redeploy if needed

### "Encryption key errors"
- The `${{secret()}}` function generates a new key on each deploy
- For production, set a fixed `ENCRYPTION_KEY` after initial setup
- To generate: `openssl rand -base64 32`

### Volume mount issues
- Ensure volumes are attached BEFORE the first deploy
- Volumes created after deployment may not persist existing data

## Cost Optimization

For the Railway free tier ($5/month credit):

- **InvoicePlane**: ~$0.50-1.00/month (light usage)
- **MariaDB**: ~$0.50-1.00/month (small database)
- **Total**: ~$1-2/month (well within free tier)

To minimize costs:
- Use the smallest instance size for both services
- Enable sleep mode for non-production deployments
- Monitor usage in Railway dashboard

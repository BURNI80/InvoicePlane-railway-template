# InvoicePlane on Railway

Deploy [InvoicePlane](https://invoiceplane.com) — a free, open-source, self-hosted invoicing application — on Railway with MariaDB in one click.

## What's Included

- **InvoicePlane** — Full invoicing app with client management, quotes, invoices, and payments
- **MariaDB 11.4** — Persistent database for all your data
- **Persistent volumes** — Uploads and database survive redeployments
- **Auto-generated secrets** — Encryption key and database passwords created automatically

## Quick Start

1. Click **Deploy Template** below
2. Wait ~2 minutes for both services to start
3. Open the generated InvoicePlane URL
4. Complete the InvoicePlane setup wizard (create admin account, company info)
5. Start invoicing!

## Variables

All variables are auto-configured. No manual setup needed.

| Variable | Description |
|----------|-------------|
| `IP_URL` | Auto-set to your public domain |
| `IP_DB_HOSTNAME` | References MariaDB automatically |
| `IP_DB_USERNAME` | References MariaDB automatically |
| `IP_DB_PASSWORD` | Auto-generated secret |
| `IP_DB_DATABASE` | `invoiceplane` |
| `ENCRYPTION_KEY` | Auto-generated 32-char secret |
| `CI_ENV` | `production` |
| `TZ` | `UTC` |

## Post-Deployment

After the first deploy:

1. Open your InvoicePlane URL
2. The setup wizard will guide you through:
   - Creating your admin account
   - Setting company details
   - Configuring currency and tax settings
3. Start adding clients and creating invoices

## Persistence

| Volume | Mount Path | Purpose |
|--------|------------|---------|
| MariaDB data | `/var/lib/mysql` | Database files |
| InvoicePlane uploads | `/var/www/html/uploads` | Uploaded files, attachments |
| InvoicePlane storage | `/var/www/html/storage` | Application cache, sessions |

## Cost Estimate

This template runs within the Railway free tier ($5/month credit):

- **InvoicePlane**: ~$0.50/month (light usage, sleeps when idle)
- **MariaDB**: ~$0.50/month (small database)
- **Total**: ~$1/month

## Technical Details

- **InvoicePlane** v1.6.5 via [funktionslust/invoiceplane](https://github.com/funktionslust/invoiceplane-docker) Docker image
- Custom entrypoint fixes Apache MPM conflicts for Railway compatibility
- MariaDB 11.4 with persistent storage
- Sleep mode enabled to minimize costs when idle

## Links

- [InvoicePlane](https://invoiceplane.com)
- [InvoicePlane GitHub](https://github.com/InvoicePlane/InvoicePlane)
- [Railway](https://railway.app)

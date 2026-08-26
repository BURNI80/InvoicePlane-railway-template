# Deploy and Host InvoicePlane on Railway

Deploy [InvoicePlane](https://invoiceplane.com) — a free, open-source, self-hosted invoicing application — on Railway with MariaDB in one click.

## About Hosting InvoicePlane on Railway

InvoicePlane is a complete invoicing solution for freelancers and small businesses. Running it on Railway gives you a fully managed, always-available invoicing platform without managing servers.

This template deploys:

- **InvoicePlane 1.6.5** — The invoicing web application (PHP/Apache)
- **MariaDB 11.4** — Persistent relational database

Both services run within Railway's free tier (~$1/month total).

## Why Deploy InvoicePlane on Railway?

- **Zero configuration** — All environment variables are auto-generated (database credentials, encryption keys, URLs)
- **Persistent storage** — Uploads, attachments, and database data survive redeployments
- **Sleep mode** — Services sleep when idle to minimize costs
- **Private networking** — Database communicates over Railway's private network, never exposed publicly
- **One-click deploy** — No terminal commands or manual setup required

## Common Use Cases

- Freelancer invoicing and billing
- Small business quote and invoice management
- Client management with contact history
- Payment tracking (PayPal, Stripe)
- PDF invoice generation
- E-invoice support (ZUGFeRD, Factur-X, UBL, FacturaE, FatturaPA)

## Dependencies for InvoicePlane

### Deployment Dependencies

- **MariaDB 11.4** — InvoicePlane requires a MySQL-compatible database
- **Persistent Volumes** — Three volumes for data persistence:
  - `/var/lib/mysql` (MariaDB data)
  - `/var/www/html/uploads` (InvoicePlane file uploads)
  - `/var/www/html/storage` (InvoicePlane cache and sessions)

### Network Dependencies

- InvoicePlane connects to MariaDB via Railway's private network
- A public domain is auto-generated for web access
- No incoming port configuration required

## Quick Start

1. Click **Deploy Template**
2. Wait ~2 minutes for both services to start
3. Open the generated InvoicePlane URL
4. Complete the setup wizard (create admin account, company info)
5. Start invoicing!

## Post-Deployment

After the first deploy, open your InvoicePlane URL. The setup wizard guides you through:

- Creating your admin account
- Setting company details
- Configuring currency and tax settings

Then start adding clients and creating invoices.

## Technical Details

- **Custom Dockerfile** fixes Apache MPM conflicts for Railway compatibility (disables `mpm_event`/`mpm_worker`, enables `mpm_prefork`)
- No healthcheck path configured (InvoicePlane redirects to setup wizard during initial setup)
- Sleep mode enabled to minimize costs when idle

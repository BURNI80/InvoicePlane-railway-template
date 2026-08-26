# InvoicePlane — Railway Template

Deploy [InvoicePlane](https://www.invoiceplane.com/) on [Railway](https://railway.app) with one click. InvoicePlane is a self-hosted, open-source invoicing application for managing quotes, invoices, clients, and payments.

## What's Included

| Service | Image | Purpose |
|---------|-------|---------|
| **InvoicePlane** | `funktionslust/invoiceplane:1.6.5` | Web invoicing application |
| **MariaDB** | `mariadb:11.4` | Persistent database |

## Estimated Cost

Runs within Railway's **free tier** ($5/month credit included). Typical usage: ~$0-2/month for light invoicing workloads.

## Quick Deploy

1. Click the template link on Railway Marketplace
2. Wait for deployment (~2-3 minutes)
3. Open your InvoicePlane URL
4. Follow the setup wizard to create your admin account

**That's it.** No manual environment variable configuration needed.

## Post-Deploy Steps

1. Open the generated Railway URL (e.g. `invoiceplane-xxx.up.railway.app`)
2. The InvoicePlane setup wizard will appear on first access
3. Create your admin account (email + password)
4. Configure your company settings (name, address, tax info)
5. Start creating invoices!

## What Gets Auto-Configured

- Database connection (MariaDB via private networking)
- Encryption key (auto-generated, unique per deployment)
- Public URL (set automatically by Railway)
- Persistent storage (uploads + database survive redeployments)

## Architecture

```
┌─────────────────────────┐
│     Public Internet     │
└───────────┬─────────────┘
            │
┌───────────▼─────────────┐     Private Network     ┌──────────────────┐
│     InvoicePlane        │ ◄──────────────────────► │     MariaDB      │
│  Custom Dockerfile      │    mariadb:11.4          │   mariadb:11.4   │
│  (MPM prefork fix)      │   (port 3306)            │                  │
│                         │                          │  Volume: /var/   │
│  Volume: /var/www/html/ │                          │  lib/mysql       │
│  uploads                │                          └──────────────────┘
│  Volume: /var/www/html/ │
│  storage                │
└─────────────────────────┘
```

## Features

- Invoice & quote management
- Client management with contact history
- Product catalog
- Payment tracking (PayPal, Stripe integration)
- PDF generation
- Multi-language support
- E-invoice support (ZUGFeRD, Factur-X, UBL, FacturaE, FatturaPA)
- Reporting and analytics
- Custom templates and themes

## Environment Variables

All variables are auto-configured by the template. No manual setup required.

| Variable | Source | Description |
|----------|--------|-------------|
| `IP_URL` | Auto-set | Public application URL |
| `IP_DB_HOSTNAME` | Reference | MariaDB hostname (private network) |
| `IP_DB_USERNAME` | Reference | Database user |
| `IP_DB_PASSWORD` | Auto-generated | Database password |
| `IP_DB_DATABASE` | Reference | Database name |
| `IP_DB_PORT` | Reference | Database port |
| `ENCRYPTION_KEY` | Auto-generated | Application encryption key |
| `CI_ENV` | `production` | Environment mode |
| `DEFAULT_LANGUAGE` | `english` | Initial admin language |
| `DEFAULT_ADMIN_EMAIL` | `admin@localhost` | Admin email |
| `TZ` | `UTC` | Timezone |

## Persistent Volumes

| Mount Path | Service | Contents |
|------------|---------|----------|
| `/var/www/html/uploads` | InvoicePlane | Client files, logos, documents |
| `/var/www/html/storage` | InvoicePlane | Sessions, cache, logs |
| `/var/lib/mysql` | MariaDB | Database files |

## Troubleshooting

### Setup wizard not appearing
- Ensure `DISABLE_SETUP` is not set to `true`
- Check that the database connection is healthy
- Review deployment logs in Railway dashboard

### Database connection errors
- MariaDB may take 30-60 seconds to initialize on first deploy
- Check that `IP_DB_HOSTNAME` points to the MariaDB service via private network
- Verify MariaDB volume is properly mounted

### PDF generation issues
- InvoicePlane uses mPDF for PDF generation
- Ensure sufficient memory (default 256M is usually enough)

### File upload problems
- Check that the `/var/www/html/uploads` volume is mounted
- Verify PHP upload limits in container settings

## Technical Notes

- **Custom Dockerfile**: Adds an entrypoint wrapper that fixes Apache MPM conflicts (Railway's PHP base image loads multiple MPMs). The wrapper disables `mpm_event` and `mpm_worker`, enables `mpm_prefork`, then delegates to the original entrypoint.
- **No healthcheck configured**: InvoicePlane returns a 307 redirect to the setup wizard during initial setup, which Railway interprets as unhealthy. The app works correctly — the redirect resolves to 200 after setup completion.

## Versioning

- **InvoicePlane**: `1.6.5` (pinned — not using `:latest`)
- **MariaDB**: `11.4` (pinned)

## License

MIT License — same as [InvoicePlane](https://github.com/InvoicePlane/InvoicePlane/blob/develop/LICENSE.txt).

## Links

- [InvoicePlane Website](https://www.invoiceplane.com/)
- [InvoicePlane GitHub](https://github.com/InvoicePlane/InvoicePlane)
- [InvoicePlane Wiki](https://wiki.invoiceplane.com/)
- [InvoicePlane Community](https://community.invoiceplane.com/)
- [Docker Image Source](https://github.com/funktionslust/invoiceplane-docker)
- [Railway Docs](https://docs.railway.com)

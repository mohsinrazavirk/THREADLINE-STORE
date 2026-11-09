# THREADLINE — PUBLIC WEBSITE + SINGLE OWNER ADMIN + SQL ORDERS

## What is ready in this ZIP

- Node.js/Express storefront + 78 SAMPLE products (38 men, 38 women, 2 unisex).
- 32 bundled original, AI-generated product preview images, 16 for each men/women catalog. Each set of eight garment styles has two stylized photo edits. These are NOT real photographs of sellable inventory.
- Securely protected admin REST APIs, a private authenticated dashboard at `/admin.html`, and an SQLite3 relational database.
- SQL tables: `users`, `products`, `orders`, `order_items`, `cart_items`. Every COD order saves the customer's contact/delivery details and itemized garments, variants, prices, shipping, and status transactionally in SQL.
- Customer checkout can be tested on localhost. On a public deployment, `STORE_READY=false` keeps checkouts DISABLED until real merchandise, pricing, inventory, contact/policy and privacy details have been verified by the owner.
- `backend/schema.sql` documents SQL schema. `backend/data/store.sqlite` is a **demo database**, initialized with 78 sample products and **zero actual customer orders**.

## Your sole owner account (local Windows)

1. Extract ZIP; double-click `START-WEBSITE.bat` and leave its console open.
2. Double-click `CREATE-ADMIN.bat`, enter **your** email and your chosen 12+ character password.
3. Sign in at `http://localhost:5000/admin.html`.
4. The database has a **unique index restricting the system to one admin account**. Customers registering from the public storefront are always customer-role accounts. Setting another email in `CREATE-ADMIN.bat` cannot produce a second admin while the first one exists.
5. The owner can open **Orders**, click a particular order, view dress name, size, color, quantity, customer name, email, phone, address, total, COD status; update delivery status and download a CSV.
6. The admin dashboard checks for newly placed orders approximately every 30 seconds while the browser tab is open, and has a Refresh button.

**Never share owner passwords, your `.env` file, production `store.sqlite` or SQL backups.** Passwords are salted/hashed in the database. Always use HTTPS and keep software dependencies updated before a real launch. Admin APIs are protected from unlogged visitors and customer accounts; the `/admin.html` login page itself is publicly reachable and does not disclose private order data without authorization.

## SQL / database durability and old orders

- Default database file: `backend/data/store.sqlite`.
- **Migrating an older store with real orders**: stop both servers, make an offline backup of the old `backend/data/store.sqlite`, then copy that older file to the same path in this new folder BEFORE starting the new server. It will migrate order lines and add missing demo products without deleting existing products or orders. Do not overwrite your old DB with the clean demo DB.
- On Railway use persistent **volume mount `/data`** and the environment setting `DB_PATH=/data/store.sqlite`; Railway ephemeral files are not safe to use as your primary live order database. Take separate encrypted offsite backups. Keep credentials out of the repository and ZIP.
- Production data belongs to your hosting service, not to your laptop. A local admin page cannot see orders placed on an independently hosted database; log in to the **public site's** `/admin.html` to see orders submitted there.

## Publishing and public link

There is NO PUBLIC LIVE URL as part of this downloaded ZIP. A deployment needs a hosting project linked to your own Railway account, and a URL created successfully by the hosting platform.

Railway docs: https://docs.railway.com/guides/express and https://docs.railway.com/volumes.

A typical production flow (PowerShell inside project folder) is:

```powershell
npm install -g @railway/cli
railway login
railway link
railway up
railway domain
```

Before deployment, in Railway service variables use:

```
NODE_ENV=production
STORE_READY=false
DB_PATH=/data/store.sqlite
JWT_SECRET=<a-cryptographically-random-secret-with-32-or-more-characters>
```

Create & mount a persistent volume at `/data`. After `railway domain` returns a public `https://...up.railway.app` address, set `PUBLIC_BASE_URL` to the actual returned URL (do not guess it). Verify `/api/health`, `/api/products`, admin login and a test COD order with a production-like private staging database BEFORE accepting real purchases. To create the owner on the hosted database, securely run `npm run create-admin` with temporary `ADMIN_EMAIL` and `ADMIN_PASSWORD` environment variables inside the hosting service context. Creating an owner on localhost does not create one on the public service.

A registered custom domain (e.g. `shop.example.com`) requires YOU to purchase/own it and update its DNS. Login/verification and possible billing cannot safely be done without the hosting provider's authorization.

## Payment and AI status

- COD backend is implemented, but published checkout is disabled by default until you set `STORE_READY=true` after verifying real inventory and policies.
- Card payment cannot go live without a verified Safepay merchant account, API keys and webhook testing. Card fields must NEVER be collected or stored by this website directly.
- The shopping assistant's built-in product recommendations work without keys. Gemini replies require a valid secret `GEMINI_API_KEY` on the server. No live Gemini key is included in this package.

**Illustrative inventory notice:** The clothing previews, stock counts and prices are demos, not proof of possession, quality, exact appearance or delivery availability. Replace the pictures with photographs of your actual sale items and correct all metadata before opening public checkout.

# THREADLINE Fashion Store v3 — 32 bundled men/women outfit photos + sole-owner admin + SQL database

**Latest package (October 2026):** 78 demo products: 38 men, 38 women, 2 unisex. 32 local, AI-generated product photographs (16 men + 16 women) are included so those images load without an external photo host. These are illustrative garment previews rather than actual inventory.

**Local Windows:** unzip, launch `START-WEBSITE.bat`, then `CREATE-ADMIN.bat`. Visit `http://localhost:5000` (shop) and `http://localhost:5000/admin.html` (owner). The admin database enforces **one owner account only**. Every COD order is recorded in SQLite `orders` and `order_items` with buyer, phone, address, dress, size, color, quantities, prices and status. The admin dashboard has search, order details, COD updates, customer list, stock editing, CSV export, and automatic refresh.

**Public launch:** currently **not deployed**. See [`DEPLOY-PUBLIC-OWNER.md`](DEPLOY-PUBLIC-OWNER.md) for Railway+SQLite persistent volume, secrets, owner account, domain and production preview mode. `STORE_READY=false` is the default for public deployments so sample items cannot accidentally receive real orders.

**Important:** existing user databases with real orders must be backed up and migrated; do not overwrite them with the seeded demo DB included here. Verify real inventory, pictures, legal policies, shipping and payment gateway before live checkout.

---

# THREADLINE — Fashion Store v2.0

A rebuilt, responsive fashion e-commerce starter based on the uploaded “online store.zip” project. Uses Node.js 22+, Express, SQLite, vanilla HTML/CSS/JS, authentication, product API, saved orders, a working Cash on Delivery flow, optional Safepay hosted card checkout, and an optional Gemini-backed shopping guide.

**Important:** The products, their prices, stock, business branding and online photos are demonstration content. The merchant must replace these with real inventory and publish valid support contact, privacy/returns policy and business details before real sales.

## Hosting, domains and Gemini setup (new)

**Production preview safety:** Orders are disabled by default in production until the owner explicitly sets `STORE_READY=true` *after* verifying products, fulfillment, merchant and policies. Local development orders still work for testing.

See **`OWNER-SETUP-CHECKLIST.md`** for real account requirements, and run **`SETUP-GEMINI-WINDOWS.ps1`** after personally generating a key in Google AI Studio. **No hosting account, domain or Google API key is included or claimed.** Gemini uses an official server-side API request with a secret header; its replies are labelled as AI only when a real model response succeeds.

## FASTEST WAY ON WINDOWS (v2.1.1)
Extract this archive. Install **Node.js v22.13+** (or Node 24 LTS). Double-click **`START-WEBSITE.bat`** from inside `Threadline-Store-Working`. This specially packaged edition includes the basic offline runtime dependencies; it creates a secure random local `backend/.env` on first launch, starts the backend and opens `http://localhost:5000` after the server becomes reachable. Leave the terminal window open. Internet is not needed for basic COD/shop features; the product photos themselves use remote URLs and may need internet. This ZIP does NOT include the Node.js executable. Card payment SDK is not bundled and still needs installation and merchant approval. If any issue, read `START-HERE-WINDOWS.txt`.

## Local Windows setup (VS Code + PowerShell)

1. Install Node.js **22.13 or newer**. Unzip `Threadline-Store.zip` and open the extracted **Threadline-Store** folder in VS Code.
2. In VS Code Terminal run:

   ```powershell
   npm install
   Copy-Item backend\.env.example backend\.env
   ```

3. Edit `backend/.env`. Replace the placeholder `JWT_SECRET` with a truly random 32+ character value. Example generation in PowerShell: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`.
4. Run `npm start`, then open **http://localhost:5000** in Chrome. Frontend and backend are on one URL, so no cross-origin or localhost-3000 problem.
5. For automatic reload, run `npm run dev`. Tests: `npm test`.

**Linux/macOS:** `cp backend/.env.example backend/.env` instead of Copy-Item. Node's built-in `node:sqlite` may print an experimental warning on Node 22; it works in this project. Keep Node 22+ pinned.

## How to use

- Men / Women / Unisex categories; search, sort, type filter; size/color variants.
- Cart and wishlist persist in browser storage. Logged-in users also sync cart entries to the `/api/cart` endpoint. You can order without registering; registered users have order history. 
- On checkout, enter customer details, select **Cash on Delivery**, click **Place Order**. It saves a real order in the local SQLite database and decreases stock. Use **Track an order** with order number + checkout email.
- Account registration and login: bcrypt password hashes, signed JWT tokens, profile and order history. No pre-created/default admin credentials.
- Create an admin securely by setting `ADMIN_EMAIL` and `ADMIN_PASSWORD` (12+ characters) in `backend/.env`, then run `npm run create-admin`. Sign in to view and update order statuses via the account menu. Admin product CRUD is available through the API.
- Shopping assistant works **without** an API key as a rule-based guide and recommends your actual product names/prices. To enable AI responses, obtain your own Google AI Studio key and use `SETUP-GEMINI-WINDOWS.ps1`, or set `GEMINI_API_KEY` and optionally `GEMINI_MODEL` in `backend/.env`. Do not put your key in the frontend or publicly shared files. It falls back to rules when the AI provider is unavailable.

## Card payments — Safepay (merchant setup required)

The app includes a server-side integration for **Safepay hosted checkout**. It **never collects or stores a card number/CVV**. Until the merchant's Safepay credentials are provided, card payment appears disabled instead of pretending to charge a card.

1. Register and obtain **sandbox merchant keys**: https://getsafepay.pk and https://safepay-docs.netlify.app/build-your-integration/express-checkout/
2. In `backend/.env`, configure `SAFEPAY_ENV=sandbox`, `SAFEPAY_API_KEY`, `SAFEPAY_SECRET_KEY`, `SAFEPAY_WEBHOOK_SECRET`, and `PUBLIC_BASE_URL` to your real HTTPS domain.
3. Configure Safepay webhooks to `https://your-domain.com/api/payments/safepay/webhook`.
4. Test sandbox checkout and payment status end-to-end. The backend reserves inventory, creates a payment tracker, redirects to a hosted checkout, verifies payment state server-to-server, checks charged amount and currency, and marks orders paid **only after verified status**. Failed initiation restores stock. A successful redirect by itself **does not** mark paid.
5. Activate a live Safepay merchant account and merchant card acceptance approval, then change `SAFEPAY_ENV=production` and use **live** credentials. Do not use sandbox credentials to collect money.

**Caution:** Provider SDK/API behavior may change; the Safepay live checkout could not be tested without user-owned keys or a public webhook endpoint. Always verify with the provider and test all success, failure and duplicate webhook scenarios before enabling production payments.

## No-GitHub publishing option (Railway)

If you do **not** want GitHub, follow **`RAILWAY-DEPLOY-WITHOUT-GITHUB.md`** included in this ZIP. Railway's official `railway up` CLI can upload this exact local folder and deploy the Node server directly. After configuring `NODE_ENV=production`, a strong `JWT_SECRET` and a persistent Railway volume at `/data` (`DB_PATH=/data/store.sqlite`), run `railway domain` to generate your public `.up.railway.app` URL. No deployment or public URL has been created on the user's behalf.

## Public deployment / URL / custom domain

**Local URL:** `http://localhost:5000` works on your own computer only. It is **not** a shareable public URL. This ZIP does not automatically own a domain or host itself.

Recommended: deploy this full-stack Node app on a host with **persistent filesystem/database**, such as **Render paid web service with persistent disk**, Railway with attached volume, or a VPS. Free ephemeral Node instances on Render **lose SQLite data on restart** and are inappropriate for real orders. To publish:

1. Create your own private GitHub repository and push the contents (never commit `.env`).
2. Go to https://dashboard.render.com/ and select **New → Web Service → connect your repository**. Set `Node >=22`, build command `npm install`, start command `npm start`.
3. Attach a **persistent disk** on a supported paid plan, for example mount path `/var/data`. Set `DB_PATH=/var/data/store.sqlite`.
4. Add environment variables `NODE_ENV=production`, strong `JWT_SECRET`, `PUBLIC_BASE_URL=https://your-service.onrender.com`; add your Safepay/Gemini keys only if desired. **Never** upload `.env` to GitHub.
5. Deploy. Render assigns a unique URL such as `https://your-service.onrender.com`. Replace it with your purchased domain e.g. `https://shop.yourbrand.com` using Render custom-domain settings and your domain DNS records. You choose your name; **no “chatgpt” will appear in the website/domain unless you put it there.**
6. Before taking public orders, replace demonstration photos/products, configure real store contact details and policies, check tax/shipping requirements, complete payment onboarding, and perform security & checkout testing.

A public URL **cannot be issued until a hosting account is connected and deploy succeeds**, and a branded domain requires DNS/domain ownership. No domain or deployment is claimed in this package.

## Configuration

| Variable | Purpose |
| --- | --- |
| `PORT` | Server listening port, defaults to 5000 |
| `NODE_ENV` | `development` or `production` |
| `DB_PATH` | Location of persistent SQLite database (essential on hosted service) |
| `JWT_SECRET` | Random 32+ characters in production |
| `PUBLIC_BASE_URL` | External HTTPS URL for gateway returns |
| `ADMIN_EMAIL` / `ADMIN_PASSWORD` | Credentials used only by `npm run create-admin` |
| `SAFEPAY_ENV` | `sandbox` or `production` |
| `SAFEPAY_API_KEY` / `SAFEPAY_SECRET_KEY` / `SAFEPAY_WEBHOOK_SECRET` | Safepay merchant credentials |
| `GEMINI_API_KEY` / `GEMINI_MODEL` | Optional AI-generated assistance |

## API routes

- `GET /api/health`, `GET /api/config`, `GET /api/products`, `GET /api/products/:id`
- `POST /api/auth/register`, `POST /api/auth/login`, `GET /api/auth/me`
- `GET|PUT|DELETE /api/cart`, `PUT /api/cart/sync` (requires user bearer token)
- `POST /api/orders` (Cash on Delivery), `GET /api/orders` (logged in), `GET /api/orders/lookup?id=...&email=...`
- `POST /api/payments/safepay/start`, `POST /api/payments/safepay/webhook`, `GET /api/payments/status?order=...&tracker=...`
- `POST /api/assistant`
- `GET /api/admin/orders`, `PATCH /api/admin/orders/:id`, `POST /api/admin/products`, `PATCH /api/admin/products/:id` (admin only)

Prices are stored in whole **PKR**, shipping is PKR 250 and is free for carts of PKR 7,000+; the Safepay payment amount is sent in **minor currency units** (`PKR * 100`). Client-submitted price/total values are ignored. Variants, quantities and stock are verified on the server. Order writes/stock changes run within a SQLite transaction.

## Changes made versus original upload

- Original `frontend/script.js` hardcoded the API to `localhost:5000` (breaks public hosted use), and `checkout-btn` only showed “checkout would be implemented here.” The source had placeholder-only product pictures.
- Original code required a separate local MongoDB server; this version starts with auto-seeded, locally persisted SQLite and **one Node server**.
- The original documentation contained a publicly known default admin password; this version provides **no default admin**.
- Added COD order persistence + stock deduction, tracked orders, cart synchronization, customer auth, wishlist, search/sort, responsive fashion design, optional Safepay card checkout, optional Gemini AI and fallback guide, admin order/product APIs, basic rate limiting, payment reconciliation, and automated tests.
- Kept project readable in `frontend/` + `backend/`. Original source is not included in the new ZIP to avoid unsafe `.env`, outdated dependencies and thousands of copied `node_modules` files.

## Before real commercial launch

This is a functional self-hostable **starter**, not a PCI/security-certified production shop. Arrange real photo rights, legal policies, contact details, backups, transactional emails/SMS, spam protection, tax records, monitoring, a professionally reviewed payment integration, and secure cloud hosting. Do not use a free ephemeral filesystem with customer or order data. Back up your SQLite database.


### Troubleshooting running locally
- **`Cannot find module 'node:sqlite'`**: upgrade to Node 22.13+ (or 24 LTS).
- **`npm` is not recognized**: install Node.js, restart VS Code/PowerShell; this package does not need npm for normal local demo start.
- **`EADDRINUSE :::5000`**: close conflicting server or update `PORT` in `backend/.env` to `5001` and run the launcher again.
- **Page shows backend unavailable**: avoid opening `frontend/index.html` directly; the server must be running at `http://localhost:5000`.
- **Images blank**: example images are hosted externally; they require internet.
- **Gemini/card payment disabled**: those optional live integrations require owner credentials; the base store works without them.

## NEW: Admin Dashboard, customer order database and more fashion products

Read `DATABASE-ADMIN-GUIDE.md` first.

- Admin portal: `http://localhost:5000/admin.html`
- Create owner: double-click `CREATE-ADMIN.bat` and choose a unique password.
- Order history database: `backend/data/store.sqlite`. Normal checkout writes BOTH `orders` and relational `order_items` tables; archived products cannot be ordered.
- Owner controls include all orders, line items, delivery address, phone, search, CSV report, order tracking, COD collection, account counts and inventory CRUD.
- Expanded demonstration catalog: men and women clothes, including dresses, kurtis, suits, kurtas, tops and outerwear. Verify photographs, prices and stock against actual merchandise before selling.
- Database backups: double-click `BACKUP-DATABASE.bat`; resulting backups contain customer details and MUST stay private.
- When upgrading from an older THREADLINE install, first stop the website and copy your real SQLite DB to the new site rather than replacing it with a demo database.

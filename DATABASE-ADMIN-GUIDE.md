# THREADLINE — Admin orders + SQLite database

## Windows start (local only)

1. Extract all files. Install Node.js 22.13+ if needed.
2. Double-click `START-WEBSITE.bat`. The launcher creates `backend/.env` and generates a random JWT secret if missing. Keep the CMD window open.
3. Double-click `CREATE-ADMIN.bat` and enter **your own** email and strong admin password (12+ characters). No default admin password. If this email already belongs to a customer account, the script changes it to admin and resets its password.
4. Open **http://localhost:5000/admin.html** and sign in. Admin account creation happens in the **same database** used by your storefront.
5. Place a test COD order from the storefront. Refresh **Admin → Orders** to see: customer name, email, mobile, street address, city, products, sizes, colors, quantities, total, payment and delivery status.

## What the database saves

- SQLite file: `backend/data/store.sqlite` (unless `DB_PATH` is explicitly set in `backend/.env`).
- `users`: registered shoppers and private admin accounts with hashed passwords.
- `products`: the catalog (including men's and women's outfits), stock, photos and prices.
- `orders`: customer and delivery contact details, payment type, amounts and current status.
- `order_items`: **each purchased item**, its product ID, name, size, color, quantity, unit price and line total. This is written transactionally together with the order. Older orders are automatically migrated from `items_json` on first run.
- `cart_items`: shopping carts for signed-in customers.

Guest checkouts are saved in `orders` and visible to the admin too; these are **not** registered customers. Guests can check status using their order ID and matching email. A signed-in shopper can see their own orders and items under My Account. Other customers cannot view them.

## Important details

- **New installs:** a seeded SQLite file is included. No customer orders are pre-loaded. Actual orders get saved when customers submit checkout.
- **Existing installs:** stop the site first, and copy your old `backend/data/store.sqlite` into the new site's same path to keep **real** orders/customers; do not overwrite the old database with the demo database. Keep a backup before migrating.
- **Backup:** double-click `BACKUP-DATABASE.bat` — it writes a consistent copy into `backups/`. Backups contain personal customer information and must not be shared publicly.
- **Production deployment:** never deploy a local SQLite file as the only durable database. Use a persistent volume and set `DB_PATH` to its path, for example `/data/store.sqlite`, and configure encrypted backups. Hosted ephemeral disks will lose customers' orders on restart.
- **Security:** keep `backend/.env`, database, backups and passwords private, never upload them to a public repo. Serve via HTTPS. Admin APIs require the admin's authenticated token and role. Staff access and legal privacy/returns policies are the merchant's responsibility.
- **Payments:** COD works in local development. Real card payments remain disabled unless an approved Safepay merchant account, live credentials and verified webhooks are configured. Never manually mark a card payment paid.
- **Demo images and prices:** placeholders for illustration. Verify product images match actual inventory before taking real orders.

## Main owner features

- Admin overview dashboard with revenue/order/customer/product counts
- View/filter/search orders and download CSV with items + delivery details
- Change orders: placed → confirmed → shipped → delivered, or cancel eligible orders
- Mark COD payments collected after receiving actual money
- View registered customers and order counts
- Add/edit/hide men's, women's and unisex products; change sizes, colors, price, images, and stock
- Catalog is re-seeded with extra example clothes **without deleting or overwriting** existing owner product edits.

## Helpful links

Storefront: `http://localhost:5000/`  
Admin dashboard: `http://localhost:5000/admin.html`

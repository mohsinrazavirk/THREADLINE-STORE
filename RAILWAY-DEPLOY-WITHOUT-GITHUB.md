# Publish THREADLINE online WITHOUT GitHub (Windows + Railway)

This procedure uses your own Railway account to deploy the full Node.js app; **no GitHub repository is needed**. There is no live public URL until deployment finishes and a public domain is created. Hosting and domain fees, if any, are paid by the site owner.

## 1. Prerequisites

- Install Node.js 22 or newer on Windows (nodejs.org).
- Extract the ZIP and open the `Threadline-Store` folder in VS Code.
- Open the Terminal (PowerShell). Run the following *inside that folder*:

```powershell
npm install
npm install -g @railway/cli
railway login
```

A browser tab opens so you can securely log into your own Railway account.

## 2. Prepare persistent storage BEFORE accepting orders

Railway requires a **volume** to save SQLite data between redeploys. In your Railway dashboard, create a project and an empty service, then add a volume to the service with mount path **`/data`**.

Set these service variables in **Railway Dashboard > Service > Variables** (never paste secrets into the website or commit them to source code):

| Variable | Value |
|---|---|
| `NODE_ENV` | `production` |
| `STORE_READY` | `false` for preview. Change to `true` ONLY once verified real products, terms, inventory and business details are live |
| `JWT_SECRET` | A random secret at least 32 characters |
| `DB_PATH` | `/data/store.sqlite` |
| `PUBLIC_BASE_URL` | `https://YOUR-REAL-RAILWAY-DOMAIN.up.railway.app` (after domain generation) |

Generate a secret locally with:

```powershell
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

## 3. Deploy directly from your computer

If you created an empty service already:

```powershell
railway link
railway up
```

Select the right project/service when prompted. If you haven't created a project, `railway up` can walk you through creating one, but **add the persistent volume before real orders**.

After deployment, make the site publicly reachable:

```powershell
railway domain
```

Railway can issue a free auto-generated URL ending in **`.up.railway.app`**. Copy the *exact* URL it returns. This is a real public website link that other people can open. No “chatgpt” is added. Set `PUBLIC_BASE_URL` to this exact `https://` URL and redeploy if needed. To use your own `shop.yourbrand.com` domain, you must own it and configure the required DNS records in Railway.

## 4. Card payment and real AI options

- COD works once your service/volume is running. Card payment is disabled until you obtain an approved Safepay merchant account and set `SAFEPAY_ENV`, `SAFEPAY_API_KEY`, `SAFEPAY_SECRET_KEY` and `SAFEPAY_WEBHOOK_SECRET` in Railway Variables. Configure your public webhook: `https://YOUR-DOMAIN/api/payments/safepay/webhook`. Test sandbox before live.
- The shopping guide works without an external key (rule-based). Add `GEMINI_API_KEY` to enable AI-generated answers.
- To create an administrator, set `ADMIN_EMAIL` + strong `ADMIN_PASSWORD` and run `npm run create-admin` against the persistent production database in a secure server shell, not only on your computer. Do not keep these credentials as long-lived Railway variables unless needed.

## IMPORTANT: Before taking money from real customers

The catalog currently contains sample products, prices, stocks and externally loaded editorial photos. Replace them with real stock/products and authorized image assets; add verified store phone/email, refund/privacy/terms policies, shipping coverage, backups and taxes. Safepay hosted payments need sandbox end-to-end tests and live approval; no live card payments were verified without your own keys.

Docs: https://docs.railway.com/cli/up · https://docs.railway.com/cli/domain · https://docs.railway.com/volumes

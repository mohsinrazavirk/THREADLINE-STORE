# Owner setup / go-live checklist (24 October 2026)

**Accounts created by this ZIP: NONE.** This package is source code, not a service subscription. Nobody can issue or safely share a live Gemini key or paid domain without authorizing the Google / hosting / registrar account owner. No domain or live URL has been reserved.

## Gemini AI — activate in your own Google account

1. Sign into **https://aistudio.google.com/api-keys** with your Google account. Accept terms, create/select a project and create an API key (Google AI Studio may offer a default key).
2. Run `powershell -NoProfile -ExecutionPolicy Bypass -File .\SETUP-GEMINI-WINDOWS.ps1` in this extracted folder; paste your key at the hidden prompt. Or set `GEMINI_API_KEY` in hosting service variables.
3. Keep the key **only on the server**. Never put it in browser JavaScript, GitHub, public ZIPs, screenshots, messages, or frontend forms. Do not send it to anyone to configure.
4. Start/restart the server (`npm start`). In the website shopping assistant, expect "Gemini AI configured"; ask for outfit ideas. Each successful answer has a "Gemini AI reply" label. If Google is unavailable / your key has no quota, it automatically falls back to the built-in shopping guide.
5. For a hosted site use Railway -> service -> Variables -> `GEMINI_API_KEY`, and optionally `GEMINI_MODEL=gemini-3.5-flash-lite`. Restart/redeploy.

**The supplied ZIP contains no Gemini key and does NOT have AI-generated replies enabled until you authorize a real key.** Google may require billing or limit API usage. The built-in shopping guide works immediately.

## Railway full-stack hosting

1. Connect/authorize your own Railway account at **https://railway.com** (or connect the Railway app in ChatGPT if offered).
2. Follow `RAILWAY-DEPLOY-WITHOUT-GITHUB.md` to deploy the code folder. Create a Railway volume mounted at `/data` before real orders.
3. Set production variables (`NODE_ENV`, strong `JWT_SECRET`, `DB_PATH=/data/store.sqlite`) in Railway Secrets/Variables. The site is **preview-only** by default in production; only set `STORE_READY=true` after replacing demos and satisfying the checklist below.
4. In the Railway service -> Settings -> Public Networking -> **Generate Domain** to receive an actual `https://....up.railway.app` URL; set `PUBLIC_BASE_URL` to that URL.
5. A custom branded domain is a separate purchase/ownership step with an external domain registrar. Add Railway's **CNAME AND TXT** DNS records and wait for verification. The assistant has not bought or registered any domain.

## Store identity / production obligations — cannot be invented

- Publish verified shop name, contact email and phone, legal details if required, and an approved return/exchange/refund/privacy policy.
- Replace demonstration items, images, prices and inventory with products you have rights to sell, and keep stock accurate.
- Set up and approve a merchant account for Safepay **card** payments; test sandbox payments, callbacks and refunds before enabling live transactions. Cash on delivery needs your real fulfillment process.
- Confirm fulfillment areas, shipment costs, taxes, privacy/data retention, secure backups, and support channels.

**Security:** never hand over passwords, OTPs, Gemini keys, card details, or merchant credentials in chat. Sign in directly at the provider website. Downloaded project files are not yet deployed or production certified.

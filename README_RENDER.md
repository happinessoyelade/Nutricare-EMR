# Render deployment & local dev instructions

This PR adds Dockerfile, docker-compose, a local start script, .env example, and render.yaml to simplify local development and deploy to Render.

Quick local start
1. Copy .env.example -> .env and adjust values.
2. chmod +x start-local.sh
3. ./start-local.sh
4. Visit http://localhost:3000/health

Render deployment (UI summary)
1. Create a Render account and enable 2FA.
2. Create a managed Postgres on Render and copy DATABASE_URL.
3. Create a Web Service on Render:
   - Environment: Docker
   - Dockerfile Path: ./Dockerfile
   - Health Check Path: /health
   - Auto Deploy: ON
4. Add environment variables in the Web Service:
   - DATABASE_URL (from Render Postgres)
   - PAYSTACK_SECRET_KEY (sk_test or sk_live)
   - PAYSTACK_PUBLIC_KEY
   - NODE_ENV=production
5. Configure Paystack webhook in Paystack dashboard to:
   https://<your-render-service>.onrender.com/paystack/webhook
   Subscribe to: charge.success, subscription.create, invoice.payment_failed, subscription.disable
6. Test with Paystack test keys; swap to live keys once tested.

Security checklist
- Enable 2FA on Render and Paystack.
- Use Render's secret env var feature for keys.
- Verify x-paystack-signature for webhooks.
- Always call /transaction/verify/{reference} server-side before crediting users.
- Enable backups for the managed Postgres DB.

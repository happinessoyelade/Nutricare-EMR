# Dockerfile for Render and local builds
FROM node:18-alpine

WORKDIR /app

# Install runtime deps and postgres client for pg_isready
RUN apk add --no-cache bash postgresql-client

# Install node deps
COPY package*.json ./
RUN npm ci

# Copy prisma schema and source
COPY prisma ./prisma
COPY . .

# Generate Prisma client at build time
RUN npx prisma generate

EXPOSE 3000

# Start: wait for DB, run migrations, start server
CMD ["sh", "-c", "until pg_isready -h ${DB_HOST:-db} -p ${DB_PORT:-5432} -U ${DB_USER:-postgres}; do echo 'Waiting for Postgres...'; sleep 1; done; npx prisma migrate deploy || true; node server.js"]
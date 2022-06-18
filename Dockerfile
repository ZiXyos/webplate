FROM node:18-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /dep

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

## --------------------------------------------------------------------------- ##

FROM node:18-alpine AS builder
WORKDIR /build

COPY --from=deps /dep/node_modules ./node_modules
COPY . .
COPY .env .env.production
RUN yarn build

## --------------------------------------------------------------------------- ##

FROM node:18-alpine AS RUNNER
WORKDIR /app

ENV NODE_ENV production

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

COPY --from=builder /build/src/public ./public
COPY --from=builder /build/package.json ./package.json
COPY --from=builder --chown=nextjs:nodejs /build/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /build/.next/static ./.next/static

USER nextjs

EXPOSE ${CLIENT_PORT}
ENV PORT ${CLIENT_PORT}

CMD ["node", "server.js"]
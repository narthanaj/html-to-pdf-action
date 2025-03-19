FROM node:22-slim

# Install dependencies for Puppeteer
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    fonts-noto-color-emoji \
    fonts-noto-cjk \
    libasound2t64 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libxss1 \
    libxtst6 \
    libcups2 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libatspi2.0-0 \
    libxshmfence1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy source code
COPY src /app/src

# Make index.js executable
RUN chmod +x /app/src/index.js

# Set environment variable for Node.js
ENV NODE_OPTIONS=--no-experimental-fetch
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=false

# Create a directory for temporary files
RUN mkdir -p /tmp/html-to-pdf

# Set the entrypoint
ENTRYPOINT ["node", "/app/src/index.js"]
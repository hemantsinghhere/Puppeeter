# Use the Puppeteer image with a specific version
FROM ghcr.io/puppeteer/puppeteer:22.10.0

# Set environment variables for Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# Install dependencies for Chrome
RUN apt-get update && apt-get install -y \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdbus-glib-1-2 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    xdg-utils \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image
COPY package*.json ./

# Install the application dependencies
RUN npm ci

# Copy the rest of your application code to the container
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD [ "node", "index.js" ]

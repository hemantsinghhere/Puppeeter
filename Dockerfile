# Use the Puppeteer image with a specific version
FROM ghcr.io/puppeteer/puppeteer:22.10.0

# Set environment variables for Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

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

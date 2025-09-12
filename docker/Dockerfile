# HeadlessX - Advanced Browserless Web Scraping API
FROM mcr.microsoft.com/playwright:v1.40.0-focal

# Install Nginx for serving static files
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy application code
COPY src/server.js ./

# Copy website files
COPY website/out/ /var/www/headlessx/

# Copy nginx configuration
COPY nginx/headlessx.conf /etc/nginx/sites-available/default

# Create non-root user for security
RUN groupadd -r headlessx && useradd -r -g headlessx headlessx
RUN chown -R headlessx:headlessx /app
RUN chown -R headlessx:headlessx /var/www/headlessx

# Set environment variables
ENV TOKEN=SaifyXPRO@112255
ENV PORT=3000
ENV NODE_ENV=production

# Create startup script
RUN echo '#!/bin/bash\n\
service nginx start\n\
exec su headlessx -c "node server.js"' > /start.sh && chmod +x /start.sh

# Expose ports
EXPOSE 80 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/api/health || exit 1

# Start both Nginx and HeadlessX application
CMD ["/start.sh"]

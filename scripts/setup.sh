#!/bin/bash

# Enhanced HeadlessX Setup Script v1.1.0
# Run with: bash setup.sh

set -e

echo "🚀 Setting up HeadlessX v1.1.0 - Open Source Browserless Web Scraping API"
echo "=========================================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}Error: This script should not be run as root${NC}"
   echo "Please run as a regular user with sudo privileges"
   exit 1
fi

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y
print_status "System updated"

# Install Node.js 20 LTS
echo "📥 Installing Node.js 20 LTS..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs build-essential
    print_status "Node.js installed: $(node -v)"
else
    print_status "Node.js already installed: $(node -v)"
fi

# Install system dependencies for Playwright
echo "🔧 Installing system dependencies..."
sudo apt install -y \
    libatk1.0-0 libatk-bridge2.0-0 libcups2 libatspi2.0-0 \
    libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 \
    libcairo2 libpango-1.0-0 libasound2 fonts-liberation \
    libnss3 xdg-utils wget ca-certificates curl
print_status "System dependencies installed"

# Install project dependencies
echo "📦 Installing project dependencies..."
npm install
print_status "NPM dependencies installed"

# Build website
echo "🌐 Building website..."
cd website
npm install
npm run build
cd ..
print_status "Website built successfully"

# Install Playwright browsers
echo "🌐 Installing Playwright browsers..."
npx playwright install
npx playwright install-deps
print_status "Playwright browsers installed"

# Create logs directory
mkdir -p logs
print_status "Logs directory created"

# Install PM2 globally
echo "⚙️ Installing PM2 process manager..."
if ! command -v pm2 &> /dev/null; then
    sudo npm install -g pm2
    print_status "PM2 installed"
else
    print_status "PM2 already installed"
fi

# Install Nginx
echo "🌐 Installing and configuring Nginx..."
if ! command -v nginx &> /dev/null; then
    sudo apt install -y nginx
    print_status "Nginx installed"
else
    print_status "Nginx already installed"
fi

# Copy Nginx configuration
sudo cp nginx/headlessx.conf /etc/nginx/sites-available/headlessx
sudo ln -sf /etc/nginx/sites-available/headlessx /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
print_status "Nginx configured for headlessx.domain.com"

# Create website directory
sudo mkdir -p /var/www/headlessx
sudo cp -r website/out/* /var/www/headlessx/
sudo chown -R www-data:www-data /var/www/headlessx
print_status "Website files deployed"

# Configure firewall
echo "🔥 Configuring firewall..."
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw --force enable
print_status "Firewall configured"

# Create environment file
echo "⚙️ Creating environment configuration..."
if [ ! -f .env ]; then
    cp .env.example .env
    print_warning "Created .env file - please update the TOKEN value!"
else
    print_status ".env file already exists"
fi

# Test the server
echo "🧪 Testing server startup..."
timeout 10s node server.js &
SERVER_PID=$!
sleep 5

if kill -0 $SERVER_PID 2>/dev/null; then
    print_status "Server test successful"
    kill $SERVER_PID
else
    print_error "Server test failed"
fi

echo ""
echo "🎉 HeadlessX v1.1.0 Setup completed successfully!"
echo "==============================================="
echo ""
echo "📋 Next steps:"
echo ""
echo "1. Update your domain DNS:"
echo "   - Point headlessx.domain.com to your server IP"
echo "   - Wait for DNS propagation (1-24 hours)"
echo ""
echo "2. Configure SSL certificate:"
echo "   sudo apt install certbot python3-certbot-nginx"
echo "   sudo certbot --nginx -d headlessx.domain.com"
echo ""
echo "3. Update the TOKEN in .env file:"
echo "   nano .env"
echo ""
echo "4. Start the HeadlessX API server:"
echo "   pm2 start ecosystem.config.js"
echo "   pm2 save"
echo "   pm2 startup"
echo ""
echo "5. Test your setup:"
echo "   🌐 Website: http://headlessx.domain.com"
echo "   🔧 API Health: http://headlessx.domain.com/api/health"
echo "   📊 API Status: http://headlessx.domain.com/api/status"
echo ""
echo "📚 Visit https://github.com/SaifyXPRO/HeadlessX for documentation"
echo ""

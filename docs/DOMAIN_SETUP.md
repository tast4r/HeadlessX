# 🌐 Custom Domain Setup Guide

This guide walks you through setting up HeadlessX with your own custom domain, including SSL certificate configuration.

## Prerequisites

- A VPS/server with Ubuntu 20.04+ LTS
- A registered domain name
- DNS management access for your domain
- HeadlessX already installed and running

## Domain Structure

HeadlessX is designed to work with a subdomain structure:
- **Website**: `your-subdomain.yourdomain.com` → Landing page  
- **API**: `your-subdomain.yourdomain.com/api/*` → All API endpoints

## Step 1: DNS Configuration

Configure your domain's DNS settings to point to your server:

### A Record Setup
```
Type: A
Name: headlessx
Value: YOUR_SERVER_IP_ADDRESS
TTL: 300 (or default)
```

### Example DNS Configuration
```
your-subdomain.yourdomain.com → 203.0.113.10
```

**Note:** DNS propagation can take 1-24 hours. You can check propagation status using:
```bash
dig your-subdomain.yourdomain.com
# or
nslookup your-subdomain.yourdomain.com
```

## Step 2: Update Nginx Configuration

Edit the Nginx configuration file to use your domain:

```bash
sudo nano /etc/nginx/sites-available/headlessx
```

Update the server_name directive:
```nginx
server {
    listen 80;
    server_name your-subdomain.yourdomain.com;
    
    # Website serving
    location / {
        root /var/www/headlessx;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
    
    # API proxy
    location /api/ {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 300s;
        proxy_connect_timeout 75s;
    }
}
```

Test and reload Nginx:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

## Step 3: SSL Certificate (Let's Encrypt)

Install Certbot and obtain an SSL certificate:

### Install Certbot
```bash
sudo apt update
sudo apt install certbot python3-certbot-nginx
```

### Obtain SSL Certificate
```bash
sudo certbot --nginx -d your-subdomain.yourdomain.com
```

Follow the prompts:
1. Enter your email address
2. Agree to terms of service
3. Choose whether to share email with EFF
4. Select redirect option (recommended: redirect HTTP to HTTPS)

### Verify SSL Installation
```bash
sudo certbot certificates
```

### Auto-renewal Setup
Certbot automatically sets up renewal. Test it:
```bash
sudo certbot renew --dry-run
```

## Step 4: Update HeadlessX Configuration

### Update Environment Variables
If you have any domain-specific configurations, update your `.env` file:
```bash
nano .env
```

### Update Documentation References
Update any internal documentation or configuration files that reference the old domain.

## Step 5: Firewall Configuration

Ensure your firewall allows HTTPS traffic:
```bash
sudo ufw allow 443/tcp
sudo ufw reload
```

## Step 6: Testing Your Setup

### Test Website Access
```bash
curl -I https://your-subdomain.yourdomain.com
```

Expected response:
```
HTTP/2 200
content-type: text/html
...
```

### Test API Endpoints
```bash
# Health check (no token required)
curl https://your-subdomain.yourdomain.com/api/health

# Status check (requires token)
curl "https://your-subdomain.yourdomain.com/api/status?token=YOUR_TOKEN"
```

### Comprehensive Test Script
Create a test script to verify all functionality:

```bash
#!/bin/bash
DOMAIN="your-subdomain.yourdomain.com"
TOKEN="YOUR_SECURE_TOKEN"

echo "Testing HeadlessX domain setup..."

# Test website
echo "1. Testing website..."
curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN
echo

# Test health endpoint
echo "2. Testing health endpoint..."
curl -s https://$DOMAIN/api/health | jq .status
echo

# Test authenticated endpoint
echo "3. Testing authenticated endpoint..."
curl -s "https://$DOMAIN/api/status?token=$TOKEN" | jq .server.name
echo

# Test HTML extraction
echo "4. Testing HTML extraction..."
curl -s "https://$DOMAIN/api/html?token=$TOKEN&url=https://httpbin.org/html" | head -n 5
echo

echo "Domain setup test completed!"
```

## Troubleshooting

### Common Issues

#### 1. DNS Not Propagating
**Symptoms:** Domain doesn't resolve to your server IP
**Solutions:**
- Wait longer (up to 24 hours)
- Check DNS configuration with your registrar
- Use online DNS checker tools
- Verify A record is correct

#### 2. Nginx 502 Bad Gateway
**Symptoms:** Website loads but API endpoints return 502
**Solutions:**
```bash
# Check if HeadlessX server is running
pm2 status

# Check server logs
pm2 logs headlessx

# Restart HeadlessX if needed
pm2 restart headlessx

# Check Nginx error logs
sudo tail -f /var/log/nginx/error.log
```

#### 3. SSL Certificate Issues
**Symptoms:** HTTPS not working or certificate errors
**Solutions:**
```bash
# Check certificate status
sudo certbot certificates

# Renew certificate manually
sudo certbot renew --force-renewal -d your-subdomain.yourdomain.com

# Check Nginx SSL configuration
sudo nginx -t
```

#### 4. Firewall Blocking
**Symptoms:** Can't access website from external network
**Solutions:**
```bash
# Check firewall status
sudo ufw status

# Allow necessary ports
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

### Debugging Commands

```bash
# Check DNS resolution
dig your-subdomain.yourdomain.com

# Test local connectivity
curl -H "Host: your-subdomain.yourdomain.com" http://localhost

# Check port 3000 directly
curl http://localhost:3000/api/health

# Verify Nginx configuration
sudo nginx -t

# Check SSL certificate
openssl s_client -connect your-subdomain.yourdomain.com:443 -servername your-subdomain.yourdomain.com
```

## Advanced Configuration

### Custom Nginx Settings

For high-traffic scenarios, consider these optimizations in your Nginx config:

```nginx
# Rate limiting
limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;

server {
    # ... existing config ...
    
    location /api/ {
        # Apply rate limiting
        limit_req zone=api burst=20 nodelay;
        
        # Increase timeouts for long-running requests
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        
        # ... existing proxy config ...
    }
}
```

### Multiple Domains

To serve HeadlessX on multiple domains:

```nginx
server {
    listen 80;
    listen 443 ssl;
    server_name headlessx.domain1.com headlessx.domain2.com;
    
    # SSL certificates for all domains
    ssl_certificate /etc/letsencrypt/live/headlessx.domain1.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/headlessx.domain1.com/privkey.pem;
    
    # ... rest of configuration ...
}
```

### Custom Error Pages

Create custom error pages for better user experience:

```nginx
server {
    # ... existing config ...
    
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    
    location = /404.html {
        root /var/www/headlessx/errors;
        internal;
    }
    
    location = /50x.html {
        root /var/www/headlessx/errors;
        internal;
    }
}
```

## Security Considerations

1. **Always use HTTPS** in production
2. **Keep SSL certificates updated** (Certbot handles this automatically)
3. **Monitor access logs** for suspicious activity
4. **Use strong tokens** for API authentication
5. **Consider IP whitelisting** for sensitive deployments
6. **Keep Nginx and system updated** regularly

## Monitoring and Maintenance

### Log Monitoring
```bash
# Monitor Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Monitor HeadlessX logs
pm2 logs headlessx --lines 100

# Monitor system resources
htop
```

### Automated Backup
Set up automated backups of your configuration:

```bash
#!/bin/bash
# backup-config.sh
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/headlessx-$DATE"

mkdir -p $BACKUP_DIR
cp -r /etc/nginx/sites-available/headlessx $BACKUP_DIR/
cp .env $BACKUP_DIR/
cp -r logs/ $BACKUP_DIR/

echo "Backup created: $BACKUP_DIR"
```

## Support

If you encounter issues with domain setup:

1. **Check this troubleshooting guide** first
2. **Verify DNS propagation** using online tools
3. **Test each component** individually (DNS, Nginx, SSL, HeadlessX)
4. **Check server logs** for detailed error information
5. **Create a GitHub issue** with complete error details

For additional help, include this information in your support request:
- Domain name and DNS configuration
- Server OS and version
- Nginx configuration
- Error logs from both Nginx and HeadlessX
- Output from testing commands

### 🔧 **Project Files**
- ✅ `package.json` - Added build and deployment scripts

---

## 🚀 **Deployment Instructions**

### **Method 1: Automated Setup**
```bash
# Clone and setup everything
git clone https://github.com/SaifyXPRO/HeadlessX.git
cd HeadlessX

# Run automated setup (builds website, configures Nginx, etc.)
chmod +x scripts/setup.sh
sudo bash scripts/setup.sh

# Configure your domain DNS to point to your server IP
# Then setup SSL:
sudo certbot --nginx -d your-subdomain.yourdomain.com
```

### **Method 2: Docker Deployment**
```bash
# Clone repository
git clone https://github.com/SaifyXPRO/HeadlessX.git
cd HeadlessX

# Build website first
npm run build

# Start with Docker (serves both website and API)
docker-compose -f docker/docker-compose.yml up -d

# Your deployment will be available at:
# Website: http://your-server-ip/
# API: http://your-server-ip/api/health
```

### **Method 3: Manual Configuration**
```bash
# 1. Build website
cd website && npm install && npm run build && cd ..

# 2. Copy Nginx configuration  
sudo cp nginx/headlessx.conf /etc/nginx/sites-available/headlessx
sudo ln -sf /etc/nginx/sites-available/headlessx /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# 3. Deploy website files
sudo mkdir -p /var/www/headlessx
sudo cp -r website/out/* /var/www/headlessx/
sudo chown -R www-data:www-data /var/www/headlessx

# 4. Test and reload Nginx
sudo nginx -t && sudo systemctl reload nginx

# 5. Start HeadlessX API
pm2 start config/ecosystem.config.js
```

---

## 🧪 **Testing Your Setup**

### **Local Testing** 
```bash
# Test routing configuration locally
chmod +x scripts/test-routing.sh
bash scripts/test-routing.sh localhost
```

### **Domain Testing**
```bash
# Test your actual domain
bash scripts/test-routing.sh your-subdomain.yourdomain.com
```

### **Manual Testing**
```bash
# Test website
curl -I http://your-subdomain.yourdomain.com/

# Test API health
curl http://your-subdomain.yourdomain.com/api/health

# Test API status  
curl http://your-subdomain.yourdomain.com/api/status
```

---

## 🔧 **Nginx Configuration Summary**

The Nginx configuration (`nginx/headlessx.conf`) now handles:

1. **Website Serving** (`location /`)
   - Serves static files from `/var/www/headlessx`
   - Handles Next.js routing with `try_files`
   - Caches static assets (CSS, JS, images)

2. **API Proxying** (`location /api/`)
   - Removes `/api` prefix when forwarding to backend
   - Proxies to HeadlessX server on `localhost:3000`
   - Applies rate limiting and security headers

3. **Special Endpoints**
   - `/api/health` - Minimal rate limiting for monitoring
   - `/api/status` - Higher rate limits for diagnostics

---

## 📊 **Expected Results**

After successful deployment:

| URL | Expected Response | Purpose |
|-----|------------------|---------|
| `your-subdomain.yourdomain.com` | Website homepage | Landing page |
| `your-subdomain.yourdomain.com/api/health` | JSON status | Health check |
| `your-subdomain.yourdomain.com/api/status` | Server info | Diagnostics |
| `your-subdomain.yourdomain.com/api/html` | HTML extraction | Core API |
| `your-subdomain.yourdomain.com/api/screenshot` | Image capture | Core API |

---

## 🐛 **Troubleshooting**

### **Website not loading**
```bash
# Check Nginx status
sudo systemctl status nginx

# Check website files
ls -la /var/www/headlessx/

# Check Nginx config
sudo nginx -t
```

### **API not working**
```bash
# Check HeadlessX server
pm2 status
pm2 logs headlessx

# Test direct API connection
curl http://localhost:3000/health
```

### **Domain not resolving**
```bash
# Check DNS
nslookup your-subdomain.yourdomain.com

# Test domain verification
bash scripts/verify-domain.sh
```

---

## ✅ **Configuration Complete!**

Your HeadlessX v1.1.0 is now properly configured for:
- Beautiful landing page at the root domain
- Full API functionality under `/api/` prefix  
- Professional domain structure
- SSL-ready configuration
- Docker deployment support

🎉 **Ready to deploy your open source browserless web scraping API!**

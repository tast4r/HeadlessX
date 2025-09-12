# 🌐 HeadlessX v1.1.0 Custom Domain Setup Guide

## Overview
This guide will help you set up a custom domain for your HeadlessX server with SSL certificate and proper Nginx configuration. Your domain will serve both the beautiful landing page and the API endpoints.

## 🎯 Domain Structure
- **Homepage**: `headlessx.domain.com` → Beautiful landing page  
- **API Endpoints**: `headlessx.domain.com/api/*` → All API functionality
- **Example**: 
  - Website: `headlessx.domain.com`
  - Health Check: `headlessx.domain.com/api/health`
  - HTML Extraction: `headlessx.domain.com/api/html`

---

## 📋 Prerequisites

- ✅ Domain name registered (e.g., `domain.com`)
- ✅ VPS/Server with public IP address
- ✅ DNS management access
- ✅ Root/sudo access on server
- ✅ HeadlessX v1.1.0 installed and running

---

## 🔧 Step-by-Step Setup

### Step 1: DNS Configuration

**Recommended: Subdomain Setup**
```
Record Type: A
Name: headlessx
Value: YOUR_SERVER_IP
TTL: 300
```
**Result**: `headlessx.domain.com`

**Alternative: Main Domain**
```
Record Type: A
Name: @ (or blank)
Value: YOUR_SERVER_IP
TTL: 300
```
**Result**: `domain.com`

**Popular DNS Providers:**
- **Cloudflare**: DNS → Records → Add Record
- **Namecheap**: Advanced DNS → Host Records
- **GoDaddy**: DNS Management → Records
- **Route53**: Hosted Zones → Create Record

### Step 2: Server Preparation

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install nginx certbot python3-certbot-nginx ufw -y

# Start services
sudo systemctl start nginx
sudo systemctl enable nginx
```

### Step 3: Nginx Configuration

Create the configuration file:
```bash
sudo nano /etc/nginx/sites-available/headlessx
```

**Complete Nginx Configuration:**
```nginx
# HeadlessX Nginx Configuration
server {
    listen 80;
    server_name headlessx.domain.com;  # ⚠️ CHANGE THIS TO YOUR DOMAIN
    
    # Security headers
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # Rate limiting zones
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=burst:10m rate=50r/s;
    
    # Main API endpoints with rate limiting
    location / {
        limit_req zone=api burst=20 nodelay;
        limit_req_status 429;
        
        # Proxy settings
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # Timeout settings for large requests (screenshots, PDFs)
        proxy_connect_timeout 60s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
        
        # Buffer settings for large responses
        proxy_buffering off;
        proxy_buffer_size 128k;
        proxy_buffers 100 128k;
        proxy_busy_buffers_size 128k;
        
        # Client settings
        client_max_body_size 10M;
        client_body_timeout 60s;
    }
    
    # Health check endpoint (no rate limiting)
    location /health {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Quick timeouts for health checks
        proxy_connect_timeout 5s;
        proxy_send_timeout 5s;
        proxy_read_timeout 5s;
    }
    
    # Status endpoint with higher rate limit
    location /status {
        limit_req zone=burst burst=10 nodelay;
        
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    # Block common bot paths
    location ~ ^/(wp-admin|admin|phpmyadmin|xmlrpc.php) {
        return 404;
    }
    
    # Security: Hide nginx version
    server_tokens off;
}
```

### Step 4: Enable Site

```bash
# Enable the site
sudo ln -s /etc/nginx/sites-available/headlessx /etc/nginx/sites-enabled/

# Remove default site (optional)
sudo rm /etc/nginx/sites-enabled/default

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

### Step 5: Firewall Setup

```bash
# Configure UFW firewall
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw enable

# Check status
sudo ufw status verbose
```

### Step 6: SSL Certificate

```bash
# Install SSL certificate
sudo certbot --nginx -d headlessx.domain.com

# Test automatic renewal
sudo certbot renew --dry-run

# Check certificate
sudo certbot certificates
```

### Step 7: Verify Setup

**Test Commands:**
```bash
# 1. Test HTTP (should redirect to HTTPS)
curl -I http://headlessx.domain.com/health

# 2. Test HTTPS health check
curl -I https://headlessx.domain.com/health

# 3. Test API endpoint
curl -X POST "https://headlessx.domain.com/html?token=YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"url":"https://example.com"}'

# 4. Test status endpoint
curl https://headlessx.domain.com/status?token=YOUR_TOKEN
```

**Expected Results:**
- ✅ HTTP redirects to HTTPS
- ✅ Health check returns 200 OK
- ✅ API returns HTML content
- ✅ Status returns server information

---

## 🔍 Troubleshooting

### Common Issues:

**1. Domain not resolving:**
```bash
# Check DNS propagation
nslookup headlessx.domain.com
dig headlessx.domain.com

# Wait up to 24 hours for DNS propagation
```

**2. Nginx errors:**
```bash
# Check Nginx logs
sudo tail -f /var/log/nginx/error.log

# Test configuration
sudo nginx -t

# Check if ports are open
sudo netstat -tlnp | grep :80
sudo netstat -tlnp | grep :443
```

**3. SSL certificate issues:**
```bash
# Check certificate status
sudo certbot certificates

# Renew certificate manually
sudo certbot renew --force-renewal

# Check certificate details
openssl s_client -connect headlessx.domain.com:443
```

**4. Rate limiting triggered:**
```bash
# Check Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Temporarily disable rate limiting (testing only)
# Comment out limit_req lines in nginx config
```

### Performance Optimization:

**Nginx Optimization (Optional):**
```nginx
# Add to /etc/nginx/nginx.conf in http block
worker_processes auto;
worker_connections 1024;
keepalive_timeout 65;
gzip on;
gzip_types text/plain application/json application/javascript text/css;
```

---

## 📱 Integration Examples

### Make.com Integration
```
URL: https://headlessx.domain.com/html?token=YOUR_TOKEN
Method: POST
Headers: Content-Type: application/json
Body: {"url": "{{dynamic_url}}"}
```

### Zapier Integration
```
URL: https://headlessx.domain.com/render?token=YOUR_TOKEN
Method: POST
Headers: Content-Type: application/json
Body: {"url": "{{url}}", "format": "html"}
```

### Postman Collection
```javascript
// Environment Variables
BASE_URL: https://headlessx.domain.com
API_TOKEN: YOUR_TOKEN

// Request URL
{{BASE_URL}}/html?token={{API_TOKEN}}
```

---

## 🔒 Security Best Practices

1. **Change Default Token**: Update the token in your `.env` file
2. **Enable Rate Limiting**: Use the provided Nginx configuration
3. **Monitor Logs**: Regularly check access and error logs
4. **Keep Updated**: Update HeadlessX, Nginx, and SSL certificates
5. **Backup Configuration**: Save your Nginx and SSL configurations
6. **Use HTTPS Only**: Ensure all traffic is encrypted

---

## 📈 Monitoring

**Check Server Health:**
```bash
# Server status
curl https://headlessx.domain.com/status?token=YOUR_TOKEN

# Nginx status
sudo systemctl status nginx

# Check resource usage
htop
df -h
```

**Log Monitoring:**
```bash
# Real-time access logs
sudo tail -f /var/log/nginx/access.log

# Real-time error logs
sudo tail -f /var/log/nginx/error.log

# HeadlessX application logs
pm2 logs headlessx
```

---

## ✅ Final Checklist

- [ ] Domain DNS configured
- [ ] Server firewall configured
- [ ] Nginx installed and configured
- [ ] SSL certificate installed
- [ ] HeadlessX server running
- [ ] Health check responding
- [ ] API endpoints working
- [ ] Rate limiting active
- [ ] Logs monitoring setup

**Your HeadlessX server is now accessible at:**
`https://headlessx.domain.com` 🎉

---

*Last updated: September 12, 2025*
*HeadlessX v1.1.0 - Advanced Browserless Web Scraping API*
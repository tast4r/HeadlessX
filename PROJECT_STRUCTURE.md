# 📁 HeadlessX Project Structure Guide

## 🏗️ Organized Directory Structure

HeadlessX has been reorganized into a clean, professional directory structure that separates concerns and improves maintainability.

---

## 📋 Directory Overview

```
📁 HeadlessX/
├── 📁 src/                         # Source code
│   └── 📄 server.js                # Main HeadlessX server
├── 📁 config/                      # Configuration files
│   ├── 📄 ecosystem.config.js      # PM2 configuration
│   └── 📄 .env.example             # Environment template
├── 📁 docker/                      # Docker configuration
│   ├── 📄 docker-compose.yml       # Docker compose setup
│   └── � Dockerfile               # Container definition
├── �📁 scripts/                     # Utility scripts
│   ├── � setup.sh                 # Automated setup script
│   ├── 📄 verify-domain.sh         # Domain verification
│   └── 📄 test-routing.sh          # Routing tests
├── �📁 nginx/                       # Nginx configuration
│   └── 📄 headlessx.conf           # Reverse proxy config
├── 📁 docs/                        # Documentation
│   ├── 📖 DOMAIN_SETUP.md          # Domain configuration guide
│   ├── 📖 GET_ENDPOINTS.md         # GET API reference
│   ├── 📖 POST_ENDPOINTS.md        # POST API reference
│   └── 📖 HUMAN_BEHAVIOR_UPDATE.md # Human behavior features
├── 📁 website/                     # Landing page (Next.js)
│   ├── 📄 package.json             # Website dependencies
│   ├── 📁 app/                     # Next.js app directory
│   └── 📁 components/              # React components
├── 📁 logs/                        # Application logs (auto-generated)
├── 📄 package.json                 # Main project dependencies
├── 📄 .env.example                 # Environment template (root)
├── 📄 .gitignore                   # Git ignore patterns
├── 📄 LICENSE                      # MIT License
├── � README.md                    # Main documentation
├── 📄 CHANGELOG.md                 # Version history
├── 📄 CONTRIBUTING.md              # Contribution guidelines
├── 📄 SECURITY.md                  # Security policy
├── 📄 DEPLOYMENT.md                # Quick deployment guide
└── 📄 PROJECT_STRUCTURE.md         # This file
```

---

## 📂 Detailed Structure

### `/src/` - Source Code
```
src/
└── 📄 server.js                    # Main HeadlessX server application
```
**Purpose**: Contains the main application source code
**Entry Point**: `src/server.js`

### `/config/` - Configuration Files
```
config/
├── 📄 ecosystem.config.js          # PM2 process manager configuration
└── 📄 .env.example                 # Environment variables template
```
**Purpose**: All configuration files for different environments
**Usage**: 
- Copy `.env.example` to project root as `.env`
- Run PM2 with `pm2 start config/ecosystem.config.js`

### `/docker/` - Docker Configuration
```
docker/
├── 📄 Dockerfile                   # Docker container configuration
└── 📄 docker-compose.yml           # Docker Compose setup
```
**Purpose**: Docker containerization files
**Usage**: 
- `docker-compose -f docker/docker-compose.yml up -d`
- Builds from project root context

### `/scripts/` - Utility Scripts
```
scripts/
├── 📄 setup.sh                     # Automated environment setup
└── 📄 verify-domain.sh             # Domain configuration verification
```
**Purpose**: Automation and utility scripts
**Usage**:
- `chmod +x scripts/setup.sh && ./scripts/setup.sh`
- `./scripts/verify-domain.sh` (for domain testing)

### `/nginx/` - Nginx Configuration
```
nginx/
└── 📄 headlessx.conf               # Nginx reverse proxy configuration
```
**Purpose**: Web server configuration templates
**Usage**: Copy to `/etc/nginx/sites-available/headlessx`

### `/docs/` - Documentation
```
docs/
├── 📖 DOMAIN_SETUP.md              # Complete domain setup with SSL
├── 📖 GET_ENDPOINTS.md             # Complete GET API documentation
├── 📖 POST_ENDPOINTS.md            # Complete POST API documentation
└── 📖 HUMAN_BEHAVIOR_UPDATE.md     # Advanced human behavior simulation features
```
**Purpose**: Detailed project documentation
**Note**: Main deployment guide is in root `DEPLOYMENT.md`

### `/logs/` - Application Logs
```
logs/
├── 📄 .gitkeep                     # Ensures directory is tracked
├── 📄 err.log                      # Error logs (auto-generated)
├── 📄 out.log                      # Output logs (auto-generated)
└── 📄 combined.log                 # Combined logs (auto-generated)
```
**Purpose**: Runtime logs and monitoring
**Auto-generated**: PM2 and application create log files here

---

## 🚀 Usage Examples

### Docker Deployment
```bash
# From project root
docker-compose -f docker/docker-compose.yml up -d
```

### Node.js Deployment
```bash
# Setup environment
chmod +x scripts/setup.sh
./scripts/setup.sh

# Configure environment
cp config/.env.example .env
nano .env

# Start with PM2
pm2 start config/ecosystem.config.js
```

### Domain Setup
```bash
# Copy Nginx configuration
sudo cp nginx/headlessx.conf /etc/nginx/sites-available/headlessx

# Verify domain setup
./scripts/verify-domain.sh
```

---

## 🔧 File Reference Updates

All file references have been updated:

### Documentation Links
- `DEPLOYMENT.md` - Deployment instructions
- `docs/DOMAIN_SETUP.md` - Domain configuration
- `docs/GET_ENDPOINTS.md` - GET API reference
- `docs/POST_ENDPOINTS.md` - POST API reference

### Configuration References
- `config/ecosystem.config.js` - PM2 configuration
- `config/.env.example` - Environment template
- `docker/docker-compose.yml` - Docker Compose
- `docker/Dockerfile` - Docker build

### Script References
- `scripts/setup.sh` - Environment setup
- `scripts/verify-domain.sh` - Domain verification

---

## 🎯 Benefits of New Structure

### 🏗️ **Organization**
- Clear separation of concerns
- Easy to navigate and understand
- Professional project structure

### 🚀 **Deployment**
- Docker files isolated in `/docker/`
- Configuration centralized in `/config/`
- Scripts organized in `/scripts/`

### 📚 **Documentation**
- All docs centralized in `/docs/`
- Clear reference paths
- Easy to maintain

### 🔧 **Maintenance**
- Source code isolated in `/src/`
- Logs contained in `/logs/`
- Configuration separate from code

### 🐳 **Container Friendly**
- Proper Docker context handling
- Clean build layers
- Efficient caching

---

## 🔄 Migration Notes

If you have an existing HeadlessX installation:

1. **Stop Services**: `pm2 stop all`
2. **Backup Data**: `cp .env .env.backup`
3. **Update Repository**: `git pull origin main`
4. **Update Paths**: Use new file paths
5. **Restart Services**: `pm2 start config/ecosystem.config.js`

---

## 📝 Development Guidelines

### Adding New Features
- Source code goes in `/src/`
- Configuration in `/config/`
- Documentation in `/docs/`
- Scripts in `/scripts/`

### File Naming
- Use kebab-case for files: `my-feature.js`
- Use PascalCase for classes: `MyFeature`
- Use UPPER_CASE for constants: `API_TOKEN`

### Documentation
- Update relevant docs in `/docs/`
- Update main README.md if needed
- Include examples and usage

---

*Structure organized: September 12, 2025*
*HeadlessX v1.1.0 - Advanced Browserless Web Scraping API*
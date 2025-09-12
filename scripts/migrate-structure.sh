#!/bin/bash

# HeadlessX Structure Migration Script
# Migrates from flat structure to organized directory structure

echo "🔄 HeadlessX Structure Migration"
echo "================================"

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from the HeadlessX root directory."
    exit 1
fi

# Check if this is a HeadlessX project
if ! grep -q "headlessx" package.json; then
    echo "❌ Error: This doesn't appear to be a HeadlessX project."
    exit 1
fi

echo "✅ HeadlessX project detected"

# Stop any running PM2 processes
echo "🛑 Stopping PM2 processes..."
pm2 stop headlessx 2>/dev/null || true
pm2 stop enhanced-playwright-server 2>/dev/null || true

# Backup existing .env if it exists
if [ -f ".env" ]; then
    echo "💾 Backing up existing .env file..."
    cp .env .env.backup
    echo "   Backup saved as .env.backup"
fi

# Create new directory structure
echo "📁 Creating directory structure..."
mkdir -p src config docker scripts nginx docs logs

# Move files to appropriate directories
echo "📦 Moving files to organized structure..."

# Move source code
if [ -f "server.js" ]; then
    mv server.js src/
    echo "   ✅ Moved server.js → src/"
fi

# Move configuration files
if [ -f "ecosystem.config.js" ]; then
    mv ecosystem.config.js config/
    echo "   ✅ Moved ecosystem.config.js → config/"
fi

if [ -f ".env.example" ]; then
    mv .env.example config/
    echo "   ✅ Moved .env.example → config/"
fi

# Move Docker files
if [ -f "Dockerfile" ]; then
    mv Dockerfile docker/
    echo "   ✅ Moved Dockerfile → docker/"
fi

if [ -f "docker-compose.yml" ]; then
    mv docker-compose.yml docker/
    echo "   ✅ Moved docker-compose.yml → docker/"
fi

# Move scripts
if [ -f "setup.sh" ]; then
    mv setup.sh scripts/
    echo "   ✅ Moved setup.sh → scripts/"
fi

if [ -f "verify-domain.sh" ]; then
    mv verify-domain.sh scripts/
    echo "   ✅ Moved verify-domain.sh → scripts/"
fi

# Move documentation
for doc in *.md; do
    if [ "$doc" != "README.md" ] && [ -f "$doc" ]; then
        mv "$doc" docs/
        echo "   ✅ Moved $doc → docs/"
    fi
done

# Update package.json
echo "⚙️ Updating package.json..."
if command -v jq >/dev/null 2>&1; then
    # Use jq if available
    jq '.main = "src/server.js" | .scripts.start = "node src/server.js" | .scripts.dev = "node src/server.js"' package.json > package.json.tmp
    mv package.json.tmp package.json
    echo "   ✅ Updated package.json with new paths"
else
    # Manual update if jq not available
    sed -i 's/"main": "server.js"/"main": "src\/server.js"/' package.json
    sed -i 's/"start": "node server.js"/"start": "node src\/server.js"/' package.json
    sed -i 's/"dev": "node server.js"/"dev": "node src\/server.js"/' package.json
    echo "   ✅ Updated package.json with new paths"
fi

# Update ecosystem config
if [ -f "config/ecosystem.config.js" ]; then
    echo "⚙️ Updating PM2 configuration..."
    sed -i 's|script: '\''server.js'\''|script: '\''../src/server.js'\''|' config/ecosystem.config.js
    sed -i 's|error_file: '\''./logs/|error_file: '\''../logs/|g' config/ecosystem.config.js
    sed -i 's|out_file: '\''./logs/|out_file: '\''../logs/|g' config/ecosystem.config.js
    sed -i 's|log_file: '\''./logs/|log_file: '\''../logs/|g' config/ecosystem.config.js
    echo "   ✅ Updated PM2 configuration paths"
fi

# Update docker-compose.yml
if [ -f "docker/docker-compose.yml" ]; then
    echo "⚙️ Updating Docker configuration..."
    sed -i 's|context: \.|context: ..|' docker/docker-compose.yml
    sed -i 's|dockerfile: Dockerfile|dockerfile: docker/Dockerfile|' docker/docker-compose.yml
    sed -i 's|./logs:/app/logs|../logs:/app/logs|' docker/docker-compose.yml
    echo "   ✅ Updated Docker configuration"
fi

# Update Dockerfile
if [ -f "docker/Dockerfile" ]; then
    sed -i 's|COPY server.js ./|COPY src/server.js ./|' docker/Dockerfile
    echo "   ✅ Updated Dockerfile"
fi

# Create .gitkeep for logs directory
echo "# Logs directory" > logs/.gitkeep

# Restore .env if it was backed up
if [ -f ".env.backup" ]; then
    echo "🔄 Restoring .env file..."
    cp .env.backup .env
    echo "   ✅ .env file restored"
fi

echo ""
echo "🎉 Migration completed successfully!"
echo ""
echo "📁 New structure:"
echo "   src/              - Source code"
echo "   config/           - Configuration files"
echo "   docker/           - Docker files"
echo "   scripts/          - Utility scripts"
echo "   nginx/            - Nginx configuration"
echo "   docs/             - Documentation"
echo "   logs/             - Application logs"
echo ""
echo "🚀 Next steps:"
echo "   1. Review your .env file (restored from backup)"
echo "   2. Start services: pm2 start config/ecosystem.config.js"
echo "   3. Or with Docker: docker-compose -f docker/docker-compose.yml up -d"
echo ""
echo "📚 See PROJECT_STRUCTURE.md for detailed information"
echo ""
echo "✅ HeadlessX migration complete!"
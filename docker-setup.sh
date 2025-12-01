#!/bin/bash
# Docker Setup Script for Electronics Inventory Management

echo "🚀 Setting up Docker environment..."

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cat > .env << EOF
# Flask Configuration
FLASK_ENV=production
SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")

# Database Configuration
MYSQL_HOST=db
MYSQL_PORT=3306
MYSQL_USER=inventory_user
MYSQL_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
MYSQL_DB=inventory
MYSQL_ROOT_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)

# Application Port
APP_PORT=5000
EOF
    echo "✅ .env file created with secure random values"
else
    echo "ℹ️  .env file already exists, skipping..."
fi

# Create docker directory structure
mkdir -p docker/mysql

# Build and start containers
echo "🔨 Building Docker images..."
docker-compose build

echo "🚀 Starting containers..."
docker-compose up -d

echo "⏳ Waiting for database to be ready..."
sleep 10

echo "📊 Running database migrations..."
docker-compose exec -T web flask db upgrade

echo "✅ Setup complete!"
echo ""
echo "🌐 Application available at: http://localhost:5000"
echo "📝 View logs with: docker-compose logs -f"


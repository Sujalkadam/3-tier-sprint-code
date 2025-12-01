# Docker Setup Script for Windows PowerShell
# Electronics Inventory Management

Write-Host "🚀 Setting up Docker environment..." -ForegroundColor Cyan

# Create .env file if it doesn't exist
if (-not (Test-Path .env)) {
    Write-Host "📝 Creating .env file from template..." -ForegroundColor Yellow
    
    # Generate secure random values
    $secretKey = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | ForEach-Object {[char]$_})
    $mysqlPass = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 25 | ForEach-Object {[char]$_})
    $rootPass = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 25 | ForEach-Object {[char]$_})
    
    @"
# Flask Configuration
FLASK_ENV=production
SECRET_KEY=$secretKey

# Database Configuration
MYSQL_HOST=db
MYSQL_PORT=3306
MYSQL_USER=inventory_user
MYSQL_PASSWORD=$mysqlPass
MYSQL_DB=inventory
MYSQL_ROOT_PASSWORD=$rootPass

# Application Port
APP_PORT=5000
"@ | Out-File -FilePath .env -Encoding utf8
    
    Write-Host "✅ .env file created with secure random values" -ForegroundColor Green
} else {
    Write-Host "ℹ️  .env file already exists, skipping..." -ForegroundColor Yellow
}

# Create docker directory structure
if (-not (Test-Path docker\mysql)) {
    New-Item -ItemType Directory -Path docker\mysql -Force | Out-Null
}

# Build and start containers
Write-Host "🔨 Building Docker images..." -ForegroundColor Cyan
docker-compose build

Write-Host "🚀 Starting containers..." -ForegroundColor Cyan
docker-compose up -d

Write-Host "⏳ Waiting for database to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "📊 Running database migrations..." -ForegroundColor Cyan
docker-compose exec -T web flask db upgrade

Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Application available at: http://localhost:5000" -ForegroundColor Cyan
Write-Host "📝 View logs with: docker-compose logs -f" -ForegroundColor Cyan


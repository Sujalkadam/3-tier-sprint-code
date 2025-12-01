# Docker Deployment Guide

This guide explains how to deploy the Electronics Inventory Management application using Docker Compose.

## 📋 Prerequisites

- Docker Desktop (Windows/Mac) or Docker Engine + Docker Compose (Linux)
- Git (optional)

## 🚀 Quick Start

### 1. Clone/Download the Repository

```bash
cd Electronics-Inventory-management-main
```

### 2. Create Environment File

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` and update the following values:
- `SECRET_KEY`: Generate a strong secret key (use: `python -c "import secrets; print(secrets.token_hex(32))"`)
- `MYSQL_ROOT_PASSWORD`: Set a strong MySQL root password
- `MYSQL_PASSWORD`: Set a strong password for the database user

### 3. Build and Run with Docker Compose

**Production Mode:**
```bash
docker-compose up -d --build
```

**Development Mode (with hot reload):**
```bash
docker-compose -f docker-compose.dev.yml up -d --build
```

### 4. Initialize Database

The database will be automatically initialized. To manually run migrations:

```bash
docker-compose exec web flask db upgrade
```

### 5. Access the Application

- **Application:** http://localhost:5000
- **MySQL:** localhost:3306

## 📁 Docker Files Structure

```
.
├── Dockerfile              # Production Docker image
├── Dockerfile.dev          # Development Docker image
├── docker-compose.yml      # Production compose file
├── docker-compose.dev.yml  # Development compose file
├── .dockerignore           # Files to exclude from build
├── .env.example            # Environment variables template
└── docker/
    └── mysql/
        └── init.sql        # Database initialization script
```

## 🔧 Configuration

### Environment Variables

Edit `.env` file to configure:

| Variable | Description | Default |
|----------|-------------|---------|
| `FLASK_ENV` | Flask environment | `production` |
| `SECRET_KEY` | Flask secret key | `change-me-in-production` |
| `MYSQL_HOST` | Database host | `db` |
| `MYSQL_PORT` | Database port | `3306` |
| `MYSQL_USER` | Database user | `inventory_user` |
| `MYSQL_PASSWORD` | Database password | `inventory_pass` |
| `MYSQL_DB` | Database name | `inventory` |
| `APP_PORT` | Application port | `5000` |

### Port Configuration

- **Application:** Change `APP_PORT` in `.env` or modify `ports` in `docker-compose.yml`
- **MySQL:** Change `MYSQL_PORT` in `.env` or modify `ports` in `docker-compose.yml`

## 🛠️ Common Commands

### Start Services
```bash
docker-compose up -d
```

### Stop Services
```bash
docker-compose down
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f web
docker-compose logs -f db
```

### Rebuild After Code Changes
```bash
docker-compose up -d --build
```

### Access Container Shell
```bash
# Flask app container
docker-compose exec web bash

# MySQL container
docker-compose exec db bash
```

### Database Commands
```bash
# Run migrations
docker-compose exec web flask db upgrade

# Create new migration
docker-compose exec web flask db migrate -m "description"

# Access MySQL CLI
docker-compose exec db mysql -u root -p
```

### Remove Everything (including volumes)
```bash
docker-compose down -v
```

## 🔍 Troubleshooting

### Issue: Port Already in Use

**Solution:** Change the port in `.env` or `docker-compose.yml`:
```yaml
ports:
  - "5001:5000"  # Use port 5001 instead
```

### Issue: Database Connection Error

**Solution:** 
1. Check if database container is healthy: `docker-compose ps`
2. Wait for database to be ready (healthcheck)
3. Verify environment variables in `.env`

### Issue: Permission Denied

**Solution:** On Linux, you may need to fix permissions:
```bash
sudo chown -R $USER:$USER .
```

### Issue: Migrations Not Running

**Solution:** Manually run migrations:
```bash
docker-compose exec web flask db upgrade
```

### Issue: Container Keeps Restarting

**Solution:** Check logs:
```bash
docker-compose logs web
```

## 📦 Production Deployment

### 1. Security Checklist

- [ ] Change `SECRET_KEY` to a strong random value
- [ ] Change `MYSQL_ROOT_PASSWORD` to a strong password
- [ ] Change `MYSQL_PASSWORD` to a strong password
- [ ] Use environment-specific `.env` files
- [ ] Enable HTTPS (use reverse proxy like Nginx)
- [ ] Set up proper firewall rules

### 2. Production Optimizations

The production Dockerfile uses:
- **Gunicorn** with 4 workers
- **Python 3.11 slim** image for smaller size
- **Health checks** for monitoring
- **Multi-stage builds** (can be added)

### 3. Reverse Proxy (Nginx)

For production, add Nginx as a reverse proxy:

```yaml
# Add to docker-compose.yml
nginx:
  image: nginx:alpine
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    - ./nginx/ssl:/etc/nginx/ssl:ro
  depends_on:
    - web
```

## 🔄 Updates and Maintenance

### Update Application Code

```bash
git pull  # or update files
docker-compose up -d --build
```

### Backup Database

```bash
docker-compose exec db mysqldump -u root -p inventory > backup.sql
```

### Restore Database

```bash
docker-compose exec -T db mysql -u root -p inventory < backup.sql
```

## 📊 Monitoring

### Check Service Status
```bash
docker-compose ps
```

### View Resource Usage
```bash
docker stats
```

### Health Checks
```bash
# Application health
curl http://localhost:5000/

# Database health
docker-compose exec db mysqladmin ping -h localhost -u root -p
```

## 🎯 Development vs Production

| Feature | Development | Production |
|---------|-------------|------------|
| Dockerfile | `Dockerfile.dev` | `Dockerfile` |
| Compose File | `docker-compose.dev.yml` | `docker-compose.yml` |
| Server | Flask dev server | Gunicorn |
| Hot Reload | ✅ Yes | ❌ No |
| Debug Mode | ✅ Enabled | ❌ Disabled |
| Volume Mount | ✅ Code mounted | ❌ Code copied |

## 📝 Notes

- Database data persists in Docker volumes (`mysql_data`)
- Instance folder is mounted for Flask config
- Migrations folder is mounted for database migrations
- Use `.dockerignore` to exclude unnecessary files from build

## 🆘 Support

For issues:
1. Check logs: `docker-compose logs`
2. Verify environment variables
3. Ensure ports are not in use
4. Check Docker daemon is running


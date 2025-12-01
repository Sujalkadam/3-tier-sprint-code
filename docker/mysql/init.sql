-- Initialize database with UTF8MB4 encoding
CREATE DATABASE IF NOT EXISTS inventory CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Grant privileges (if user doesn't exist, it will be created by MySQL)
GRANT ALL PRIVILEGES ON inventory.* TO 'inventory_user'@'%';
FLUSH PRIVILEGES;


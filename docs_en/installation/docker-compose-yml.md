# 📄 Docker Compose Configuration Guide

This document provides detailed information about New API's Docker Compose configuration options for various deployment scenarios.

## 🧱 Basic Configuration Structure

The Docker Compose configuration file `docker-compose.yml` defines how New API services and their dependencies (such as MySQL, Redis) are deployed.

## 🏭 Standard Configuration (Recommended for Production)

Below is the standard Docker Compose configuration suitable for most production environments:

```yaml
services:
  new-api:
    image: calciumion/new-api:latest
    container_name: new-api
    restart: always
    command: --log-dir /app/logs
    ports:
      - "3000:3000"
    volumes:
      - ./data:/data
      - ./logs:/app/logs
    environment:
      - SQL_DSN=root:123456@tcp(mysql:3306)/new-api  # Points to mysql service
      - REDIS_CONN_STRING=redis://redis
      - TZ=Asia/Shanghai
    #      - SESSION_SECRET=random_string  # Set for multi-machine deployment, must modify this random string!!!!!!!
    #      - NODE_TYPE=slave  # Uncomment for slave nodes in multi-machine deployment
    #      - SYNC_FREQUENCY=60  # Uncomment if periodic database sync is needed
    #      - FRONTEND_BASE_URL=https://your-domain.com  # Uncomment for multi-machine deployment with frontend URL

    depends_on:
      - redis
      - mysql
    healthcheck:
      test: ["CMD-SHELL", "wget -q -O - http://localhost:3000/api/status | grep -o '\"success\":\\s*true' | awk -F: '{print $$2}'"]
      interval: 30s
      timeout: 10s
      retries: 3

  redis:
    image: redis:latest
    container_name: redis
    restart: always

  mysql:
    image: mysql:8.2
    container_name: mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: 123456  # Ensure consistency with password in SQL_DSN
      MYSQL_DATABASE: new-api
    volumes:
      - mysql_data:/var/lib/mysql
    # ports:
    #   - "3306:3306"  # Uncomment if MySQL access from outside Docker is needed

volumes:
  mysql_data:
```

## 🧪 Simplified Configuration (Suitable for Testing)

If just for testing, you can use the following simplified version containing only the New API service itself:

```yaml
services:
  new-api:
    image: calciumion/new-api:latest
    container_name: new-api
    restart: always
    ports:
      - "3000:3000"
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./data:/data
```

## ⚙️ Configuration Explanation

### 🔧 New API Service Configuration

| Parameter | Description |
|-----------|-------------|
| `image` | Image name, usually use `calciumion/new-api:latest` to get the latest version |
| `container_name` | Container name, customizable |
| `restart` | Container restart policy, recommended to set as `always` to ensure automatic service restart |
| `command` | Startup command, customizable startup parameters |
| `ports` | Port mapping, default maps container port 3000 to host port 3000 |
| `volumes` | Volume mapping, ensures data persistence |
| `environment` | Environment variable settings, used to configure New API behavior |
| `depends_on` | Dependent services, ensures correct startup order |
| `healthcheck` | Health check configuration, used to monitor service status |

### 🔍 Environment Variable Explanation

New API supports various environment variable configurations. Here are some commonly used ones:

| Environment Variable | Description | Example |
|---------------------|-------------|---------|
| `SQL_DSN` | Database connection string | `root:123456@tcp(mysql:3306)/new-api` |
| `REDIS_CONN_STRING` | Redis connection string | `redis://redis` |
| `TZ` | Timezone setting | `Asia/Shanghai` |
| `SESSION_SECRET` | Session secret (required for multi-machine deployment) | `your_random_string` |
| `NODE_TYPE` | Node type (master/slave) | `master` or `slave` |
| `SYNC_FREQUENCY` | Sync frequency (seconds) | `60` |

For a complete list of environment variables, please refer to [Environment Variables Configuration Guide](environment-variables.md).

## 🌐 Multi-Node Deployment Configuration

For multi-node deployment scenarios, master and slave node configurations are slightly different:

### 👑 Master Node Configuration

```yaml
services:
  new-api-master:
    image: calciumion/new-api:latest
    container_name: new-api-master
    restart: always
    ports:
      - "3000:3000"
    environment:
      - SQL_DSN=root:123456@tcp(mysql:3306)/new-api
      - REDIS_CONN_STRING=redis://redis
      - SESSION_SECRET=your_unique_session_secret
      - CRYPTO_SECRET=your_unique_crypto_secret
      - TZ=Asia/Shanghai
    volumes:
      - ./data:/data
```

### 👥 Slave Node Configuration

```yaml
services:
  new-api-slave:
    image: calciumion/new-api:latest
    container_name: new-api-slave
    restart: always
    ports:
      - "3001:3000"  # Note different port mapping
    environment:
      - SQL_DSN=root:123456@tcp(mysql:3306)/new-api
      - REDIS_CONN_STRING=redis://redis
      - SESSION_SECRET=your_unique_session_secret  # Must be same as master node
      - CRYPTO_SECRET=your_unique_crypto_secret  # Must be same as master node
      - NODE_TYPE=slave  # Set as slave node
      - SYNC_FREQUENCY=60
      - TZ=Asia/Shanghai
    volumes:
      - ./data-slave:/data
```

## 📝 Usage Instructions

### ⬇️ Installation

Save the configuration as a `docker-compose.yml` file, then run in the same directory:

```bash
docker compose up -d
```

### 📋 Viewing Logs

```bash
docker compose logs -f
```

### 🛑 Stopping Services

```bash
docker compose down
```

!!! tip "Tip"
    For more information about Docker Compose usage, please refer to [Docker Compose Installation Guide](docker-compose-installation.md). 
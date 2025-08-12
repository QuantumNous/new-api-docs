# 🐙 Docker Compose Installation Guide

This document provides detailed steps for deploying New API using Docker Compose.

## 📋 Prerequisites

- Docker and Docker Compose installed
- Recommended system: Linux (Ubuntu/CentOS/Debian, etc.)

## 🔄 Deploying with Docker Compose

### 📂 Method 1: Using Git Clone (Recommended)

If you can access GitHub normally, this method is recommended:

```shell
# Download project source code
git clone https://github.com/Calcium-Ion/new-api.git

# Enter project directory
cd new-api
```

### ✍️ Method 2: Manually Creating Configuration Files

If you cannot access GitHub or clone the repository, you can manually create configuration files:

1. Create a directory for New API deployment:

```shell
mkdir new-api
cd new-api
```

2. Create a `docker-compose.yml` file in this directory

   You can refer to the configuration examples in the [Docker Compose Configuration Guide](docker-compose-yml.md) document and choose based on your needs:
   
   - Production environment: Recommended to use complete configuration (including MySQL and Redis)
   - Testing environment: Can use simplified configuration

3. Create the file using a text editor:

```shell
# Using nano editor
nano docker-compose.yml

# Or using vim editor
vim docker-compose.yml
```

Copy the selected configuration content to this file and customize it as needed.

## 🚀 Starting Services

After the configuration file is ready, whether you cloned via Git or created manually, you can use the following command to start services:

```shell
# Start services using Docker Compose
docker compose up -d
```

This command will automatically pull the required images and start services in the background.

## 📋 Viewing Logs

- **All services (follow)**

```bash
docker compose logs -f
```

- **Logs of a specific service** (examples: `new-api`, `mysql`, `redis`)

```bash
docker compose logs -f new-api
docker compose logs -f mysql
docker compose logs -f redis
```

- **Show only the latest N lines**

```bash
docker compose logs --tail=100 new-api
```

- **Show logs since a time window**

```bash
docker compose logs --since=10m new-api
```

- **Include timestamps**

```bash
docker compose logs -f -t new-api
```

- **Foreground mode debugging (stream logs while starting)**

```bash
docker compose up
# Or start and follow a single service
docker compose up new-api
```

Press Ctrl+C to exit foreground mode (the service will stop). Use `-d` for background mode.

- **List services/status**

```bash
docker compose ps
```

- **Using container name to view logs** (when `container_name` is set, e.g., `new-api`)

```bash
docker logs -f new-api
```

## 🛑 Stopping Services

```shell
# Stop services
docker compose down
```

## 🌐 Accessing the System

After services start successfully, visit `http://server-IP:3000` to enter the system.

Default admin username: `root`  
Default admin password: `123456`

!!! danger "Important"
    It is recommended to change the default password immediately after first login. 
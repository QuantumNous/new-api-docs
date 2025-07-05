# 🔄 System Update Guide

This document provides methods and best practices for updating the New API system to ensure a smooth upgrade to the latest version.

## 🔍 Preparation Before Update

Before updating the system, it is recommended to perform the following preparations:

1. **Backup Data**: Backup your database and important configuration files
2. **Check Release Notes**: View the latest release notes on [GitHub Releases](https://github.com/Calcium-Ion/new-api/releases)
3. **Check Compatibility**: Ensure the new version is compatible with your existing plugins, integrations, or custom configurations
4. **Choose the Right Time**: Perform updates during off-peak hours to minimize user impact

## 🐳 Update Methods for Docker Deployment

### 📦 Method 1: Single Container Deployment Update

If you deployed New API using a single Docker container, update as follows:

```shell
# Pull the latest image
docker pull calciumion/new-api:latest

# Stop and remove the old container
docker stop new-api
docker rm new-api

# Re-run the container with the same parameters
docker run --name new-api -d --restart always \
  -p 3000:3000 \
  -e TZ=Asia/Shanghai \
  -v /your/data/path:/data \
  calciumion/new-api:latest
```

!!! warning "Attention"
    Make sure to use the same parameters as the original container, especially for data volume mounts and environment variable configuration.

### 🐙 Method 2: Update with Docker Compose

If you deployed with Docker Compose (see [Docker Compose Configuration Guide](docker-compose-yml.md)), the update process is simpler:

```shell
# Enter the project directory
cd new-api

# Pull the latest image
docker compose pull

# Stop and restart the service
docker compose down
docker compose up -d
```

Or use a one-liner:

```shell
docker compose pull && docker compose down && docker compose up -d
```

### 🛠️ Method 3: Update with BT Panel

If you deployed with BT Panel, update as follows:

1. Log in to BT Panel, go to **Docker Management** -> **Container List**
2. Find the New API container, click **More** -> **Recreate**
3. Check **Pull Latest Image** option, ensure other configurations remain unchanged
4. Click **Submit**; the system will automatically pull the latest image and recreate the container

## 💻 Update Method for Source Code Deployment

If you deployed New API from source, update as follows:

```shell
# Enter the project directory
cd new-api

# Pull the latest code
git pull

# Build the backend
go build -o new-api

# Update and build the frontend
cd web
bun install
bun run build
cd ..

# Restart the service
./new-api --port 3000
```

## 🌐 Update Strategy for Multi-Node Deployment {: #multi-node-update-strategy }

For multi-node deployments, it is recommended to use the following update strategy:

1. **Update Slave Nodes First**: Update one slave node first and test its stability
2. **Proceed Gradually**: After confirming the slave node is stable, update the remaining slave nodes one by one
3. **Update the Master Node Last**: After all slave nodes are running stably, update the master node

This strategy minimizes the risk of service interruption.

!!! tip "Detailed Guide"
    For a complete guide on cluster deployment, see the [Cluster Deployment Documentation](cluster-deployment.md).

## ✅ Post-Update Checklist

After updating the system, check the following to ensure everything is working properly:

1. **Access the Admin Panel**: Make sure you can log in and access the admin panel
2. **Check Logs**: Review system logs for errors or warnings
3. **Test API Calls**: Test some API calls to ensure functionality
4. **Check Database Migration**: Confirm that database structure updates were successful
5. **Check Channel Status**: Ensure all channel connections are normal

## ⏪ Version Rollback

If you encounter problems after updating, you can roll back to a previous stable version:

### 🐳 Docker Rollback

```shell
# Pull a specific version image
docker pull calciumion/new-api:v1.x.x

# Stop and remove the current container
docker stop new-api
docker rm new-api

# Recreate the container with the old version image
docker run --name new-api -d --restart always \
  -p 3000:3000 \
  -e TZ=Asia/Shanghai \
  -v /your/data/path:/data \
  calciumion/new-api:v1.x.x
```

### 💻 Source Code Rollback

```shell
# Enter the project directory
cd new-api

# Checkout a specific version
git checkout v1.x.x

# Rebuild
go build -o new-api

# Update and build the frontend
cd web
bun install
bun run build
cd ..

# Restart the service
./new-api --port 3000
```

## ❓ FAQ

### ❗ Service Fails to Start After Update

- Check logs for error messages
- Ensure database connection is normal
- Ensure environment variable configuration is correct

### ⚠️ Abnormal Functionality After Update

- Check for API format changes
- Ensure frontend and backend versions match
- Check if the new version requires additional configuration

### 🗄️ Database Structure Incompatibility

- Check release notes for database migration instructions
- Check if manual database migration scripts are needed
- Contact developers for database upgrade guidance

## 🤖 Automatic Update Tool (Use with Caution)

For users who want automatic updates, you can use Watchtower to automatically update containers:

```shell
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower -c \
  --run-once new-api
```

!!! warning "Attention"
    Automatic updates may cause unexpected issues, especially when there are database structure changes. It is recommended to use automatic updates only in test environments. In production, updates should be controlled manually. 
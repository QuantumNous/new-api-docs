# System Update Guide

This document provides the update methods and best practices for the New API system to ensure a smooth upgrade to the latest version.

## Pre-Update Preparation

Before updating the system, it is recommended to perform the following preparatory steps:

1. **Backup Data**: Back up the database and important configuration files
2. **Check Update Logs**: Review the latest version's updates on [GitHub Releases](https://github.com/Calcium-Ion/new-api/releases)
3. **Check Compatibility**: Confirm whether the new version is compatible with your existing plugins, integrations, or custom configurations
4. **Choose an Appropriate Time**: Perform the update during off-peak hours to minimize impact on users

## Docker Deployment Update Methods

### Method One: Single Container Deployment Update

If you deployed New API using a single Docker container, you can update by following these steps:

```shell
# 拉取最新镜像
docker pull calciumion/new-api:latest

# 停止并移除旧容器
docker stop new-api
docker rm new-api

# 使用相同的参数重新运行容器
docker run --name new-api -d --restart always \
  -p 3000:3000 \
  -e TZ=Asia/Shanghai \
  -v /your/data/path:/data \
  calciumion/new-api:latest
```

!!! warning "Attention"
    Please ensure that you use the same parameters as the original container when starting the new container, especially for volume mounts and environment variable configuration.

### Method Two: Using Docker Compose to Update

If you are using Docker Compose for deployment (see [Docker Compose Configuration Instructions](docker-compose-yml.md)), the update process is simpler:

```shell
# 进入项目目录
cd new-api

# 拉取最新镜像
docker compose pull

# 停止并重启服务
docker compose down
docker compose up -d
```

Or use a more concise command:

```shell
docker compose pull && docker compose down && docker compose up -d
```

### Method Three: Using 1Panel Panel to Update

If you deployed using the 1Panel panel, you can update by following these steps:

1. Log in to the 1Panel panel, go to **App Store** -> **Upgradable Page**
2. Find the New API application and click the **Upgrade** button
3. Select the **Target Version to Upgrade To**
4. Click the **Confirm** button, and the system will automatically pull the latest image and upgrade the application

### Method Four: Using BaoTa Panel to Update

If you deployed using the BaoTa panel, you can update by following these steps:

1. Log in to the BaoTa panel, go to **Docker Management** -> **Container List**
2. Find the New API container, click **More** -> **Recreate**
3. Check the **Pull Latest Image** option, ensuring other configurations remain unchanged
4. Click **Submit**, and the system will automatically pull the latest image and recreate the container

## Update Method for Source Code Compilation

If you deployed New API by compiling from source code, the update steps are as follows:

```shell
# 进入项目目录
cd new-api

# 拉取最新代码
git pull

# 编译后端
go build -o new-api

# 更新并编译前端
cd web
bun install
bun run build
cd ..

# 重启服务
./new-api --port 3000
```

## Update Strategy for Multi-Node Deployment {: #多节点部署的更新策略 }

For multi-node deployment environments, the following update strategy is recommended:

1. **Update Secondary Nodes First**: Start by updating one secondary node and testing its stability
2. **Gradual Rollout**: After confirming the stability of the secondary node, update the remaining secondary nodes one by one
3. **Update Primary Node Last**: After all secondary nodes are running stably, update the primary node

This strategy minimizes the risk of service interruption.

!!! tip "Detailed Guide"
    For a complete guide on cluster deployment, please refer to the [Cluster Deployment Documentation](cluster-deployment.md).

## Post-Update Checklist

After the system update, please check the following items to ensure the system is running correctly:

1. **Access Management Interface**: Confirm that you can log in and access the management interface normally
2. **Check Logs**: Review system logs for errors or warnings
3. **Test API Calls**: Test some API calls to ensure functionality is normal
4. **Check Database Migration**: Confirm whether the database structure update was successful
5. **Check Channel Status**: Confirm whether all Channel connections are normal

## Version Rollback

If issues arise after the update, you can roll back to a previous stable version:

### Docker Rollback

```shell
# 拉取特定版本的镜像
docker pull calciumion/new-api:v1.x.x

# 停止并移除当前容器
docker stop new-api
docker rm new-api

# 使用旧版本镜像重新创建容器
docker run --name new-api -d --restart always \
  -p 3000:3000 \
  -e TZ=Asia/Shanghai \
  -v /your/data/path:/data \
  calciumion/new-api:v1.x.x
```

### Source Code Rollback

```shell
# 进入项目目录
cd new-api

# 切换到特定版本
git checkout v1.x.x

# 重新编译
go build -o new-api

# 更新并编译前端
cd web
bun install
bun run build
cd ..

# 重启服务
./new-api --port 3000
```

## Frequently Asked Questions (FAQ)

### Service Fails to Start After Update

- Check logs for error messages
- Confirm that the database connection is normal
- Confirm that environment variable configuration is correct

### Abnormal Functionality After Update

- Check for any changes in API format
- Check if the frontend and backend versions match
- Confirm if the new version requires additional configuration

### Database Structure Incompatibility

- Check the update logs for database migration instructions
- Check if manual execution of database migration scripts is required
- Contact the developer for database upgrade guidance

## Automatic Update Tool (Use with Caution)

For users who wish to update automatically, Watchtower can be used to update containers:

```shell
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower -c \
  --run-once new-api
```

!!! warning "Attention"
    Automatic updates may lead to unexpected issues, especially when database structures change. It is recommended to use automatic updates only in testing environments; production environments should control the update process manually.
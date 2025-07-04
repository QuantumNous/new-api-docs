# 🐳 Docker Installation Guide

This document provides detailed steps for deploying New API using Docker.

## 📋 Basic Requirements

- Docker environment installed
- Recommended system: Linux (Ubuntu/CentOS/Debian, etc.)
- Port: Default is 3000

## 🚢 Deploy Directly Using Docker Image

### 💾 Using SQLite Database (Recommended for Beginners)

```shell
docker run --name new-api -d --restart always \
  -p 3000:3000 \
  -e TZ=Asia/Shanghai \
  -v /your/data/path:/data \
  calciumion/new-api:latest
```

!!! warning "Note"
    Please replace `/your/data/path` with your desired local data storage path.

### 🗄️ Using MySQL Database

```shell
docker run --name new-api -d --restart always \
  -p 3000:3000 \
  -e SQL_DSN="username:password@tcp(database-host:3306)/database-name" \
  -e TZ=Asia/Shanghai \
  -v /your/data/path:/data \
  calciumion/new-api:latest
```

!!! warning "Note"
    Please replace the database connection information in the parameters.

## 🌐 Accessing the System

After deployment, visit `http://server-IP:3000` to access the system.

Default admin username: `root`  
Default admin password: `123456`

!!! danger "Important"
    It is recommended to change the default password immediately after first login. 
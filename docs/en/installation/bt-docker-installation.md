# BT Panel Docker Installation Guide

This document provides a step-by-step tutorial with screenshots for deploying New API using BT Panel's Docker functionality.

## Prerequisites

- BT Panel version 9.2.0 or higher installed
- Recommended systems: CentOS 7+, Ubuntu 18.04+, Debian 10+
- Server configuration: At least 1 core, 2GB RAM

## Installing BT Panel

1. Visit the [BT Panel official website](https://www.bt.cn/new/download.html) to download the installation script suitable for your system
2. Run the installation script to install BT Panel
3. After installation, use the provided address, username, and password to log into BT Panel

## Installing Docker

1. After logging into BT Panel, find and click **Docker** in the left menu bar
2. On first entry, you'll be prompted to install Docker service, click **Install Now**
3. Follow the prompts to complete the Docker service installation

## Installing New API

### Method 1: Using BT App Store (Recommended)

1. In BT Panel's Docker functionality, click **App Store**
2. Search for and find **New-API**
3. Click **Install**
4. Configure the following basic options:
   - Container name: Customizable, default is `new-api`
   - Port mapping: Default is `3000:3000`
   - Environment variables: Add as needed (e.g., TZ=Asia/Shanghai, etc.)
   - Directory mapping: Ensure the `/data` directory is mapped to a host directory
5. Click **Submit** to complete installation

### Method 2: Using Custom Image

1. In BT Panel's Docker functionality, click **Image Management**
2. Click **Get Image** -> **Pull Image**
3. Enter image name: `calciumion/new-api:latest`
4. Click **Submit** and wait for the image to be pulled
5. After pulling is complete, go to **Container List** and click **Create Container**
6. Fill in the following information:
   - Container name: `new-api` (customizable)
   - Image: Select the recently pulled `calciumion/new-api:latest`
   - Port mapping: Add `3000:3000`
   - Directory mapping: Add `/your/host/path:/data` (replace with your host path)
   - Environment variables: Add as needed (e.g., TZ=Asia/Shanghai, etc.)
7. Click **Submit** to complete installation

## Configuration and Access

After installation, you can access New API at the following address:

```
http://server-IP:3000
```

On first access, you will be guided to the initialization page to create the admin account and password (only required on first installation). After initialization, log in with the credentials you created.

## Common Issues

### 1. Cannot Access New API Interface

- Check if port mapping is correct
- Confirm that port 3000 is allowed in server firewall
- Check if the container is running normally

### 2. Data Cannot Be Persisted

- Confirm that the `/data` directory is correctly mapped
- Check if the host directory permissions are correct 
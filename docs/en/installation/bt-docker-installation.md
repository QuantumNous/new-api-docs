# BT Panel Docker Installation Guide

This document provides a visual tutorial for deploying New API using the BT Panel Docker feature.

## Prerequisites

- Install BT Panel version 9.2.0 or higher
- Recommended OS: CentOS 7+, Ubuntu 18.04+, Debian 10+
- Server Configuration: At least 1 core and 2GB RAM

## Installing BT Panel

1. Go to the [BT Panel Official Website](https://www.bt.cn/new/download.html) to download the installation script suitable for your system
2. Run the installation script to install BT Panel
3. After installation, use the provided address, username, and password to log in to the BT Panel

## Installing Docker

1. After logging into the BT Panel, find and click **Docker** in the left sidebar menu
2. The first time you enter, you will be prompted to install the Docker service. Click **Install Now**
3. Follow the prompts to complete the installation of the Docker service

## Installing New API

### Method One: Using the BT App Store (Recommended)

1. In the BT Panel Docker feature, click **App Store**
2. Search for and find **New-API**
3. Click **Install**
4. Configure the following basic options:
   - Container Name: Customizable, default is `new-api`
   - Port Mapping: Default is `3000:3000`
   - Environment Variables: Add as needed (e.g., TZ=Asia/Shanghai, etc.)
   - Directory Mapping: Ensure that the `/data` directory is mapped to a host directory
5. Click **Submit** to complete the installation

### Method Two: Using a Custom Image

> It is highly recommended to install via the "App Store" for automatic configuration. This section is for advanced usage and is suitable for users who clearly understand Docker and BT container configuration.

??? warning "I confirm that I want to manually set up the image and will resolve any issues myself"
    Only after you check and agree to the above confirmation should you refer to the following steps to manually configure the custom image:

    1. In the BT Panel Docker feature, click **Image Management**
    2. Click **Get Image** -> **Pull Image**
    3. Enter the image name: `calciumion/new-api:latest`
    4. Click **Submit** and wait for the image pull to complete
    5. After the pull is complete, go to the **Container List** and click **Create Container**
    6. Fill in the following information:
       - Container Name: `new-api` (Customizable)
       - Image: Select the recently pulled `calciumion/new-api:latest`
       - Port Mapping: Add `3000:3000`
       - Directory Mapping: Add `/your/host/path:/data` (Replace with your host path)
       - Environment Variables: Add as needed (e.g., TZ=Asia/Shanghai, etc.)
    7. Click **Submit** to complete the installation

## Configuration and Access

After installation, you can access New API using the following address:

    http://Server IP:3000

The first visit will automatically guide you to the initialization page. Follow the on-screen instructions to set up the administrator account and password (required only for the first installation), and then log in using the set administrator account.

## Frequently Asked Questions

### 1. Unable to access the New API interface

- Check if the port mapping is correct
- Confirm whether the server firewall allows access to port 3000
- Check if the container is running normally

### 2. Data cannot be persisted

- Confirm whether the `/data` directory is mapped correctly
- Check if the host directory permissions are correct
# Cluster Deployment Guide

This document provides detailed configuration steps and best practices for New API cluster deployment, helping you build a high-availability, load-balanced distributed system.

## Prerequisites

- Multiple servers (at least two, master-slave architecture)
- Docker and Docker Compose installed
- Shared MySQL database (master and slave nodes need to access the same database)
- Shared Redis service (for data synchronization and caching between nodes)
- Optional: Load balancer (such as Nginx, HAProxy, or cloud provider's load balancing service)

## Cluster Architecture Overview

New API cluster adopts a master-slave architecture design:

1. **Master Node**: Responsible for handling all write operations and some read operations
2. **Slave Nodes**: Primarily responsible for handling read operations, improving overall system throughput

![Cluster Architecture](../assets/cluster-architecture.svg)

## Key Configuration for Cluster Deployment

The key to cluster deployment is that all nodes must:

1. **Share the same database**: All nodes access the same MySQL database
2. **Share the same Redis**: For caching and inter-node communication
3. **Use the same secrets**: `SESSION_SECRET` and `CRYPTO_SECRET` must be identical on all nodes
4. **Configure node types correctly**: Master node as `master`, slave nodes as `slave`

## Deployment Steps

### Step 1: Prepare Shared Database and Redis

First, you need to prepare shared MySQL database and Redis services. This can be:

- High-availability MySQL and Redis services deployed separately
- Managed database and cache services provided by cloud providers
- MySQL and Redis running on independent servers

For MySQL database, you can choose the following architecture solutions:

| Architecture Type | Component Composition | Working Method | Application Configuration Method |
|------------------|----------------------|----------------|----------------------------------|
| **Master-Slave Replication** | 1 master database<br>N slave databases | Master handles writes<br>Slaves handle reads<br>Automatic master-slave data sync | Configure master database address as `SQL_DSN` |
| **Database Cluster** | Multiple peer nodes<br>Proxy layer (ProxySQL/MySQL Router) | All nodes can read/write<br>Load balancing through proxy layer<br>Automatic failover | Configure proxy layer address as `SQL_DSN` |

!!! warning "Important Note"
    Regardless of which architecture you choose, the application's `SQL_DSN` configuration only needs one unified entry address.

Ensure these services can be accessed by all nodes and have sufficient performance and reliability.

### Step 2: Configure Master Node

Create a `docker-compose.yml` file on the master node server:

```yaml
services:
  new-api-master:
    image: calciumion/new-api:latest
    container_name: new-api-master
    restart: always
    ports:
      - "3000:3000"
    environment:
      - SQL_DSN=root:password@tcp(your-db-host:3306)/new-api
      - REDIS_CONN_STRING=redis://default:password@your-redis-host:6379
      - SESSION_SECRET=your_unique_session_secret
      - CRYPTO_SECRET=your_unique_crypto_secret
      - TZ=Asia/Shanghai
      # Optional configurations below
      - SYNC_FREQUENCY=60  # Sync frequency in seconds
      - FRONTEND_BASE_URL=https://your-domain.com  # Frontend base URL for email notifications and other functions
    volumes:
      - ./data:/data
      - ./logs:/app/logs
```

!!! warning "Security Tip"
    Please use strong passwords and randomly generated secret strings to replace the example values in the above configuration.

Start the master node:

```bash
docker compose up -d
```

### Step 3: Configure Slave Nodes

Create a `docker-compose.yml` file on each slave node server:

```yaml
services:
  new-api-slave:
    image: calciumion/new-api:latest
    container_name: new-api-slave
    restart: always
    ports:
      - "3000:3000"  # Can use the same port as master node since they're on different servers
    environment:
      - SQL_DSN=root:password@tcp(your-db-host:3306)/new-api  # Same as master node
      - REDIS_CONN_STRING=redis://default:password@your-redis-host:6379  # Same as master node
      - SESSION_SECRET=your_unique_session_secret  # Must be same as master node
      - CRYPTO_SECRET=your_unique_crypto_secret  # Must be same as master node
      - NODE_TYPE=slave  # Key configuration, specify as slave node
      - SYNC_FREQUENCY=60  # Sync frequency between slave and master nodes, in seconds
      - TZ=Asia/Shanghai
      # Optional configurations below
      - FRONTEND_BASE_URL=https://your-domain.com  # Must be same as master node
    volumes:
      - ./data:/data
      - ./logs:/app/logs
```

Start the slave node:

```bash
docker compose up -d
```

Repeat this step for each slave node server.

### Step 4: Configure Load Balancing

To achieve balanced traffic distribution, you need to set up a load balancer. Here's an example configuration using Nginx as the load balancer:

```nginx
upstream new_api_cluster {
    server master-node-ip:3000 weight=3;
    server slave-node1-ip:3000 weight=5;
    server slave-node2-ip:3000 weight=5;
    # Can add more slave nodes
}

server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://new_api_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

This configuration sets the master node weight to 3 and slave node weights to 5, meaning slave nodes will handle more requests. You can adjust these weights based on your actual needs.

## Advanced Configuration Options

### Data Synchronization Settings

Data synchronization between cluster nodes depends on the following environment variables:

| Environment Variable | Description | Recommended Value |
|---------------------|-------------|-------------------|
| `SYNC_FREQUENCY` | Node sync frequency (seconds) | `60` |
| `BATCH_UPDATE_ENABLED` | Enable batch updates | `true` |
| `BATCH_UPDATE_INTERVAL` | Batch update interval (seconds) | `5` |

### Redis High Availability Configuration

To improve Redis availability, you can configure Redis cluster or sentinel mode:

```yaml
environment:
  - REDIS_CONN_STRING=redis://your-redis-host:6379
  - REDIS_PASSWORD=your_redis_password
  - REDIS_MASTER_NAME=mymaster  # Master node name in sentinel mode
  - REDIS_CONN_POOL_SIZE=10     # Redis connection pool size
```

### Session Security Configuration

Ensure all nodes in the cluster use the same session and encryption secrets:

```yaml
environment:
  - SESSION_SECRET=your_unique_session_secret  # Must be same on all nodes
  - CRYPTO_SECRET=your_unique_crypto_secret    # Must be same on all nodes
```

## Monitoring and Maintenance

### Health Checks

Configure regular health checks to monitor node status:

```yaml
healthcheck:
  test: ["CMD-SHELL", "wget -q -O - http://localhost:3000/api/status | grep -o '\"success\":\\s*true' | awk -F: '{print $$2}'"]
  interval: 30s
  timeout: 10s
  retries: 3
```

### Log Management

For large-scale clusters, it's recommended to use centralized log management:

```yaml
environment:
  - LOG_SQL_DSN=root:password@tcp(log-db-host:3306)/new_api_logs  # Independent log database
```

## Scaling Guide

As your business grows, you may need to expand the cluster scale. Scaling steps are as follows:

1. **Prepare new servers**: Install Docker and Docker Compose
2. **Configure slave nodes**: Configure new slave nodes according to "Step 3: Configure Slave Nodes"
3. **Update load balancer configuration**: Add new nodes to the load balancer configuration
4. **Test new nodes**: Ensure new nodes work properly and participate in load balancing

## Best Practices

1. **Regular database backups**: Even in cluster environments, regularly backup the database
2. **Monitor resource usage**: Closely monitor CPU, memory, and disk usage
3. **Adopt rolling update strategy**: When updating, update slave nodes first, confirm stability before updating master node
4. **Configure alert system**: Monitor node status and notify administrators promptly when issues occur
5. **Geographic distribution deployment**: If possible, deploy nodes in different geographic locations to improve availability

## Troubleshooting

### Nodes Cannot Sync Data

- Check if Redis connection is normal
- Confirm that SESSION_SECRET and CRYPTO_SECRET are identical on all nodes
- Verify database connection configuration is correct

### Load Imbalance

- Check load balancer configuration and weight settings
- Monitor resource usage of each node to ensure no node is overloaded
- May need to adjust node weights or add more nodes

### Session Loss Issues

- Ensure all nodes use the same SESSION_SECRET
- Verify Redis configuration is correct and accessible
- Check if clients handle cookies correctly

## Related Documentation

- [Environment Variables Configuration Guide](environment-variables.md) - Contains all relevant environment variables for multi-node deployment
- [System Update Guide](system-update.md) - System update strategy in multi-node environment
- [Docker Compose Configuration Guide](docker-compose-yml.md) - For writing cluster node configuration files 
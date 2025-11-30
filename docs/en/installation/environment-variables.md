# Environment Variable Configuration Guide

This document provides all environment variables supported by New API and their configuration instructions. You can customize system behavior by setting these environment variables.

!!! tip "Tip"
    New API supports reading environment variables from the `.env` file. Please refer to the `.env.example` file and rename it to `.env` for use.

## Basic Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `PORT` | Service listening port | `3000` | `PORT=8080` |
| `TZ` | Time zone setting | - | `TZ=America/New_York` |
| `VERSION` | Override running version number | - | `VERSION=1.2.3` |

## Database Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `SQL_DSN` | Database connection string | SQLite (data/one-api.db) | MySQL: `SQL_DSN=root:123456@tcp(localhost:3306)/new-api` \| PostgreSQL: `SQL_DSN=postgresql://root:123456@postgres:5432/new-api` |
| `SQL_MAX_IDLE_CONNS` | Maximum number of idle connections in the connection pool | `100` | `SQL_MAX_IDLE_CONNS=50` |
| `SQL_MAX_OPEN_CONNS` | Maximum number of open connections in the connection pool | `1000` | `SQL_MAX_OPEN_CONNS=500` |
| `SQL_MAX_LIFETIME` | Maximum connection lifetime (minutes) | `60` | `SQL_MAX_LIFETIME=120` |
| `LOG_SQL_DSN` | Separate database connection string for log tables | - | `LOG_SQL_DSN=root:123456@tcp(localhost:3306)/oneapi_logs` |
| `SQLITE_PATH` | SQLite database path | `/path/to/sqlite.db` | `SQLITE_PATH=/var/lib/new-api/new-api.db` |

## Cache Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `REDIS_CONN_STRING` | Redis connection string | - | `REDIS_CONN_STRING=redis://default:redispw@localhost:6379` |
| `REDIS_POOL_SIZE` | Redis connection pool size | `10` | `REDIS_POOL_SIZE=20` |
| `MEMORY_CACHE_ENABLED` | Whether to enable memory cache | `false` | `MEMORY_CACHE_ENABLED=true` |
| `BATCH_UPDATE_ENABLED` | Enable database batch update aggregation | `false` | `BATCH_UPDATE_ENABLED=true` |
| `BATCH_UPDATE_INTERVAL` | Batch update aggregation interval (seconds) | `5` | `BATCH_UPDATE_INTERVAL=10` |

## Multi-Node and Security Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `SESSION_SECRET` | Session secret (required for multi-machine deployment) | - | `SESSION_SECRET=random_string` |
| `CRYPTO_SECRET` | Encryption secret (for encrypting database content) | - | `CRYPTO_SECRET=your_crypto_secret` |
| `FRONTEND_BASE_URL` | Frontend base URL | - | `FRONTEND_BASE_URL=https://your-domain.com` |
| `SYNC_FREQUENCY` | Cache and database synchronization frequency (seconds) | `60` | `SYNC_FREQUENCY=60` |
| `NODE_TYPE` | Node type | `master` | `NODE_TYPE=slave` |

!!! info "Cluster Deployment"
    For instructions on how to use these environment variables to build a complete cluster deployment, please refer to the [Cluster Deployment Guide](cluster-deployment.md).

## User and Token Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `GENERATE_DEFAULT_TOKEN` | Generate initial Token for new registered users | `false` | `GENERATE_DEFAULT_TOKEN=true` |
| `NOTIFICATION_LIMIT_DURATION_MINUTE` | Notification limit duration (minutes) | `10` | `NOTIFICATION_LIMIT_DURATION_MINUTE=15` |
| `NOTIFY_LIMIT_COUNT` | Maximum number of notifications within the specified duration | `2` | `NOTIFY_LIMIT_COUNT=3` |

## Request Limit Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `GLOBAL_API_RATE_LIMIT` | Global API rate limit (per IP, three minutes) | `180` | `GLOBAL_API_RATE_LIMIT=100` |
| `GLOBAL_WEB_RATE_LIMIT` | Global Web rate limit (per IP, three minutes) | `60` | `GLOBAL_WEB_RATE_LIMIT=30` |
| `RELAY_TIMEOUT` | Relay request timeout (seconds) | `0` | `RELAY_TIMEOUT=60` |
| `STREAMING_TIMEOUT` | Streaming single response timeout (seconds) | `300` | `STREAMING_TIMEOUT=120` |
| `MAX_FILE_DOWNLOAD_MB` | Maximum file download size (MB) | `20` | `MAX_FILE_DOWNLOAD_MB=50` |
| `GLOBAL_API_RATE_LIMIT_ENABLE` | Global API rate limit switch | `true` | `GLOBAL_API_RATE_LIMIT_ENABLE=false` |
| `GLOBAL_API_RATE_LIMIT_DURATION` | Global API rate limit window (seconds) | `180` | `GLOBAL_API_RATE_LIMIT_DURATION=120` |
| `GLOBAL_WEB_RATE_LIMIT_ENABLE` | Global Web rate limit switch | `true` | `GLOBAL_WEB_RATE_LIMIT_ENABLE=false` |
| `GLOBAL_WEB_RATE_LIMIT_DURATION` | Global Web rate limit window (seconds) | `180` | `GLOBAL_WEB_RATE_LIMIT_DURATION=120` |
| `CRITICAL_RATE_LIMIT_ENABLE` | Critical operation rate limit switch | `true` | `CRITICAL_RATE_LIMIT_ENABLE=false` |
| `CRITICAL_RATE_LIMIT` | Critical operation rate limit count | `20` | `CRITICAL_RATE_LIMIT=10` |
| `CRITICAL_RATE_LIMIT_DURATION` | Critical operation rate limit window (seconds) | `1200` | `CRITICAL_RATE_LIMIT_DURATION=600` |

!!! warning "RELAY_TIMEOUT Setting Warning"
    Exercise caution when setting the `RELAY_TIMEOUT` environment variable. Setting it too short may lead to the following issues:

    - The upstream API completes the request and charges, but the local system fails to complete billing due to timeout.

    - Causes billing desynchronization, potentially leading to system losses.

    - It is recommended not to set it unless you know what you are doing.

## Channel Management Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `CHANNEL_UPDATE_FREQUENCY` | Periodically update Channel balance (minutes) | - | `CHANNEL_UPDATE_FREQUENCY=1440` |
| `CHANNEL_TEST_FREQUENCY` | Periodically check Channels (minutes) | - | `CHANNEL_TEST_FREQUENCY=1440` |
| `POLLING_INTERVAL` | Request interval when batch updating Channels (seconds) | `0` | `POLLING_INTERVAL=5` |

## Model and Request Processing Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `FORCE_STREAM_OPTION` | Override client stream_options parameter | `true` | `FORCE_STREAM_OPTION=false` |
| `GET_MEDIA_TOKEN` | Whether to count image tokens | `true` | `GET_MEDIA_TOKEN=false` |
| `GET_MEDIA_TOKEN_NOT_STREAM` | Whether to count image tokens in non-streaming mode | `false` | `GET_MEDIA_TOKEN_NOT_STREAM=false` |
| `UPDATE_TASK` | Whether to update asynchronous tasks (MJ, Suno) | `true` | `UPDATE_TASK=false` |
| `CountToken` | Whether to count text tokens | `true` | `CountToken=false` |
| `TASK_PRICE_PATCH` | Task price patch (comma separated) | `""` | `TASK_PRICE_PATCH=suno=0.8,mj=1.2` |

## Specific Model Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `AZURE_DEFAULT_API_VERSION` | Azure Channel default API version | `2025-04-01-preview` | `AZURE_DEFAULT_API_VERSION=2023-05-15` |
| `COHERE_SAFETY_SETTING` | Cohere model safety setting | `NONE` | `COHERE_SAFETY_SETTING=CONTEXTUAL` |
| `GEMINI_VISION_MAX_IMAGE_NUM` | Gemini model maximum image count | `16` | `GEMINI_VISION_MAX_IMAGE_NUM=8` |
| `DIFY_DEBUG` | Dify Channel output workflow and node information | `true` | `DIFY_DEBUG=false` |

## Other Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `ERROR_LOG_ENABLED` | Whether to record and display error logs on the frontend | false | `ERROR_LOG_ENABLED=true` |

## Analytics and Statistics

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `UMAMI_WEBSITE_ID` | Umami Website ID | - | `UMAMI_WEBSITE_ID=xxxx-xxxx` |
| `UMAMI_SCRIPT_URL` | Umami Script URL | `https://analytics.umami.is/script.js` | `UMAMI_SCRIPT_URL=https://umami.example.com/script.js` |
| `GOOGLE_ANALYTICS_ID` | Google Analytics Site ID | - | `GOOGLE_ANALYTICS_ID=G-XXXXXXX` |

## Metadata Synchronization

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `SYNC_UPSTREAM_BASE` | Model/Vendor metadata upstream address | `https://basellm.github.io/llm-metadata` | `SYNC_UPSTREAM_BASE=https://mirror.example.com/llm-metadata` |
| `SYNC_HTTP_TIMEOUT_SECONDS` | Sync HTTP timeout (seconds) | `10` | `SYNC_HTTP_TIMEOUT_SECONDS=15` |
| `SYNC_HTTP_RETRY` | Sync retry count | `3` | `SYNC_HTTP_RETRY=5` |
| `SYNC_HTTP_MAX_MB` | Maximum response body size (MB) | `10` | `SYNC_HTTP_MAX_MB=20` |

## Frontend Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `VITE_REACT_APP_SERVER_URL` | Frontend base address for backend requests | - | `VITE_REACT_APP_SERVER_URL=https://api.example.com` |

## Deprecated Environment Variables

The following environment variables have been deprecated. Please use the corresponding options in the System Settings interface:

| Environment Variable | Alternative Method |
|---------|--------|
| `GEMINI_MODEL_MAP` | Please set in System Settings - Model Related Settings |
| `GEMINI_SAFETY_SETTING` | Please set in System Settings - Model Related Settings |

## Multi-Machine Deployment Example

In multi-machine deployment scenarios, the following environment variables must be set:

### Master Node Configuration

```env
# Database Configuration - Use remote database
SQL_DSN=root:password@tcp(db-server:3306)/oneapi

# Security Configuration
SESSION_SECRET=your_unique_session_secret
CRYPTO_SECRET=your_unique_crypto_secret

# Redis Cache Configuration
REDIS_CONN_STRING=redis://default:password@redis-server:6379
```

### Slave Node Configuration

```env
# Database Configuration - Use the same remote database
SQL_DSN=root:password@tcp(db-server:3306)/oneapi

# Security Configuration - Use the same secrets as the master node
SESSION_SECRET=your_unique_session_secret
CRYPTO_SECRET=your_unique_crypto_secret

# Redis Cache Configuration - Use the same Redis as the master node
REDIS_CONN_STRING=redis://default:password@redis-server:6379

# Node Type Setting
NODE_TYPE=slave

# Optional: Frontend Base URL
FRONTEND_BASE_URL=https://your-domain.com

# Optional: Sync Frequency
SYNC_FREQUENCY=60
```

!!! tip "Complete Cluster Configuration"
    This is just a basic multi-node configuration example. For complete cluster deployment configuration, architectural description, and best practices, please refer to the [Cluster Deployment Guide](cluster-deployment.md).

## Docker Compose Environment Variable Example

Below is a brief example of setting environment variables in a Docker Compose configuration file:

```yaml
services:
  new-api:
    image: calciumion/new-api:latest
    environment:
      - TZ=Asia/Shanghai
      - SQL_DSN=root:123456@tcp(mysql:3306)/oneapi
      - REDIS_CONN_STRING=redis://default:redispw@redis:6379
      - SESSION_SECRET=your_unique_session_secret
      - CRYPTO_SECRET=your_unique_crypto_secret
      - MEMORY_CACHE_ENABLED=true
      - GENERATE_DEFAULT_TOKEN=true
      - STREAMING_TIMEOUT=120
      - CHANNEL_UPDATE_FREQUENCY=1440
```

For the complete Docker Compose configuration, including more environment variable setting options, please refer to the [Docker Compose Configuration Instructions](docker-compose-yml.md) document.

## LinuxDo Related

No modification is required under normal circumstances

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `LINUX_DO_TOKEN_ENDPOINT` | LinuxDo Token Endpoint | `https://connect.linux.do/oauth2/token` | `LINUX_DO_TOKEN_ENDPOINT=https://connect.linux.do/oauth2/token` |
| `LINUX_DO_USER_ENDPOINT` | LinuxDo User Endpoint | `https://connect.linux.do/api/user` | `LINUX_DO_USER_ENDPOINT=https://connect.linux.do/api/user` |   

## Debugging Related

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `ENABLE_PPROF` | Enable pprof performance analysis | `false` | `ENABLE_PPROF=true` |
| `DEBUG` | Enable debug mode | `false` | `DEBUG=true` | 
| `GIN_MODE` | Gin running mode | - | `GIN_MODE=release` |
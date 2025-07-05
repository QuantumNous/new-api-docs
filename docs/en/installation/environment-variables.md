# 🔧 Environment Variables Configuration Guide

This document provides all environment variables supported by New API and their configuration instructions. You can customize the system behavior by setting these environment variables.

!!! tip "Tip"
    New API supports reading environment variables from a `.env` file. Please refer to the `.env.example` file and rename it to `.env` when using.

## 🔄 Basic Configuration

| Environment Variable | Description | Default | Example |
|---------------------|-------------|---------|---------|
| `PORT` | Service listening port | `3000` | `PORT=8080` |
| `TZ` | Timezone setting | `Asia/Shanghai` | `TZ=America/New_York` |

## 💾 Database Configuration

| Environment Variable | Description | Default | Example |
|---------------------|-------------|---------|---------|
| `SQL_DSN` | Database connection string | SQLite (data/one-api.db) | `SQL_DSN=root:123456@tcp(localhost:3306)/oneapi` |
| `SQL_MAX_IDLE_CONNS` | Max idle connections in pool | `100` | `SQL_MAX_IDLE_CONNS=50` |
| `SQL_MAX_OPEN_CONNS` | Max open connections in pool | `1000` | `SQL_MAX_OPEN_CONNS=500` |
| `SQL_CONN_MAX_LIFETIME` | Max connection lifetime (minutes) | `60` | `SQL_CONN_MAX_LIFETIME=120` |
| `LOG_SQL_DSN` | Separate database connection string for logs | - | `LOG_SQL_DSN=root:123456@tcp(localhost:3306)/oneapi_logs` |
| `SQLITE_BUSY_TIMEOUT` | SQLite lock wait timeout (ms) | `3000` | `SQLITE_BUSY_TIMEOUT=5000` |

## 📦 Cache Configuration

| Environment Variable | Description | Default | Example |
|---------------------|-------------|---------|---------|
| `REDIS_CONN_STRING` | Redis connection string | - | `REDIS_CONN_STRING=redis://default:redispw@localhost:6379` |
| `MEMORY_CACHE_ENABLED` | Enable in-memory cache | `false` | `MEMORY_CACHE_ENABLED=true` |
| `REDIS_CONN_POOL_SIZE` | Redis connection pool size | - | `REDIS_CONN_POOL_SIZE=10` |
| `REDIS_PASSWORD` | Redis cluster or sentinel mode password | - | `REDIS_PASSWORD=your_password` |
| `REDIS_MASTER_NAME` | Redis sentinel mode master name | - | `REDIS_MASTER_NAME=mymaster` |
| `BATCH_UPDATE_ENABLED` | Enable database batch update aggregation | `false` | `BATCH_UPDATE_ENABLED=true` |
| `BATCH_UPDATE_INTERVAL` | Batch update aggregation interval (seconds) | `5` | `BATCH_UPDATE_INTERVAL=10` |

## 🌐 Multi-Node & Security Configuration

| Environment Variable | Description | Default | Example |
|---------------------|-------------|---------|---------|
| `SESSION_SECRET` | Session secret (required for multi-node deployment) | - | `SESSION_SECRET=random_string` |
| `CRYPTO_SECRET` | Encryption secret (for encrypting database content) | - | `CRYPTO_SECRET=your_crypto_secret` |
| `FRONTEND_BASE_URL` | Frontend base URL | - | `FRONTEND_BASE_URL=https://your-domain.com` |
| `SYNC_FREQUENCY` | Cache and database sync frequency (seconds) | `600` | `SYNC_FREQUENCY=60` |
| `NODE_TYPE` | Node type | `master` | `NODE_TYPE=slave` |
| `INITIAL_ROOT_TOKEN` | Root user token created on first startup | - | `INITIAL_ROOT_TOKEN=your_token` |
| `INITIAL_ROOT_ACCESS_TOKEN` | System admin token created on first startup | - | `INITIAL_ROOT_ACCESS_TOKEN=your_token` |

!!! info "Cluster Deployment"
    For how to use these environment variables to build a complete cluster deployment, please refer to the [Cluster Deployment Guide](cluster-deployment.md).

## 👤 User & Token Configuration

| Environment Variable | Description | Default | Example |
|---------------------|-------------|---------|---------|
| `DEFAULT_QUOTA` | Default quota for new users | `0` | `DEFAULT_QUOTA=10` |
| `GLOBAL_USER_QUOTA` | Global user quota limit | - | `GLOBAL_USER_QUOTA=100` |
| `GENERATE_DEFAULT_TOKEN` | Generate initial token for new registered users | `false` | `GENERATE_DEFAULT_TOKEN=true` |
| `NOTIFICATION_LIMIT_DURATION_MINUTE` | Notification limit duration (minutes) | `10` | `NOTIFICATION_LIMIT_DURATION_MINUTE=15` |
| `NOTIFY_LIMIT_COUNT` | Max notifications in specified duration | `2` | `NOTIFY_LIMIT_COUNT=3` |

## 🚦 Request Limiting Configuration

| Environment Variable | Description | Default | Example |
|---------------------|-------------|---------|---------|
| `GLOBAL_API_RATE_LIMIT` | Global API rate limit (per IP, 3 minutes) | `180` | `GLOBAL_API_RATE_LIMIT=100` |
| `GLOBAL_WEB_RATE_LIMIT` | Global Web rate limit (per IP, 3 minutes) | `60` | `GLOBAL_WEB_RATE_LIMIT=30` |
| `RELAY_TIMEOUT` | Relay request timeout (seconds) | - | `RELAY_TIMEOUT=60` |
| `USER_CONTENT_REQUEST_TIMEOUT` | User content download timeout (seconds) | - | `USER_CONTENT_REQUEST_TIMEOUT=30` |
| `STREAMING_TIMEOUT` | Streaming single reply timeout (seconds) | `60` | `STREAMING_TIMEOUT=120` |
| `MAX_FILE_DOWNLOAD_MB` | Max file download size (MB) | `20` | `MAX_FILE_DOWNLOAD_MB=50` |

!!! warning "RELAY_TIMEOUT Setting Warning"
    Be cautious when setting the `RELAY_TIMEOUT` environment variable. If set too short, it may cause the following issues:

    - The upstream API has completed the request and billed, but the local system did not complete billing due to timeout
    - Causes billing desynchronization, which may lead to system loss
    - It is recommended not to set unless you know what you are doing

## 📡 Channel Management Configuration

| Environment Variable | Description | Default | Example |
|---------------------|-------------|---------|---------|
| `CHANNEL_UPDATE_FREQUENCY` | Periodically update channel balance (minutes) | - | `CHANNEL_UPDATE_FREQUENCY=1440` |
| `CHANNEL_TEST_FREQUENCY` | Periodically check channels (minutes) | - | `CHANNEL_TEST_FREQUENCY=1440` |
| `POLLING_INTERVAL` | Request interval when batch updating channels (seconds) | `0` | `POLLING_INTERVAL=5` |
| `ENABLE_METRIC` | Disable channels based on request success rate | `false` | `ENABLE_METRIC=true` |
| `METRIC_QUEUE_SIZE` | Request success rate statistics queue size | `10` | `METRIC_QUEUE_SIZE=20` |
| `METRIC_SUCCESS_RATE_THRESHOLD` | Request success rate threshold | `0.8` | `METRIC_SUCCESS_RATE_THRESHOLD=0.7` |
| `TEST_PROMPT` | User prompt for model testing | `Print your model name exactly...` | `TEST_PROMPT=Hello` |

<!-- ## 🔄 Proxy Configuration

| Environment Variable | Description | Default | Example |
|---------------------|-------------|---------|---------|
| `RELAY_PROXY` | Proxy for relay requests | - | `RELAY_PROXY=http://127.0.0.1:7890` |
| `USER_CONTENT_REQUEST_PROXY` | Proxy for user content requests | - | `USER_CONTENT_REQUEST_PROXY=http://127.0.0.1:7890` | -->

## 🤖 Model & Request Handling Configuration

| Environment Variable | Description | Default | Example |
|---------------------|-------------|---------|---------|
| `FORCE_STREAM_OPTION` | Override client stream_options parameter | `true` | `FORCE_STREAM_OPTION=false` |
| `GET_MEDIA_TOKEN` | Count image tokens | `true` | `GET_MEDIA_TOKEN=false` |
| `GET_MEDIA_TOKEN_NOT_STREAM` | Count image tokens in non-stream mode | `true` | `GET_MEDIA_TOKEN_NOT_STREAM=false` |
| `UPDATE_TASK` | Update async tasks (MJ, Suno) | `true` | `UPDATE_TASK=false` |
| `ENFORCE_INCLUDE_USAGE` | Force return usage in stream mode | `false` | `ENFORCE_INCLUDE_USAGE=true` |
| `TIKTOKEN_CACHE_DIR` | Tiktoken encoder cache directory, for storing tokenizer files to avoid network download | - | `TIKTOKEN_CACHE_DIR=/cache/tiktoken` |
| `DATA_GYM_CACHE_DIR` | DataGym cache directory | - | `DATA_GYM_CACHE_DIR=/cache/data_gym` |

!!! tip "Tiktoken File Configuration"
    After downloading tiktoken files, please rename them as follows:

    - `cl100k_base.tiktoken` rename to `9b5ad71b2ce5302211f9c61530b329a4922fc6a4`
    - `o200k_base.tiktoken` rename to `fb374d419588a4632f3f557e76b4b70aebbca790`

    These files should be placed in the directory specified by `TIKTOKEN_CACHE_DIR` to improve token calculation performance and reduce network dependency.

!!! example "Tiktoken Configuration Example"
    ```bash
    # Docker environment example
    TIKTOKEN_CACHE_DIR=/app/data/tiktoken
    
    # Then download and rename tiktoken files into this directory:
    /app/data/tiktoken/9b5ad71b2ce5302211f9c61530b329a4922fc6a4
    /app/data/tiktoken/fb374d419588a4632f3f557e76b4b70aebbca790
    ```
    
    Tiktoken is the tokenizer used by OpenAI to calculate the number of tokens in text. By caching these files locally, you can avoid downloading from the network every time the system starts, improving stability and performance, especially in network-restricted environments.

## 🔎 Specific Model Configuration

| Environment Variable | Description | Default | Example |
|---------------------|-------------|---------|---------|
| `AZURE_DEFAULT_API_VERSION` | Default API version for Azure channel | `2024-12-01-preview` | `AZURE_DEFAULT_API_VERSION=2023-05-15` |
| `COHERE_SAFETY_SETTING` | Cohere model safety setting | `NONE` | `COHERE_SAFETY_SETTING=CONTEXTUAL` |
| `GEMINI_VISION_MAX_IMAGE_NUM` | Gemini model max image number | `16` | `GEMINI_VISION_MAX_IMAGE_NUM=8` |
| `GEMINI_VERSION` | Gemini version | `v1` | `GEMINI_VERSION=v1beta` |
| `DIFY_DEBUG` | Output workflow and node info for Dify channel | `true` | `DIFY_DEBUG=false` |

## 📨 Other Configuration

| Environment Variable | Description | Default | Example |
|---------------------|-------------|---------|---------|
| `EMAIL_SERVER` | Email server configuration | - | `EMAIL_SERVER=smtp.example.com:25` |
| `EMAIL_FROM` | Email sender address | - | `EMAIL_FROM=noreply@example.com` |
| `EMAIL_PASSWORD` | Email server password | - | `EMAIL_PASSWORD=yourpassword` |
| `ERROR_LOG_ENABLE` | Record and display error logs on frontend | false | `ERROR_LOG_ENABLED=true` |

## ⚠️ Deprecated Environment Variables

The following environment variables are deprecated. Please use the corresponding options in the system settings interface:

| Environment Variable | Replacement |
|---------------------|-------------|
| `GEMINI_MODEL_MAP` | Please set in System Settings - Model Related Settings |
| `GEMINI_SAFETY_SETTING` | Please set in System Settings - Model Related Settings |

## 🌍 Multi-Node Deployment Example

In multi-node deployment scenarios, you must set the following environment variables:

### 👑 Master Node Configuration

```env
# Database configuration - use remote database
SQL_DSN=root:password@tcp(db-server:3306)/oneapi

# Security configuration
SESSION_SECRET=your_unique_session_secret
CRYPTO_SECRET=your_unique_crypto_secret

# Redis cache configuration
REDIS_CONN_STRING=redis://default:password@redis-server:6379
```

### 👥 Slave Node Configuration

```env
# Database configuration - use the same remote database
SQL_DSN=root:password@tcp(db-server:3306)/oneapi

# Security configuration - use the same secrets as master node
SESSION_SECRET=your_unique_session_secret
CRYPTO_SECRET=your_unique_crypto_secret

# Redis cache configuration - use the same Redis as master node
REDIS_CONN_STRING=redis://default:password@redis-server:6379

# Node type setting
NODE_TYPE=slave

# Optional: Frontend base URL
FRONTEND_BASE_URL=https://your-domain.com

# Optional: Sync frequency
SYNC_FREQUENCY=60
```

!!! tip "Full Cluster Configuration"
    This is just a basic multi-node configuration example. For full cluster deployment configuration, architecture explanation, and best practices, please refer to the [Cluster Deployment Guide](cluster-deployment.md).

## 🐳 Environment Variables Example in Docker Compose

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

For a complete Docker Compose configuration, including more environment variable options, please refer to the [Docker Compose Configuration Guide](docker-compose-yml.md) document. 
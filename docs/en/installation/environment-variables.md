# Environment Variable Configuration Guide

This document provides all environment variables supported by New API and their configuration instructions. You can customize the system's behavior by setting these environment variables.

!!! tip "Tip"
    New API supports reading environment variables from the `.env` file. Please refer to the `.env.example` file and rename it to `.env` for use.

## Basic Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `PORT` | Service listening port | `3000` | `PORT=8080` |
| `TZ` | Time zone setting | `Asia/Shanghai` | `TZ=America/New_York` |

## Database Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `SQL_DSN` | Database connection string | SQLite (data/one-api.db) | MySQL: `SQL_DSN=root:123456@tcp(localhost:3306)/new-api` \| PostgreSQL: `SQL_DSN=postgresql://root:123456@postgres:5432/new-api` |
| `SQL_MAX_IDLE_CONNS` | Maximum number of idle connections in the connection pool | `100` | `SQL_MAX_IDLE_CONNS=50` |
| `SQL_MAX_OPEN_CONNS` | Maximum number of open connections in the connection pool | `1000` | `SQL_MAX_OPEN_CONNS=500` |
| `SQL_CONN_MAX_LIFETIME` | Maximum connection lifetime (minutes) | `60` | `SQL_CONN_MAX_LIFETIME=120` |
| `LOG_SQL_DSN` | Separate database connection string for the log table | - | `LOG_SQL_DSN=root:123456@tcp(localhost:3306)/oneapi_logs` |
| `SQLITE_BUSY_TIMEOUT` | SQLite lock wait timeout (milliseconds) | `3000` | `SQLITE_BUSY_TIMEOUT=5000` |

## Cache Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `REDIS_CONN_STRING` | Redis connection string | - | `REDIS_CONN_STRING=redis://default:redispw@localhost:6379` |
| `MEMORY_CACHE_ENABLED` | Whether to enable memory cache | `false` | `MEMORY_CACHE_ENABLED=true` |
| `REDIS_CONN_POOL_SIZE` | Redis connection pool size | - | `REDIS_CONN_POOL_SIZE=10` |
| `REDIS_PASSWORD` | Password for Redis cluster or sentinel mode | - | `REDIS_PASSWORD=your_password` |
| `REDIS_MASTER_NAME` | Redis sentinel mode master name | - | `REDIS_MASTER_NAME=mymaster` |
| `BATCH_UPDATE_ENABLED` | Enable database batch update aggregation | `false` | `BATCH_UPDATE_ENABLED=true` |
| `BATCH_UPDATE_INTERVAL` | Batch update aggregation interval (seconds) | `5` | `BATCH_UPDATE_INTERVAL=10` |

## Multi-Node and Security Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `SESSION_SECRET` | Session secret (required for multi-machine deployment) | - | `SESSION_SECRET=random_string` |
| `CRYPTO_SECRET` | Encryption key (encrypts database content) | - | `CRYPTO_SECRET=your_crypto_secret` |
| `FRONTEND_BASE_URL` | Frontend base URL | - | `FRONTEND_BASE_URL=https://your-domain.com` |
| `SYNC_FREQUENCY` | Cache and database synchronization frequency (seconds) | `600` | `SYNC_FREQUENCY=60` |
| `NODE_TYPE` | Node type | `master` | `NODE_TYPE=slave` |
| `INITIAL_ROOT_TOKEN` | Root user token created on first startup | - | `INITIAL_ROOT_TOKEN=your_token` |
| `INITIAL_ROOT_ACCESS_TOKEN` | System management token created on first startup | - | `INITIAL_ROOT_ACCESS_TOKEN=your_token` |

!!! info "Cluster Deployment"
    For information on how to use these environment variables to build a complete cluster deployment, please refer to the [Cluster Deployment Guide](cluster-deployment.md).

## User and Token Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `DEFAULT_QUOTA` | Default quota for new users | `0` | `DEFAULT_QUOTA=10` |
| `GLOBAL_USER_QUOTA` | Global user quota limit | - | `GLOBAL_USER_QUOTA=100` |
| `GENERATE_DEFAULT_TOKEN` | Generate initial token for new registered users | `false` | `GENERATE_DEFAULT_TOKEN=true` |
| `NOTIFICATION_LIMIT_DURATION_MINUTE` | Duration of notification limit (minutes) | `10` | `NOTIFICATION_LIMIT_DURATION_MINUTE=15` |
| `NOTIFY_LIMIT_COUNT` | Maximum number of notifications within the specified duration | `2` | `NOTIFY_LIMIT_COUNT=3` |

## Request Limit Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `GLOBAL_API_RATE_LIMIT` | Global API rate limit (per IP, three minutes) | `180` | `GLOBAL_API_RATE_LIMIT=100` |
| `GLOBAL_WEB_RATE_LIMIT` | Global Web rate limit (per IP, three minutes) | `60` | `GLOBAL_WEB_RATE_LIMIT=30` |
| `RELAY_TIMEOUT` | Relay request timeout (seconds) | - | `RELAY_TIMEOUT=60` |
| `USER_CONTENT_REQUEST_TIMEOUT` | User content download timeout (seconds) | - | `USER_CONTENT_REQUEST_TIMEOUT=30` |
| `STREAMING_TIMEOUT` | Streaming single response timeout (seconds) | `60` | `STREAMING_TIMEOUT=120` |
| `MAX_FILE_DOWNLOAD_MB` | Maximum file download size (MB) | `20` | `MAX_FILE_DOWNLOAD_MB=50` |

!!! warning "RELAY_TIMEOUT Setting Warning"
    Please exercise caution when setting the `RELAY_TIMEOUT` environment variable. Setting it too short may lead to the following issues:

    - The upstream API has completed the request and charged, but local billing failed due to timeout

    - Causing billing synchronization issues, which may lead to system losses
    
    - It is recommended not to set this, unless you know what you are doing

## Channel Management Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `CHANNEL_UPDATE_FREQUENCY` | Periodically update channel balance (minutes) | - | `CHANNEL_UPDATE_FREQUENCY=1440` |
| `CHANNEL_TEST_FREQUENCY` | Periodically check channels (minutes) | - | `CHANNEL_TEST_FREQUENCY=1440` |
| `POLLING_INTERVAL` | Request interval during batch channel updates (seconds) | `0` | `POLLING_INTERVAL=5` |
| `ENABLE_METRIC` | Whether to disable channels based on request success rate | `false` | `ENABLE_METRIC=true` |
| `METRIC_QUEUE_SIZE` | Request success rate statistics queue size | `10` | `METRIC_QUEUE_SIZE=20` |
| `METRIC_SUCCESS_RATE_THRESHOLD` | Request success rate threshold | `0.8` | `METRIC_SUCCESS_RATE_THRESHOLD=0.7` |
| `TEST_PROMPT` | User prompt when testing models | `Print your model name exactly...` | `TEST_PROMPT=Hello` |

<!-- ## 🔄 代理配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `RELAY_PROXY` | 中继请求使用的代理 | - | `RELAY_PROXY=http://127.0.0.1:7890` |
| `USER_CONTENT_REQUEST_PROXY` | 用户内容请求使用的代理 | - | `USER_CONTENT_REQUEST_PROXY=http://127.0.0.1:7890` | -->

## Model and Request Processing Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `FORCE_STREAM_OPTION` | Override client stream_options parameter | `true` | `FORCE_STREAM_OPTION=false` |
| `GET_MEDIA_TOKEN` | Whether to count image tokens | `true` | `GET_MEDIA_TOKEN=false` |
| `GET_MEDIA_TOKEN_NOT_STREAM` | Whether to count image tokens in non-streaming mode | `true` | `GET_MEDIA_TOKEN_NOT_STREAM=false` |
| `UPDATE_TASK` | Whether to update asynchronous tasks (MJ, Suno) | `true` | `UPDATE_TASK=false` |
| `ENFORCE_INCLUDE_USAGE` | Force usage return in stream mode | `false` | `ENFORCE_INCLUDE_USAGE=true` |
| `TIKTOKEN_CACHE_DIR` | Tiktoken encoder cache directory, used to store tokenizer files to avoid network download | - | `TIKTOKEN_CACHE_DIR=/cache/tiktoken` |
| `DATA_GYM_CACHE_DIR` | DataGym cache directory | - | `DATA_GYM_CACHE_DIR=/cache/data_gym` |

!!! tip "Tiktoken File Configuration"
    After downloading the tiktoken files, please rename them as follows:

    - `cl100k_base.tiktoken` renamed to `9b5ad71b2ce5302211f9c61530b329a4922fc6a4`
    
    - `o200k_base.tiktoken` renamed to `fb374d419588a4632f3f557e76b4b70aebbca790`
    
    These files should be placed in the directory specified by `TIKTOKEN_CACHE_DIR` to improve token calculation performance and reduce network dependency.

!!! example "Tiktoken Configuration Example"
    ```bash
    # Docker environment example
    TIKTOKEN_CACHE_DIR=/app/data/tiktoken
    
    # Then download and rename the tiktoken files and place them in this directory:
    /app/data/tiktoken/9b5ad71b2ce5302211f9c61530b329a4922fc6a4
    /app/data/tiktoken/fb374d419588a4632f3f557e76b4b70aebbca790
    ```
    
    Tiktoken is the tokenizer used by OpenAI to calculate the number of tokens in the text. By caching these files locally, the system can avoid downloading them from the network every time it starts, improving stability and performance, especially in network-restricted environments.

## Specific Model Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `AZURE_DEFAULT_API_VERSION` | Azure channel default API version | `2024-12-01-preview` | `AZURE_DEFAULT_API_VERSION=2023-05-15` |
| `COHERE_SAFETY_SETTING` | Cohere model safety setting | `NONE` | `COHERE_SAFETY_SETTING=CONTEXTUAL` |
| `GEMINI_VISION_MAX_IMAGE_NUM` | Gemini model maximum image count | `16` | `GEMINI_VISION_MAX_IMAGE_NUM=8` |
| `GEMINI_VERSION` | Gemini version | `v1` | `GEMINI_VERSION=v1beta` |
| `DIFY_DEBUG` | Dify channel output workflow and node information | `true` | `DIFY_DEBUG=false` |

## Other Configuration

| Environment Variable | Description | Default Value | Example |
|---------|------|-------|------|
| `EMAIL_SERVER` | Email server configuration | - | `EMAIL_SERVER=smtp.example.com:25` |
| `EMAIL_FROM` | Email sender address | - | `EMAIL_FROM=noreply@example.com` |
| `EMAIL_PASSWORD` | Email server password | - | `EMAIL_PASSWORD=yourpassword` |
| `ERROR_LOG_ENABLED` | Whether to record and display error logs on the frontend | false | `ERROR_LOG_ENABLED=true` |

## Deprecated Environment Variables

The following environment variables have been deprecated. Please use the corresponding options in the system settings interface:

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

# Optional: Synchronization Frequency
SYNC_FREQUENCY=60
```

!!! tip "Complete Cluster Configuration"
    This is just a basic multi-node configuration example. For complete cluster deployment configuration, architecture description, and best practices, please refer to the [Cluster Deployment Guide](cluster-deployment.md).

## Environment Variable Example in Docker Compose

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
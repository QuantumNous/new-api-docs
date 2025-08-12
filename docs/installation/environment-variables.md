# 环境变量配置指南

本文档提供了New API支持的所有环境变量及其配置说明。您可以通过设置这些环境变量来自定义系统的行为。

!!! tip "提示"
    New API 支持从 `.env` 文件中读取环境变量，请参照 `.env.example` 文件，使用时请将其重命名为 `.env`。

## 基本配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `PORT` | 服务监听端口 | `3000` | `PORT=8080` |
| `TZ` | 时区设置 | `Asia/Shanghai` | `TZ=America/New_York` |

## 数据库配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `SQL_DSN` | 数据库连接字符串 | SQLite (data/one-api.db) | `SQL_DSN=root:123456@tcp(localhost:3306)/oneapi` |
| `SQL_MAX_IDLE_CONNS` | 空闲连接池最大连接数 | `100` | `SQL_MAX_IDLE_CONNS=50` |
| `SQL_MAX_OPEN_CONNS` | 连接池最大打开连接数 | `1000` | `SQL_MAX_OPEN_CONNS=500` |
| `SQL_CONN_MAX_LIFETIME` | 连接最大生命周期(分钟) | `60` | `SQL_CONN_MAX_LIFETIME=120` |
| `LOG_SQL_DSN` | 日志表独立数据库连接字符串 | - | `LOG_SQL_DSN=root:123456@tcp(localhost:3306)/oneapi_logs` |
| `SQLITE_BUSY_TIMEOUT` | SQLite锁等待超时(毫秒) | `3000` | `SQLITE_BUSY_TIMEOUT=5000` |

## 缓存配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `REDIS_CONN_STRING` | Redis连接字符串 | - | `REDIS_CONN_STRING=redis://default:redispw@localhost:6379` |
| `MEMORY_CACHE_ENABLED` | 是否启用内存缓存 | `false` | `MEMORY_CACHE_ENABLED=true` |
| `REDIS_CONN_POOL_SIZE` | Redis连接池大小 | - | `REDIS_CONN_POOL_SIZE=10` |
| `REDIS_PASSWORD` | Redis集群或哨兵模式密码 | - | `REDIS_PASSWORD=your_password` |
| `REDIS_MASTER_NAME` | Redis哨兵模式主节点名称 | - | `REDIS_MASTER_NAME=mymaster` |
| `BATCH_UPDATE_ENABLED` | 启用数据库批量更新聚合 | `false` | `BATCH_UPDATE_ENABLED=true` |
| `BATCH_UPDATE_INTERVAL` | 批量更新聚合时间间隔(秒) | `5` | `BATCH_UPDATE_INTERVAL=10` |

## 多节点与安全配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `SESSION_SECRET` | 会话密钥(多机部署必须) | - | `SESSION_SECRET=random_string` |
| `CRYPTO_SECRET` | 加密密钥(加密数据库内容) | - | `CRYPTO_SECRET=your_crypto_secret` |
| `FRONTEND_BASE_URL` | 前端基础URL | - | `FRONTEND_BASE_URL=https://your-domain.com` |
| `SYNC_FREQUENCY` | 缓存与数据库同步频率(秒) | `600` | `SYNC_FREQUENCY=60` |
| `NODE_TYPE` | 节点类型 | `master` | `NODE_TYPE=slave` |
| `INITIAL_ROOT_TOKEN` | 首次启动时创建的root用户令牌 | - | `INITIAL_ROOT_TOKEN=your_token` |
| `INITIAL_ROOT_ACCESS_TOKEN` | 首次启动时创建的系统管理令牌 | - | `INITIAL_ROOT_ACCESS_TOKEN=your_token` |

!!! info "集群部署"
    关于如何使用这些环境变量构建完整的集群部署，请参考[集群部署指南](cluster-deployment.md)。

## 用户及令牌配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `DEFAULT_QUOTA` | 新用户默认配额 | `0` | `DEFAULT_QUOTA=10` |
| `GLOBAL_USER_QUOTA` | 全局用户配额限制 | - | `GLOBAL_USER_QUOTA=100` |
| `GENERATE_DEFAULT_TOKEN` | 为新注册用户生成初始令牌 | `false` | `GENERATE_DEFAULT_TOKEN=true` |
| `NOTIFICATION_LIMIT_DURATION_MINUTE` | 通知限制的持续时间(分钟) | `10` | `NOTIFICATION_LIMIT_DURATION_MINUTE=15` |
| `NOTIFY_LIMIT_COUNT` | 指定持续时间内的最大通知数量 | `2` | `NOTIFY_LIMIT_COUNT=3` |

## 请求限制配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `GLOBAL_API_RATE_LIMIT` | 全局API速率限制(单IP三分钟) | `180` | `GLOBAL_API_RATE_LIMIT=100` |
| `GLOBAL_WEB_RATE_LIMIT` | 全局Web速率限制(单IP三分钟) | `60` | `GLOBAL_WEB_RATE_LIMIT=30` |
| `RELAY_TIMEOUT` | 中继请求超时时间(秒) | - | `RELAY_TIMEOUT=60` |
| `USER_CONTENT_REQUEST_TIMEOUT` | 用户内容下载超时时间(秒) | - | `USER_CONTENT_REQUEST_TIMEOUT=30` |
| `STREAMING_TIMEOUT` | 流式一次回复的超时时间(秒) | `60` | `STREAMING_TIMEOUT=120` |
| `MAX_FILE_DOWNLOAD_MB` | 最大文件下载大小(MB) | `20` | `MAX_FILE_DOWNLOAD_MB=50` |

!!! warning "RELAY_TIMEOUT 设置警告"
    设置 `RELAY_TIMEOUT` 环境变量时请谨慎，如果设置过短可能导致以下问题：

    - 上游API已经完成请求并计费，但本地因超时而未完成计费

    - 造成计费不同步，可能导致系统亏损
    
    - 建议不设置，除非您知道自己在做什么

## 渠道管理配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `CHANNEL_UPDATE_FREQUENCY` | 定期更新渠道余额(分钟) | - | `CHANNEL_UPDATE_FREQUENCY=1440` |
| `CHANNEL_TEST_FREQUENCY` | 定期检查渠道(分钟) | - | `CHANNEL_TEST_FREQUENCY=1440` |
| `POLLING_INTERVAL` | 批量更新渠道时请求间隔(秒) | `0` | `POLLING_INTERVAL=5` |
| `ENABLE_METRIC` | 是否根据请求成功率禁用渠道 | `false` | `ENABLE_METRIC=true` |
| `METRIC_QUEUE_SIZE` | 请求成功率统计队列大小 | `10` | `METRIC_QUEUE_SIZE=20` |
| `METRIC_SUCCESS_RATE_THRESHOLD` | 请求成功率阈值 | `0.8` | `METRIC_SUCCESS_RATE_THRESHOLD=0.7` |
| `TEST_PROMPT` | 测试模型时的用户prompt | `Print your model name exactly...` | `TEST_PROMPT=Hello` |

<!-- ## 🔄 代理配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `RELAY_PROXY` | 中继请求使用的代理 | - | `RELAY_PROXY=http://127.0.0.1:7890` |
| `USER_CONTENT_REQUEST_PROXY` | 用户内容请求使用的代理 | - | `USER_CONTENT_REQUEST_PROXY=http://127.0.0.1:7890` | -->

## 模型和请求处理配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `FORCE_STREAM_OPTION` | 覆盖客户端stream_options参数 | `true` | `FORCE_STREAM_OPTION=false` |
| `GET_MEDIA_TOKEN` | 是否统计图片token | `true` | `GET_MEDIA_TOKEN=false` |
| `GET_MEDIA_TOKEN_NOT_STREAM` | 非流模式下是否统计图片token | `true` | `GET_MEDIA_TOKEN_NOT_STREAM=false` |
| `UPDATE_TASK` | 是否更新异步任务(MJ、Suno) | `true` | `UPDATE_TASK=false` |
| `ENFORCE_INCLUDE_USAGE` | 强制stream模式下返回usage | `false` | `ENFORCE_INCLUDE_USAGE=true` |
| `TIKTOKEN_CACHE_DIR` | Tiktoken编码器缓存目录，用于存放分词文件避免网络下载 | - | `TIKTOKEN_CACHE_DIR=/cache/tiktoken` |
| `DATA_GYM_CACHE_DIR` | DataGym缓存目录 | - | `DATA_GYM_CACHE_DIR=/cache/data_gym` |

!!! tip "Tiktoken文件配置"
    下载tiktoken文件后，请按照以下方式重命名：

    - `cl100k_base.tiktoken` 重命名为 `9b5ad71b2ce5302211f9c61530b329a4922fc6a4`
    
    - `o200k_base.tiktoken` 重命名为 `fb374d419588a4632f3f557e76b4b70aebbca790`
    
    这些文件应放置在`TIKTOKEN_CACHE_DIR`指定的目录中，以提高token计算性能并减少网络依赖。

!!! example "Tiktoken配置示例"
    ```bash
    # Docker环境示例
    TIKTOKEN_CACHE_DIR=/app/data/tiktoken
    
    # 然后将tiktoken文件下载并重命名后放入该目录：
    /app/data/tiktoken/9b5ad71b2ce5302211f9c61530b329a4922fc6a4
    /app/data/tiktoken/fb374d419588a4632f3f557e76b4b70aebbca790
    ```
    
    Tiktoken是OpenAI使用的分词器，用于计算文本的token数量。通过本地缓存这些文件，可以避免系统每次启动时从网络下载，提高稳定性和性能，特别是在网络受限环境中。

## 特定模型配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `AZURE_DEFAULT_API_VERSION` | Azure渠道默认API版本 | `2024-12-01-preview` | `AZURE_DEFAULT_API_VERSION=2023-05-15` |
| `COHERE_SAFETY_SETTING` | Cohere模型安全设置 | `NONE` | `COHERE_SAFETY_SETTING=CONTEXTUAL` |
| `GEMINI_VISION_MAX_IMAGE_NUM` | Gemini模型最大图片数量 | `16` | `GEMINI_VISION_MAX_IMAGE_NUM=8` |
| `GEMINI_VERSION` | Gemini版本 | `v1` | `GEMINI_VERSION=v1beta` |
| `DIFY_DEBUG` | Dify渠道输出工作流和节点信息 | `true` | `DIFY_DEBUG=false` |

## 其他配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `EMAIL_SERVER` | 邮件服务器配置 | - | `EMAIL_SERVER=smtp.example.com:25` |
| `EMAIL_FROM` | 邮件发送者地址 | - | `EMAIL_FROM=noreply@example.com` |
| `EMAIL_PASSWORD` | 邮件服务器密码 | - | `EMAIL_PASSWORD=yourpassword` |
| `ERROR_LOG_ENABLE` | 是否记录并在前端显示错误日志 | false | `ERROR_LOG_ENABLED=true` |

## 已废弃的环境变量

以下环境变量已被废弃，请使用系统设置界面中的相应选项：

| 环境变量 | 替代方式 |
|---------|--------|
| `GEMINI_MODEL_MAP` | 请在系统设置-模型相关设置中设置 |
| `GEMINI_SAFETY_SETTING` | 请在系统设置-模型相关设置中设置 |

## 多机部署示例

在多机部署场景中，必须设置以下环境变量：

### 主节点配置

```env
# 数据库配置 - 使用远程数据库
SQL_DSN=root:password@tcp(db-server:3306)/oneapi

# 安全配置
SESSION_SECRET=your_unique_session_secret
CRYPTO_SECRET=your_unique_crypto_secret

# Redis缓存配置
REDIS_CONN_STRING=redis://default:password@redis-server:6379
```

### 从节点配置

```env
# 数据库配置 - 使用相同的远程数据库
SQL_DSN=root:password@tcp(db-server:3306)/oneapi

# 安全配置 - 与主节点使用相同的密钥
SESSION_SECRET=your_unique_session_secret
CRYPTO_SECRET=your_unique_crypto_secret

# Redis缓存配置 - 与主节点使用相同的Redis
REDIS_CONN_STRING=redis://default:password@redis-server:6379

# 节点类型设置
NODE_TYPE=slave

# 可选：前端基础URL
FRONTEND_BASE_URL=https://your-domain.com

# 可选：同步频率
SYNC_FREQUENCY=60
```

!!! tip "完整集群配置"
    这只是基本的多节点配置示例。完整的集群部署配置、架构说明和最佳实践，请参考[集群部署指南](cluster-deployment.md)。

## Docker Compose中的环境变量示例

下面是一个在Docker Compose配置文件中设置环境变量的简要示例:

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

有关完整的Docker Compose配置，包括更多环境变量设置选项，请参考[Docker Compose配置说明](docker-compose-yml.md)文档。

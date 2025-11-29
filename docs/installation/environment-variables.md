# 环境变量配置指南

本文档提供了New API支持的所有环境变量及其配置说明。您可以通过设置这些环境变量来自定义系统的行为。

!!! tip "提示"
    New API 支持从 `.env` 文件中读取环境变量，请参照 `.env.example` 文件，使用时请将其重命名为 `.env`。

## 基本配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `PORT` | 服务监听端口 | `3000` | `PORT=8080` |
| `TZ` | 时区设置 | - | `TZ=America/New_York` |
| `VERSION` | 覆盖运行版本号 | - | `VERSION=1.2.3` |

## 数据库配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `SQL_DSN` | 数据库连接字符串 | SQLite (data/one-api.db) | MySQL: `SQL_DSN=root:123456@tcp(localhost:3306)/new-api` \| PostgreSQL: `SQL_DSN=postgresql://root:123456@postgres:5432/new-api` |
| `SQL_MAX_IDLE_CONNS` | 空闲连接池最大连接数 | `100` | `SQL_MAX_IDLE_CONNS=50` |
| `SQL_MAX_OPEN_CONNS` | 连接池最大打开连接数 | `1000` | `SQL_MAX_OPEN_CONNS=500` |
| `SQL_MAX_LIFETIME` | 连接最大生命周期(分钟) | `60` | `SQL_MAX_LIFETIME=120` |
| `LOG_SQL_DSN` | 日志表独立数据库连接字符串 | - | `LOG_SQL_DSN=root:123456@tcp(localhost:3306)/oneapi_logs` |
| `SQLITE_PATH` | SQLite数据库路径 | `/path/to/sqlite.db` | `SQLITE_PATH=/var/lib/new-api/new-api.db` |

## 缓存配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `REDIS_CONN_STRING` | Redis连接字符串 | - | `REDIS_CONN_STRING=redis://default:redispw@localhost:6379` |
| `REDIS_POOL_SIZE` | Redis连接池大小 | `10` | `REDIS_POOL_SIZE=20` |
| `MEMORY_CACHE_ENABLED` | 是否启用内存缓存 | `false` | `MEMORY_CACHE_ENABLED=true` |
| `BATCH_UPDATE_ENABLED` | 启用数据库批量更新聚合 | `false` | `BATCH_UPDATE_ENABLED=true` |
| `BATCH_UPDATE_INTERVAL` | 批量更新聚合时间间隔(秒) | `5` | `BATCH_UPDATE_INTERVAL=10` |

## 多节点与安全配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `SESSION_SECRET` | 会话密钥(多机部署必须) | - | `SESSION_SECRET=random_string` |
| `CRYPTO_SECRET` | 加密密钥(加密数据库内容) | - | `CRYPTO_SECRET=your_crypto_secret` |
| `FRONTEND_BASE_URL` | 前端基础URL | - | `FRONTEND_BASE_URL=https://your-domain.com` |
| `SYNC_FREQUENCY` | 缓存与数据库同步频率(秒) | `60` | `SYNC_FREQUENCY=60` |
| `NODE_TYPE` | 节点类型 | `master` | `NODE_TYPE=slave` |

!!! info "集群部署"
    关于如何使用这些环境变量构建完整的集群部署，请参考[集群部署指南](cluster-deployment.md)。

## 用户及令牌配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `GENERATE_DEFAULT_TOKEN` | 为新注册用户生成初始令牌 | `false` | `GENERATE_DEFAULT_TOKEN=true` |
| `NOTIFICATION_LIMIT_DURATION_MINUTE` | 通知限制的持续时间(分钟) | `10` | `NOTIFICATION_LIMIT_DURATION_MINUTE=15` |
| `NOTIFY_LIMIT_COUNT` | 指定持续时间内的最大通知数量 | `2` | `NOTIFY_LIMIT_COUNT=3` |

## 请求限制配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `GLOBAL_API_RATE_LIMIT` | 全局API速率限制(单IP三分钟) | `180` | `GLOBAL_API_RATE_LIMIT=100` |
| `GLOBAL_WEB_RATE_LIMIT` | 全局Web速率限制(单IP三分钟) | `60` | `GLOBAL_WEB_RATE_LIMIT=30` |
| `RELAY_TIMEOUT` | 中继请求超时时间(秒) | `0` | `RELAY_TIMEOUT=60` |
| `STREAMING_TIMEOUT` | 流式一次回复的超时时间(秒) | `300` | `STREAMING_TIMEOUT=120` |
| `MAX_FILE_DOWNLOAD_MB` | 最大文件下载大小(MB) | `20` | `MAX_FILE_DOWNLOAD_MB=50` |
| `GLOBAL_API_RATE_LIMIT_ENABLE` | 全局API速率限制开关 | `true` | `GLOBAL_API_RATE_LIMIT_ENABLE=false` |
| `GLOBAL_API_RATE_LIMIT_DURATION` | 全局API速率限制窗口(秒) | `180` | `GLOBAL_API_RATE_LIMIT_DURATION=120` |
| `GLOBAL_WEB_RATE_LIMIT_ENABLE` | 全局Web速率限制开关 | `true` | `GLOBAL_WEB_RATE_LIMIT_ENABLE=false` |
| `GLOBAL_WEB_RATE_LIMIT_DURATION` | 全局Web速率限制窗口(秒) | `180` | `GLOBAL_WEB_RATE_LIMIT_DURATION=120` |
| `CRITICAL_RATE_LIMIT_ENABLE` | 关键操作速率限制开关 | `true` | `CRITICAL_RATE_LIMIT_ENABLE=false` |
| `CRITICAL_RATE_LIMIT` | 关键操作速率限制次数 | `20` | `CRITICAL_RATE_LIMIT=10` |
| `CRITICAL_RATE_LIMIT_DURATION` | 关键操作速率限制窗口(秒) | `1200` | `CRITICAL_RATE_LIMIT_DURATION=600` |

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

## 模型和请求处理配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `FORCE_STREAM_OPTION` | 覆盖客户端stream_options参数 | `true` | `FORCE_STREAM_OPTION=false` |
| `GET_MEDIA_TOKEN` | 是否统计图片token | `true` | `GET_MEDIA_TOKEN=false` |
| `GET_MEDIA_TOKEN_NOT_STREAM` | 非流模式下是否统计图片token | `false` | `GET_MEDIA_TOKEN_NOT_STREAM=false` |
| `UPDATE_TASK` | 是否更新异步任务(MJ、Suno) | `true` | `UPDATE_TASK=false` |
| `CountToken` | 是否统计文本token | `true` | `CountToken=false` |
| `TASK_PRICE_PATCH` | 任务价格补丁(逗号分隔) | `""` | `TASK_PRICE_PATCH=suno=0.8,mj=1.2` |


## 特定模型配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `AZURE_DEFAULT_API_VERSION` | Azure渠道默认API版本 | `2025-04-01-preview` | `AZURE_DEFAULT_API_VERSION=2023-05-15` |
| `COHERE_SAFETY_SETTING` | Cohere模型安全设置 | `NONE` | `COHERE_SAFETY_SETTING=CONTEXTUAL` |
| `GEMINI_VISION_MAX_IMAGE_NUM` | Gemini模型最大图片数量 | `16` | `GEMINI_VISION_MAX_IMAGE_NUM=8` |
| `DIFY_DEBUG` | Dify渠道输出工作流和节点信息 | `true` | `DIFY_DEBUG=false` |

## 其他配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `ERROR_LOG_ENABLED` | 是否记录并在前端显示错误日志 | false | `ERROR_LOG_ENABLED=true` |

## 分析统计

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `UMAMI_WEBSITE_ID` | Umami站点ID | - | `UMAMI_WEBSITE_ID=xxxx-xxxx` |
| `UMAMI_SCRIPT_URL` | Umami脚本地址 | `https://analytics.umami.is/script.js` | `UMAMI_SCRIPT_URL=https://umami.example.com/script.js` |
| `GOOGLE_ANALYTICS_ID` | Google Analytics站点ID | - | `GOOGLE_ANALYTICS_ID=G-XXXXXXX` |

## 元数据同步

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `SYNC_UPSTREAM_BASE` | 模型/厂商元数据上游地址 | `https://basellm.github.io/llm-metadata` | `SYNC_UPSTREAM_BASE=https://mirror.example.com/llm-metadata` |
| `SYNC_HTTP_TIMEOUT_SECONDS` | 同步HTTP超时(秒) | `10` | `SYNC_HTTP_TIMEOUT_SECONDS=15` |
| `SYNC_HTTP_RETRY` | 同步重试次数 | `3` | `SYNC_HTTP_RETRY=5` |
| `SYNC_HTTP_MAX_MB` | 响应体最大大小(MB) | `10` | `SYNC_HTTP_MAX_MB=20` |

## 前端配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `VITE_REACT_APP_SERVER_URL` | 前端请求后端的基础地址 | - | `VITE_REACT_APP_SERVER_URL=https://api.example.com` |

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

## LinuxDo 相关

正常情况下无需修改

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `LINUX_DO_TOKEN_ENDPOINT` | LinuxDo 令牌端点 | `https://connect.linux.do/oauth2/token` | `LINUX_DO_TOKEN_ENDPOINT=https://connect.linux.do/oauth2/token` |
| `LINUX_DO_USER_ENDPOINT` | LinuxDo 用户端点 | `https://connect.linux.do/api/user` | `LINUX_DO_USER_ENDPOINT=https://connect.linux.do/api/user` |   

## 调试相关

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `ENABLE_PPROF` | 启用pprof性能分析 | `false` | `ENABLE_PPROF=true` |
| `DEBUG` | 启用调试模式 | `false` | `DEBUG=true` | 
| `GIN_MODE` | Gin运行模式 | - | `GIN_MODE=release` |

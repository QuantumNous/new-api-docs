# Local Development Deployment Guide

This document provides detailed steps for setting up and developing the New API project in a local environment, suitable for developers who want to participate in project development or perform secondary development.

## Development Environment Requirements

Before starting local development, please ensure your system has the following software installed:

- **Go** 1.21 or higher (backend development)
- **Node.js** 18 or higher (frontend development)
- **Bun** latest version (recommended package manager, 25x faster than npm/yarn)
- **Git** (version control)
- **MySQL** (optional, SQLite used by default)
- **Redis** (optional, for performance improvement)
- **Visual Studio Code** or other code editors

!!! info "About Bun"
    Bun is an ultra-fast JavaScript package manager, test runner, and bundler. Compared to traditional npm or yarn, Bun's installation speed is 25x faster, making it the most recommended JavaScript package management tool in 2024.

## Clone the Project

First, clone the New API repository from GitHub to your local machine:

```bash
git clone https://github.com/Calcium-Ion/new-api.git
cd new-api
```

## Backend Development Setup

### Install Go Dependencies

```bash
go mod download
```

### Configure Development Environment

New API supports configuration through `.env` file. Create a `.env` file (copy from `.env.example`):

```bash
cp .env.example .env
```

Edit the `.env` file and modify the configuration as needed. Here are commonly used configurations in development environment:

```env
PORT=3000
SQL_DSN=root:password@tcp(localhost:3306)/new-api   # Uncomment and modify if using MySQL
# REDIS_CONN_STRING=redis://localhost:6379         # Uncomment and modify if using Redis
```

!!! tip "Note"
    If `SQL_DSN` is not configured, the system will use SQLite database by default, stored in the `one-api.db` file.

### Run Backend Service

```bash
# Run directly
go run main.go

# Or compile and run
go build -o new-api
./new-api
```

The service runs on `http://localhost:3000` by default

## Frontend Development Setup

The frontend code of New API is located in the `web` directory, developed using React and [Semi Design component library](https://semi.design/zh-CN).

### Install Bun (Recommended)

If you haven't installed Bun yet, please install it using the following commands:

**macOS/Linux:**
```bash
curl -fsSL https://bun.sh/install | bash
```

**Windows (using WSL):**
```bash
curl -fsSL https://bun.sh/install | bash
```

**macOS (using Homebrew):**
```bash
brew tap oven-sh/bun
brew install bun
```

After installation, restart the terminal or run `source ~/.bashrc` (or `~/.zshrc`) to make the Bun command effective.

### Install Frontend Dependencies

```bash
cd web
bun install   # Use bun to install frontend dependencies
```

### Run Development Server

```bash
bun run dev   # Use bun to run development server
```

The frontend development server runs on `http://localhost:5173` by default, and is configured with a proxy that forwards API requests to the backend service.

### Build Frontend Resources

```bash
bun run build   # Use bun to build frontend resources
```

The built files will be generated in the `web/dist` directory, and the backend service will automatically load these static resources.

7. **Create Pull Request**: Create a PR on GitHub describing your changes

## Debugging Tips

### Backend Debugging

1. **View Logs**:
   ```bash
   go run main.go --log-dir ./logs
   ```

2. **Use Delve for Debugging**:
   ```bash
   go install github.com/go-delve/delve/cmd/dlv@latest
   dlv debug main.go
   ```

### Frontend Debugging

1. **Use Chrome DevTools**:
   - Open Chrome Developer Tools (F12)
   - Check Console and Network tabs

2. **React Developer Tools**:
   - Install React Developer Tools extension in Chrome
   - Use it to inspect component structure and state

## Project Structure

The directory structure of the New API project:

```
new-api/                                 # Project root directory
│  .dockerignore                         # Docker build ignore file configuration
│  .env.example                          # Environment variables example file
│  .gitignore                            # Git ignore file configuration
│  BT.md                                 # BT (possibly Baota Panel) related documentation
│  docker-compose.yml                    # Docker Compose configuration file for container orchestration
│  Dockerfile                            # Docker image build configuration
│  go.mod                                # Go module dependency configuration file
│  go.sum                                # Go module dependency checksum file
│  LICENSE                               # Project license file
│  main.go                               # Project main entry file
│  makefile                              # Project build script
│  Midjourney.md                         # Midjourney service related documentation
│  one-api.service                       # systemd service configuration file
│  README.en.md                          # English version project documentation
│  README.md                             # Chinese version project documentation
│  Rerank.md                             # Rerank functionality related documentation
│  Suno.md                               # Suno API related documentation
│  VERSION                               # Project version information file
│
├─.github                                # GitHub related configuration directory
│  │  FUNDING.yml                        # GitHub sponsorship configuration file
│  │
│  ├─ISSUE_TEMPLATE                      # GitHub Issue template directory
│  │      bug_report.md                  # Bug report template
│  │      config.yml                     # Issue configuration file
│  │      feature_request.md             # Feature request template
│  │
│  └─workflows                           # GitHub Actions workflow configuration directory
│          docker-image-amd64.yml        # AMD64 architecture Docker image build workflow
│          docker-image-arm64.yml        # ARM64 architecture Docker image build workflow
│          linux-release.yml             # Linux platform release workflow
│          macos-release.yml             # macOS platform release workflow
│          windows-release.yml           # Windows platform release workflow
│
├─bin                                    # Binary files and scripts directory
│      migration_v0.2-v0.3.sql           # Database v0.2 to v0.3 migration script
│      migration_v0.3-v0.4.sql           # Database v0.3 to v0.4 migration script
│      time_test.sh                      # Time test script
│
├─common                                 # Common functionality modules directory
│      constants.go                      # Common constant definitions
│      crypto.go                         # Encryption related functionality
│      custom-event.go                   # Custom event handling
│      database.go                       # Database connection and operations
│      email-outlook-auth.go             # Outlook email authentication
│      email.go                          # Email functionality
│      embed-file-system.go              # Embedded file system
│      env.go                            # Environment variable handling
│      gin.go                            # Gin framework related functionality
│      go-channel.go                     # Go channel management
│      gopool.go                         # Go coroutine pool
│      init.go                           # Initialization functions
│      logger.go                         # Logging functionality
│      pprof.go                          # Performance analysis tools
│      rate-limit.go                     # Rate limiting functionality
│      redis.go                          # Redis client
│      str.go                            # String processing utilities
│      topup-ratio.go                    # Top-up ratio calculation
│      utils.go                          # Common utility functions
│      validate.go                       # Data validation functionality
│      verification.go                   # Verification code related functionality
│
├─constant                               # Constant definitions directory
│      cache_key.go                      # Cache key name constants
│      channel_setting.go                # Channel setting constants
│      context_key.go                    # Context key name constants
│      env.go                            # Environment variable constants
│      finish_reason.go                  # Completion reason constants
│      midjourney.go                     # Midjourney related constants
│      task.go                           # Task related constants
│      user_setting.go                   # User setting constants
│
├─controller                             # Controller layer, handling HTTP requests
│      billing.go                        # Billing controller
│      channel-billing.go                # Channel billing controller
│      channel-test.go                   # Channel test controller
│      channel.go                        # Channel management controller
│      github.go                         # GitHub related controller
│      group.go                          # User group controller
│      linuxdo.go                        # LinuxDo related controller
│      log.go                            # Log controller
│      midjourney.go                     # Midjourney service controller
│      misc.go                           # Miscellaneous functionality controller
│      model.go                          # Model management controller
│      oidc.go                           # OpenID Connect authentication controller
│      option.go                         # Option setting controller
│      playground.go                     # Test scenario controller
│      pricing.go                        # Price management controller
│      redemption.go                     # Redemption code controller
│      relay.go                          # Request forwarding controller
│      task.go                           # Task management controller
│      telegram.go                       # Telegram related controller
│      token.go                          # Token management controller
│      topup.go                          # Top-up controller
│      usedata.go                        # User data controller
│      user.go                           # User management controller
│      wechat.go                         # WeChat related controller
│
├─docs                                   # Documentation directory
│  ├─api                                 # API documentation
│  │      api_auth.md                    # API authentication documentation
│  │      user.md                        # User related API documentation
│  │
│  └─channel                             # Channel documentation
│          other_setting.md              # Other settings documentation
│
├─dto                                    # Data Transfer Object directory
│      audio.go                          # Audio related DTO
│      dalle.go                          # DALL-E related DTO
│      embedding.go                      # Embedding vector related DTO
│      error.go                          # Error response DTO
│      file_data.go                      # File data DTO
│      midjourney.go                     # Midjourney related DTO
│      notify.go                         # Notification related DTO
│      openai_request.go                 # OpenAI request DTO
│      openai_response.go                # OpenAI response DTO
│      playground.go                     # Test scenario DTO
│      pricing.go                        # Price related DTO
│      realtime.go                       # Real-time data DTO
│      rerank.go                         # Rerank related DTO
│      sensitive.go                      # Sensitive content related DTO
│      suno.go                           # Suno related DTO
│      task.go                           # Task related DTO
│
├─middleware                             # Middleware directory
│      auth.go                           # Authentication middleware
│      cache.go                          # Cache middleware
│      cors.go                           # Cross-Origin Resource Sharing middleware
│      distributor.go                    # Request distribution middleware
│      gzip.go                           # Gzip compression middleware
│      logger.go                         # Logging middleware
│      model-rate-limit.go               # Model level rate limiting middleware
│      rate-limit.go                     # General rate limiting middleware
│      recover.go                        # Exception recovery middleware
│      request-id.go                     # Request ID middleware
│      turnstile-check.go                # Cloudflare Turnstile check middleware
│      utils.go                          # Middleware utility functions
│
├─model                                  # Data model directory
│      ability.go                        # Ability model
│      cache.go                          # Cache model
│      channel.go                        # Channel model
│      log.go                            # Log model
│      main.go                           # Main model and ORM configuration
│      midjourney.go                     # Midjourney related model
│      option.go                         # Option setting model
│      pricing.go                        # Price model
│      redemption.go                     # Redemption code model
│      task.go                           # Task model
│      token.go                          # Token model
│      token_cache.go                    # Token cache model
│      topup.go                          # Top-up model
│      usedata.go                        # User data model
│      user.go                           # User model
│      user_cache.go                     # User cache model
│      utils.go                          # Model utility functions
│
├─relay                                  # Request forwarding module directory
│  │  relay-audio.go                     # Audio request forwarding
│  │  relay-image.go                     # Image request forwarding
│  │  relay-mj.go                        # Midjourney request forwarding
│  │  relay-text.go                      # Text request forwarding
│  │  relay_adaptor.go                   # Forwarding adapter
│  │  relay_embedding.go                 # Embedding vector request forwarding
│  │  relay_rerank.go                    # Rerank request forwarding
│  │  relay_task.go                      # Task request forwarding
│  │  websocket.go                       # WebSocket communication handling
│  │
│  ├─channel                             # Forwarding channel directory
│  │  │  adapter.go                      # General channel adapter
│  │  │  api_request.go                  # API request handling
│  │  │
│  │  ├─ai360                            # 360 AI channel
│  │  │      constants.go                # 360 AI constant definitions
│  │  │
│  │  ├─ali                              # Alibaba Cloud AI channel
│  │  │      adaptor.go                  # Alibaba Cloud adapter
│  │  │      constants.go                # Alibaba Cloud constant definitions
│  │  │      dto.go                      # Alibaba Cloud data transfer object
│  │  │      image.go                    # Alibaba Cloud image processing
│  │  │      text.go                     # Alibaba Cloud text processing
│  │  │
│  │  ├─aws                              # AWS AI channel
│  │  │      adaptor.go                  # AWS adapter
│  │  │      constants.go                # AWS constant definitions
│  │  │      dto.go                      # AWS data transfer object
│  │  │      relay-aws.go                # AWS request forwarding
│  │  │
│  │  ├─baidu                            # Baidu AI channel
│  │  │      adaptor.go                  # Baidu adapter
│  │  │      constants.go                # Baidu constant definitions
│  │  │      dto.go                      # Baidu data transfer object
│  │  │      relay-baidu.go              # Baidu request forwarding
│  │  │
│  │  ├─baidu_v2                         # Baidu AI v2 version channel
│  │  │      adaptor.go                  # Baidu v2 adapter
│  │  │      constants.go                # Baidu v2 constant definitions
│  │  │
│  │  ├─claude                           # Claude AI channel
│  │  │      adaptor.go                  # Claude adapter
│  │  │      constants.go                # Claude constant definitions
│  │  │      dto.go                      # Claude data transfer object
│  │  │      relay-claude.go             # Claude request forwarding
│  │  │
│  │  ├─cloudflare                       # Cloudflare AI channel
│  │  │      adaptor.go                  # Cloudflare adapter
│  │  │      constant.go                 # Cloudflare constant definitions
│  │  │      dto.go                      # Cloudflare data transfer object
│  │  │      relay_cloudflare.go         # Cloudflare request forwarding
│  │  │
│  │  ├─cohere                           # Cohere AI channel
│  │  │      adaptor.go                  # Cohere adapter
│  │  │      constant.go                 # Cohere constant definitions
│  │  │      dto.go                      # Cohere data transfer object
│  │  │      relay-cohere.go             # Cohere request forwarding
│  │  │
│  │  ├─deepseek                         # DeepSeek AI channel
│  │  │      adaptor.go                  # DeepSeek adapter
│  │  │      constants.go                # DeepSeek constant definitions
│  │  │
│  │  ├─dify                             # Dify AI channel
│  │  │      adaptor.go                  # Dify adapter
│  │  │      constants.go                # Dify constant definitions
│  │  │      dto.go                      # Dify data transfer object
│  │  │      relay-dify.go               # Dify request forwarding
│  │  │
│  │  ├─gemini                           # Google Gemini AI channel
│  │  │      adaptor.go                  # Gemini adapter
│  │  │      constant.go                 # Gemini constant definitions
│  │  │      dto.go                      # Gemini data transfer object
│  │  │      relay-gemini.go             # Gemini request forwarding
│  │  │
│  │  ├─jina                             # Jina AI channel
│  │  │      adaptor.go                  # Jina adapter
│  │  │      constant.go                 # Jina constant definitions
│  │  │      relay-jina.go               # Jina request forwarding
│  │  │
│  │  ├─lingyiwanwu                      # Lingyi Wanwu AI channel
│  │  │      constrants.go               # Lingyi Wanwu constant definitions
│  │  │
│  │  ├─minimax                          # MiniMax AI channel
│  │  │      constants.go                # MiniMax constant definitions
│  │  │      relay-minimax.go            # MiniMax request forwarding
│  │  │
│  │  ├─mistral                          # Mistral AI channel
│  │  │      adaptor.go                  # Mistral adapter
│  │  │      constants.go                # Mistral constant definitions
│  │  │      text.go                     # Mistral text processing
│  │  │
│  │  ├─mokaai                           # MokaAI channel
│  │  │      adaptor.go                  # MokaAI adapter
│  │  │      constants.go                # MokaAI constant definitions
│  │  │      relay-mokaai.go             # MokaAI request forwarding
│  │  │
│  │  ├─moonshot                         # Moonshot AI channel
│  │  │      constants.go                # Moonshot constant definitions
│  │  │
│  │  ├─ollama                           # Ollama AI channel
│  │  │      adaptor.go                  # Ollama adapter
│  │  │      constants.go                # Ollama constant definitions
│  │  │      dto.go                      # Ollama data transfer object
│  │  │      relay-ollama.go             # Ollama request forwarding
│  │  │
│  │  ├─openai                           # OpenAI channel
│  │  │      adaptor.go                  # OpenAI adapter
│  │  │      constant.go                 # OpenAI constant definitions
│  │  │      relay-openai.go             # OpenAI request forwarding
│  │  │
│  │  ├─openrouter                       # OpenRouter AI channel
│  │  │      adaptor.go                  # OpenRouter adapter
│  │  │      constant.go                 # OpenRouter constant definitions
│  │  │
│  │  ├─palm                             # Google PaLM AI channel
│  │  │      adaptor.go                  # PaLM adapter
│  │  │      constants.go                # PaLM constant definitions
│  │  │      dto.go                      # PaLM data transfer object
│  │  │      relay-palm.go               # PaLM request forwarding
│  │  │
│  │  ├─perplexity                       # Perplexity AI channel
│  │  │      adaptor.go                  # Perplexity adapter
│  │  │      constants.go                # Perplexity constant definitions
│  │  │      relay-perplexity.go         # Perplexity request forwarding
│  │  │
│  │  ├─siliconflow                      # SiliconFlow AI channel
│  │  │      adaptor.go                  # SiliconFlow adapter
│  │  │      constant.go                 # SiliconFlow constant definitions
│  │  │      dto.go                      # SiliconFlow data transfer object
│  │  │      relay-siliconflow.go        # SiliconFlow request forwarding
│  │  │
│  │  ├─task                             # Task related channels
│  │  │  └─suno                          # Suno audio generation task
│  │  │          adaptor.go              # Suno adapter
│  │  │          models.go               # Suno model definitions
│  │  │
│  │  ├─tencent                          # Tencent AI channel
│  │  │      adaptor.go                  # Tencent adapter
│  │  │      constants.go                # Tencent constant definitions
│  │  │      dto.go                      # Tencent data transfer object
│  │  │      relay-tencent.go            # Tencent request forwarding
│  │  │
│  │  ├─vertex                           # Google Vertex AI channel
│  │  │      adaptor.go                  # Vertex adapter
│  │  │      constants.go                # Vertex constant definitions
│  │  │      dto.go                      # Vertex data transfer object
│  │  │      relay-vertex.go             # Vertex request forwarding
│  │  │      service_account.go          # Vertex service account
│  │  │
│  │  ├─volcengine                       # Volcengine AI channel
│  │  │      adaptor.go                  # Volcengine adapter
│  │  │      constants.go                # Volcengine constant definitions
│  │  │
│  │  ├─xunfei                           # Xunfei AI channel
│  │  │      adaptor.go                  # Xunfei adapter
│  │  │      constants.go                # Xunfei constant definitions
│  │  │      dto.go                      # Xunfei data transfer object
│  │  │      relay-xunfei.go             # Xunfei request forwarding
│  │  │
│  │  ├─zhipu                            # Zhipu AI channel
│  │  │      adaptor.go                  # Zhipu adapter
│  │  │      constants.go                # Zhipu constant definitions
│  │  │      dto.go                      # Zhipu data transfer object
│  │  │      relay-zhipu.go              # Zhipu request forwarding
│  │  │
│  │  └─zhipu_4v                         # Zhipu 4.0 version channel
│  │          adaptor.go                 # Zhipu 4.0 adapter
│  │          constants.go               # Zhipu 4.0 constant definitions
│  │          dto.go                     # Zhipu 4.0 data transfer object
│  │          relay-zhipu_v4.go          # Zhipu 4.0 request forwarding
│  │
│  ├─common                              # Forwarding common modules
│  │      relay_info.go                  # Forwarding information
│  │      relay_utils.go                 # Forwarding utility functions
│  │
│  ├─constant                            # Forwarding constant directory
│  │      api_type.go                    # API type constants
│  │      relay_mode.go                  # Forwarding mode constants
│  │
│  └─helper                              # Forwarding auxiliary functionality
│          common.go                     # Common auxiliary functions
│          model_mapped.go               # Model mapping
│          price.go                      # Price calculation
│          stream_scanner.go             # Stream data scanner
│
├─router                                 # Route configuration directory
│      api-router.go                     # API route configuration
│      dashboard.go                      # Dashboard routes
│      main.go                           # Main route configuration
│      relay-router.go                   # Forwarding route configuration
│      web-router.go                     # Web interface route configuration
│
├─service                                # Service layer directory
│      audio.go                          # Audio service
│      cf_worker.go                      # Cloudflare Worker service
│      channel.go                        # Channel service
│      epay.go                           # Electronic payment service
│      error.go                          # Error handling service
│      file_decoder.go                   # File decoder service
│      http_client.go                    # HTTP client service
│      image.go                          # Image processing service
│      log_info_generate.go              # Log information generation service
│      midjourney.go                     # Midjourney service
│      notify-limit.go                   # Notification limit service
│      quota.go                          # Quota management service
│      sensitive.go                      # Sensitive content filtering service
│      str.go                            # String processing service
│      task.go                           # Task management service
│      token_counter.go                  # Token counting service
│      usage_helpr.go                    # Usage statistics auxiliary service
│      user_notify.go                    # User notification service
│      webhook.go                        # WebHook service
│
├─setting                                # Setting management directory
│  │  chat.go                            # Chat settings
│  │  group_ratio.go                     # User group ratio settings
│  │  midjourney.go                      # Midjourney settings
│  │  payment.go                         # Payment settings
│  │  rate_limit.go                      # Rate limit settings
│  │  sensitive.go                       # Sensitive content settings
│  │  system_setting.go                  # System settings
│  │  user_usable_group.go               # User available group settings
│  │
│  ├─config                              # Configuration directory
│  │      config.go                      # Configuration loading and processing
│  │
│  ├─model_setting                       # Model setting directory
│  │      claude.go                      # Claude model settings
│  │      gemini.go                      # Gemini model settings
│  │      global.go                      # Global model settings
│  │
│  ├─operation_setting                   # Operation setting directory
│  │      cache_ratio.go                 # Cache ratio settings
│  │      general_setting.go             # General settings
│  │      model-ratio.go                 # Model ratio settings
│  │      operation_setting.go           # Operation settings
│  │
│  └─system_setting                      # System setting directory
│          oidc.go                       # OpenID Connect settings
│
└─web                                    # Frontend Web interface directory
    │  .gitignore                        # Frontend Git ignore file configuration
    │  .prettierrc.mjs                   # Prettier code formatting configuration
    │  bun.lockb                         # Bun package manager lock file
    │  index.html                        # Main HTML file
    │  package.json                      # Frontend dependency configuration
    │  bun.lockb                         # Bun package manager lock file (binary format, faster)
    │  README.md                         # Frontend documentation
    │  vercel.json                       # Vercel deployment configuration
    │  vite.config.js                    # Vite build configuration
    │
    ├─public                             # Static resources directory
    │      favicon.ico                   # Website icon
    │      logo.png                      # Website logo
    │      ratio.png                     # Ratio image
    │      robots.txt                    # Search engine crawler configuration
    │
    └─src                                # Frontend source code directory
        │  App.js                        # Main application component
        │  index.css                     # Main style file
        │  index.js                      # Application entry JS
        │
        ├─components                     # Components directory
        │  │  ChannelsTable.js           # Channel table component
        │  │  fetchTokenKeys.js          # Tool for fetching token keys
        │  │  Footer.js                  # Footer component
        │  │  HeaderBar.js               # Header component
        │  │  LinuxDoIcon.js             # LinuxDo icon component
        │  │  Loading.js                 # Loading component
        │  │  LoginForm.js               # Login form component
        │  │  LogsTable.js               # Log table component
        │  │  MjLogsTable.js             # Midjourney log table component
        │  │  ModelPricing.js            # Model pricing component
        │  │  ModelSetting.js            # Model setting component
        │  │  OAuth2Callback.js          # OAuth2 callback component
        │  │  OIDCIcon.js                # OIDC icon component
        │  │  OperationSetting.js        # Operation setting component
        │  │  OtherSetting.js            # Other setting component
        │  │  PageLayout.js              # Page layout component
        │  │  PasswordResetConfirm.js    # Password reset confirmation component
        │  │  PasswordResetForm.js       # Password reset form component
        │  │  PersonalSetting.js         # Personal setting component
        │  │  PrivateRoute.js            # Private route component
        │  │  RateLimitSetting.js        # Rate limit setting component
        │  │  RedemptionsTable.js        # Redemption table component
        │  │  RegisterForm.js            # Registration form component
        │  │  SafetySetting.js           # Safety setting component
        │  │  SiderBar.js                # Sidebar component
        │  │  SystemSetting.js           # System setting component
        │  │  TaskLogsTable.js           # Task log table component
        │  │  TokensTable.js             # Token management table component
        │  │  UsersTable.js              # User management table component
        │  │  utils.js                   # Common utility functions
        │  │  WeChatIcon.js              # WeChat icon component
        │  │
        │  └─custom                      # Custom components directory
        │          TextInput.js          # Text input component
        │          TextNumberInput.js    # Number input component
        │
        ├─constants                      # Constant definitions directory
        │      channel.constants.js      # Channel related constants
        │      common.constant.js        # Common constants
        │      index.js                  # Constant export index
        │      toast.constants.js        # Toast message constants
        │      user.constants.js         # User related constants
        │
        ├─context                        # React Context context directory
        │  ├─Status                      # Status context
        │  │      index.js               # Status context entry
        │  │      reducer.js             # Status context reducer
        │  │
        │  ├─Style                       # Style context
        │  │      index.js               # Style context entry
        │  │
        │  ├─Theme                       # Theme context
        │  │      index.js               # Theme context entry
        │  │
        │  └─User                        # User context
        │          index.js              # User context entry
        │          reducer.js            # User context reducer
        │
        ├─helpers                        # Helper functions directory
        │      api.js                    # API request helper functions
        │      auth-header.js            # Authentication header handling
        │      data.js                   # Data processing functions
        │      history.js                # Route history management
        │      index.js                  # Helper function export index
        │      other.js                  # Other helper functions
        │      render.js                 # Rendering helper functions
        │      utils.js                  # Utility functions
        │
        ├─i18n                           # Internationalization directory
        │  │  i18n.js                    # Internationalization configuration file
        │  │
        │  └─locales                     # Language pack directory
        │          en.json               # English language pack
        │          zh.json               # Chinese language pack
        │
        └─pages                          # Page components directory
            ├─About                      # About page
            │      index.js              # About page entry
            │
            ├─Channel                    # Channel management page
            │      EditChannel.js        # Edit channel component
            │      EditTagModal.js       # Edit tag modal
            │      index.js              # Channel management page entry
            │
            ├─Chat                       # Chat page
            │      index.js              # Chat page entry
            │
            ├─Chat2Link                  # Chat link sharing page
            │      index.js              # Chat link entry
            │
            ├─Detail                     # Detail page
            │      index.js              # Detail page entry
            │
            ├─Home                       # Home page
            │      index.js              # Home page entry
            │
            ├─Log                        # Log page
            │      index.js              # Log page entry
            │
            ├─Midjourney                 # Midjourney management page
            │      index.js              # Midjourney page entry
            │
            ├─NotFound                   # 404 page
            │      index.js              # 404 page entry
            │
            ├─Playground                 # Test scenario page
            │      Playground.js         # Test scenario component
            │
            ├─Pricing                    # Price management page
            │      index.js              # Price management page entry
            │
            ├─Redemption                 # Redemption code management page
            │      EditRedemption.js     # Edit redemption component
            │      index.js              # Redemption management page entry
            │
            ├─Setting                    # Settings page
            │  │  index.js               # Settings page entry
            │  │
            │  ├─Model                   # Model settings page
            │  │      SettingClaudeModel.js # Claude model setting component
            │  │      SettingGeminiModel.js # Gemini model setting component
            │  │      SettingGlobalModel.js # Global model setting component
            │  │
            │  ├─Operation               # Operation settings page
            │  │      GroupRatioSettings.js       # User group ratio setting component
            │  │      ModelRationNotSetEditor.js  # Model ratio not set editor
            │  │      ModelRatioSettings.js       # Model ratio setting component
            │  │      ModelSettingsVisualEditor.js # Model setting visual editor
            │  │      SettingsChats.js            # Chat setting component
            │  │      SettingsCreditLimit.js      # Credit limit setting component
            │  │      SettingsDataDashboard.js    # Data dashboard setting component
            │  │      SettingsDrawing.js          # Drawing setting component
            │  │      SettingsGeneral.js          # General setting component
            │  │      SettingsLog.js              # Log setting component
            │  │      SettingsMonitoring.js       # Monitoring setting component
            │  │      SettingsSensitiveWords.js   # Sensitive word setting component
            │  │
            │  └─RateLimit                   # Rate limit settings page
            │          SettingsRequestRateLimit.js # Request rate limit setting component
            │
            ├─Task                           # Task management page
            │      index.js                  # Task management page entry
            │
            ├─Token                          # Token management page
            │      EditToken.js              # Edit token component
            │      index.js                  # Token management page entry
            │
            ├─TopUp                          # Top-up page
            │      index.js                  # Top-up page entry
            │
            └─User                           # User management page
                    AddUser.js               # Add user component
                    EditUser.js              # Edit user component
                    index.js                 # User management page entry
```

!!! tip "Need Help?"
    If you encounter problems during development, you can:
    
    1. Check [GitHub Issues](https://github.com/Calcium-Ion/new-api/issues)
    2. Join the [Community Group](../support/community-interaction.md)
    3. Submit issues through the [Feedback Page](../support/feedback-issues.md) 
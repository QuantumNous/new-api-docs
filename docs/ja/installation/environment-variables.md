# 環境変数設定ガイド

本ドキュメントでは、New APIがサポートするすべての環境変数とその設定について説明します。これらの環境変数を設定することで、システムの動作をカスタマイズできます。

!!! tip "ヒント"
    New API は `.env` ファイルから環境変数を読み込むことができます。`.env.example` ファイルを参照し、使用時には `.env` にリネームしてください。

## 基本設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `PORT` | サービスリスニングポート | `3000` | `PORT=8080` |
| `TZ` | タイムゾーン設定 | - | `TZ=America/New_York` |
| `VERSION` | 実行バージョン番号を上書き | - | `VERSION=1.2.3` |

## データベース設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `SQL_DSN` | データベース接続文字列 | SQLite (data/one-api.db) | MySQL: `SQL_DSN=root:123456@tcp(localhost:3306)/new-api` \| PostgreSQL: `SQL_DSN=postgresql://root:123456@postgres:5432/new-api` |
| `SQL_MAX_IDLE_CONNS` | アイドル接続プール最大接続数 | `100` | `SQL_MAX_IDLE_CONNS=50` |
| `SQL_MAX_OPEN_CONNS` | 接続プール最大オープン接続数 | `1000` | `SQL_MAX_OPEN_CONNS=500` |
| `SQL_MAX_LIFETIME` | 接続最大ライフタイム(分) | `60` | `SQL_MAX_LIFETIME=120` |
| `LOG_SQL_DSN` | ログテーブル独立データベース接続文字列 | - | `LOG_SQL_DSN=root:123456@tcp(localhost:3306)/oneapi_logs` |
| `SQLITE_PATH` | SQLiteデータベースパス | `/path/to/sqlite.db` | `SQLITE_PATH=/var/lib/new-api/new-api.db` |

## キャッシュ設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `REDIS_CONN_STRING` | Redis接続文字列 | - | `REDIS_CONN_STRING=redis://default:redispw@localhost:6379` |
| `REDIS_POOL_SIZE` | Redis接続プールサイズ | `10` | `REDIS_POOL_SIZE=20` |
| `MEMORY_CACHE_ENABLED` | メモリキャッシュを有効にするか | `false` | `MEMORY_CACHE_ENABLED=true` |
| `BATCH_UPDATE_ENABLED` | データベース一括更新集約を有効化 | `false` | `BATCH_UPDATE_ENABLED=true` |
| `BATCH_UPDATE_INTERVAL` | 一括更新集約間隔(秒) | `5` | `BATCH_UPDATE_INTERVAL=10` |

## マルチノードとセキュリティ設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `SESSION_SECRET` | セッションシークレット(マルチマシンデプロイ必須) | - | `SESSION_SECRET=random_string` |
| `CRYPTO_SECRET` | 暗号化シークレット(データベース内容の暗号化) | - | `CRYPTO_SECRET=your_crypto_secret` |
| `FRONTEND_BASE_URL` | フロントエンドベースURL | - | `FRONTEND_BASE_URL=https://your-domain.com` |
| `SYNC_FREQUENCY` | キャッシュとデータベースの同期頻度(秒) | `60` | `SYNC_FREQUENCY=60` |
| `NODE_TYPE` | ノードタイプ | `master` | `NODE_TYPE=slave` |

!!! info "クラスターデプロイメント"
    これらの環境変数を使用して完全なクラスターデプロイメントを構築する方法については、[クラスターデプロイメントガイド](cluster-deployment.md)を参照してください。

## ユーザーおよびトークン設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `GENERATE_DEFAULT_TOKEN` | 新規登録ユーザーに初期トークンを生成 | `false` | `GENERATE_DEFAULT_TOKEN=true` |
| `NOTIFICATION_LIMIT_DURATION_MINUTE` | 通知制限の持続時間(分) | `10` | `NOTIFICATION_LIMIT_DURATION_MINUTE=15` |
| `NOTIFY_LIMIT_COUNT` | 指定された持続時間内の最大通知数 | `2` | `NOTIFY_LIMIT_COUNT=3` |

## リクエスト制限設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `GLOBAL_API_RATE_LIMIT` | グローバルAPIレート制限(単一IP 3分間) | `180` | `GLOBAL_API_RATE_LIMIT=100` |
| `GLOBAL_WEB_RATE_LIMIT` | グローバルWebレート制限(単一IP 3分間) | `60` | `GLOBAL_WEB_RATE_LIMIT=30` |
| `RELAY_TIMEOUT` | リレーリクエストタイムアウト時間(秒) | `0` | `RELAY_TIMEOUT=60` |
| `STREAMING_TIMEOUT` | ストリーミング一回応答のタイムアウト時間(秒) | `300` | `STREAMING_TIMEOUT=120` |
| `MAX_FILE_DOWNLOAD_MB` | 最大ファイルダウンロードサイズ(MB) | `20` | `MAX_FILE_DOWNLOAD_MB=50` |
| `GLOBAL_API_RATE_LIMIT_ENABLE` | グローバルAPIレート制限スイッチ | `true` | `GLOBAL_API_RATE_LIMIT_ENABLE=false` |
| `GLOBAL_API_RATE_LIMIT_DURATION` | グローバルAPIレート制限ウィンドウ(秒) | `180` | `GLOBAL_API_RATE_LIMIT_DURATION=120` |
| `GLOBAL_WEB_RATE_LIMIT_ENABLE` | グローバルWebレート制限スイッチ | `true` | `GLOBAL_WEB_RATE_LIMIT_ENABLE=false` |
| `GLOBAL_WEB_RATE_LIMIT_DURATION` | グローバルWebレート制限ウィンドウ(秒) | `180` | `GLOBAL_WEB_RATE_LIMIT_DURATION=120` |
| `CRITICAL_RATE_LIMIT_ENABLE` | クリティカル操作レート制限スイッチ | `true` | `CRITICAL_RATE_LIMIT_ENABLE=false` |
| `CRITICAL_RATE_LIMIT` | クリティカル操作レート制限回数 | `20` | `CRITICAL_RATE_LIMIT=10` |
| `CRITICAL_RATE_LIMIT_DURATION` | クリティカル操作レート制限ウィンドウ(秒) | `1200` | `CRITICAL_RATE_LIMIT_DURATION=600` |

!!! warning "RELAY_TIMEOUT 設定警告"
    `RELAY_TIMEOUT` 環境変数を設定する際は注意してください。短すぎると以下の問題が発生する可能性があります：

    - アップストリームAPIがリクエストを完了し課金されたにもかかわらず、ローカルでタイムアウトにより課金が完了しない
    - 課金が非同期になり、システム損失を引き起こす可能性がある
    
    - ご自身で何をされているか理解している場合を除き、設定しないことを推奨します

## チャネル管理設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `CHANNEL_UPDATE_FREQUENCY` | 定期的なチャネル残高更新(分) | - | `CHANNEL_UPDATE_FREQUENCY=1440` |
| `CHANNEL_TEST_FREQUENCY` | 定期的なチャネルチェック(分) | - | `CHANNEL_TEST_FREQUENCY=1440` |
| `POLLING_INTERVAL` | チャネル一括更新時のリクエスト間隔(秒) | `0` | `POLLING_INTERVAL=5` |

## モデルとリクエスト処理設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `FORCE_STREAM_OPTION` | クライアントのstream_optionsパラメータを上書き | `true` | `FORCE_STREAM_OPTION=false` |
| `GET_MEDIA_TOKEN` | 画像トークンをカウントするか | `true` | `GET_MEDIA_TOKEN=false` |
| `GET_MEDIA_TOKEN_NOT_STREAM` | 非ストリームモードで画像トークンをカウントするか | `false` | `GET_MEDIA_TOKEN_NOT_STREAM=false` |
| `UPDATE_TASK` | 非同期タスク(MJ、Suno)を更新するか | `true` | `UPDATE_TASK=false` |
| `CountToken` | テキストトークンをカウントするか | `true` | `CountToken=false` |
| `TASK_PRICE_PATCH` | タスク価格パッチ(カンマ区切り) | `""` | `TASK_PRICE_PATCH=suno=0.8,mj=1.2` |


## 特定モデル設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `AZURE_DEFAULT_API_VERSION` | AzureチャネルデフォルトAPIバージョン | `2025-04-01-preview` | `AZURE_DEFAULT_API_VERSION=2023-05-15` |
| `COHERE_SAFETY_SETTING` | Cohereモデル安全設定 | `NONE` | `COHERE_SAFETY_SETTING=CONTEXTUAL` |
| `GEMINI_VISION_MAX_IMAGE_NUM` | Geminiモデル最大画像数 | `16` | `GEMINI_VISION_MAX_IMAGE_NUM=8` |
| `DIFY_DEBUG` | Difyチャネルのワークフローとノード情報を出力 | `true` | `DIFY_DEBUG=false` |

## その他の設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `ERROR_LOG_ENABLED` | エラーログを記録し、フロントエンドに表示するか | false | `ERROR_LOG_ENABLED=true` |

## 分析統計

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `UMAMI_WEBSITE_ID` | UmamiサイトID | - | `UMAMI_WEBSITE_ID=xxxx-xxxx` |
| `UMAMI_SCRIPT_URL` | Umamiスクリプトアドレス | `https://analytics.umami.is/script.js` | `UMAMI_SCRIPT_URL=https://umami.example.com/script.js` |
| `GOOGLE_ANALYTICS_ID` | Google AnalyticsサイトID | - | `GOOGLE_ANALYTICS_ID=G-XXXXXXX` |

## メタデータ同期

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `SYNC_UPSTREAM_BASE` | モデル/ベンダーメタデータアップストリームアドレス | `https://basellm.github.io/llm-metadata` | `SYNC_UPSTREAM_BASE=https://mirror.example.com/llm-metadata` |
| `SYNC_HTTP_TIMEOUT_SECONDS` | 同期HTTPタイムアウト(秒) | `10` | `SYNC_HTTP_TIMEOUT_SECONDS=15` |
| `SYNC_HTTP_RETRY` | 同期リトライ回数 | `3` | `SYNC_HTTP_RETRY=5` |
| `SYNC_HTTP_MAX_MB` | 応答ボディ最大サイズ(MB) | `10` | `SYNC_HTTP_MAX_MB=20` |

## フロントエンド設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `VITE_REACT_APP_SERVER_URL` | フロントエンドがバックエンドにリクエストするベースアドレス | - | `VITE_REACT_APP_SERVER_URL=https://api.example.com` |

## 非推奨の環境変数

以下の環境変数は非推奨となりました。システム設定画面の対応するオプションを使用してください：

| 環境変数 | 代替方法 |
|---------|--------|
| `GEMINI_MODEL_MAP` | システム設定 - モデル関連設定で設定してください |
| `GEMINI_SAFETY_SETTING` | システム設定 - モデル関連設定で設定してください |

## マルチマシンデプロイメントの例

マルチマシンデプロイメントのシナリオでは、以下の環境変数を設定する必要があります：

### マスターノード設定

```env
# データベース設定 - リモートデータベースを使用
SQL_DSN=root:password@tcp(db-server:3306)/oneapi

# セキュリティ設定
SESSION_SECRET=your_unique_session_secret
CRYPTO_SECRET=your_unique_crypto_secret

# Redisキャッシュ設定
REDIS_CONN_STRING=redis://default:password@redis-server:6379
```

### スレーブノード設定

```env
# データベース設定 - 同じリモートデータベースを使用
SQL_DSN=root:password@tcp(db-server:3306)/oneapi

# セキュリティ設定 - マスターノードと同じキーを使用
SESSION_SECRET=your_unique_session_secret
CRYPTO_SECRET=your_unique_crypto_secret

# Redisキャッシュ設定 - マスターノードと同じRedisを使用
REDIS_CONN_STRING=redis://default:password@redis-server:6379

# ノードタイプ設定
NODE_TYPE=slave

# オプション：フロントエンドベースURL
FRONTEND_BASE_URL=https://your-domain.com

# オプション：同期頻度
SYNC_FREQUENCY=60
```

!!! tip "完全なクラスター設定"
    これは基本的なマルチノード設定の例にすぎません。完全なクラスターデプロイメント設定、アーキテクチャの説明、およびベストプラクティスについては、[クラスターデプロイメントガイド](cluster-deployment.md)を参照してください。

## Docker Composeにおける環境変数設定例

以下は、Docker Compose設定ファイル内で環境変数を設定する簡単な例です:

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

完全なDocker Compose設定、およびその他の環境変数設定オプションについては、[Docker Compose設定説明](docker-compose-yml.md)ドキュメントを参照してください。

## LinuxDo 関連

通常、変更する必要はありません

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `LINUX_DO_TOKEN_ENDPOINT` | LinuxDoトークンエンドポイント | `https://connect.linux.do/oauth2/token` | `LINUX_DO_TOKEN_ENDPOINT=https://connect.linux.do/oauth2/token` |
| `LINUX_DO_USER_ENDPOINT` | LinuxDoユーザーエンドポイント | `https://connect.linux.do/api/user` | `LINUX_DO_USER_ENDPOINT=https://connect.linux.do/api/user` |   

## デバッグ関連

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `ENABLE_PPROF` | pprofパフォーマンス分析を有効化 | `false` | `ENABLE_PPROF=true` |
| `DEBUG` | デバッグモードを有効化 | `false` | `DEBUG=true` | 
| `GIN_MODE` | Gin実行モード | - | `GIN_MODE=release` |
# 環境変数設定ガイド

このドキュメントでは、New APIがサポートするすべての環境変数とその設定について説明します。これらの環境変数を設定することで、システムの動作をカスタマイズできます。

!!! tip "ヒント"
    New API は、`.env` ファイルから環境変数を読み込むことをサポートしています。`.env.example` ファイルを参照し、使用する際は `.env` にリネームしてください。

## 基本設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `PORT` | サービスリスニングポート | `3000` | `PORT=8080` |
| `TZ` | タイムゾーン設定 | `Asia/Shanghai` | `TZ=America/New_York` |

## データベース設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `SQL_DSN` | データベース接続文字列 | SQLite (data/one-api.db) | MySQL: `SQL_DSN=root:123456@tcp(localhost:3306)/new-api` \| PostgreSQL: `SQL_DSN=postgresql://root:123456@postgres:5432/new-api` |
| `SQL_MAX_IDLE_CONNS` | アイドル接続プール最大接続数 | `100` | `SQL_MAX_IDLE_CONNS=50` |
| `SQL_MAX_OPEN_CONNS` | 接続プール最大オープン接続数 | `1000` | `SQL_MAX_OPEN_CONNS=500` |
| `SQL_CONN_MAX_LIFETIME` | 接続の最大ライフタイム（分） | `60` | `SQL_CONN_MAX_LIFETIME=120` |
| `LOG_SQL_DSN` | ログテーブル独立データベース接続文字列 | - | `LOG_SQL_DSN=root:123456@tcp(localhost:3306)/oneapi_logs` |
| `SQLITE_BUSY_TIMEOUT` | SQLiteロック待機タイムアウト（ミリ秒） | `3000` | `SQLITE_BUSY_TIMEOUT=5000` |

## キャッシュ設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `REDIS_CONN_STRING` | Redis接続文字列 | - | `REDIS_CONN_STRING=redis://default:redispw@localhost:6379` |
| `MEMORY_CACHE_ENABLED` | インメモリキャッシュを有効にするかどうか | `false` | `MEMORY_CACHE_ENABLED=true` |
| `REDIS_CONN_POOL_SIZE` | Redis接続プールサイズ | - | `REDIS_CONN_POOL_SIZE=10` |
| `REDIS_PASSWORD` | Redisクラスターまたはセンチネルモードのパスワード | - | `REDIS_PASSWORD=your_password` |
| `REDIS_MASTER_NAME` | Redisセンチネルモードのマスターノード名 | - | `REDIS_MASTER_NAME=mymaster` |
| `BATCH_UPDATE_ENABLED` | データベース一括更新の集約を有効にする | `false` | `BATCH_UPDATE_ENABLED=true` |
| `BATCH_UPDATE_INTERVAL` | 一括更新集約の時間間隔（秒） | `5` | `BATCH_UPDATE_INTERVAL=10` |

## マルチノードとセキュリティ設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `SESSION_SECRET` | セッションキー（マルチサーバーデプロイに必須） | - | `SESSION_SECRET=random_string` |
| `CRYPTO_SECRET` | 暗号化キー（データベースコンテンツの暗号化） | - | `CRYPTO_SECRET=your_crypto_secret` |
| `FRONTEND_BASE_URL` | フロントエンドベースURL | - | `FRONTEND_BASE_URL=https://your-domain.com` |
| `SYNC_FREQUENCY` | キャッシュとデータベースの同期頻度（秒） | `600` | `SYNC_FREQUENCY=60` |
| `NODE_TYPE` | ノードタイプ | `master` | `NODE_TYPE=slave` |
| `INITIAL_ROOT_TOKEN` | 初回起動時に作成されるrootユーザーのトークン | - | `INITIAL_ROOT_TOKEN=your_token` |
| `INITIAL_ROOT_ACCESS_TOKEN` | 初回起動時に作成されるシステム管理トークン | - | `INITIAL_ROOT_ACCESS_TOKEN=your_token` |

!!! info "クラスターデプロイ"
    これらの環境変数を使用して完全なクラスターデプロイを構築する方法については、[集群部署指南](cluster-deployment.md)を参照してください。

## ユーザーおよびトークン設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `DEFAULT_QUOTA` | 新規ユーザーのデフォルトクォータ | `0` | `DEFAULT_QUOTA=10` |
| `GLOBAL_USER_QUOTA` | グローバルユーザーのクォータ制限 | - | `GLOBAL_USER_QUOTA=100` |
| `GENERATE_DEFAULT_TOKEN` | 新規登録ユーザー向けに初期トークンを生成する | `false` | `GENERATE_DEFAULT_TOKEN=true` |
| `NOTIFICATION_LIMIT_DURATION_MINUTE` | 通知制限の継続時間（分） | `10` | `NOTIFICATION_LIMIT_DURATION_MINUTE=15` |
| `NOTIFY_LIMIT_COUNT` | 指定された継続時間内の最大通知数 | `2` | `NOTIFY_LIMIT_COUNT=3` |

## リクエスト制限設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `GLOBAL_API_RATE_LIMIT` | グローバルAPIレート制限（単一IP、3分間） | `180` | `GLOBAL_API_RATE_LIMIT=100` |
| `GLOBAL_WEB_RATE_LIMIT` | グローバルWebレート制限（単一IP、3分間） | `60` | `GLOBAL_WEB_RATE_LIMIT=30` |
| `RELAY_TIMEOUT` | リレーリクエストのタイムアウト時間（秒） | - | `RELAY_TIMEOUT=60` |
| `USER_CONTENT_REQUEST_TIMEOUT` | ユーザーコンテンツダウンロードのタイムアウト時間（秒） | - | `USER_CONTENT_REQUEST_TIMEOUT=30` |
| `STREAMING_TIMEOUT` | ストリーミングの1回あたりの応答タイムアウト時間（秒） | `60` | `STREAMING_TIMEOUT=120` |
| `MAX_FILE_DOWNLOAD_MB` | 最大ファイルダウンロードサイズ（MB） | `20` | `MAX_FILE_DOWNLOAD_MB=50` |

!!! warning "RELAY_TIMEOUT 設定の警告"
    環境変数 `RELAY_TIMEOUT` を設定する際は注意してください。短すぎる設定は以下の問題を引き起こす可能性があります：

    - アップストリームAPIがリクエストを完了し課金済みであるにもかかわらず、ローカルでタイムアウトにより課金が完了しない

    - 課金の不一致を引き起こし、システム損失につながる可能性がある
    
    - ご自身で何をしているか理解している場合を除き、設定しないことを推奨します

## チャネル管理設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `CHANNEL_UPDATE_FREQUENCY` | 定期的なチャネル残高の更新（分） | - | `CHANNEL_UPDATE_FREQUENCY=1440` |
| `CHANNEL_TEST_FREQUENCY` | 定期的なチャネルのチェック（分） | - | `CHANNEL_TEST_FREQUENCY=1440` |
| `POLLING_INTERVAL` | チャネルを一括更新する際のリクエスト間隔（秒） | `0` | `POLLING_INTERVAL=5` |
| `ENABLE_METRIC` | リクエスト成功率に基づいてチャネルを無効にするかどうか | `false` | `ENABLE_METRIC=true` |
| `METRIC_QUEUE_SIZE` | リクエスト成功率統計キューサイズ | `10` | `METRIC_QUEUE_SIZE=20` |
| `METRIC_SUCCESS_RATE_THRESHOLD` | リクエスト成功率のしきい値 | `0.8` | `METRIC_SUCCESS_RATE_THRESHOLD=0.7` |
| `TEST_PROMPT` | モデルテスト時のユーザープロンプト | `Print your model name exactly...` | `TEST_PROMPT=Hello` |

<!-- ## 🔄 代理配置

| 环境变量 | 说明 | 默认值 | 示例 |
|---------|------|-------|------|
| `RELAY_PROXY` | 中继请求使用的代理 | - | `RELAY_PROXY=http://127.0.0.1:7890` |
| `USER_CONTENT_REQUEST_PROXY` | 用户内容请求使用的代理 | - | `USER_CONTENT_REQUEST_PROXY=http://127.0.0.1:7890` | -->

## モデルとリクエスト処理設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `FORCE_STREAM_OPTION` | クライアントのstream_optionsパラメータを上書きする | `true` | `FORCE_STREAM_OPTION=false` |
| `GET_MEDIA_TOKEN` | 画像トークンをカウントするかどうか | `true` | `GET_MEDIA_TOKEN=false` |
| `GET_MEDIA_TOKEN_NOT_STREAM` | 非ストリームモードで画像トークンをカウントするかどうか | `true` | `GET_MEDIA_TOKEN_NOT_STREAM=false` |
| `UPDATE_TASK` | 非同期タスク（MJ、Suno）を更新するかどうか | `true` | `UPDATE_TASK=false` |
| `ENFORCE_INCLUDE_USAGE` | ストリームモードでusageの返却を強制する | `false` | `ENFORCE_INCLUDE_USAGE=true` |
| `TIKTOKEN_CACHE_DIR` | Tiktokenエンコーダーキャッシュディレクトリ。トークン分割ファイルを格納し、ネットワークダウンロードを回避するために使用 | - | `TIKTOKEN_CACHE_DIR=/cache/tiktoken` |
| `DATA_GYM_CACHE_DIR` | DataGymキャッシュディレクトリ | - | `DATA_GYM_CACHE_DIR=/cache/data_gym` |

!!! tip "Tiktokenファイル設定"
    tiktokenファイルをダウンロードした後、以下の方法でリネームしてください：

    - `cl100k_base.tiktoken` を `9b5ad71b2ce5302211f9c61530b329a4922fc6a4` にリネーム
    
    - `o200k_base.tiktoken` を `fb374d419588a4632f3f557e76b4b70aebbca790` にリネーム
    
    これらのファイルは、トークン計算のパフォーマンスを向上させ、ネットワーク依存を減らすために、`TIKTOKEN_CACHE_DIR`で指定されたディレクトリに配置する必要があります。

!!! example "Tiktoken設定例"
    ```bash
    # Docker環境の例
    TIKTOKEN_CACHE_DIR=/app/data/tiktoken
    
    # その後、tiktokenファイルをダウンロードしてリネームし、このディレクトリに配置します：
    /app/data/tiktoken/9b5ad71b2ce5302211f9c61530b329a4922fc6a4
    /app/data/tiktoken/fb374d419588a4632f3f557e76b4b70aebbca790
    ```
    
    TiktokenはOpenAIが使用するトークナイザーであり、テキストのトークン数を計算するために使用されます。これらのファイルをローカルにキャッシュすることで、システム起動のたびにネットワークからダウンロードすることを回避し、特にネットワークが制限された環境での安定性とパフォーマンスを向上させることができます。

## 特定モデル設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `AZURE_DEFAULT_API_VERSION` | AzureチャネルのデフォルトAPIバージョン | `2024-12-01-preview` | `AZURE_DEFAULT_API_VERSION=2023-05-15` |
| `COHERE_SAFETY_SETTING` | Cohereモデルのセキュリティ設定 | `NONE` | `COHERE_SAFETY_SETTING=CONTEXTUAL` |
| `GEMINI_VISION_MAX_IMAGE_NUM` | Geminiモデルの最大画像数 | `16` | `GEMINI_VISION_MAX_IMAGE_NUM=8` |
| `GEMINI_VERSION` | Geminiバージョン | `v1` | `GEMINI_VERSION=v1beta` |
| `DIFY_DEBUG` | Difyチャネルのワークフローとノード情報の出力 | `true` | `DIFY_DEBUG=false` |

## その他の設定

| 環境変数 | 説明 | デフォルト値 | 例 |
|---------|------|-------|------|
| `EMAIL_SERVER` | メールサーバー設定 | - | `EMAIL_SERVER=smtp.example.com:25` |
| `EMAIL_FROM` | メール送信元アドレス | - | `EMAIL_FROM=noreply@example.com` |
| `EMAIL_PASSWORD` | メールサーバーパスワード | - | `EMAIL_PASSWORD=yourpassword` |
| `ERROR_LOG_ENABLED` | エラーログを記録し、フロントエンドに表示するかどうか | false | `ERROR_LOG_ENABLED=true` |

## 非推奨の環境変数

以下の環境変数は非推奨となりました。システム設定画面の対応するオプションを使用してください：

| 環境変数 | 代替方法 |
|---------|--------|
| `GEMINI_MODEL_MAP` | システム設定 - モデル関連設定で設定してください |
| `GEMINI_SAFETY_SETTING` | システム設定 - モデル関連設定で設定してください |

## マルチサーバーデプロイの例

マルチサーバーデプロイのシナリオでは、以下の環境変数を設定する必要があります：

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
    これは基本的なマルチノード設定の例にすぎません。完全なクラスターデプロイ設定、アーキテクチャの説明、およびベストプラクティスについては、[集群部署指南](cluster-deployment.md)を参照してください。

## Docker Composeにおける環境変数の例

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

より多くの環境変数設定オプションを含む完全なDocker Compose設定については、[Docker Compose配置说明](docker-compose-yml.md)ドキュメントを参照してください。
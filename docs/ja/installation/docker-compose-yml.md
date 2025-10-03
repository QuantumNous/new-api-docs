# Docker Compose 設定ガイド

本ドキュメントでは、New APIのDocker Compose設定オプションについて詳しく説明します。これらは様々なデプロイメントシナリオで使用できます。

## 基本的な設定構造

Docker Compose設定ファイルである `docker-compose.yml` は、New APIサービスおよびその依存サービス（MySQL、Redisなど）のデプロイ方法を定義します。

## 標準設定（本番環境推奨）

以下は、ほとんどの本番環境に適した標準的なDocker Compose設定です。

```yaml
# New-API Docker Compose Configuration
# 
# Quick Start:
#   1. docker-compose up -d
#   2. Access at http://localhost:3000
#
# Using MySQL instead of PostgreSQL:
#   1. Comment out the postgres service and SQL_DSN line 15
#   2. Uncomment the mysql service and SQL_DSN line 16
#   3. Uncomment mysql in depends_on (line 28)
#   4. Uncomment mysql_data in volumes section (line 64)
#
# ⚠️  IMPORTANT: Change all default passwords before deploying to production!

version: '3.4' # For compatibility with older Docker versions

services:
  new-api:
    image: calciumion/new-api:latest
    container_name: new-api
    restart: always
    command: --log-dir /app/logs
    ports:
      - "3000:3000"
    volumes:
      - ./data:/data
      - ./logs:/app/logs
    environment:
      - SQL_DSN=postgresql://root:123456@postgres:5432/new-api # ⚠️ IMPORTANT: Change the password in production!
#      - SQL_DSN=root:123456@tcp(mysql:3306)/new-api  # Point to the mysql service, uncomment if using MySQL
      - REDIS_CONN_STRING=redis://redis
      - TZ=Asia/Shanghai
      - ERROR_LOG_ENABLED=true # エラーログ記録を有効にするかどうか
      - BATCH_UPDATE_ENABLED=true  # バッチ更新を有効にするかどうか batch update enabled
#      - STREAMING_TIMEOUT=300  # ストリーミングモードでの無応答タイムアウト時間（秒単位）。デフォルトは120秒。空の補完が発生する場合は、より大きな値に設定してみてください Streaming timeout in seconds, default is 120s. Increase if experiencing empty completions
#      - SESSION_SECRET=random_string  # マルチノードデプロイメント時に設定。このランダムな文字列を必ず変更してください！！ multi-node deployment, set this to a random string!!!!!!!
#      - SYNC_FREQUENCY=60  # Uncomment if regular database syncing is needed

    depends_on:
      - redis
      - postgres
#      - mysql  # Uncomment if using MySQL
    healthcheck:
      test: ["CMD-SHELL", "wget -q -O - http://localhost:3000/api/status | grep -o '\"success\":\\s*true' || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3

  redis:
    image: redis:latest
    container_name: redis
    restart: always

  postgres:
    image: postgres:15
    container_name: postgres
    restart: always
    environment:
      POSTGRES_USER: root
      POSTGRES_PASSWORD: 123456  # ⚠️ IMPORTANT: Change this password in production!
      POSTGRES_DB: new-api
    volumes:
      - pg_data:/var/lib/postgresql/data
#    ports:
#      - "5432:5432"  # Uncomment if you need to access PostgreSQL from outside Docker

#  mysql:
#    image: mysql:8.2
#    container_name: mysql
#    restart: always
#    environment:
#      MYSQL_ROOT_PASSWORD: 123456  # ⚠️ IMPORTANT: Change this password in production!
#      MYSQL_DATABASE: new-api
#    volumes:
#      - mysql_data:/var/lib/mysql
#    ports:
#      - "3306:3306"  # Uncomment if you need to access MySQL from outside Docker

volumes:
  pg_data:
#  mysql_data:

```

## 簡易設定（テスト環境向け）

テスト目的でのみ使用する場合は、New APIサービス自体のみを含む以下の簡易バージョンを採用できます。

```yaml
services:
  new-api:
    image: calciumion/new-api:latest
    container_name: new-api
    restart: always
    ports:
      - "3000:3000"
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./data:/data
```

## 設定の詳細

### New APIサービス設定

| パラメータ | 説明 |
|------|------|
| `image` | イメージ名。通常、最新バージョンを取得するために`calciumion/new-api:latest`を使用します |
| `container_name` | コンテナ名。カスタマイズ可能です |
| `restart` | コンテナの再起動ポリシー。サービスの自動再起動を確実にするため、`always`に設定することを推奨します |
| `command` | 起動コマンド。起動パラメータをカスタマイズできます |
| `ports` | ポートマッピング。デフォルトでは、コンテナ内のポート3000をホストのポート3000にマッピングします |
| `volumes` | データボリュームマッピング。データの永続化を保証します |
| `environment` | 環境変数設定。New APIの動作を設定するために使用されます |
| `depends_on` | 依存サービス。正しい順序で起動することを保証します |
| `healthcheck` | ヘルスチェック設定。サービスの状態を監視するために使用されます |

### 環境変数の説明

New APIは様々な環境変数設定をサポートしており、以下は一般的に使用されるものです。

| 環境変数 | 説明 | 例 |
|---------|------|------|
| `SQL_DSN` | データベース接続文字列 | `root:123456@tcp(mysql:3306)/new-api` |
| `REDIS_CONN_STRING` | Redis接続文字列 | `redis://redis` |
| `TZ` | タイムゾーン設定 | `Asia/Shanghai` |
| `SESSION_SECRET` | セッションシークレット（マルチノードデプロイメントで必須） | `your_random_string` |
| `NODE_TYPE` | ノードタイプ（マスター/スレーブ） | `master`または`slave` |
| `SYNC_FREQUENCY` | 同期頻度（秒） | `60` |

より完全な環境変数リストについては、[環境変数設定ガイド](environment-variables.md)を参照してください。

## マルチノードデプロイメント設定

マルチノードデプロイメントのシナリオでは、マスターノードとスレーブノードの設定はわずかに異なります。

### マスターノード設定

```yaml
services:
  new-api-master:
    image: calciumion/new-api:latest
    container_name: new-api-master
    restart: always
    ports:
      - "3000:3000"
    environment:
      - SQL_DSN=root:123456@tcp(mysql:3306)/new-api
      - REDIS_CONN_STRING=redis://redis
      - SESSION_SECRET=your_unique_session_secret
      - CRYPTO_SECRET=your_unique_crypto_secret
      - TZ=Asia/Shanghai
    volumes:
      - ./data:/data
```

### スレーブノード設定

```yaml
services:
  new-api-slave:
    image: calciumion/new-api:latest
    container_name: new-api-slave
    restart: always
    ports:
      - "3001:3000"  # ポートマッピングが異なることに注意
    environment:
      - SQL_DSN=root:123456@tcp(mysql:3306)/new-api
      - REDIS_CONN_STRING=redis://redis
      - SESSION_SECRET=your_unique_session_secret  # マスターノードと同じである必要があります
      - CRYPTO_SECRET=your_unique_crypto_secret  # マスターノードと同じである必要があります
      - NODE_TYPE=slave  # スレーブノードとして設定
      - SYNC_FREQUENCY=60
      - TZ=Asia/Shanghai
    volumes:
      - ./data-slave:/data
```

## 使用方法

### インストール

設定を`docker-compose.yml`ファイルとして保存し、同じディレクトリ内で以下を実行します。

```bash
docker compose up -d
```

### ログの確認

```bash
docker compose logs -f
```

### サービスの停止

```bash
docker compose down
```

!!! tip "ヒント"
    Docker Composeのより詳細な使用方法については、[Docker Composeインストールガイド](docker-compose-installation.md)を参照してください。
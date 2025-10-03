# クラスターデプロイメントガイド

本ドキュメントは、New API クラスターデプロイメントの詳細な設定手順とベストプラクティスを提供し、高可用性、負荷分散された分散システムを構築するのに役立ちます。

## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| レート | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーへのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格レートに影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

## 前提条件

- 複数のサーバー（最低2台、マスター・スレーブ構成）
- Docker および Docker Compose がインストールされていること
- 共有MySQLデータベース（マスターノードとスレーブノードは同じデータベースにアクセスする必要があります）
- 共有Redisサービス（ノード間のデータ同期とキャッシュに使用）
- オプション：ロードバランサー（Nginx、HAProxy、またはクラウドプロバイダーが提供するロードバランシングサービスなど）

## クラスターアーキテクチャの概要

New API クラスターはマスター・スレーブアーキテクチャ設計を採用しています。

1. **マスターノード**：すべての書き込み操作と一部の読み取り操作の処理を担当
2. **スレーブノード**：主に読み取り操作の処理を担当し、システム全体の処理能力を向上させる

![集群架构](../assets/cluster-architecture.svg)

## クラスターデプロイメントの主要な設定

クラスターデプロイメントの鍵は、すべてのノードが以下を満たすことです。

1. **同じデータベースを共有する**：すべてのノードが同じMySQLデータベースにアクセスする
2. **同じRedisを共有する**：キャッシュとノード間通信に使用する
3. **同じシークレットキーを使用する**：`SESSION_SECRET` と `CRYPTO_SECRET` はすべてのノードで同じである必要があります
4. **ノードタイプを正しく設定する**：マスターノードは `master`、スレーブノードは `slave`

## デプロイメント手順

### ステップ1：共有データベースとRedisの準備

まず、共有のMySQLデータベースとRedisサービスを準備する必要があります。これらは以下のいずれかです。

- 個別にデプロイされた高可用性MySQLおよびRedisサービス
- クラウドプロバイダーが提供するマネージドデータベースおよびキャッシュサービス
- 独立したサーバーで実行されているMySQLおよびRedis

MySQL データベースについては、以下のアーキテクチャスキームを選択できます。

| アーキテクチャタイプ | コンポーネント構成 | 動作方式 | アプリケーション設定方式 |
|---------|----------|----------|-------------|
| **マスター・スレーブレプリケーションアーキテクチャ** | マスターDB 1つ<br>スレーブDB N個 | マスターDBが書き込みを処理<br>スレーブDBが読み取りを処理<br>マスター・スレーブ間でデータが自動同期 | マスターDBアドレスを `SQL_DSN` として設定 |
| **データベースクラスターアーキテクチャ** | 複数の対等ノード<br>プロキシ層(ProxySQL/MySQL Router) | すべてのノードで読み書きが可能<br>プロキシ層を通じて負荷分散を実現<br>自動フェイルオーバー | プロキシ層のアドレスを `SQL_DSN` として設定 |

!!! warning "重要事項"
    どのアーキテクチャを選択しても、アプリケーションの `SQL_DSN` 設定には、統一された単一のエントリポイントアドレスのみが必要です。

これらのサービスがすべてのノードからアクセス可能であり、十分なパフォーマンスと信頼性を備えていることを確認してください。

### ステップ2：マスターノードの設定

マスターノードサーバー上に `docker-compose.yml` ファイルを作成します。

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
      # 以下はオプション設定
      - SYNC_FREQUENCY=60  # 同期頻度（秒単位）
      - FRONTEND_BASE_URL=https://your-domain.com  # フロントエンドのベースURL（メール通知機能などに使用）
    volumes:
      - ./data:/data
      - ./logs:/app/logs
```

!!! warning "セキュリティに関する注意"
    強力なパスワードとランダムに生成されたシークレット文字列を使用して、上記設定のサンプル値を置き換えてください。

マスターノードの起動：

```bash
docker compose up -d
```

### ステップ3：スレーブノードの設定

各スレーブノードサーバー上に `docker-compose.yml` ファイルを作成します。

```yaml
services:
  new-api-slave:
    image: calciumion/new-api:latest
    container_name: new-api-slave
    restart: always
    ports:
      - "3000:3000"  # 異なるサーバー上にあるため、マスターノードと同じポートを使用できます
    environment:
      - SQL_DSN=root:password@tcp(your-db-host:3306)/new-api  # マスターノードと同じ
      - REDIS_CONN_STRING=redis://default:password@your-redis-host:6379  # マスターノードと同じ
      - SESSION_SECRET=your_unique_session_secret  # マスターノードと一致させる必要があります
      - CRYPTO_SECRET=your_unique_crypto_secret  # マスターノードと一致させる必要があります
      - NODE_TYPE=slave  # 重要な設定。スレーブノードとして指定
      - SYNC_FREQUENCY=60  # スレーブノードとマスターノードの同期頻度（秒単位）
      - TZ=Asia/Shanghai
      # 以下はオプション設定
      - FRONTEND_BASE_URL=https://your-domain.com  # マスターノードと一致させる必要があります
    volumes:
      - ./data:/data
      - ./logs:/app/logs
```

スレーブノードの起動：

```bash
docker compose up -d
```

各スレーブノードサーバーでこの手順を繰り返します。

### ステップ4：ロードバランサーの設定

トラフィックの均等な分散を実現するために、ロードバランサーを設定する必要があります。以下は、Nginx をロードバランサーとして使用する設定例です。

```nginx
upstream new_api_cluster {
    server master-node-ip:3000 weight=3;
    server slave-node1-ip:3000 weight=5;
    server slave-node2-ip:3000 weight=5;
    # さらにスレーブノードを追加可能
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

この設定では、マスターノードの重みを 3 に、スレーブノードの重みを 5 に設定しています。これは、スレーブノードがより多くのリクエストを処理することを意味します。実際の要件に基づいてこれらの重みを調整できます。

## 高度な設定オプション

### データ同期設定

クラスターノード間のデータ同期は、以下の環境変数に依存します。

| 環境変数 | 説明 | 推奨値 |
|---------|------|-------|
| `SYNC_FREQUENCY` | ノード同期頻度（秒） | `60` |
| `BATCH_UPDATE_ENABLED` | バッチ更新を有効化 | `true` |
| `BATCH_UPDATE_INTERVAL` | バッチ更新間隔（秒） | `5` |

### Redis高可用性設定

Redis の可用性を高めるために、Redis クラスターまたは Sentinel モードを設定できます。

```yaml
environment:
  - REDIS_CONN_STRING=redis://your-redis-host:6379
  - REDIS_PASSWORD=your_redis_password
  - REDIS_MASTER_NAME=mymaster  # Sentinelモードでのマスターノード名
  - REDIS_CONN_POOL_SIZE=10     # Redis接続プールサイズ
```

### セッションセキュリティ設定

クラスター内のすべてのノードが同じセッションおよび暗号化キーを使用していることを確認してください。

```yaml
environment:
  - SESSION_SECRET=your_unique_session_secret  # すべてのノードで同じである必要があります
  - CRYPTO_SECRET=your_unique_crypto_secret    # すべてのノードで同じである必要があります
```

## 監視とメンテナンス

### ヘルスチェック

ノードの状態を監視するために、定期的なヘルスチェックを設定します。

```yaml
healthcheck:
  test: ["CMD-SHELL", "wget -q -O - http://localhost:3000/api/status | grep -o '\"success\":\\s*true' | awk -F: '{print $$2}'"]
  interval: 30s
  timeout: 10s
  retries: 3
```

### ログ管理

大規模なクラスターの場合、集中型ログ管理システムの使用を推奨します。

```yaml
environment:
  - LOG_SQL_DSN=root:password@tcp(log-db-host:3306)/new_api_logs  # 独立したログデータベース
```

## スケーリングガイド

ビジネスの成長に伴い、クラスターの規模を拡張する必要がある場合があります。スケーリング手順は以下の通りです。

1. **新しいサーバーの準備**：Docker と Docker Compose をインストールします
2. **スレーブノードの設定**：「ステップ3：スレーブノードの設定」の説明に従って新しいスレーブノードを設定します
3. **ロードバランサー設定の更新**：新しいノードをロードバランサー設定に追加します
4. **新しいノードのテスト**：新しいノードが正常に動作し、負荷分散に参加していることを確認します

## ベストプラクティス

1. **データベースの定期的なバックアップ**：クラスター環境であっても、データベースを定期的にバックアップする必要があります
2. **リソース使用状況の監視**：CPU、メモリ、ディスクの使用状況を綿密に監視します
3. **ローリングアップデート戦略の採用**：更新時には、まずスレーブノードを更新し、安定性を確認してからマスターノードを更新します
4. **アラートシステムの設定**：ノードの状態を監視し、問題が発生した際に管理者へ迅速に通知します
5. **地理的分散デプロイメント**：可能であれば、ノードを異なる地理的場所にデプロイし、可用性を向上させます

## トラブルシューティング

### ノードがデータを同期できない

- Redis 接続が正常であることを確認してください
- `SESSION_SECRET` および `CRYPTO_SECRET` がすべてのノードで同じであることを確認してください
- データベース接続設定が正しいことを検証してください

### 負荷が不均衡である

- ロードバランサーの設定と重み設定を確認してください
- 各ノードのリソース使用状況を監視し、ノードが過負荷になっていないことを確認してください
- ノードの重みを調整するか、ノードを追加する必要がある場合があります

### セッションの損失問題

- すべてのノードが同じ `SESSION_SECRET` を使用していることを確認してください
- Redis の設定が正しく、アクセス可能であることを検証してください
- クライアントが Cookie を正しく処理しているか確認してください

## 関連ドキュメント

- [环境变量配置指南](environment-variables.md) - マルチノードデプロイメントに関連するすべての環境変数を含みます
- [系统更新指南](system-update.md) - マルチノード環境でのシステム更新戦略
- [Docker Compose 配置说明](docker-compose-yml.md) - クラスターノード設定ファイルの作成に使用されます
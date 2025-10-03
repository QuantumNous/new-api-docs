# クラスターデプロイメントガイド

本文書は、New API クラスターデプロイメントの詳細な設定手順とベストプラクティスを提供し、高可用性でロードバランシングされた分散システムの構築を支援します。

## 前提条件

- 複数のサーバー（最低2台、マスター/マルチスレーブアーキテクチャ）
- Docker および Docker Compose がインストール済みであること
- 共有 MySQL データベース（マスターノードとスレーブノードが同じデータベースにアクセスできること）
- 共有 Redis サービス（ノード間のデータ同期とキャッシュに使用）
- オプション：ロードバランサー（Nginx、HAProxy、またはクラウドプロバイダーが提供するロードバランシングサービスなど）

## クラスターアーキテクチャの概要

New API クラスターは、マスター/スレーブアーキテクチャを採用しています。

1. **マスターノード**：すべての書き込み操作と一部の読み取り操作を処理します。
2. **スレーブノード**：主に読み取り操作を処理し、システム全体の処理能力を向上させます。

![集群架构](../assets/cluster-architecture.svg)

## クラスターデプロイメントの主要な設定

クラスターデプロイメントの鍵は、すべてのノードが以下を満たすことです。

1. **同じデータベースを共有する**：すべてのノードが同一の MySQL データベースにアクセスします。
2. **同じ Redis を共有する**：キャッシュおよびノード間通信に使用します。
3. **同じシークレットキーを使用する**：`SESSION_SECRET` と `CRYPTO_SECRET` はすべてのノードで同一である必要があります。
4. **ノードタイプを正しく設定する**：マスターノードは `master`、スレーブノードは `slave` とします。

## デプロイメント手順

### ステップ 1：共有データベースと Redis の準備

まず、共有の MySQL データベースと Redis サービスを準備する必要があります。これには以下の選択肢があります。

- 個別にデプロイされた高可用性 MySQL および Redis サービス
- クラウドプロバイダーが提供するマネージドデータベースおよびキャッシュサービス
- 独立したサーバー上で実行される MySQL および Redis

MySQL データベースについては、以下のアーキテクチャを選択できます。

| 架构类型 | コンポーネント構成 | 動作方式 | アプリケーション設定方法 |
|---------|----------|----------|-------------|
| **主从复制架构** | マスター 1つ<br>スレーブ N個 | マスターが書き込みを処理<br>スレーブが読み取りを処理<br>マスター/スレーブ間でデータが自動同期 | マスターのアドレスを `SQL_DSN` として設定 |
| **数据库集群架构** | 複数のピアノード<br>プロキシ層(ProxySQL/MySQL Router) | すべてのノードが読み書き可能<br>プロキシ層を通じてロードバランシングを実現<br>自動フェイルオーバー | プロキシ層のアドレスを `SQL_DSN` として設定 |

!!! warning "重要"
    どのアーキテクチャを選択しても、アプリケーションの `SQL_DSN` 設定には単一の統一されたエントリポイントアドレスのみが必要です。

これらのサービスがすべてのノードからアクセス可能であり、十分なパフォーマンスと信頼性を備えていることを確認してください。

### ステップ 2：マスターノードの設定

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
      # 以下是可选配置
      - SYNC_FREQUENCY=60  # 同步频率，单位秒
      - FRONTEND_BASE_URL=https://your-domain.com  # 前端基础 URL，用于邮件通知等功能
    volumes:
      - ./data:/data
      - ./logs:/app/logs
```

!!! warning "セキュリティに関する注意"
    強力なパスワードとランダムに生成されたシークレット文字列を使用して、上記設定のサンプル値を置き換えてください。

マスターノードを起動します。

```bash
docker compose up -d
```

### ステップ 3：スレーブノードの設定

各スレーブノードサーバー上に `docker-compose.yml` ファイルを作成します。

```yaml
services:
  new-api-slave:
    image: calciumion/new-api:latest
    container_name: new-api-slave
    restart: always
    ports:
      - "3000:3000"  # 可以与主节点使用相同端口，因为它们在不同服务器上
    environment:
      - SQL_DSN=root:password@tcp(your-db-host:3306)/new-api  # 与主节点相同
      - REDIS_CONN_STRING=redis://default:password@your-redis-host:6379  # 与主节点相同
      - SESSION_SECRET=your_unique_session_secret  # 必须与主节点相同
      - CRYPTO_SECRET=your_unique_crypto_secret  # 必须与主节点相同
      - NODE_TYPE=slave  # 关键配置，指定为从节点
      - SYNC_FREQUENCY=60  # 从节点与主节点同步频率，单位秒
      - TZ=Asia/Shanghai
      # 以下是可选配置
      - FRONTEND_BASE_URL=https://your-domain.com  # 需与主节点相同
    volumes:
      - ./data:/data
      - ./logs:/app/logs
```

スレーブノードを起動します。

```bash
docker compose up -d
```

この手順を各スレーブノードサーバーで繰り返します。

### ステップ 4：ロードバランシングの設定

トラフィックを均等に分散するために、ロードバランサーを設定する必要があります。以下は、Nginx をロードバランサーとして使用する場合の設定例です。

```nginx
upstream new_api_cluster {
    server master-node-ip:3000 weight=3;
    server slave-node1-ip:3000 weight=5;
    server slave-node2-ip:3000 weight=5;
    # 可添加更多从节点
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

この設定では、マスターノードの重みを 3、スレーブノードの重みを 5 に設定しています。これは、スレーブノードがより多くのリクエストを処理することを意味します。実際の要件に応じてこれらの重みを調整できます。

## 高度な設定オプション

### データ同期設定

クラスターノード間のデータ同期は、以下の環境変数に依存します。

| 環境変数 | 説明 | 推奨値 |
|---------|------|-------|
| `SYNC_FREQUENCY` | ノード同期頻度（秒） | `60` |
| `BATCH_UPDATE_ENABLED` | バッチ更新を有効にする | `true` |
| `BATCH_UPDATE_INTERVAL` | バッチ更新間隔（秒） | `5` |

### Redis 高可用性設定

Redis の可用性を向上させるために、Redis クラスターまたは Sentinel モードを設定できます。

```yaml
environment:
  - REDIS_CONN_STRING=redis://your-redis-host:6379
  - REDIS_PASSWORD=your_redis_password
  - REDIS_MASTER_NAME=mymaster  # 哨兵模式下的主节点名称
  - REDIS_CONN_POOL_SIZE=10     # Redis 连接池大小
```

### セッションセキュリティ設定

クラスター内のすべてのノードが同じセッションおよび暗号化キーを使用していることを確認してください。

```yaml
environment:
  - SESSION_SECRET=your_unique_session_secret  # 所有节点必须相同
  - CRYPTO_SECRET=your_unique_crypto_secret    # 所有节点必须相同
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
  - LOG_SQL_DSN=root:password@tcp(log-db-host:3306)/new_api_logs  # 独立的日志数据库
```

## スケーリングガイド

ビジネスの成長に伴い、クラスターの規模を拡張する必要がある場合があります。スケーリングの手順は以下の通りです。

1. **新しいサーバーの準備**：Docker と Docker Compose をインストールします。
2. **スレーブノードの設定**：「ステップ 3：スレーブノードの設定」の説明に従って新しいスレーブノードを設定します。
3. **ロードバランサー設定の更新**：新しいノードをロードバランサー設定に追加します。
4. **新しいノードのテスト**：新しいノードが正常に動作し、ロードバランシングに参加していることを確認します。

## ベストプラクティス

1. **データベースの定期的なバックアップ**：クラスター環境であっても、データベースを定期的にバックアップする必要があります。
2. **リソース使用状況の監視**：CPU、メモリ、ディスクの使用状況を注意深く監視します。
3. **ローリングアップデート戦略の採用**：更新時には、まずスレーブノードを更新し、安定性を確認してからマスターノードを更新します。
4. **アラートシステムの設定**：ノードの状態を監視し、問題が発生した際に管理者へ迅速に通知します。
5. **地理的に分散したデプロイメント**：可能であれば、ノードを異なる地理的場所にデプロイし、可用性を向上させます。

## トラブルシューティング

### ノードがデータを同期できない

- Redis 接続が正常であることを確認します。
- `SESSION_SECRET` と `CRYPTO_SECRET` がすべてのノードで同一であることを確認します。
- データベース接続設定が正しいことを検証します。

### 負荷の不均衡

- ロードバランサーの設定と重み付けを確認します。
- 各ノードのリソース使用状況を監視し、過負荷になっているノードがないことを確認します。
- ノードの重みを調整するか、ノードを追加する必要がある場合があります。

### セッション喪失の問題

- すべてのノードが同じ `SESSION_SECRET` を使用していることを確認します。
- Redis の設定が正しく、アクセス可能であることを検証します。
- クライアントが Cookie を正しく処理しているか確認します。

## 関連ドキュメント

- [环境变量配置指南](environment-variables.md) - マルチノードデプロイメントに関連するすべての環境変数を含みます。
- [系统更新指南](system-update.md) - マルチノード環境におけるシステム更新戦略。
- [Docker Compose 配置说明](docker-compose-yml.md) - クラスターノード設定ファイルの作成に使用します。
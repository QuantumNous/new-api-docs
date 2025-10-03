## コアコンセプト (Core Concepts)

| 中文 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数ファクタ | Multiplier factor used for price calculation |
| 令牌 | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| 渠道 | Channel | APIサービスプロバイダーのアクセス経路 | Access channel for API service providers |
| 分组 | Group | ユーザーまたはトークンの分類、価格レートに影響 | Classification of users or tokens, affecting price ratios |
| 额度 | Quota | ユーザーが利用可能なサービス上限 | Available service quota for users |

# Docker Compose インストールガイド

このドキュメントでは、Docker Composeを使用してNew APIをデプロイするための詳細な手順を提供します。

## 前提条件

- DockerおよびDocker Composeがインストールされていること
- 推奨システム: Linux (Ubuntu/CentOS/Debianなど)

## Docker Composeを使用したデプロイ

### 方法1：Gitを使用したプロジェクトのクローン（推奨）

GitHubに正常にアクセスできる場合は、この方法を推奨します。プロジェクトには完全な `docker-compose.yml` 設定ファイルが含まれています：

```shell
# ダウンロードプロジェクトのソースコード
git clone https://github.com/QuantumNous/new-api.git

# プロジェクトディレクトリへ移動
cd new-api

# 必要に応じて docker-compose.yml ファイルを編集
# nanoエディタを使用
nano docker-compose.yml
# またはvimエディタを使用
# vim docker-compose.yml
```

!!! tip "ヒント"
    プロジェクトに付属の `docker-compose.yml` ファイルには、必要なすべてのサービス（MySQLおよびRedisを含む）がすでに設定されています。実際の状況に応じてポートやパスワードなどのパラメータを変更するだけで使用できます。

### 方法2：手動での設定ファイルの作成

GitHubにアクセスできない、またはリポジトリをクローンできない場合は、手動で設定ファイルを作成できます：

1. New APIのデプロイに使用するディレクトリを作成します：

```shell
mkdir new-api
cd new-api
```

1. そのディレクトリ内に`docker-compose.yml`ファイルを作成します

   [Docker Compose設定説明](docker-compose-yml.md)ドキュメント内の設定例を参照し、ニーズに応じて選択できます：
   
   - 本番環境では完全な設定（MySQLとRedisを含む）の使用を推奨します
   - テスト環境では簡略化された設定を使用できます

1. テキストエディタを使用してファイルを作成します：

```shell
# nanoエディタを使用
nano docker-compose.yml

# またはvimエディタを使用
vim docker-compose.yml
```

選択した設定内容をこのファイルにコピーし、必要に応じてカスタマイズして変更します。

## サービスの起動

設定ファイルの準備ができたら、Gitクローンまたは手動作成のどちらの方法を用いた場合でも、以下のコマンドを使用してサービスを起動できます：

```shell
# Docker Composeを使用してサービスを起動
docker compose up -d
```

このコマンドは、必要なイメージを自動的にプルし、バックグラウンドでサービスを起動します。

## ログの確認

- **全サービスのリアルタイムログ**

```bash
docker compose logs -f
```

- **指定したサービスのログ**（例：`new-api`、`mysql`、`redis`）

```bash
docker compose logs -f new-api
docker compose logs -f mysql
docker compose logs -f redis
```

- **直近 N 行のみを表示**

```bash
docker compose logs --tail=100 new-api
```

- **直近一定期間内のログを表示**

```bash
docker compose logs --since=10m new-api
```

- **タイムスタンプを表示**

```bash
docker compose logs -f -t new-api
```

- **フォアグラウンドモードでのデバッグ（起動と同時にリアルタイムでログを出力）**

```bash
docker compose up
# または特定のサービスのみを起動して追跡
docker compose up new-api
```

Ctrl+Cを押すとフォアグラウンドモードを終了します（対応するサービスが停止します）。バックグラウンドで実行するには `-d` を使用してください。

- **サービスリスト/ステータスの確認**

```bash
docker compose ps
```

- **コンテナ名を使用したログの確認**（設定で `container_name` が設定されている場合、例：`new-api`）

```bash
docker logs -f new-api
```

## サービスの停止

```shell
# サービスを停止
docker compose down
```

## システムへのアクセス

サービスの起動が成功した後、`http://サーバーIP:3000` にアクセスすると、自動的に初期化ページに誘導されます。ページの手順に従って、管理者アカウントとパスワードを手動で設定してください（初回インストール時のみ必要）。初期化が完了すると、設定した管理者アカウントを使用してシステムにログインできます。
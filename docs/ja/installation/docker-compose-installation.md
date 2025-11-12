# Docker Compose インストールガイド

本ドキュメントでは、Docker Composeを使用してNew APIをデプロイするための詳細な手順を提供します。

## 前提条件

- DockerおよびDocker Composeがインストールされていること
- 推奨システム: Linux (Ubuntu/CentOS/Debianなど)

## Docker Composeを使用したデプロイ

### 方法1：Gitを使用したプロジェクトのクローン（推奨）

GitHubに正常にアクセスできる場合は、この方法を推奨します。プロジェクトには完全な `docker-compose.yml` 設定ファイルが含まれています。

```shell
# 下载项目源码
git clone https://github.com/QuantumNous/new-api.git

# 进入项目目录
cd new-api

# 根据需要编辑 docker-compose.yml 文件
# 使用nano编辑器
nano docker-compose.yml
# 或使用vim编辑器
# vim docker-compose.yml
```

!!! tip "ヒント"
    プロジェクトに付属の `docker-compose.yml` ファイルには、必要なすべてのサービス（MySQLおよびRedisを含む）が既に設定されています。実際の状況に応じてポート、パスワードなどのパラメータを変更するだけで使用できます。

### 方法2：手動での設定ファイルの作成

GitHubにアクセスできない、またはリポジトリをクローンできない場合は、手動で設定ファイルを作成できます。

1. New APIのデプロイに使用するディレクトリを作成します。

```shell
mkdir new-api
cd new-api
```

1. そのディレクトリ内に`docker-compose.yml`ファイルを作成します。

   [Docker Compose配置说明](docker-compose-yml.md)ドキュメントの設定例を参照し、要件に応じて選択してください。
   
   - 本番環境では、完全な設定（MySQLとRedisを含む）の使用を推奨します。
   - テスト環境では、簡略化された設定を使用できます。

1. テキストエディタを使用してファイルを作成します。

```shell
# 使用nano编辑器
nano docker-compose.yml

# 或使用vim编辑器
vim docker-compose.yml
```

選択した設定内容をこのファイルにコピーし、必要に応じてカスタマイズしてください。

## サービスの起動

設定ファイルの準備ができたら、Gitクローンまたは手動作成のどちらの方法を用いた場合でも、以下のコマンドを使用してサービスを起動できます。

```shell
# 使用Docker Compose启动服务
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
# 或仅启动并跟随某个服务
docker compose up new-api
```

Ctrl+Cを押してフォアグラウンドモードを終了します（対応するサービスが停止します）。バックグラウンドで実行するには `-d` を使用してください。

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
# 停止服务
docker compose down
```

## システムへのアクセス

サービスが正常に起動した後、`http://サーバーIP:3000`にアクセスすると、自動的に初期化ページに誘導されます。ページの手順に従って、管理者アカウントとパスワードを手動で設定してください（初回インストール時のみ必要）。初期化が完了すると、設定した管理者アカウントを使用してシステムにログインできます。
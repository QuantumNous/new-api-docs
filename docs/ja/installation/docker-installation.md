## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 比率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類、価格比率に影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス割り当て | Available service quota for users |

# Dockerインストールガイド

本ドキュメントでは、Dockerを使用してNew APIをデプロイするための詳細な手順を提供します。

!!! warning "強く推奨"
    手動でDockerコンテナを起動する代わりに、[Docker Compose インストール方法](docker-compose-installation.md) の使用を強く推奨します。Docker Compose方式は、より優れた構成管理、サービスオーケストレーション、およびデプロイメント体験を提供します。

## 基本要件

- Docker環境がインストールされていること
- ポート: デフォルトで3000番ポートを使用します

## Dockerイメージを直接使用したデプロイ

### SQLiteデータベースの使用（非推奨）

```shell
docker run --name new-api -d --restart always \
  -p 3000:3000 \
  -e TZ=Asia/Shanghai \
  -v /your/data/path:/data \
  calciumion/new-api:latest
```

!!! warning "注意"
    `/your/data/path` を、データを保存したいローカルパスに置き換えてください。

### MySQLデータベースの使用

```shell
docker run --name new-api -d --restart always \
  -p 3000:3000 \
  -e SQL_DSN="用户名:密码@tcp(数据库地址:3306)/数据库名" \
  -e TZ=Asia/Shanghai \
  -v /your/data/path:/data \
  calciumion/new-api:latest
```

!!! warning "注意"
    パラメータ内のデータベース接続情報を置き換えてください。

## システムへのアクセス

デプロイ完了後、 `http://サーバーIP:3000` にアクセスすると、自動的に初期化ページに誘導されます。ページの手順に従って管理者アカウントとパスワードを手動で設定し（初回インストール時のみ必要）、完了後、新しく設定した管理者アカウントを使用してシステムにログインできます。
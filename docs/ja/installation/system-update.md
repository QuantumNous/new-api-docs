## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス利用枠 | Available service quota for users |

# システム更新ガイド

本ドキュメントは、New APIシステムの更新方法とベストプラクティスを提供し、システムが最新バージョンへスムーズにアップグレードされることを保証します。

## 更新前の準備作業

システムを更新する前に、以下の準備作業を実行することを推奨します。

1. **データのバックアップ**：データベースと重要な設定ファイルをバックアップします
2. **更新ログの確認**：[GitHub Releases](https://github.com/Calcium-Ion/new-api/releases)で最新バージョンの更新内容を確認します
3. **互換性の確認**：新バージョンが既存のプラグイン、インテグレーション、またはカスタム設定と互換性があることを確認します
4. **適切な時間帯の選択**：ユーザーへの影響を減らすため、トラフィックの少ない時間帯に更新を実行します

## Dockerデプロイメントの更新方法

### 方法一：シングルコンテナデプロイメントの更新

シングルDockerコンテナを使用してNew APIをデプロイしている場合、以下の手順で更新できます。

```shell
# 拉取最新镜像
docker pull calciumion/new-api:latest

# 停止并移除旧容器
docker stop new-api
docker rm new-api

# 使用相同的参数重新运行容器
docker run --name new-api -d --restart always \
  -p 3000:3000 \
  -e TZ=Asia/Shanghai \
  -v /your/data/path:/data \
  calciumion/new-api:latest
```

!!! warning "ご注意ください"
    新しいコンテナを起動する際は、元のコンテナと同じパラメータ、特にデータボリュームのマウントと環境変数設定を使用していることを確認してください。

### 方法二：Docker Composeを使用した更新

Docker Composeを使用してデプロイしている場合（[Docker Compose配置说明](docker-compose-yml.md)を参照）、更新プロセスはより簡単です。

```shell
# 进入项目目录
cd new-api

# 拉取最新镜像
docker compose pull

# 停止并重启服务
docker compose down
docker compose up -d
```

または、より簡潔なコマンドを使用します：

```shell
docker compose pull && docker compose down && docker compose up -d
```

### 方法三：宝塔パネルを使用した更新

宝塔パネルを使用してデプロイしている場合、以下の手順で更新できます。

1. 宝塔パネルにログインし、 **Docker管理** -> **コンテナリスト** へ移動します
2. New APIコンテナを見つけ、 **その他** -> **再作成** をクリックします
3. **拉取最新镜像** （最新イメージのプル）オプションにチェックを入れ、その他の設定が変更されていないことを確認します
4. **提交** （送信）をクリックすると、システムは自動的に最新イメージをプルし、コンテナを再作成します

## ソースコードからコンパイルした場合の更新方法

ソースコードからNew APIをコンパイルしてデプロイしている場合、更新手順は以下の通りです。

```shell
# 进入项目目录
cd new-api

# 拉取最新代码
git pull

# 编译后端
go build -o new-api

# 更新并编译前端
cd web
bun install
bun run build
cd ..

# 重启服务
./new-api --port 3000
```

## マルチノードデプロイメントの更新戦略 {: #多节点部署的更新策略 }

マルチノードデプロイメント環境の場合、以下の更新戦略を採用することを推奨します。

1. **まずスレーブノードを更新**：最初に1つのスレーブノードを更新し、その安定性をテストします
2. **段階的な進行**：スレーブノードが安定していることを確認した後、残りのスレーブノードを一つずつ更新します
3. **最後にマスターノードを更新**：すべてのスレーブノードが安定稼働した後、マスターノードを更新します

この戦略により、サービス中断のリスクを最小限に抑えることができます。

!!! tip "詳細ガイド"
    クラスターデプロイメントに関する完全なガイドについては、[集群部署文档](cluster-deployment.md)を参照してください。

## 更新後の確認事項

システム更新後、システムが正常に動作していることを確認するために、以下の事項をチェックしてください。

1. **管理インターフェースへのアクセス**：管理インターフェースに正常にログインし、アクセスできることを確認します
2. **ログの確認**：システムログにエラーや警告がないか確認します
3. **API呼び出しのテスト**：いくつかのAPI呼び出しをテストし、機能が正常であることを確認します
4. **データベース移行の確認**：データベース構造の更新が成功したことを確認します
5. **チャネル状態の確認**：すべてのチャネル接続が正常であることを確認します

## バージョンロールバック

更新後に問題が発生した場合、以前の安定バージョンにロールバックできます。

### Docker ロールバック

```shell
# 拉取特定版本的镜像
docker pull calciumion/new-api:v1.x.x

# 停止并移除当前容器
docker stop new-api
docker rm new-api

# 使用旧版本镜像重新创建容器
docker run --name new-api -d --restart always \
  -p 3000:3000 \
  -e TZ=Asia/Shanghai \
  -v /your/data/path:/data \
  calciumion/new-api:v1.x.x
```

### ソースコード ロールバック

```shell
# 进入项目目录
cd new-api

# 切换到特定版本
git checkout v1.x.x

# 重新编译
go build -o new-api

# 更新并编译前端
cd web
bun install
bun run build
cd ..

# 重启服务
./new-api --port 3000
```

## よくある質問 (FAQ)

### 更新後にサービスが起動しない

- ログにエラーメッセージがないか確認します
- データベース接続が正常であることを確認します
- 環境変数設定が正しいことを確認します

### 更新後に機能が異常になる

- API形式の変更がないか確認します
- フロントエンドとバックエンドのバージョンが一致しているか確認します
- 新バージョンに追加の設定が必要かどうか確認します

### データベース構造の非互換性

- 更新ログにデータベース移行に関する説明があるか確認します
- データベース移行スクリプトを手動で実行する必要があるか確認します
- データベースアップグレードのガイダンスについて開発者に連絡します

## 自動更新ツール（慎重に使用）

自動更新を希望するユーザーは、Watchtowerを使用してコンテナを自動更新できます。

```shell
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower -c \
  --run-once new-api
```

!!! warning "ご注意ください"
    自動更新は、特にデータベース構造が変更される場合に予期せぬ問題を引き起こす可能性があります。自動更新はテスト環境でのみ使用し、本番環境では手動で更新プロセスを制御することを推奨します。
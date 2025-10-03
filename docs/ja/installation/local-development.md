## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| レート (倍率) | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格レートに影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# ローカル開発およびデプロイガイド

本ドキュメントは、ローカル環境で New API プロジェクトを設定し、開発するための詳細な手順を提供します。プロジェクト開発への参加や二次開発を希望する開発者向けです。

## 開発環境要件

ローカル開発を開始する前に、システムに以下のソフトウェアがインストールされていることを確認してください。

- **Go** 1.21 以降（バックエンド開発）
- **Node.js** 18 以降（フロントエンド開発）
- **Bun** 最新バージョン（推奨されるパッケージマネージャー。npm/yarnより25倍高速）
- **Git**（バージョン管理）
- **MySQL**（オプション。デフォルトでは SQLite を使用）
- **Redis**（オプション。パフォーマンス向上に使用）
- **Visual Studio Code** またはその他のコードエディタ

!!! info "Bunについて"
    Bunは、超高速なJavaScriptパッケージマネージャー、テストランナー、およびバンドラーです。従来のnpmやyarnと比較して、Bunのインストール速度は25倍速く、2024年に最も推奨されるJavaScriptパッケージ管理ツールです。

## プロジェクトのクローン

まず、GitHubからNew APIリポジトリをローカルにクローンします。

```bash
git clone https://github.com/Calcium-Ion/new-api.git
cd new-api
```

## バックエンド開発の設定

### Go依存関係のインストール

```bash
go mod download
```

### 開発環境の設定

New API は、`.env` ファイルを介した環境変数の設定をサポートしています。`.env` ファイルを作成します（`.env.example` からコピー可能）：

```bash
cp .env.example .env
```

`.env` ファイルを編集し、必要に応じて設定を変更します。以下は開発環境で一般的に使用される設定です。

```env
PORT=3000
SQL_DSN=root:password@tcp(localhost:3306)/new-api   # MySQLを使用する場合、コメントアウトを解除して変更
# REDIS_CONN_STRING=redis://localhost:6379         # Redisを使用する場合、コメントアウトを解除して変更
```

!!! tip "ヒント"
    `SQL_DSN` を設定しない場合、システムはデフォルトで SQLite データベースを使用し、`one-api.db` ファイルに保存されます。

### バックエンドサービスの実行

```bash
# 直接実行
go run main.go

# またはコンパイル後に実行
go build -o new-api
./new-api
```

サービスはデフォルトで `http://localhost:3000` で実行されます。

## フロントエンド開発の設定

New API のフロントエンドコードは `web` ディレクトリ内にあり、Reactと [semi design コンポーネントライブラリ](https://semi.design/zh-CN) を使用して開発されています。

### Bunのインストール（推奨）

まだBunをインストールしていない場合は、以下のコマンドを使用してインストールしてください。

**macOS/Linux:**
```bash
curl -fsSL https://bun.sh/install | bash
```

**Windows（WSLを使用）:**
```bash
curl -fsSL https://bun.sh/install | bash
```

**macOS（Homebrewを使用）:**
```bash
brew tap oven-sh/bun
brew install bun
```

インストール完了後、ターミナルを再起動するか、`source ~/.bashrc`（または `~/.zshrc`）を実行してBunコマンドを有効にしてください。

### フロントエンド依存関係のインストール

```bash
cd web
bun install   # bun を使用してフロントエンドの依存関係をインストール
```

### 開発サーバーの実行

```bash
bun run dev   # bun を使用して開発サーバーを実行
```

フロントエンド開発サーバーはデフォルトで `http://localhost:5173` で実行され、プロキシが設定されているため、APIリクエストはバックエンドサービスに転送されます。

### フロントエンドリソースのビルド

```bash
bun run build   # bun を使用してフロントエンドリソースをビルド
```

ビルドされたファイルは `web/dist` ディレクトリに生成され、バックエンドサービスがこれらの静的リソースを自動的にロードします。

7. **プルリクエストの作成**：GitHubでPRを作成し、変更内容を記述します

## デバッグのヒント

### バックエンドのデバッグ

1. **ログの確認**：
   ```bash
   go run main.go --log-dir ./logs
   ```

2. **Delveを使用したデバッグ**：
   ```bash
   go install github.com/go-delve/delve/cmd/dlv@latest
   dlv debug main.go
   ```

### フロントエンドのデバッグ

1. **Chrome DevToolsの使用**：
   - Chrome開発者ツール (F12) を開く
   - Console および Network タブを確認する

2. **React開発者ツール**：
   - Chromeに React Developer Tools 拡張機能をインストールする
   - それを使用してコンポーネント構造と状態を検査する

## プロジェクト構造

New API プロジェクトのディレクトリ構造：

```
new-api/                                 # プロジェクトルートディレクトリ
│  .dockerignore                         # Dockerビルド時に無視するファイル設定
│  .env.example                          # 環境変数サンプルファイル
│  .gitignore                            # Git無視ファイル設定
│  BT.md                                 # BT（宝塔パネルの可能性あり）関連の説明ドキュメント
│  docker-compose.yml                    # Docker Compose設定ファイル（コンテナオーケストレーション用）
│  Dockerfile                            # Dockerイメージビルド設定
│  go.mod                                # Goモジュール依存関係設定ファイル
│  go.sum                                # Goモジュール依存関係チェックサムファイル
│  LICENSE                               # プロジェクトライセンスファイル
│  main.go                               # プロジェクトメインエントリファイル
│  makefile                              # プロジェクトビルドスクリプト
│  Midjourney.md                         # Midjourneyサービス関連ドキュメント
│  one-api.service                       # systemdサービス設定ファイル
│  README.en.md                          # 英語版プロジェクト説明ドキュメント
│  README.md                             # 中国語版プロジェクト説明ドキュメント
│  Rerank.md                             # Rerank機能関連ドキュメント
│  Suno.md                               # Suno API関連ドキュメント
│  VERSION                               # プロジェクトバージョン情報ファイル
│
├─.github                                # GitHub関連設定ディレクトリ
│  │  FUNDING.yml                        # GitHubスポンサー設定ファイル
│  │
│  ├─ISSUE_TEMPLATE                      # GitHub Issueテンプレートディレクトリ
│  │      bug_report.md                  # バグ報告テンプレート
│  │      config.yml                     # Issue設定ファイル
│  │      feature_request.md             # 機能リクエストテンプレート
│  │
│  └─workflows                           # GitHub Actionsワークフロー設定ディレクトリ
│          docker-image-amd64.yml        # AMD64アーキテクチャDockerイメージビルドワークフロー
│          docker-image-arm64.yml        # ARM64アーキテクチャDockerイメージビルドワークフロー
│          linux-release.yml             # Linuxプラットフォームリリースワークフロー
│          macos-release.yml             # macOSプラットフォームリリースワークフロー
│          windows-release.yml           # Windowsプラットフォームリリースワークフロー
│
├─bin                                    # バイナリファイルおよびスクリプトディレクトリ
│      migration_v0.2-v0.3.sql           # データベース v0.2 から v0.3 へのマイグレーションスクリプト
│      migration_v0.3-v0.4.sql           # データベース v0.3 から v0.4 へのマイグレーションスクリプト
│      time_test.sh                      # 時間テストスクリプト
│
├─common                                 # 共通機能モジュールディレクトリ
│      constants.go                      # 共通定数定義
│      crypto.go                         # 暗号化関連機能
│      custom-event.go                   # カスタムイベント処理
│      database.go                       # データベース接続と操作
│      email-outlook-auth.go             # Outlookメール認証
│      email.go                          # Eメール機能
│      embed-file-system.go              # 組み込みファイルシステム
│      env.go                            # 環境変数処理
│      gin.go                            # Ginフレームワーク関連機能
│      go-channel.go                     # Goチャネル管理
│      gopool.go                         # Goコルーチンプール
│      init.go                           # 初期化関数
│      logger.go                         # ロギング機能
│      pprof.go                          # パフォーマンス分析ツール
│      rate-limit.go                     # レート制限機能
│      redis.go                          # Redisクライアント
│      str.go                            # 文字列処理ツール
│      topup-ratio.go                    # チャージ比率計算
│      utils.go                          # 共通ユーティリティ関数
│      validate.go                       # データ検証機能
│      verification.go                   # 検証コード関連機能
│
├─constant                               # 定数定義ディレクトリ
│      cache_key.go                      # キャッシュキー名定数
│      channel_setting.go                # チャネル設定定数
│      context_key.go                    # コンテキストキー名定数
│      env.go                            # 環境変数定数
│      finish_reason.go                  # 完了理由定数
│      midjourney.go                     # Midjourney関連定数
│      task.go                           # タスク関連定数
│      user_setting.go                   # ユーザー設定定数
│
├─controller                             # コントローラー層（HTTPリクエスト処理）
│      billing.go                        # 課金コントローラー
│      channel-billing.go                # チャネル課金コントローラー
│      channel-test.go                   # チャネルテストコントローラー
│      channel.go                        # チャネル管理コントローラー
│      github.go                         # GitHub関連コントローラー
│      group.go                          # ユーザーグループコントローラー
│      linuxdo.go                        # LinuxDo関連コントローラー
│      log.go                            # ログコントローラー
│      midjourney.go                     # Midjourneyサービスコントローラー
│      misc.go                           # 雑多な機能コントローラー
│      model.go                          # モデル管理コントローラー
│      oidc.go                           # OpenID Connect認証コントローラー
│      option.go                         # オプション設定コントローラー
│      playground.go                     # プレイグラウンド（テスト環境）コントローラー
│      pricing.go                        # 価格管理コントローラー
│      redemption.go                     # 兌換コードコントローラー
│      relay.go                          # リクエスト転送コントローラー
│      task.go                           # タスク管理コントローラー
│      telegram.go                       # Telegram関連コントローラー
│      token.go                          # トークン管理コントローラー
│      topup.go                          # チャージコントローラー
│      usedata.go                        # ユーザーデータコントローラー
│      user.go                           # ユーザー管理コントローラー
│      wechat.go                         # WeChat関連コントローラー
│
├─docs                                   # ドキュメントディレクトリ
│  ├─api                                 # APIドキュメント
│  │      api_auth.md                    # API認証ドキュメント
│  │      user.md                        # ユーザー関連APIドキュメント
│  │
│  └─channel                             # チャネルドキュメント
│          other_setting.md              # その他の設定ドキュメント
│
├─dto                                    # データ転送オブジェクトディレクトリ
│      audio.go                          # オーディオ関連DTO
│      dalle.go                          # DALL-E関連DTO
│      embedding.go                      # 埋め込みベクトル関連DTO
│      error.go                          # エラー応答DTO
│      file_data.go                      # ファイルデータDTO
│      midjourney.go                     # Midjourney関連DTO
│      notify.go                         # 通知関連DTO
│      openai_request.go                 # OpenAIリクエストDTO
│      openai_response.go                # OpenAI応答DTO
│      playground.go                     # プレイグラウンドDTO
│      pricing.go                        # 価格関連DTO
│      realtime.go                       # リアルタイムデータDTO
│      rerank.go                         # リランキング関連DTO
│      sensitive.go                      # 機密コンテンツ関連DTO
│      suno.go                           # Suno関連DTO
│      task.go                           # タスク関連DTO
│
├─middleware                             # ミドルウェアディレクトリ
│      auth.go                           # 認証ミドルウェア
│      cache.go                          # キャッシュミドルウェア
│      cors.go                           # クロスオリジンリソース共有ミドルウェア
│      distributor.go                    # リクエスト分散ミドルウェア
│      gzip.go                           # Gzip圧縮ミドルウェア
│      logger.go                         # ロギングミドルウェア
│      model-rate-limit.go               # モデルレベルのレート制限ミドルウェア
│      rate-limit.go                     # 一般的なレート制限ミドルウェア
│      recover.go                        # 例外回復ミドルウェア
│      request-id.go                     # リクエストIDミドルウェア
│      turnstile-check.go                # Cloudflare Turnstileチェックミドルウェア
│      utils.go                          # ミドルウェアユーティリティ関数
│
├─model                                  # データモデルディレクトリ
│      ability.go                        # 能力モデル
│      cache.go                          # キャッシュモデル
│      channel.go                        # チャネルモデル
│      log.go                            # ログモデル
│      main.go                           # 主要モデルとORM設定
│      midjourney.go                     # Midjourney関連モデル
│      option.go                         # オプション設定モデル
│      pricing.go                        # 価格モデル
│      redemption.go                     # 兌換コードモデル
│      task.go                           # タスクモデル
│      token.go                          # トークンモデル
│      token_cache.go                    # トークンキャッシュモデル
│      topup.go                          # チャージモデル
│      usedata.go                        # ユーザーデータモデル
│      user.go                           # ユーザーモデル
│      user_cache.go                     # ユーザーキャッシュモデル
│      utils.go                          # モデルユーティリティ関数
│
├─relay                                  # リクエスト転送モジュールディレクトリ
│  │  relay-audio.go                     # オーディオリクエスト転送
│  │  relay-image.go                     # 画像リクエスト転送
│  │  relay-mj.go                        # Midjourneyリクエスト転送
│  │  relay-text.go                      # テキストリクエスト転送
│  │  relay_adaptor.go                   # 転送アダプター
│  │  relay_embedding.go                 # 埋め込みベクトルリクエスト転送
│  │  relay_rerank.go                    # リランキングリクエスト転送
│  │  relay_task.go                      # タスクリクエスト転送
│  │  websocket.go                       # WebSocket通信処理
│  │
│  ├─channel                             # 転送チャネルディレクトリ
│  │  │  adapter.go                      # 共通チャネルアダプター
│  │  │  api_request.go                  # APIリクエスト処理
│  │  │
│  │  ├─ai360                            # 360 AIチャネル
│  │  │      constants.go                # 360 AI定数定義
│  │  │
│  │  ├─ali                              # Alibaba Cloud AIチャネル
│  │  │      adaptor.go                  # Alibaba Cloudアダプター
│  │  │      constants.go                # Alibaba Cloud定数定義
│  │  │      dto.go                      # Alibaba Cloudデータ転送オブジェクト
│  │  │      image.go                    # Alibaba Cloud画像処理
│  │  │      text.go                     # Alibaba Cloudテキスト処理
│  │  │
│  │  ├─aws                              # AWS AIチャネル
│  │  │      adaptor.go                  # AWSアダプター
│  │  │      constants.go                # AWS定数定義
│  │  │      dto.go                      # AWSデータ転送オブジェクト
│  │  │      relay-aws.go                # AWSリクエスト転送
│  │  │
│  │  ├─baidu                            # Baidu AIチャネル
│  │  │      adaptor.go                  # Baiduアダプター
│  │  │      constants.go                # Baidu定数定義
│  │  │      dto.go                      # Baiduデータ転送オブジェクト
│  │  │      relay-baidu.go              # Baiduリクエスト転送
│  │  │
│  │  ├─baidu_v2                         # Baidu AI v2バージョンチャネル
│  │  │      adaptor.go                  # Baidu v2アダプター
│  │  │      constants.go                # Baidu v2定数定義
│  │  │
│  │  ├─claude                           # Claude AIチャネル
│  │  │      adaptor.go                  # Claudeアダプター
│  │  │      constants.go                # Claude定数定義
│  │  │      dto.go                      # Claudeデータ転送オブジェクト
│  │  │      relay-claude.go             # Claudeリクエスト転送
│  │  │
│  │  ├─cloudflare                       # Cloudflare AIチャネル
│  │  │      adaptor.go                  # Cloudflareアダプター
│  │  │      constant.go                 # Cloudflare定数定義
│  │  │      dto.go                      # Cloudflareデータ転送オブジェクト
│  │  │      relay_cloudflare.go         # Cloudflareリクエスト転送
│  │  │
│  │  ├─cohere                           # Cohere AIチャネル
│  │  │      adaptor.go                  # Cohereアダプター
│  │  │      constant.go                 # Cohere定数定義
│  │  │      dto.go                      # Cohereデータ転送オブジェクト
│  │  │      relay-cohere.go             # Cohereリクエスト転送
│  │  │
│  │  ├─deepseek                         # DeepSeek AIチャネル
│  │  │      adaptor.go                  # DeepSeekアダプター
│  │  │      constants.go                # DeepSeek定数定義
│  │  │
│  │  ├─dify                             # Dify AIチャネル
│  │  │      adaptor.go                  # Difyアダプター
│  │  │      constants.go                # Dify定数定義
│  │  │      dto.go                      # Difyデータ転送オブジェクト
│  │  │      relay-dify.go               # Difyリクエスト転送
│  │  │
│  │  ├─gemini                           # Google Gemini AIチャネル
│  │  │      adaptor.go                  # Geminiアダプター
│  │  │      constant.go                 # Gemini定数定義
│  │  │      dto.go                      # Geminiデータ転送オブジェクト
│  │  │      relay-gemini.go             # Geminiリクエスト転送
│  │  │
│  │  ├─jina                             # Jina AIチャネル
│  │  │      adaptor.go                  # Jinaアダプター
│  │  │      constant.go                 # Jina定数定義
│  │  │      relay-jina.go               # Jinaリクエスト転送
│  │  │
│  │  ├─lingyiwanwu                      # 霊医万物 AIチャネル
│  │  │      constrants.go               # 霊医万物定数定義
│  │  │
│  │  ├─minimax                          # MiniMax AIチャネル
│  │  │      constants.go                # MiniMax定数定義
│  │  │      relay-minimax.go            # MiniMaxリクエスト転送
│  │  │
│  │  ├─mistral                          # Mistral AIチャネル
│  │  │      adaptor.go                  # Mistralアダプター
│  │  │      constants.go                # Mistral定数定義
│  │  │      text.go                     # Mistralテキスト処理
│  │  │
│  │  ├─mokaai                           # MokaAIチャネル
│  │  │      adaptor.go                  # MokaAIアダプター
│  │  │      constants.go                # MokaAI定数定義
│  │  │      relay-mokaai.go             # MokaAIリクエスト転送
│  │  │
│  │  ├─moonshot                         # Moonshot AIチャネル
│  │  │      constants.go                # Moonshot定数定義
│  │  │
│  │  ├─ollama                           # Ollama AIチャネル
│  │  │      adaptor.go                  # Ollamaアダプター
│  │  │      constants.go                # Ollama定数定義
│  │  │      dto.go                      # Ollamaデータ転送オブジェクト
│  │  │      relay-ollama.go             # Ollamaリクエスト転送
│  │  │
│  │  ├─openai                           # OpenAIチャネル
│  │  │      adaptor.go                  # OpenAIアダプター
│  │  │      constant.go                 # OpenAI定数定義
│  │  │      relay-openai.go             # OpenAIリクエスト転送
│  │  │
│  │  ├─openrouter                       # OpenRouter AIチャネル
│  │  │      adaptor.go                  # OpenRouterアダプター
│  │  │      constant.go                 # OpenRouter定数定義
│  │  │
│  │  ├─palm                             # Google PaLM AIチャネル
│  │  │      adaptor.go                  # PaLMアダプター
│  │  │      constants.go                # PaLM定数定義
│  │  │      dto.go                      # PaLMデータ転送オブジェクト
│  │  │      relay-palm.go               # PaLMリクエスト転送
│  │  │
│  │  ├─perplexity                       # Perplexity AIチャネル
│  │  │      adaptor.go                  # Perplexityアダプター
│  │  │      constants.go                # Perplexity定数定義
│  │  │      relay-perplexity.go         # Perplexityリクエスト転送
│  │  │
│  │  ├─siliconflow                      # SiliconFlow AIチャネル
│  │  │      adaptor.go                  # SiliconFlowアダプター
│  │  │      constant.go                 # SiliconFlow定数定義
│  │  │      dto.go                      # SiliconFlowデータ転送オブジェクト
│  │  │      relay-siliconflow.go        # SiliconFlowリクエスト転送
│  │  │
│  │  ├─task                             # タスク関連チャネル
│  │  │  └─suno                          # Sunoオーディオ生成タスク
│  │  │          adaptor.go              # Sunoアダプター
│  │  │          models.go               # Sunoモデル定義
│  │  │
│  │  ├─tencent                          # Tencent AIチャネル
│  │  │      adaptor.go                  # Tencentアダプター
│  │  │      constants.go                # Tencent定数定義
│  │  │      dto.go                      # Tencentデータ転送オブジェクト
│  │  │      relay-tencent.go            # Tencentリクエスト転送
│  │  │
│  │  ├─vertex                           # Google Vertex AIチャネル
│  │  │      adaptor.go                  # Vertexアダプター
│  │  │      constants.go                # Vertex定数定義
│  │  │      dto.go                      # Vertexデータ転送オブジェクト
│  │  │      relay-vertex.go             # Vertexリクエスト転送
│  │  │      service_account.go          # Vertexサービスアカウント
│  │  │
│  │  ├─volcengine                       # Volcengine AIチャネル
│  │  │      adaptor.go                  # Volcengineアダプター
│  │  │      constants.go                # Volcengine定数定義
│  │  │
│  │  ├─xunfei                           # Xunfei AIチャネル
│  │  │      adaptor.go                  # Xunfeiアダプター
│  │  │      constants.go                # Xunfei定数定義
│  │  │      dto.go                      # Xunfeiデータ転送オブジェクト
│  │  │      relay-xunfei.go             # Xunfeiリクエスト転送
│  │  │
│  │  ├─zhipu                            # Zhipu AIチャネル
│  │  │      adaptor.go                  # Zhipuアダプター
│  │  │      constants.go                # Zhipu定数定義
│  │  │      dto.go                      # Zhipuデータ転送オブジェクト
│  │  │      relay-zhipu.go              # Zhipuリクエスト転送
│  │  │
│  │  └─zhipu_4v                         # Zhipu 4.0バージョンチャネル
│  │          adaptor.go                 # Zhipu 4.0アダプター
│  │          constants.go               # Zhipu 4.0定数定義
│  │          dto.go                     # Zhipu 4.0データ転送オブジェクト
│  │          relay-zhipu_v4.go          # Zhipu 4.0リクエスト転送
│  │
│  ├─common                              # 転送共通モジュール
│  │      relay_info.go                  # 転送情報
│  │      relay_utils.go                 # 転送ユーティリティ関数
│  │
│  ├─constant                            # 転送定数ディレクトリ
│  │      api_type.go                    # APIタイプ定数
│  │      relay_mode.go                  # 転送モード定数
│  │
│  └─helper                              # 転送補助機能
│          common.go                     # 共通補助関数
│          model_mapped.go               # モデルマッピング
│          price.go                      # 価格計算
│          stream_scanner.go             # ストリームデータスキャナー
│
├─router                                 # ルーティング設定ディレクトリ
│      api-router.go                     # APIルーティング設定
│      dashboard.go                      # ダッシュボードルーティング
│      main.go                           # メインルーティング設定
│      relay-router.go                   # 転送ルーティング設定
│      web-router.go                     # Webインターフェースルーティング設定
│
├─service                                # サービス層ディレクトリ
│      audio.go                          # オーディオサービス
│      cf_worker.go                      # Cloudflare Workerサービス
│      channel.go                        # チャネルサービス
│      epay.go                           # 電子決済サービス
│      error.go                          # エラー処理サービス
│      file_decoder.go                   # ファイルデコーダーサービス
│      http_client.go                    # HTTPクライアントサービス
│      image.go                          # 画像処理サービス
│      log_info_generate.go              # ログ情報生成サービス
│      midjourney.go                     # Midjourneyサービス
│      notify-limit.go                   # 通知制限サービス
│      quota.go                          # クォータ管理サービス
│      sensitive.go                      # 機密コンテンツフィルタリングサービス
│      str.go                            # 文字列処理サービス
│      task.go                           # タスク管理サービス
│      token_counter.go                  # トークンカウントサービス
│      usage_helpr.go                    # 使用量統計補助サービス
│      user_notify.go                    # ユーザー通知サービス
│      webhook.go                        # WebHookサービス
│
├─setting                                # 設定管理ディレクトリ
│  │  chat.go                            # チャット設定
│  │  group_ratio.go                     # ユーザーグループ比率設定
│  │  midjourney.go                      # Midjourney設定
│  │  payment.go                         # 支払い設定
│  │  rate_limit.go                      # レート制限設定
│  │  sensitive.go                       # 機密コンテンツ設定
│  │  system_setting.go                  # システム設定
│  │  user_usable_group.go               # ユーザー利用可能グループ設定
│  │
│  ├─config                              # 設定ディレクトリ
│  │      config.go                      # 設定のロードと処理
│  │
│  ├─model_setting                       # モデル設定ディレクトリ
│  │      claude.go                      # Claudeモデル設定
│  │      gemini.go                      # Geminiモデル設定
│  │      global.go                      # グローバルモデル設定
│  │
│  ├─operation_setting                   # 運用設定ディレクトリ
│  │      cache_ratio.go                 # キャッシュ比率設定
│  │      general_setting.go             # 一般設定
│  │      model-ratio.go                 # モデル比率設定
│  │      operation_setting.go           # 運用設定
│  │
│  └─system_setting                      # システム設定ディレクトリ
│          oidc.go                       # OpenID Connect設定
│
└─web                                    # フロントエンドWebインターフェースディレクトリ
    │  .gitignore                        # フロントエンドGit無視ファイル設定
    │  .prettierrc.mjs                   # Prettierコードフォーマット設定
    │  bun.lockb                         # Bunパッケージマネージャーロックファイル
    │  index.html                        # メインHTMLファイル
    │  package.json                      # フロントエンド依存関係設定
    │  bun.lockb                         # Bunパッケージマネージャーロックファイル（バイナリ形式、高速）
    │  README.md                         # フロントエンド説明ドキュメント
    │  vercel.json                       # Vercelデプロイ設定
    │  vite.config.js                    # Viteビルド設定
    │
    ├─public                             # 静的リソースディレクトリ
    │      favicon.ico                   # ウェブサイトアイコン
    │      logo.png                      # ウェブサイトロゴ
    │      ratio.png                     # 比率画像
    │      robots.txt                    # 検索エンジンクローラー設定
    │
    └─src                                # フロントエンドソースコードディレクトリ
        │  App.js                        # アプリケーションメインコンポーネント
        │  index.css                     # メインスタイルファイル
        │  index.js                      # アプリケーションエントリJS
        │
        ├─components                     # コンポーネントディレクトリ
        │  │  ChannelsTable.js           # チャネルテーブルコンポーネント
        │  │  fetchTokenKeys.js          # トークンキー取得ユーティリティ
        │  │  Footer.js                  # フッターコンポーネント
        │  │  HeaderBar.js               # ヘッダーバーコンポーネント
        │  │  LinuxDoIcon.js             # LinuxDoアイコンコンポーネント
        │  │  Loading.js                 # ロード中コンポーネント
        │  │  LoginForm.js               # ログインフォームコンポーネント
        │  │  LogsTable.js               # ログテーブルコンポーネント
        │  │  MjLogsTable.js             # Midjourneyログテーブルコンポーネント
        │  │  ModelPricing.js            # モデル価格設定コンポーネント
        │  │  ModelSetting.js            # モデル設定コンポーネント
        │  │  OAuth2Callback.js          # OAuth2コールバックコンポーネント
        │  │  OIDCIcon.js                # OIDCアイコンコンポーネント
        │  │  OperationSetting.js        # 運用設定コンポーネント
        │  │  OtherSetting.js            # その他の設定コンポーネント
        │  │  PageLayout.js              # ページレイアウトコンポーネント
        │  │  PasswordResetConfirm.js    # パスワードリセット確認コンポーネント
        │  │  PasswordResetForm.js       # パスワードリセットフォームコンポーネント
        │  │  PersonalSetting.js         # 個人設定コンポーネント
        │  │  PrivateRoute.js            # プライベート（認証済み）ルートコンポーネント
        │  │  RateLimitSetting.js        # レート制限設定コンポーネント
        │  │  RedemptionsTable.js        # 兌換コードテーブルコンポーネント
        │  │  RegisterForm.js            # 登録フォームコンポーネント
        │  │  SafetySetting.js           # 安全設定コンポーネント
        │  │  SiderBar.js                # サイドバーコンポーネント
        │  │  SystemSetting.js           # システム設定コンポーネント
        │  │  TaskLogsTable.js           # タスクログテーブルコンポーネント
        │  │  TokensTable.js             # トークン管理テーブルコンポーネント
        │  │  UsersTable.js              # ユーザー管理テーブルコンポーネント
        │  │  utils.js                   # 共通ユーティリティ関数
        │  │  WeChatIcon.js              # WeChatアイコンコンポーネント
        │  │
        │  └─custom                      # カスタムコンポーネントディレクトリ
        │          TextInput.js          # テキスト入力コンポーネント
        │          TextNumberInput.js    # 数値入力コンポーネント
        │
        ├─constants                      # 定数定義ディレクトリ
        │      channel.constants.js      # チャネル関連定数
        │      common.constant.js        # 共通定数
        │      index.js                  # 定数エクスポートインデックス
        │      toast.constants.js        # トーストメッセージ定数
        │      user.constants.js         # ユーザー関連定数
        │
        ├─context                        # React Contextコンテキストディレクトリ
        │  ├─Status                      # ステータスコンテキスト
        │  │      index.js               # ステータスコンテキストエントリ
        │  │      reducer.js             # ステータスコンテキストreducer
        │  │
        │  ├─Style                       # スタイルコンテキスト
        │  │      index.js               # スタイルコンテキストエントリ
        │  │
        │  ├─Theme                       # テーマコンテキスト
        │  │      index.js               # テーマコンテキストエントリ
        │  │
        │  └─User                        # ユーザーコンテキスト
        │          index.js              # ユーザーコンテキストエントリ
        │          reducer.js            # ユーザーコンテキストreducer
        │
        ├─helpers                        # 補助関数ディレクトリ
        │      api.js                    # APIリクエスト補助関数
        │      auth-header.js            # 認証ヘッダー処理
        │      data.js                   # データ処理関数
        │      history.js                # ルーティング履歴管理
        │      index.js                  # 補助関数エクスポートインデックス
        │      other.js                  # その他の補助関数
        │      render.js                 # レンダリング補助関数
        │      utils.js                  # 実用ユーティリティ関数
        │
        ├─i18n                           # 国際化ディレクトリ
        │  │  i18n.js                    # 国際化設定ファイル
        │  │
        │  └─locales                     # 言語パックディレクトリ
        │          en.json               # 英語言語パック
        │          zh.json               # 中国語言語パック
        │
        └─pages                          # ページコンポーネントディレクトリ
            ├─About                      # Aboutページ
            │      index.js              # Aboutページエントリ
            │
            ├─Channel                    # チャネル管理ページ
            │      EditChannel.js        # チャネル編集コンポーネント
            │      EditTagModal.js       # タグ編集モーダル
            │      index.js              # チャネル管理ページエントリ
            │
            ├─Chat                       # チャットページ
            │      index.js              # チャットページエントリ
            │
            ├─Chat2Link                  # チャットリンク共有ページ
            │      index.js              # チャットリンクエントリ
            │
            ├─Detail                     # 詳細ページ
            │      index.js              # 詳細ページエントリ
            │
            ├─Home                       # ホームページ
            │      index.js              # ホームページエントリ
            │
            ├─Log                        # ログページ
            │      index.js              # ログページエントリ
            │
            ├─Midjourney                 # Midjourney管理ページ
            │      index.js              # Midjourneyページエントリ
            │
            ├─NotFound                   # 404ページ
            │      index.js              # 404ページエントリ
            │
            ├─Playground                 # プレイグラウンド（テスト環境）ページ
            │      Playground.js         # プレイグラウンドコンポーネント
            │
            ├─Pricing                    # 価格管理ページ
            │      index.js              # 価格管理ページエントリ
            │
            ├─Redemption                 # 兌換コード管理ページ
            │      EditRedemption.js     # 兌換コード編集コンポーネント
            │      index.js              # 兌換コード管理ページエントリ
            │
            ├─Setting                    # 設定ページ
            │  │  index.js               # 設定ページエントリ
            │  │
            │  ├─Model                   # モデル設定ページ
            │  │      SettingClaudeModel.js # Claudeモデル設定コンポーネント
            │  │      SettingGeminiModel.js # Geminiモデル設定コンポーネント
            │  │      SettingGlobalModel.js # グローバルモデル設定コンポーネント
            │  │
            │  ├─Operation               # 運用設定ページ
            │  │      GroupRatioSettings.js       # ユーザーグループ比率設定コンポーネント
            │  │      ModelRationNotSetEditor.js  # モデル比率未設定エディタ
            │  │      ModelRatioSettings.js       # モデル比率設定コンポーネント
            │  │      ModelSettingsVisualEditor.js # モデル設定ビジュアルエディタ
            │  │      SettingsChats.js            # チャット設定コンポーネント
            │  │      SettingsCreditLimit.js      # クレジット制限設定コンポーネント
            │  │      SettingsDataDashboard.js    # データダッシュボード設定コンポーネント
            │  │      SettingsDrawing.js          # 描画設定コンポーネント
            │  │      SettingsGeneral.js          # 一般設定コンポーネント
            │  │      SettingsLog.js              # ログ設定コンポーネント
            │  │      SettingsMonitoring.js       # 監視設定コンポーネント
            │  │      SettingsSensitiveWords.js   # 敏感語設定コンポーネント
            │  │
            │  └─RateLimit                   # レート制限設定ページ
            │          SettingsRequestRateLimit.js # リクエストレート制限設定コンポーネント
            │
            ├─Task                           # タスク管理ページ
            │      index.js                  # タスク管理ページエントリ
            │
            ├─Token                          # トークン管理ページ
            │      EditToken.js              # トークン編集コンポーネント
            │      index.js                  # トークン管理ページエントリ
            │
            ├─TopUp                          # チャージページ
            │      index.js                  # チャージページエントリ
            │
            └─User                           # ユーザー管理ページ
                    AddUser.js               # ユーザー追加コンポーネント
                    EditUser.js              # ユーザー編集コンポーネント
                    index.js                 # ユーザー管理ページエントリ
```

!!! tip "ヘルプが必要ですか？"
    開発中に問題が発生した場合は、以下を参照してください。
    
    1. [GitHub Issues](https://github.com/Calcium-Ion/new-api/issues) を確認する
    2. [QQ交流群](../support/community-interaction.md) に参加する
    3. [問題フィードバック](../support/feedback-issues.md) ページから問題を提出する
# ローカル開発およびデプロイガイド

本ドキュメントは、ローカル環境で New API プロジェクトを設定し、開発するための詳細な手順を提供します。プロジェクト開発への参加や二次開発を希望する開発者向けです。

## 開発環境要件

ローカル開発を開始する前に、システムに以下のソフトウェアがインストールされていることを確認してください。

- **Go** 1.21 以降（バックエンド開発）
- **Node.js** 18 以降（フロントエンド開発）
- **Bun** 最新バージョン（推奨されるパッケージマネージャー。npm/yarnより25倍高速）
- **Git**（バージョン管理）
- **MySQL**（オプション、デフォルトでは SQLite を使用）
- **Redis**（オプション、パフォーマンス向上に使用）
- **Visual Studio Code** またはその他のコードエディタ

!!! info "Bun について"
    Bun は、超高速の JavaScript パッケージマネージャー、テストランナー、およびバンドラーです。従来の npm や yarn と比較して、Bun のインストール速度は 25 倍速く、2024 年に最も推奨される JavaScript パッケージ管理ツールです。

## プロジェクトのクローン

まず、GitHub から New API リポジトリをローカルにクローンします。

```bash
git clone https://github.com/Calcium-Ion/new-api.git
cd new-api
```

## バックエンド開発の設定

### Go 依存関係のインストール

```bash
go mod download
```

### 開発環境の設定

New API は `.env` ファイルを介した環境変数の設定をサポートしています。`.env` ファイルを作成します（`.env.example` からコピー可能）：

```bash
cp .env.example .env
```

`.env` ファイルを編集し、必要に応じて設定を変更します。以下は開発環境で一般的に使用される設定です：

```env
PORT=3000
SQL_DSN=root:password@tcp(localhost:3306)/new-api   # MySQL を使用する場合、コメントアウトを解除して変更
# REDIS_CONN_STRING=redis://localhost:6379         # Redis を使用する場合、コメントアウトを解除して変更
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

New API のフロントエンドコードは `web` ディレクトリにあり、React と [semi design コンポーネントライブラリ](https://semi.design/zh-CN) を使用して開発されています。

### Bun のインストール（推奨）

まだ Bun をインストールしていない場合は、以下のコマンドを使用してインストールしてください：

**macOS/Linux:**
```bash
curl -fsSL https://bun.sh/install | bash
```

**Windows（WSL を使用）:**
```bash
curl -fsSL https://bun.sh/install | bash
```

**macOS（Homebrew を使用）:**
```bash
brew tap oven-sh/bun
brew install bun
```

インストールが完了したら、ターミナルを再起動するか、`source ~/.bashrc`（または `~/.zshrc`）を実行して Bun コマンドを有効にします。

### フロントエンド依存関係のインストール

```bash
cd web
bun install   # bun を使用してフロントエンドの依存関係をインストール
```

### 開発サーバーの実行

```bash
bun run dev   # bun を使用して開発サーバーを実行
```

フロントエンド開発サーバーはデフォルトで `http://localhost:5173` で実行され、プロキシが設定されているため、API リクエストはバックエンドサービスに転送されます。

### フロントエンドリソースのビルド

```bash
bun run build   # bun を使用してフロントエンドリソースをビルド
```

ビルドされたファイルは `web/dist` ディレクトリに生成され、バックエンドサービスがこれらの静的リソースを自動的にロードします。

7. **プルリクエストの作成**: GitHub で PR を作成し、変更内容を記述します

## デバッグのヒント

### バックエンドのデバッグ

1. **ログの確認**:
   ```bash
   go run main.go --log-dir ./logs
   ```

2. **Delve を使用したデバッグ**:
   ```bash
   go install github.com/go-delve/delve/cmd/dlv@latest
   dlv debug main.go
   ```

### フロントエンドのデバッグ

1. **Chrome DevTools の使用**:
   - Chrome 開発者ツール (F12) を開く
   - Console および Network タブを確認する

2. **React 開発者ツール**:
   - Chrome に React Developer Tools 拡張機能をインストールする
   - それを使用してコンポーネント構造と状態を検査する

## プロジェクト構造

New API プロジェクトのディレクトリ構造：

```
new-api/                                 # プロジェクトルートディレクトリ
│  .dockerignore                         # Docker ビルド時に無視するファイル設定
│  .env.example                          # 環境変数サンプルファイル
│  .gitignore                            # Git 無視ファイル設定
│  BT.md                                 # BT（おそらく宝塔パネル）関連の説明ドキュメント
│  docker-compose.yml                    # コンテナオーケストレーション用の Docker Compose 設定ファイル
│  Dockerfile                            # Docker イメージビルド設定
│  go.mod                                # Go モジュール依存関係設定ファイル
│  go.sum                                # Go モジュール依存関係チェックサムファイル
│  LICENSE                               # プロジェクトライセンスファイル
│  main.go                               # プロジェクトのメインエントリファイル
│  makefile                              # プロジェクトビルドスクリプト
│  Midjourney.md                         # Midjourney サービス関連ドキュメント
│  one-api.service                       # systemd サービス設定ファイル
│  README.en.md                          # 英語版プロジェクト説明ドキュメント
│  README.md                             # 中国語版プロジェクト説明ドキュメント
│  Rerank.md                             # Rerank 機能関連ドキュメント
│  Suno.md                               # Suno API 関連ドキュメント
│  VERSION                               # プロジェクトバージョン情報ファイル
│
├─.github                                # GitHub 関連設定ディレクトリ
│  │  FUNDING.yml                        # GitHub スポンサー設定ファイル
│  │
│  ├─ISSUE_TEMPLATE                      # GitHub Issue テンプレートディレクトリ
│  │      bug_report.md                  # バグ報告テンプレート
│  │      config.yml                     # Issue 設定ファイル
│  │      feature_request.md             # 機能リクエストテンプレート
│  │
│  └─workflows                           # GitHub Actions ワークフロー設定ディレクトリ
│          docker-image-amd64.yml        # AMD64 アーキテクチャ Docker イメージビルドワークフロー
│          docker-image-arm64.yml        # ARM64 アーキテクチャ Docker イメージビルドワークフロー
│          linux-release.yml             # Linux プラットフォームリリースワークフロー
│          macos-release.yml             # macOS プラットフォームリリースワークフロー
│          windows-release.yml           # Windows プラットフォームリリースワークフロー
│
├─bin                                    # バイナリファイルおよびスクリプトディレクトリ
│      migration_v0.2-v0.3.sql           # データベース v0.2 から v0.3 への移行スクリプト
│      migration_v0.3-v0.4.sql           # データベース v0.3 から v0.4 への移行スクリプト
│      time_test.sh                      # 時間テストスクリプト
│
├─common                                 # 共通機能モジュールディレクトリ
│      constants.go                      # 共通定数定義
│      crypto.go                         # 暗号化関連機能
│      custom-event.go                   # カスタムイベント処理
│      database.go                       # データベース接続と操作
│      email-outlook-auth.go             # Outlook メール認証
│      email.go                          # Eメール機能
│      embed-file-system.go              # 組み込みファイルシステム
│      env.go                            # 環境変数処理
│      gin.go                            # Gin フレームワーク関連機能
│      go-channel.go                     # Go チャネル管理
│      gopool.go                         # Go コルーチンプール
│      init.go                           # 初期化関数
│      logger.go                         # ロギング機能
│      pprof.go                          # パフォーマンス分析ツール
│      rate-limit.go                     # レート制限機能
│      redis.go                          # Redis クライアント
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
│      midjourney.go                     # Midjourney 関連定数
│      task.go                           # タスク関連定数
│      user_setting.go                   # ユーザー設定定数
│
├─controller                             # コントローラー層、HTTP リクエストを処理
│      billing.go                        # 課金コントローラー
│      channel-billing.go                # チャネル課金コントローラー
│      channel-test.go                   # チャネルテストコントローラー
│      channel.go                        # チャネル管理コントローラー
│      github.go                         # GitHub 関連コントローラー
│      group.go                          # ユーザーグループコントローラー
│      linuxdo.go                        # LinuxDo 関連コントローラー
│      log.go                            # ログコントローラー
│      midjourney.go                     # Midjourney サービスコントローラー
│      misc.go                           # その他機能コントローラー
│      model.go                          # モデル管理コントローラー
│      oidc.go                           # OpenID Connect 認証コントローラー
│      option.go                         # オプション設定コントローラー
│      playground.go                     # プレイグラウンドコントローラー
│      pricing.go                        # 価格管理コントローラー
│      redemption.go                     # 償還コードコントローラー
│      relay.go                          # リクエスト転送コントローラー
│      task.go                           # タスク管理コントローラー
│      telegram.go                       # Telegram 関連コントローラー
│      token.go                          # トークン管理コントローラー
│      topup.go                          # チャージコントローラー
│      usedata.go                        # ユーザーデータコントローラー
│      user.go                           # ユーザー管理コントローラー
│      wechat.go                         # WeChat 関連コントローラー
│
├─docs                                   # ドキュメントディレクトリ
│  ├─api                                 # API ドキュメント
│  │      api_auth.md                    # API 認証ドキュメント
│  │      user.md                        # ユーザー関連 API ドキュメント
│  │
│  └─channel                             # チャネルドキュメント
│          other_setting.md              # その他設定ドキュメント
│
├─dto                                    # データ転送オブジェクトディレクトリ
│      audio.go                          # 音声関連 DTO
│      dalle.go                          # DALL-E 関連 DTO
│      embedding.go                      # 埋め込みベクトル関連 DTO
│      error.go                          # エラー応答 DTO
│      file_data.go                      # ファイルデータ DTO
│      midjourney.go                     # Midjourney 関連 DTO
│      notify.go                         # 通知関連 DTO
│      openai_request.go                 # OpenAI リクエスト DTO
│      openai_response.go                # OpenAI レスポンス DTO
│      playground.go                     # プレイグラウンド DTO
│      pricing.go                        # 価格関連 DTO
│      realtime.go                       # リアルタイムデータ DTO
│      rerank.go                         # リランキング関連 DTO
│      sensitive.go                      # 機密コンテンツ関連 DTO
│      suno.go                           # Suno 関連 DTO
│      task.go                           # タスク関連 DTO
│
├─middleware                             # ミドルウェアディレクトリ
│      auth.go                           # 認証ミドルウェア
│      cache.go                          # キャッシュミドルウェア
│      cors.go                           # クロスオリジンリソース共有ミドルウェア
│      distributor.go                    # リクエストディストリビューターミドルウェア
│      gzip.go                           # Gzip 圧縮ミドルウェア
│      logger.go                         # ロギングミドルウェア
│      model-rate-limit.go               # モデルレベルのレート制限ミドルウェア
│      rate-limit.go                     # 一般的なレート制限ミドルウェア
│      recover.go                        # 例外リカバリミドルウェア
│      request-id.go                     # リクエスト ID ミドルウェア
│      turnstile-check.go                # Cloudflare Turnstile チェックミドルウェア
│      utils.go                          # ミドルウェアユーティリティ関数
│
├─model                                  # データモデルディレクトリ
│      ability.go                        # アビリティモデル
│      cache.go                          # キャッシュモデル
│      channel.go                        # チャネルモデル
│      log.go                            # ログモデル
│      main.go                           # 主要モデルと ORM 設定
│      midjourney.go                     # Midjourney 関連モデル
│      option.go                         # オプション設定モデル
│      pricing.go                        # 価格モデル
│      redemption.go                     # 償還コードモデル
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
│  │  relay-audio.go                     # 音声リクエスト転送
│  │  relay-image.go                     # 画像リクエスト転送
│  │  relay-mj.go                        # Midjourney リクエスト転送
│  │  relay-text.go                      # テキストリクエスト転送
│  │  relay_adaptor.go                   # 転送アダプター
│  │  relay_embedding.go                 # 埋め込みベクトルリクエスト転送
│  │  relay_rerank.go                    # リランキングリクエスト転送
│  │  relay_task.go                      # タスクリクエスト転送
│  │  websocket.go                       # WebSocket 通信処理
│  │
│  ├─channel                             # 転送チャネルディレクトリ
│  │  │  adapter.go                      # 共通チャネルアダプター
│  │  │  api_request.go                  # API リクエスト処理
│  │  │
│  │  ├─ai360                            # 360 AI チャネル
│  │  │      constants.go                # 360 AI 定数定義
│  │  │
│  │  ├─ali                              # 阿里云 AI チャネル
│  │  │      adaptor.go                  # 阿里云アダプター
│  │  │      constants.go                # 阿里云定数定義
│  │  │      dto.go                      # 阿里云データ転送オブジェクト
│  │  │      image.go                    # 阿里云画像処理
│  │  │      text.go                     # 阿里云テキスト処理
│  │  │
│  │  ├─aws                              # AWS AI チャネル
│  │  │      adaptor.go                  # AWS アダプター
│  │  │      constants.go                # AWS 定数定義
│  │  │      dto.go                      # AWS データ転送オブジェクト
│  │  │      relay-aws.go                # AWS リクエスト転送
│  │  │
│  │  ├─baidu                            # 百度 AI チャネル
│  │  │      adaptor.go                  # 百度アダプター
│  │  │      constants.go                # 百度定数定義
│  │  │      dto.go                      # 百度データ転送オブジェクト
│  │  │      relay-baidu.go              # 百度リクエスト転送
│  │  │
│  │  ├─baidu_v2                         # 百度 AI v2 バージョンチャネル
│  │  │      adaptor.go                  # 百度 v2 アダプター
│  │  │      constants.go                # 百度 v2 定数定義
│  │  │
│  │  ├─claude                           # Claude AI チャネル
│  │  │      adaptor.go                  # Claude アダプター
│  │  │      constants.go                # Claude 定数定義
│  │  │      dto.go                      # Claude データ転送オブジェクト
│  │  │      relay-claude.go             # Claude リクエスト転送
│  │  │
│  │  ├─cloudflare                       # Cloudflare AI チャネル
│  │  │      adaptor.go                  # Cloudflare アダプター
│  │  │      constant.go                 # Cloudflare 定数定義
│  │  │      dto.go                      # Cloudflare データ転送オブジェクト
│  │  │      relay_cloudflare.go         # Cloudflare リクエスト転送
│  │  │
│  │  ├─cohere                           # Cohere AI チャネル
│  │  │      adaptor.go                  # Cohere アダプター
│  │  │      constant.go                 # Cohere 定数定義
│  │  │      dto.go                      # Cohere データ転送オブジェクト
│  │  │      relay-cohere.go             # Cohere リクエスト転送
│  │  │
│  │  ├─deepseek                         # DeepSeek AI チャネル
│  │  │      adaptor.go                  # DeepSeek アダプター
│  │  │      constants.go                # DeepSeek 定数定義
│  │  │
│  │  ├─dify                             # Dify AI チャネル
│  │  │      adaptor.go                  # Dify アダプター
│  │  │      constants.go                # Dify 定数定義
│  │  │      dto.go                      # Dify データ転送オブジェクト
│  │  │      relay-dify.go               # Dify リクエスト転送
│  │  │
│  │  ├─gemini                           # Google Gemini AI チャネル
│  │  │      adaptor.go                  # Gemini アダプター
│  │  │      constant.go                 # Gemini 定数定義
│  │  │      dto.go                      # Gemini データ転送オブジェクト
│  │  │      relay-gemini.go             # Gemini リクエスト転送
│  │  │
│  │  ├─jina                             # Jina AI チャネル
│  │  │      adaptor.go                  # Jina アダプター
│  │  │      constant.go                 # Jina 定数定義
│  │  │      relay-jina.go               # Jina リクエスト転送
│  │  │
│  │  ├─lingyiwanwu                      # 霊医万物 AI チャネル
│  │  │      constrants.go               # 霊医万物定数定義
│  │  │
│  │  ├─minimax                          # MiniMax AI チャネル
│  │  │      constants.go                # MiniMax 定数定義
│  │  │      relay-minimax.go            # MiniMax リクエスト転送
│  │  │
│  │  ├─mistral                          # Mistral AI チャネル
│  │  │      adaptor.go                  # Mistral アダプター
│  │  │      constants.go                # Mistral 定数定義
│  │  │      text.go                     # Mistral テキスト処理
│  │  │
│  │  ├─mokaai                           # MokaAI チャネル
│  │  │      adaptor.go                  # MokaAI アダプター
│  │  │      constants.go                # MokaAI 定数定義
│  │  │      relay-mokaai.go             # MokaAI リクエスト転送
│  │  │
│  │  ├─moonshot                         # Moonshot AI チャネル
│  │  │      constants.go                # Moonshot 定数定義
│  │  │
│  │  ├─ollama                           # Ollama AI チャネル
│  │  │      adaptor.go                  # Ollama アダプター
│  │  │      constants.go                # Ollama 定数定義
│  │  │      dto.go                      # Ollama データ転送オブジェクト
│  │  │      relay-ollama.go             # Ollama リクエスト転送
│  │  │
│  │  ├─openai                           # OpenAI チャネル
│  │  │      adaptor.go                  # OpenAI アダプター
│  │  │      constant.go                 # OpenAI 定数定義
│  │  │      relay-openai.go             # OpenAI リクエスト転送
│  │  │
│  │  ├─openrouter                       # OpenRouter AI チャネル
│  │  │      adaptor.go                  # OpenRouter アダプター
│  │  │      constant.go                 # OpenRouter 定数定義
│  │  │
│  │  ├─palm                             # Google PaLM AI チャネル
│  │  │      adaptor.go                  # PaLM アダプター
│  │  │      constants.go                # PaLM 定数定義
│  │  │      dto.go                      # PaLM データ転送オブジェクト
│  │  │      relay-palm.go               # PaLM リクエスト転送
│  │  │
│  │  ├─perplexity                       # Perplexity AI チャネル
│  │  │      adaptor.go                  # Perplexity アダプター
│  │  │      constants.go                # Perplexity 定数定義
│  │  │      relay-perplexity.go         # Perplexity リクエスト転送
│  │  │
│  │  ├─siliconflow                      # SiliconFlow AI チャネル
│  │  │      adaptor.go                  # SiliconFlow アダプター
│  │  │      constant.go                 # SiliconFlow 定数定義
│  │  │      dto.go                      # SiliconFlow データ転送オブジェクト
│  │  │      relay-siliconflow.go        # SiliconFlow リクエスト転送
│  │  │
│  │  ├─task                             # タスク関連チャネル
│  │  │  └─suno                          # Suno 音声生成タスク
│  │  │          adaptor.go              # Suno アダプター
│  │  │          models.go               # Suno モデル定義
│  │  │
│  │  ├─tencent                          # 騰訊 AI チャネル
│  │  │      adaptor.go                  # 騰訊アダプター
│  │  │      constants.go                # 騰訊定数定義
│  │  │      dto.go                      # 騰訊データ転送オブジェクト
│  │  │      relay-tencent.go            # 騰訊リクエスト転送
│  │  │
│  │  ├─vertex                           # Google Vertex AI チャネル
│  │  │      adaptor.go                  # Vertex アダプター
│  │  │      constants.go                # Vertex 定数定義
│  │  │      dto.go                      # Vertex データ転送オブジェクト
│  │  │      relay-vertex.go             # Vertex リクエスト転送
│  │  │      service_account.go          # Vertex サービスアカウント
│  │  │
│  │  ├─volcengine                       # 火山エンジン AI チャネル
│  │  │      adaptor.go                  # 火山エンジンアダプター
│  │  │      constants.go                # 火山エンジン定数定義
│  │  │
│  │  ├─xunfei                           # 訊飛 AI チャネル
│  │  │      adaptor.go                  # 訊飛アダプター
│  │  │      constants.go                # 訊飛定数定義
│  │  │      dto.go                      # 訊飛データ転送オブジェクト
│  │  │      relay-xunfei.go             # 訊飛リクエスト転送
│  │  │
│  │  ├─zhipu                            # 智譜 AI チャネル
│  │  │      adaptor.go                  # 智譜アダプター
│  │  │      constants.go                # 智譜定数定義
│  │  │      dto.go                      # 智譜データ転送オブジェクト
│  │  │      relay-zhipu.go              # 智譜リクエスト転送
│  │  │
│  │  └─zhipu_4v                         # 智譜 4.0 バージョンチャネル
│  │          adaptor.go                 # 智譜 4.0 アダプター
│  │          constants.go               # 智譜 4.0 定数定義
│  │          dto.go                     # 智譜 4.0 データ転送オブジェクト
│  │          relay-zhipu_v4.go          # 智譜 4.0 リクエスト転送
│  │
│  ├─common                              # 転送共通モジュール
│  │      relay_info.go                  # 転送情報
│  │      relay_utils.go                 # 転送ユーティリティ関数
│  │
│  ├─constant                            # 転送定数ディレクトリ
│  │      api_type.go                    # API タイプ定数
│  │      relay_mode.go                  # 転送モード定数
│  │
│  └─helper                              # 転送補助機能
│          common.go                     # 共通補助関数
│          model_mapped.go               # モデルマッピング
│          price.go                      # 価格計算
│          stream_scanner.go             # ストリームデータスキャナー
│
├─router                                 # ルーティング設定ディレクトリ
│      api-router.go                     # API ルーティング設定
│      dashboard.go                      # ダッシュボードルーティング
│      main.go                           # メインルーティング設定
│      relay-router.go                   # 転送ルーティング設定
│      web-router.go                     # Web インターフェースルーティング設定
│
├─service                                # サービス層ディレクトリ
│      audio.go                          # 音声サービス
│      cf_worker.go                      # Cloudflare Worker サービス
│      channel.go                        # チャネルサービス
│      epay.go                           # 電子決済サービス
│      error.go                          # エラー処理サービス
│      file_decoder.go                   # ファイルデコーダーサービス
│      http_client.go                    # HTTP クライアントサービス
│      image.go                          # 画像処理サービス
│      log_info_generate.go              # ログ情報生成サービス
│      midjourney.go                     # Midjourney サービス
│      notify-limit.go                   # 通知制限サービス
│      quota.go                          # クォータ管理サービス
│      sensitive.go                      # 機密コンテンツフィルタリングサービス
│      str.go                            # 文字列処理サービス
│      task.go                           # タスク管理サービス
│      token_counter.go                  # トークンカウントサービス
│      usage_helpr.go                    # 使用量統計補助サービス
│      user_notify.go                    # ユーザー通知サービス
│      webhook.go                        # WebHook サービス
│
├─setting                                # 設定管理ディレクトリ
│  │  chat.go                            # チャット設定
│  │  group_ratio.go                     # ユーザーグループ比率設定
│  │  midjourney.go                      # Midjourney 設定
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
│  │      claude.go                      # Claude モデル設定
│  │      gemini.go                      # Gemini モデル設定
│  │      global.go                      # グローバルモデル設定
│  │
│  ├─operation_setting                   # 運用設定ディレクトリ
│  │      cache_ratio.go                 # キャッシュ比率設定
│  │      general_setting.go             # 一般設定
│  │      model-ratio.go                 # モデル比率設定
│  │      operation_setting.go           # 運用設定
│  │
│  └─system_setting                      # システム設定ディレクトリ
│          oidc.go                       # OpenID Connect 設定
│
└─web                                    # フロントエンド Web インターフェースディレクトリ
    │  .gitignore                        # フロントエンド Git 無視ファイル設定
    │  .prettierrc.mjs                   # Prettier コードフォーマット設定
    │  bun.lockb                         # Bun パッケージマネージャーロックファイル
    │  index.html                        # メイン HTML ファイル
    │  package.json                      # フロントエンド依存関係設定
    │  bun.lockb                         # Bun パッケージマネージャーロックファイル（バイナリ形式、より高速）
    │  README.md                         # フロントエンド説明ドキュメント
    │  vercel.json                       # Vercel デプロイ設定
    │  vite.config.js                    # Vite ビルド設定
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
        │  index.js                      # アプリケーションエントリ JS
        │
        ├─components                     # コンポーネントディレクトリ
        │  │  ChannelsTable.js           # チャネルテーブルコンポーネント
        │  │  fetchTokenKeys.js          # トークン Key 取得ユーティリティ
        │  │  Footer.js                  # フッターコンポーネント
        │  │  HeaderBar.js               # ヘッダーバーコンポーネント
        │  │  LinuxDoIcon.js             # LinuxDo アイコンコンポーネント
        │  │  Loading.js                 # ローディングコンポーネント
        │  │  LoginForm.js               # ログインフォームコンポーネント
        │  │  LogsTable.js               # ログテーブルコンポーネント
        │  │  MjLogsTable.js             # Midjourney ログテーブルコンポーネント
        │  │  ModelPricing.js            # モデル価格設定コンポーネント
        │  │  ModelSetting.js            # モデル設定コンポーネント
        │  │  OAuth2Callback.js          # OAuth2 コールバックコンポーネント
        │  │  OIDCIcon.js                # OIDC アイコンコンポーネント
        │  │  OperationSetting.js        # 運用設定コンポーネント
        │  │  OtherSetting.js            # その他設定コンポーネント
        │  │  PageLayout.js              # ページレイアウトコンポーネント
        │  │  PasswordResetConfirm.js    # パスワードリセット確認コンポーネント
        │  │  PasswordResetForm.js       # パスワードリセットフォームコンポーネント
        │  │  PersonalSetting.js         # 個人設定コンポーネント
        │  │  PrivateRoute.js            # プライベートルートコンポーネント
        │  │  RateLimitSetting.js        # レート制限設定コンポーネント
        │  │  RedemptionsTable.js        # 償還コードテーブルコンポーネント
        │  │  RegisterForm.js            # 登録フォームコンポーネント
        │  │  SafetySetting.js           # 安全設定コンポーネント
        │  │  SiderBar.js                # サイドバーコンポーネント
        │  │  SystemSetting.js           # システム設定コンポーネント
        │  │  TaskLogsTable.js           # タスクログテーブルコンポーネント
        │  │  TokensTable.js             # トークン管理テーブルコンポーネント
        │  │  UsersTable.js              # ユーザー管理テーブルコンポーネント
        │  │  utils.js                   # 共通ユーティリティ関数
        │  │  WeChatIcon.js              # WeChat アイコンコンポーネント
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
        ├─context                        # React Context コンテキストディレクトリ
        │  ├─Status                      # ステータスコンテキスト
        │  │      index.js               # ステータスコンテキストエントリ
        │  │      reducer.js             # ステータスコンテキスト reducer
        │  │
        │  ├─Style                       # スタイルコンテキスト
        │  │      index.js               # スタイルコンテキストエントリ
        │  │
        │  ├─Theme                       # テーマコンテキスト
        │  │      index.js               # テーマコンテキストエントリ
        │  │
        │  └─User                        # ユーザーコンテキスト
        │          index.js              # ユーザーコンテキストエントリ
        │          reducer.js            # ユーザーコンテキスト reducer
        │
        ├─helpers                        # ヘルパー関数ディレクトリ
        │      api.js                    # API リクエストヘルパー関数
        │      auth-header.js            # 認証ヘッダー処理
        │      data.js                   # データ処理関数
        │      history.js                # ルーティング履歴管理
        │      index.js                  # ヘルパー関数エクスポートインデックス
        │      other.js                  # その他ヘルパー関数
        │      render.js                 # レンダリングヘルパー関数
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
            ├─About                      # About ページ
            │      index.js              # About ページエントリ
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
            ├─Midjourney                 # Midjourney 管理ページ
            │      index.js              # Midjourney ページエントリ
            │
            ├─NotFound                   # 404 ページ
            │      index.js              # 404 ページエントリ
            │
            ├─Playground                 # プレイグラウンドページ
            │      Playground.js         # プレイグラウンドコンポーネント
            │
            ├─Pricing                    # 価格管理ページ
            │      index.js              # 価格管理ページエントリ
            │
            ├─Redemption                 # 償還コード管理ページ
            │      EditRedemption.js     # 償還コード編集コンポーネント
            │      index.js              # 償還コード管理ページエントリ
            │
            ├─Setting                    # 設定ページ
            │  │  index.js               # 設定ページエントリ
            │  │
            │  ├─Model                   # モデル設定ページ
            │  │      SettingClaudeModel.js # Claude モデル設定コンポーネント
            │  │      SettingGeminiModel.js # Gemini モデル設定コンポーネント
            │  │      SettingGlobalModel.js # グローバルモデル設定コンポーネント
            │  │
            │  ├─Operation               # 運用設定ページ
            │  │      GroupRatioSettings.js       # ユーザーグループ比率設定コンポーネント
            │  │      ModelRationNotSetEditor.js  # モデル比率未設定エディタ
            │  │      ModelRatioSettings.js       # モデル比率設定コンポーネント
            │  │      ModelSettingsVisualEditor.js # モデル設定ビジュアルエディタ
            │  │      SettingsChats.js            # チャット設定コンポーネント
            │  │      SettingsCreditLimit.js      # クォータ制限設定コンポーネント
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
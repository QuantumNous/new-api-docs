# Claude Code
-------------------------------------

<style>
    .inline-badge img {
        display: inline-block; /* または使用 display: inline; */
        vertical-align: middle; /* 対処方法、もし必要なら */
    }
</style>
<div class="inline-badge" style="line-height: 1; display: block;">
  <img src="https://img.shields.io/badge/-Windows-0078D6?logo=windows&style=flat&logoColor=white" alt="Windows" style="height: 20px; margin: 0; vertical-align: top;">
  <img src="https://img.shields.io/badge/-macOS-black?logo=apple&style=flat&logoColor=white" alt="macOS" style="height: 20px; margin: 0; vertical-align: top;">
  <img src="https://img.shields.io/badge/-Linux-FCC624?logo=linux&style=flat&logoColor=black" alt="Linux" style="height: 20px; margin: 0; vertical-align: top;">
</div>

!!! info "プロジェクト紹介"
    Unleash Claude’s raw power directly in your terminal. Search million-line codebases instantly. Turn hours-long workflows into a single command. Your tools. Your workflow. Your codebase, evolving at thought speed.

    ターミナルで直接、Claudeの強力なパワーを解き放ちます。数百万行のコードベースを瞬時に検索。数時間かかるワークフローを単一のコマンドに変えます。あなたのツール。あなたのワークフロー。あなたのコードベースが、思考のスピードで進化します。

    1. 公式ホームページ：<a href="https://www.anthropic.com/claude-code" target="_blank">https://www.anthropic.com/claude-code</a>
    1. インストール方法：本ページ下部のチュートリアルを参照

## デモンストレーション
-------------------------------------

![introduce-01.webp](../assets/claude_code/introduce-01.webp)

![introduce-02.webp](../assets/claude_code/introduce-02.webp)

### 特徴

| **機能カテゴリ** | **特徴** |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| **コード理解** | - スマートエージェントを活用した詳細なコードベース分析、プロジェクト構造と依存関係の理解                                                          |
|                | - 高レベルのコード概要を自動生成し、ユーザーのコードベース理解を迅速に支援                                                                   |
| **コード編集** | - 複雑なコード修正に対応するマルチファイル協調編集をサポート                                                                                 |
|                | - プロジェクトのパターンとアーキテクチャに適合した、実際に使用可能なコード提案を提供                                                           |
| **統合能力** | - コンテキストを切り替えることなく、ターミナルで直接実行可能                                                                               |
|                | - VS CodeおよびJetBrains IDEとのシームレスな統合、コピー＆ペーストは不要                                                                      |
| **コード生成と最適化** | - コードの自動生成、テスト作成、バグ修正、コンセプトからコミットまでの完全なプロセスをサポート                                                  |
|                | - Claude Opus 4などの高度なモデルと連携し、コード生成と理解のために最適化                                                                   |
| **安全性と柔軟性** | - 変更にはユーザーの明確な承認が必要であり、ファイルおよびコマンド操作の安全性が向上                                                         |
|                | - ユーザーのコード規約に適応し、カスタム設定をサポート                                                                                     |
| **ツールチェーン統合** | - GitHub、GitLabなどのツールとの連携をサポートし、自動化されたワークフローを実現                                                           |
|                | - テストスイート、ビルドシステムと統合し、既存の開発ツールを強化                                                                           |
| **クロスプラットフォームと拡張性** | - Windows、macOS、Linuxオペレーティングシステムをサポート                                                                            |
|                | - SDKまたはGitHub Actionsでの実行を設定可能で、さまざまなニーズに柔軟に対応                                                                 |
| **主な応用シーン** | - コードベースの入門と理解、新規メンバーの迅速な立ち上げ                                                                                   |
|                | - コードの問題修正と最適化プロセス、問題分析からPR提出まで                                                                                 |
|                | - プロジェクトコードのリファクタリングと新機能の実装                                                                                         |
| **ユーザーフィードバックのハイライト** | - 日常の開発効率を向上させ、ルーチンタスクに費やす時間を削減                                                                       |
|                | - 複雑な多段階タスクの処理に優れており、開発の可能性を拡大                                                                                   |

## AIモデルの設定方法

### Windowsでの画像付きガイド

#### 1. Node.js環境のインストール

Claude Codeを実行するにはNode.js環境が必要です。

!!! info "Node.js環境のインストール手順"
    - ブラウザで https://nodejs.org/ にアクセスします
    - 「LTS」バージョンをクリックしてダウンロードします（長期サポートバージョンを推奨）
    - ダウンロードが完了したら、.msiファイルをダブルクリックします
    - インストールウィザードに従ってインストールを完了します。デフォルト設定のままで問題ありません

!!! caution "Windowsでの注意事項"
    - CMDではなくPowerShellの使用を推奨します
    - 権限の問題が発生した場合は、管理者として実行してみてください
    - 一部のウイルス対策ソフトが誤検知する可能性があるため、ホワイトリストに追加する必要があります

![windows-img-01.webp](../assets/claude_code/windows-img-01.webp)

![windows-img-02.webp](../assets/claude_code/windows-img-02.webp)

![windows-img-03.webp](../assets/claude_code/windows-img-03.webp)

![windows-img-04.webp](../assets/claude_code/windows-img-04.webp)

![windows-img-05.webp](../assets/claude_code/windows-img-05.webp)

!!! caution "インストールが成功したかどうかの確認"
    インストール完了後、PowerShellまたはCMDを開き、以下のコマンドを入力します：
    ```
    node --version
    npm --version
    ```
    バージョン番号が表示されれば、インストールは成功です

#### 2. Git Bashのインストール

!!! caution "Windowsでの注意事項"
    Windows環境では、Claude codeのインストールにGit Bashを使用する必要があります。インストール完了後、環境変数の設定とClaude Codeの使用は、引き続き通常のPowerShellまたはCMDで行われます。

!!! info "Git for Windowsのダウンロードとインストール"
    - https://git-scm.com/downloads/win にアクセスします
    - 「Download for Windows」をクリックしてインストールパッケージをダウンロードします
    - ダウンロードした.exeインストールファイルを実行します
    - インストールプロセス中はデフォルト設定を維持し、そのまま「Next」をクリックしてインストールを完了します

![windows-img-06.webp](../assets/claude_code/windows-img-06.webp)

![windows-img-07.webp](../assets/claude_code/windows-img-07.webp)

![windows-img-08.webp](../assets/claude_code/windows-img-08.webp)

!!! caution "Git Bashインストールの確認"
    インストール完了後、Git Bashを開き、以下のコマンドを入力して確認します：
    ```
    git --version
    ```
    バージョン番号が表示されれば、インストールは成功です

#### 3. Claude Codeのインストール

!!! info "Claude Codeのインストール"
    PowerShellを開き、以下のコマンドを実行します：
    ```
    npm install -g @anthropic-ai/claude-code
    ```
    このコマンドは、npm公式リポジトリから最新バージョンのClaude Codeをダウンロードしてインストールします。

![windows-img-09.webp](../assets/claude_code/windows-img-09.webp)

!!! info "~/.local/bin をPATHに追加（プロンプトで要求された場合のみ）"
    ```
    [Environment]::SetEnvironmentVariable('Path', ([Environment]::GetEnvironmentVariable('Path','User') + ";$HOME\.local\bin"), 'User')
    ```

!!! info "Claude Codeインストールの確認"
    インストール完了後、以下のコマンドを入力してインストールが成功したか確認します：
    ```
    claude --version
    ```
    バージョン番号が表示されたら、おめでとうございます！Claude Codeのインストールは成功です。

#### 4. 環境変数の設定

!!! info "ワンクリック設定コマンド (Windows システム)"
    Claude Codeを中継サービスに接続するために、複数の環境変数を設定する必要があります：
    ```
    iex (irm 'https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/claude-cli-setup.ps1')
    ```

![windows-configure](../assets/claude_code/windows_configure.png)

#### 5. Claude Codeの使用開始

これでClaude Codeの使用を開始できます！

!!! info "Claude Codeの起動"
    PowerShellを開き、直接Claude Codeを起動します：
    ```
    # Claude Codeの起動
    claude
    ```
    特定のプロジェクトで使用する場合:
    ```
    # プロジェクトディレクトリに移動
    cd C:\path\to\your\project
    ```
    ```
    # Claude Codeの起動
    claude
    ```

![windows-img-11.webp](../assets/claude_code/windows-img-11.webp)

![windows-img-12.webp](../assets/claude_code/windows-img-12.webp)

![windows-img-13.webp](../assets/claude_code/windows-img-13.webp)

![windows-img-14.webp](../assets/claude_code/windows-img-14.webp)

![windows-img-15.webp](../assets/claude_code/windows-img-15.webp)

!!! info "モデルの選択"
    コマンドを入力します：
    ```
    /model
    ```
    Enterを押してモデルを選択します。通常はデフォルト設定で問題ありません。

![windows-img-16.webp](../assets/claude_code/windows-img-16.webp)

![windows-img-17.webp](../assets/claude_code/windows-img-17.webp)
> 注意：環境変数を設定・変更した後、すべてのモデル（公式プリセットモデルを含む）はカスタムアクセスポイントを呼び出し、公式アカウントのクォータは使用されません。

### macOSでの画像付きガイド

#### 1. Claude Code CLIのインストール

ターミナルを開きます

![macos-img-01.webp](../assets/claude_code/macos-img-01.webp)

!!! info "Claude Codeのインストール"
    ターミナルを開き、以下のコマンドを実行します：
    ```
    curl -fsSL https://claude.ai/install.sh | bash
    ```
    オプション：プロンプトが表示された後に提供されたコマンドを実行します
    ```
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
    ```

![macos-img-02.webp](../assets/claude_code/macos-img-02.webp)

#### 2. 環境変数の設定

Claude Codeをサードパーティの中継サービスに接続するために、環境変数を設定する必要があります：

!!! info "Claude Code環境変数のワンクリック設定"
    コマンドを入力します：
    ```
    curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/claude-cli-setup.sh | bash
    ```

![macos-configure](../assets/claude_code/macos_configure.png)


!!! info "Claude Codeインストールの確認"
    インストール完了後、以下のコマンドを入力してインストールが成功したか確認します：
    ```
    claude --version
    ```
    バージョン番号が表示されたら、おめでとうございます！Claude Codeのインストールは成功です。

#### 3. Claude Codeの使用開始

これでClaude Codeの使用を開始できます！

!!! info "Claude Codeの起動"
    直接Claude Codeを起動します：
    ```
    # Claude Codeの起動
    claude
    ```
    特定のプロジェクトで使用する場合:
    ```
    # プロジェクトディレクトリに移動
    cd /path/to/your/project
    ```
    ```
    # Claude Codeの起動
    claude
    ```

![macos-img-04.webp](../assets/claude_code/macos-img-04.webp)

![macos-img-05.webp](../assets/claude_code/macos-img-05.webp)

![macos-img-06.webp](../assets/claude_code/macos-img-06.webp)

![macos-img-07.webp](../assets/claude_code/macos-img-07.webp)

![macos-img-08.webp](../assets/claude_code/macos-img-08.webp)

!!! info "モデルの選択 (オプション)"
    コマンドを入力します：
    ```
    /model
    ```
    Enterを押して公式モデルを選択します。通常はデフォルトモデルで問題ありません

![macos-img-09.webp](../assets/claude_code/macos-img-09.webp)

![macos-img-10.webp](../assets/claude_code/macos-img-10.webp)

![macos-img-11.webp](../assets/claude_code/macos-img-11.webp)
> 注意：環境変数`ANTHROPIC_BASE_URL`を設定・変更した後、すべてのモデル（公式プリセットモデルを含む）はカスタムアクセスポイントを呼び出し、公式アカウントのクォータは使用されません。

#### 6. macOSのよくある問題解決

??? example "macOSのセキュリティ設定による実行のブロック"
    システムがClaude Codeの実行をブロックした場合：

    - 「システム環境設定」→「セキュリティとプライバシー」を開きます
    - 「このまま開く」または「許可」をクリックします
    - または`Terminal`で実行します：`sudo spctl --master-disable`

### Linuxでの画像付きガイド

#### 1. Claude Codeのインストール

![linux-img-01.webp](../assets/claude_code/linux-img-01.webp)

!!! info "Claude Codeのインストール"
    ターミナルを開き、以下のコマンドを実行します：
    ```
    curl -fsSL https://claude.ai/install.sh | bash
    ```
    権限の問題が発生した場合は、sudoを使用できます：
    ```
    sudo curl -fsSL https://claude.ai/install.sh | bash
    ```
![linux-img-03.webp](../assets/claude_code/linux-img-03.webp)

!!! info "Claude Codeインストールの確認"
    インストール完了後、以下のコマンドを入力してインストールが成功したか確認します：
    ```
    claude --version
    ```
    バージョン番号が表示されたら、おめでとうございます！Claude Codeのインストールは成功です。

#### 2. 環境変数の設定

Claude Codeを中継サービスに接続するために、2つの環境変数を設定する必要があります：

!!! info "環境変数のワンクリック変更"
    コマンドを入力します：
    ```
    curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/claude-cli-setup.sh | bash
    ```

![macos-configure](../assets/claude_code/macos_configure.png)

#### 4. Claude Codeの使用開始

これでClaude Codeの使用を開始できます！

!!! info "Claude Codeの起動"
    直接Claude Codeを起動します：
    ```
    # Claude Codeの起動
    claude
    ```
    特定のプロジェクトで使用する場合:
    ```
    # プロジェクトディレクトリに移動
    cd /path/to/your/project
    ```
    ```
    # Claude Codeの起動
    claude
    ```

![linux-img-03.webp](../assets/claude_code/linux-img-03.webp)

![linux-img-04.webp](../assets/claude_code/linux-img-04.webp)

![linux-img-05.webp](../assets/claude_code/linux-img-05.webp)

!!! info "モデルの選択"
    コマンドを入力します：
    ```
    /model
    ```
    Enterを押して公式モデルを選択します。通常はデフォルトモデルで問題ありません

![linux-img-06.webp](../assets/claude_code/linux-img-06.webp)

![linux-img-07.webp](../assets/claude_code/linux-img-07.webp)

![linux-img-08.webp](../assets/claude_code/linux-img-08.webp)

![linux-img-09.webp](../assets/claude_code/linux-img-09.webp)
> 注意：環境変数`ANTHROPIC_BASE_URL`を設定・変更した後、すべてのモデル（公式プリセットモデルを含む）はカスタムアクセスポイントを呼び出し、公式アカウントのクォータは使用されません。

#### 5. Linuxのよくある問題解決

??? example "依存ライブラリの不足"
    一部のLinuxディストリビューションでは、追加の依存関係をインストールする必要があります：
    ```
    # Ubuntu/Debian
    sudo apt install build-essential
    ```
    ```
    # CentOS/RHEL
    sudo dnf groupinstall "Development Tools"
    ```

??? example "環境変数が有効にならない"
    以下の点を確認してください：

    - 正しい設定ファイル（`.bashrc`または`.zshrc`）を変更したことを確認
    - ターミナルを再起動するか、`source ~/.bashrc`を実行
    - 設定の検証：`echo $ANTHROPIC_BASE_URL`
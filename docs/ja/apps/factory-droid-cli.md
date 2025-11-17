# Factory Droid CLI
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
    Command Line: Automation Across the SDLC. Script and parallelize Droids at massive scale for CI/CD, migrations, and maintenance. From automated code review to self-healing builds, integrate agents into every phase of development.

    Droid CLI は、Factory AI によって開発されたコマンドラインツールであり、AIソフトウェアエンジニアリングエージェントとして動作するように設計されています。ユーザーはターミナルを通じて様々な大規模言語モデルと対話し、コードの構築、デバッグ、リファクタリング、さらには完全なアプリケーションの作成を行うことができます。

    1. 公式ホームページ：<a href="https://factory.ai/product/cli" target="_blank">https://factory.ai/product/cli</a>
    1. 公式ドキュメント：<a href="https://docs.factory.ai/cli/getting-started/quickstart" target="_blank">https://docs.factory.ai/cli/getting-started/quickstart</a>
    1. インストール方法：本ページ下部のチュートリアルを参照

## 動作デモ
-------------------------------------

![droid.webp](../assets/factory_droid_cli/droid_example.webp)

### 特徴

| カテゴリ | 特徴 | 価値/機能 | 例/備考 |
|---|---|---|---|
| クイックスタートと CLI | 30秒でインストール；プロジェクトディレクトリ内でdroid対話セッションを開始；macOS/LinuxおよびWindowsをサポート | 既存のプロジェクトに迅速にアクセスでき、新しいツールは不要 | Windowsインストール：`irm https://app.factory.ai/cli/windows | iex`；起動：`droid` |
| エンドツーエンドの機能開発 | 計画から実装、テストまでの全プロセスを自動化；透明なレビュープロセス | デリバリー速度を向上させ、人間の制御を維持 | ネイティブな差分表示と承認プロセス（「透明性と制御」を参照） |
| コードベースの深い理解 | 組織のコードベース、ドキュメント、Issue追跡における共有知識を統合；コンテキスト認識、効果は時間とともに向上 | より正確な提案と変更 | リポジトリやドキュメントを横断した知識を継続的に活用 |
| エンジニアリングシステム統合 | Jira、Notion、Slackなどのツールとネイティブ統合；開発作業とチームプロセスを同期 | ツール切り替えと情報のサイロ化を削減 | 「など」はさらなる統合があることを示します |
| プロダクションレベルの自動化 | ワークフローはローカルおよび CI/CD で再利用可能；エンタープライズレベルのセキュリティとコンプライアンスを内蔵 | 一貫性と監査可能性 | パイプラインとエンタープライズ環境に適応 |
| エンタープライズ機能 | プライベートデプロイオプション、SOC-2準拠、エアギャップ環境 | セキュリティとコンプライアンス要件を満たす | セキュリティと品質を優先 |
| 既存ツールの強化 | ターミナル、IDE、既存の開発環境で動作；エディタを切り替えたり、新しいインターフェースを学ぶ必要なし | 既存の作業習慣を維持、低い移行コスト | 使い慣れたツールとの深い統合 |
| 透明性と制御 | すべての決定が可視化され、レビュー可能；コード変更に対する完全な監視を維持；ネイティブな差分表示と承認ワークフロー | リスクを低減し、制御性を向上 | 監査に優しく、追跡可能 |
| モデルの柔軟性 | 単一のAIプロバイダーにロックインされない；タスクに応じて最適なモデルを選択；組織レベルで一貫した動作と記憶 | パフォーマンスとコストの間で最適な選択を行う | マルチモデルルーティングをサポート |
| 次のステップとリソース | Quickstart、Common Use Cases、IDE Integration、Configuration、AGENTS.md | 導入と実践を容易にする | ページ内の「Next steps/Additional resources」を参照 |

## AIモデルの設定方法

### Windowsでの画像付きガイド

#### 1. ターミナルを開く

![windows_open_terminal](../assets/factory_droid_cli/windows_open_terminal.png)

#### 2. Factory Droid CLIのインストール

公式のワンクリックインストールコマンド：

!!! info "ワンクリックインストールコマンド"
    ```
    irm https://app.factory.ai/cli/windows | iex
    ```

![windows-install](../assets/factory_droid_cli/windows_install_droid.webp)

#### 3. 設定ファイルの変更

Droid CLIがサードパーティAPIを使用するには、設定ファイルを変更する必要があります。

![windows-configure.webp](../assets/factory_droid_cli/factory_cli_setup_windows.png)

!!! info "環境変数の変更"
    ```
    iex (irm 'https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/factory-cli-setup.ps1')
    ```

#### 4. Droid CLIの利用開始

これで Droid CLI を使い始めることができます！

!!! info "Droid CLIの起動"
    Droid CLI を直接起動:
    ```
    # 起動 Droid CLI
    droid
    ```
    特定のプロジェクトで使用する場合:
    ```
    # プロジェクトディレクトリに移動
    cd C:\path\to\your\project
    ```
    ```
    # 起動 Droid CLI
    droid
    ```
    Enter で Droid CLI を起動

Droid CLI を使用するには、公式アカウント（無料）にログインする必要があります。

#### 5. Windowsのよくある問題解決

??? example "インストール時に「permission denied」エラーが表示される場合"
    これは通常、権限の問題です。以下の解決策を試してください：

    - `PowerShell`を管理者として実行する

    - または、`npm`がユーザーディレクトリを使用するように設定する：`npm config set prefix %APPDATA%\npm`

??? example "PowerShell 実行ポリシーエラー"
    実行ポリシーの制限に遭遇した場合は、以下を実行してください：
    ```
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

### macOS/Linuxでの画像付きガイド

#### 1. Droid CLIのインストール

!!! info "Droid CLIのインストール"
    ターミナルを開き、以下のコマンドを実行してください：
    ```
    curl -fsSL https://app.factory.ai/cli | sh
    ```

![macos-open-terminal](../assets/factory_droid_cli/macos_install_droid.webp)

![macos-img-02.webp](../assets/factory_droid_cli/macos_install_droid_2.webp)

インストールプロンプトに従って環境変数を変更します（インストールプロンプトのコードをそのままコピーしてください）：

Linuxでは状況に応じて `~/.bashrc` または `~/.zshrc` を選択してください

!!! info "Droid CLI 環境変数 (例としてのみ)"
    ```
    echo 'export PATH=/Users/修改此处/.local/bin:$PATH' >> ~/.zshrc
    ```
    ```
    source ~/.zshrc
    ```

#### 2. 設定ファイルの変更

Droid CLIがサードパーティAPIを使用するには、設定ファイルを変更する必要があります。

!!! info "ワンクリック設定ファイル変更"
    ```
    curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/factory-cli-setup.sh | bash
    ```

![macos-img-03.webp](../assets/factory_droid_cli/macos_configure.png)

#### 3. Droid CLIの利用開始

これで Droid CLI を使い始めることができます！

!!! info "Droid CLIの起動"
    Droid CLI を直接起動:
    ```
    # 起動 Droid CLI
    droid
    ```
    特定のプロジェクトで使用する場合:
    ```
    # プロジェクトディレクトリに移動
    cd /path/to/your/project
    ```
    ```
    # 起動 Droid CLI
    droid
    ```
    Enter で Droid CLI を起動

>Droid CLI を使用するには、公式アカウント（無料）にログインする必要があります。
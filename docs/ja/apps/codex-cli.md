# OpenAI Codex CLI
-------------------------------------

<style>
    .inline-badge img {
        display: inline-block; /* または display: inline; */
        vertical-align: middle; /* 必要に応じてアライメントを設定 */
    }
</style>
<div class="inline-badge" style="line-height: 1; display: block;">
  <img src="https://img.shields.io/badge/-Windows-0078D6?logo=windows&style=flat&logoColor=white" alt="Windows" style="height: 20px; margin: 0; vertical-align: top;">
  <img src="https://img.shields.io/badge/-macOS-black?logo=apple&style=flat&logoColor=white" alt="macOS" style="height: 20px; margin: 0; vertical-align: top;">
  <img src="https://img.shields.io/badge/-Linux-FCC624?logo=linux&style=flat&logoColor=black" alt="Linux" style="height: 20px; margin: 0; vertical-align: top;">
</div>

!!! info "プロジェクト紹介"
    Codex CLI is a coding agent from OpenAI that runs locally on your computer.

    Codex CLI は、OpenAI が提供するコーディングエージェントであり、お使いのコンピューター上でローカルに実行されます。

    1. 公式ホームページ：<a href="https://chatgpt.com/codex" target="_blank">https://chatgpt.com/codex</a>
    1. プロジェクトホームページ：<a href="https://github.com/openai/codex" target="_blank">https://github.com/openai/codex</a>
    1. インストール方法：本ページ下部のチュートリアルを参照

## 動作デモ
-------------------------------------

![introduce-01.webp](../assets/codex/introduce-01.webp)

### 特徴

| **機能分類** | **特徴** |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| ターミナルベースのコーディングアシスタント | Codex CLI は、ターミナルベースの対話型コーディングアシスタントであり、コマンドラインでコードの編集、パッチの生成、コマンドの実行に使用されます。 |
| ツール駆動型アーキテクチャ | `apply_patch`、`shell`、`update_plan`、`multi_tool_use` などのツールを提供し、リポジトリファイルと操作を制御された方法で変更するために使用されます。 |
| アトミックなパッチ編集 | 専用のパッチ形式を使用し、`apply_patch` を介してファイルをアトミックに追加/更新/削除することで、監査とロールバックを容易にします。 |
| サンドボックスと承認 | サンドボックスポリシー（例：`workspace-write`、`read-only`）および承認モード（`on-request`、`on-failure`、`never`）をサポートし、書き込みおよびネットワークアクセス権限を制御します。 |
| プラン追跡 | `update_plan` はステップをリストアップし、ステータスを追跡するために使用されます。明確な進捗を維持するために、常に `in_progress` ステップが1つだけ存在する必要があります。 |
| 対話の規範 | 重要な操作の前に短い前置きの説明を送信し、友好的で簡潔なトーンを保ち、進捗状況の更新を提供します。 |
| セキュリティ制約 | 厳格なルール（無関係なファイルを勝手に変更しない、著作権ヘッダーを追加しない、破壊的なコマンドを実行しない）に従い、機密性の高い操作にはユーザーの承認が必要です。 |
| テストとフォーマット | 変更後に関連するテストとフォーマットツールを実行することを推奨しますが、現在のタスクに関係のない問題の修正は担当しません。 |
| 出力とスタイル | 最終出力は CLI のレンダリング規範（例：`**` 見出し、逆引用符によるパス/コマンドの表示）に従い、スキャンしやすい簡潔な構造を保ちます。 |
| 並列実行 | `multi_tool_use.parallel` を介した複数のツールの並列実行をサポートし、効率を向上させます。 |

## AIモデル設定方法

### Windows版 図解ガイド

#### 1.ターミナルを開く

![windows_open_terminal](../assets/codex/windows_open_terminal.png)

#### 2.WSLのインストール

Windowsで最高のパフォーマンスを得るには、Windows Subsystem for Linux (WSL2) をインストールして使用してください。

!!! info "WSL2をインストールし、Windowsコンピューターを再起動します"
    ```
    wsl --install
    ```
    インストールが完了したら、Windowsコンピューターを再起動してください

!!! caution "Windowsでの注意事項"
    - CMDではなくPowerShellの使用を推奨します
    - 権限の問題が発生した場合は、管理者として実行してみてください
    - 特定のウイルス対策ソフトウェアが誤検知する可能性があるため、ホワイトリストに追加する必要があります

![windows-img-03.webp](../assets/codex/windows-img-03.webp)

!!! info "Node Version Manager (NVM) のダウンロード"
    ```
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    ```

![windows-img-04.webp](../assets/codex/windows-img-04.webp)

!!! info "NVMによるNode.js 22のインストール"
    タブバーで新しいPowerShellウィンドウを開き、WSLを起動します
    ```
    wsl
    ```

    Node.jsをインストールします
    
    バージョン番号は時期によって変わるため、OpenAIの公式サイトの要件に従って対応するバージョンをインストールしてください：https://developers.openai.com/codex/windows
    ```
    nvm install 22
    ```

![windows-img-05.webp](../assets/codex/windows-img-05.webp)

#### 3.Codex CLIのインストール

!!! info "Codex CLIのインストール"
    ```
    npm i -g @openai/codex
    ```
    このコマンドは、npm公式リポジトリから最新バージョンのCodex CLIをダウンロードしてインストールします。

![windows-img-06.webp](../assets/codex/windows-img-06.webp)

#### 4.設定ファイルの変更

!!! info "Codex CLI設定ファイルをワンクリックで変更"
    ```
    iex (irm 'https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/codex-cli-setup.ps1')
    ```

![windows-configure](../assets/codex/windows_configure.png)

#### 5.Codex CLIの使用開始

これでCodex CLIの使用を開始できます！

!!! info "Codex CLIの起動"
    WSL2を起動します
    ```
    wsl
    ```
    直接Codex CLIを起動:
    ```
    codex
    ```
    特定のプロジェクトで使用する場合:
    ```
    cd mnt/c/path/to/your/project
    ```
    ```
    codex
    ```
    EnterキーでCodex CLIを起動

![windows-img-09.webp](../assets/codex/windows-img-09.webp)

![windows-img-10.webp](../assets/codex/windows-img-10.webp)
> Codex CLIの権限設定：1. Codexがファイルを直接変更することを許可、2. Codexがファイルを変更する際に手動での承認が必要

!!! info "モデルの選択"
    ```
    /model
    ```

![windows-img-11.webp](../assets/codex/windows-img-11.webp)

![windows-img-12.webp](../assets/codex/windows-img-12.webp)

![windows-img-13.webp](../assets/codex/windows-img-13.webp)

![windows-img-14.webp](../assets/codex/windows-img-14.webp)
> 注意：インターフェースアドレスを変更した後、すべてのモデル（公式のプリセットモデルを含む）はカスタムアクセスポイントを呼び出し、公式アカウントのクォータは使用されません。

### macOS版 図解ガイド

#### 1.Homebrewのインストール (インストール済みの場合はスキップ)

Homebrew は、macOSに不足しているパッケージマネージャーです。

公式サイト：https://brew.sh

![macos-img-01.webp](../assets/codex/macos-img-01.webp)

!!! info "Homebrewのインストール"
    ```
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

![macos-img-02.webp](../assets/codex/macos-img-02.webp)

![macos-img-03.webp](../assets/codex/macos-img-03.webp)

![macos-img-04.webp](../assets/codex/macos-img-04.webp)

#### 2.Node.js環境のインストール

!!! info "Node.js環境のインストール手順"
    Homebrewを更新
    ```
    brew update
    ```
    Node.jsをインストール
    ```
    brew install node
    ```

!!! caution "macOSでの注意事項"
    - 権限の問題が発生した場合は、`sudo`を使用する必要があるかもしれません
    - 初回実行時には、システム環境設定で許可する必要があるかもしれません
    - `Terminal`または`iTerm2`の使用を推奨します

![macos-img-05.webp](../assets/codex/macos-img-05.webp)

![macos-img-06.webp](../assets/codex/macos-img-06.webp)

!!! information "インストールが成功したかどうかの確認"
    インストール完了後、ターミナルを開き、以下のコマンドを入力してください：
    ```
    node --version
    npm --version
    ```
    バージョン番号が表示されれば、インストールは成功です

#### 3.Codex CLIのインストール

!!! info "Codex CLIのインストール"
    ターミナルを開き、以下のコマンドを実行してください：
    ```
    # Codex CLIをグローバルにインストール
    npm install -g @openai/codex
    ```
    権限の問題が発生した場合は、sudoを使用できます：
    ```
    sudo npm install -g @openai/codex
    ```

![macos-img-07.webp](../assets/codex/macos-img-07.webp)

!!! info "Codex CLIのインストール確認"
    インストール完了後、以下のコマンドを入力してインストールが成功したか確認してください：
    ```
    codex --version
    ```
    バージョン番号が表示されれば、おめでとうございます！Codex CLIは正常にインストールされました。

#### 4.設定ファイルの変更

!!! info "Codex CLI設定ファイルをワンクリックで変更"
    ```
    curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/codex-cli-setup.sh | bash
    ```

![macos-configure](../assets/codex/macos_configure.png)

#### 5.Codex CLIの使用開始

これでCodex CLIの使用を開始できます！

!!! info "Codex CLIの起動"
    直接Codex CLIを起動:
    ```
    codex
    ```
    特定のプロジェクトで使用する場合:
    ```
    cd mnt/c/path/to/your/project
    ```
    ```
    codex
    ```
    EnterキーでCodex CLIを起動

![macos-img-09.webp](../assets/codex/macos-img-09.webp)

![macos-img-10.webp](../assets/codex/macos-img-10.webp)
> Codex CLIの権限設定：1. Codexがファイルを直接変更することを許可、2. Codexがファイルを変更する際に手動での承認が必要

![macos-img-11.webp](../assets/codex/macos-img-11.webp)

![macos-img-12.webp](../assets/codex/macos-img-12.webp)

![macos-img-13.webp](../assets/codex/macos-img-13.webp)

![macos-img-14.webp](../assets/codex/macos-img-14.webp)
> 注意：インターフェースアドレスを変更した後、すべてのモデル（公式のプリセットモデルを含む）はカスタムアクセスポイントを呼び出し、公式アカウントのクォータは使用されません。

#### 6.macOSのよくある問題解決

??? example "インストール時に権限エラーが表示される"
    以下の解決策を試してください：

    - `sudo`を使用してインストール：`sudo npm install -g @openai/codex`
    - または、`npm`がユーザーディレクトリを使用するように設定：`npm config set prefix ~/.npm-global`

??? example "macOSのセキュリティ設定により実行がブロックされる"
    システムがCodex CLIの実行をブロックする場合：

    - 「システム環境設定」→「セキュリティとプライバシー」を開きます
    - 「このまま開く」または「許可」をクリックします
    - または、`Terminal`で以下を実行します：`sudo spctl --master-disable`

### Linux版 図解ガイド

#### 1.Node.js環境のインストール

Codex CLIを実行するにはNode.js環境が必要です。

!!! info "Node.js環境のインストール手順"
    NodeSourceリポジトリを追加
    ```
    sudo curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    ```
    Node.jsをインストール
    ```
    sudo apt-get install -y nodejs
    ```

!!! caution "Linuxでの注意事項"
    - 特定のディストリビューションでは、追加の依存関係のインストールが必要な場合があります
    - 権限の問題が発生した場合は、sudoを使用してください
    - ユーザーがnpmのグローバルディレクトリへの書き込み権限を持っていることを確認してください

![linux-img-01.webp](../assets/codex/linux-img-01.webp)

![linux-img-02.webp](../assets/codex/linux-img-02.webp)

!!! information "インストールが成功したかどうかの確認"
    インストール完了後、ターミナルを開き、以下のコマンドを入力してください：
    ```
    node --version
    npm --version
    ```
    バージョン番号が表示されれば、インストールは成功です

#### 2.Codex CLIのインストール

!!! info "Codex CLIのインストール"
    ターミナルを開き、以下のコマンドを実行してください：
    ```
    # Codex CLIをグローバルにインストール
    npm install -g @openai/codex
    ```
    権限の問題が発生した場合は、sudoを使用できます：
    ```
    sudo npm install -g @openai/codex
    ```
![linux-img-03.webp](../assets/codex/linux-img-03.webp)

!!! info "Codex CLIのインストール確認"
    インストール完了後、以下のコマンドを入力してインストールが成功したか確認してください：
    ```
    codex --version
    ```
    バージョン番号が表示されれば、おめでとうございます！Codex CLIは正常にインストールされました。

#### 3.設定ファイルの変更

!!! info "Codex CLI設定ファイルをワンクリックで変更"
    ```
    curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/codex-cli-setup.sh | bash
    ```
    
![macos-configure](../assets/codex/macos_configure.png)

#### 4.Codex CLIの使用開始

これでCodex CLIの使用を開始できます！

!!! info "Codex CLIの起動"
    直接Codex CLIを起動:
    ```
    # Codex CLIを起動
    codex
    ```
    特定のプロジェクトで使用する場合:
    ```
    # プロジェクトディレクトリに移動
    cd /path/to/your/project
    ```
    ```
    # Codex CLIを起動
    codex
    ```
    EnterキーでCodex CLIを起動

![linux-img-05.webp](../assets/codex/linux-img-05.webp)

![linux-img-06.webp](../assets/codex/linux-img-06.webp)
> Codex CLIの権限設定：1. Codexがファイルを直接変更することを許可、2. Codexがファイルを変更する際に手動での承認が必要

![linux-img-07.webp](../assets/codex/linux-img-07.webp)

![linux-img-08.webp](../assets/codex/linux-img-08.webp)

![linux-img-09.webp](../assets/codex/linux-img-09.webp)

![linux-img-10.webp](../assets/codex/linux-img-10.webp)
> 注意：インターフェースアドレスを変更した後、すべてのモデル（公式のプリセットモデルを含む）はカスタムアクセスポイントを呼び出し、公式アカウントのクォータは使用されません。

#### 5.Linuxのよくある問題解決

??? example "インストール時に権限エラーが表示される"
    以下の解決策を試してください：

    - `sudo`を使用してインストール：`sudo npm install -g @openai/codex`

    - または、`npm`がユーザーディレクトリを使用するように設定：`npm config set prefix ~/.npm-global`

    - その後、`PATH`に追加：`export PATH=~/.npm-global/bin:$PATH`

??? example "依存ライブラリの不足"
    特定のLinuxディストリビューションでは、追加の依存関係のインストールが必要です：
    ```
    # Ubuntu/Debian
    sudo apt install build-essential
    ```
    ```
    # CentOS/RHEL
    sudo dnf groupinstall "Development Tools"
    ```
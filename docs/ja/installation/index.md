---
hide:
  - footer
---

<style>
  .md-typeset .grid.cards > ul {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr));
    gap: 1rem;
    margin: 1em 0;
  }
  
  .md-typeset .grid.cards > ul > li {
    border: none;
    border-radius: 0.8rem;
    box-shadow: var(--md-shadow-z2);
    padding: 1.5rem;
    transition: transform 0.25s, box-shadow 0.25s;
    background: linear-gradient(135deg, var(--md-primary-fg-color), var(--md-accent-fg-color));
    color: var(--md-primary-bg-color);
  }

  .md-typeset .grid.cards > ul > li:hover {
    transform: scale(1.02);
    box-shadow: var(--md-shadow-z3);
  }

  .md-typeset .grid.cards > ul > li > hr {
    margin: 0.8rem 0;
    border: none;
    border-bottom: 2px solid var(--md-primary-bg-color);
    opacity: 0.2;
  }

  .md-typeset .grid.cards > ul > li > p {
    margin: 0.5rem 0;
  }

  .md-typeset .grid.cards > ul > li > p > em {
    color: var(--md-primary-bg-color);
    opacity: 0.8;
    font-style: normal;
  }

  .md-typeset .grid.cards > ul > li > p > .twemoji {
    font-size: 2.5rem;
    display: block;
    margin: 0.5rem auto;
  }

  .md-typeset .grid.cards > ul > li a {
    display: inline-flex;
    align-items: center;
    margin-top: 1.2em;
    padding: 0.5em 1.2em;
    color: white;
    background-color: rgba(255, 255, 255, 0.15);
    border-radius: 2em;
    transition: all 0.3s ease;
    font-weight: 500;
    font-size: 0.9em;
    letter-spacing: 0.03em;
    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
    position: relative;
    overflow: hidden;
    text-decoration: none;
  }

  .md-typeset .grid.cards > ul > li a:hover {
    background-color: rgba(255, 255, 255, 0.25);
    text-decoration: none;
    box-shadow: 0 5px 12px rgba(0, 0, 0, 0.2);
    transform: translateX(5px);
  }

  .md-typeset .grid.cards > ul > li a:after {
    content: "→";
    opacity: 0;
    margin-left: -15px;
    transition: all 0.2s ease;
  }

  .md-typeset .grid.cards > ul > li a:hover:after {
    opacity: 1;
    margin-left: 5px;
  }
</style>

# インストールガイド

## デプロイ方法

<div class="grid cards" markdown>

-   :material-docker:{ .twemoji }

    **Docker Compose デプロイ** ⭐推奨

    ---

    推奨されるシングルノードデプロイ方法。完全な設定を提供します：
    
    [チュートリアルを見る →](docker-compose-installation.md)

-   :material-docker:{ .twemoji }

    **Docker デプロイ**

    ---

    シンプルで迅速なシングルノードデプロイ方法：
    
    [チュートリアルを見る →](docker-installation.md)

-   :material-server:{ .twemoji }

    **1Panel パネルデプロイ**

    ---

    1Panel パネルを使用したビジュアルデプロイ：

    [チュートリアルを見る →](1panel-installation.md)

-   :material-server:{ .twemoji }

    **宝塔パネルデプロイ**

    ---

    宝塔パネルを使用したビジュアルデプロイ：
    
    [チュートリアルを見る →](bt-docker-installation.md)

-   :material-server-network:{ .twemoji }

    **クラスターデプロイ**

    ---

    大規模デプロイに最適な選択肢：
    
    [チュートリアルを見る →](cluster-deployment.md)

-   :material-code-braces:{ .twemoji }

    **ローカル開発デプロイ**

    ---

    開発者および貢献者向け：
    
    [チュートリアルを見る →](local-development.md)

</div>

## 設定とメンテナンス

<div class="grid cards" markdown>

-   :material-update:{ .twemoji }

    **システムアップデート**

    ---

    最新バージョンへの更新方法を理解する：
    
    [説明を見る →](system-update.md)

-   :material-variable:{ .twemoji }

    **環境変数**

    ---

    設定可能なすべての環境変数の説明：
    
    [ドキュメントを見る →](environment-variables.md)

-   :material-file-cog:{ .twemoji }

    **設定ファイル**

    ---

    Docker Compose 設定ファイルの解説：
    
    [説明を見る →](docker-compose-yml.md)

</div>

## デプロイに関する説明

!!! tip "選択の推奨事項"
    - **Docker Compose デプロイの使用を推奨します**。より優れた設定管理とサービスオーケストレーションを提供します。
    - 迅速なテストには Docker デプロイを使用できますが、本番環境での使用は推奨しません。
    - 宝塔パネルに慣れているユーザーは、宝塔パネルデプロイを選択できます。
    - エンタープライズユーザーは、より優れたスケーラビリティのためにクラスターデプロイの使用を推奨します。

!!! warning "注意事項"
    デプロイ前に以下を確認してください：

    1. 必要な基本ソフトウェアがインストールされていること
    2. 基本的なLinuxおよびDockerコマンドを理解していること
    3. サーバー構成が最低要件を満たしていること
    4. 必要なAPIキーが準備されていること

!!! info "ヘルプの取得"
    デプロイ中に問題が発生した場合：

    1. [よくある質問](../support/faq.md)を確認する
    2. [GitHub](https://github.com/Calcium-Ion/new-api/issues)でIssueを提出する
    3. [QQ交流グループ](../support/community-interaction.md)に参加してヘルプを求める
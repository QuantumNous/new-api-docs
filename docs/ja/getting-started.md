---
hide:
  - footer
  - navigation
  - toc
---

<style>
  /* カードコンテナのスタイル最適化 */
  .md-typeset .grid.cards > ul {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr));
    gap: 1.2rem;
    margin: 2em 0;
  }
  
  /* カードの基本スタイル */
  .md-typeset .grid.cards > ul > li {
    border: none;
    border-radius: 1rem;
    display: flex;
    flex-direction: column;
    margin: 0;
    padding: 1.8em 1.5em;
    transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    color: white;
    position: relative;
    overflow: hidden;
    line-height: 1.5;
    z-index: 1;
  }
  
  /* カードのホバー効果の強化 */
  .md-typeset .grid.cards > ul > li:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.18);
  }
  
  /* カードホバー時の光沢効果 */
  .md-typeset .grid.cards > ul > li:before {
    content: "";
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(
      90deg, 
      rgba(255, 255, 255, 0) 0%, 
      rgba(255, 255, 255, 0.2) 50%, 
      rgba(255, 255, 255, 0) 100%
    );
    transition: all 0.6s;
    z-index: 2;
  }
  
  .md-typeset .grid.cards > ul > li:hover:before {
    left: 100%;
  }
  
  /* カードの暗色オーバーレイの最適化 */
  .md-typeset .grid.cards > ul > li:after {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: radial-gradient(circle at center, rgba(0, 0, 0, 0.05) 0%, rgba(0, 0, 0, 0.2) 100%);
    pointer-events: none;
    z-index: 1;
  }
  
  /* カードコンテンツの重ね合わせ設定 */
  .md-typeset .grid.cards > ul > li > * {
    position: relative;
    z-index: 3;
  }
  
  /* 導入方法カードの色の設定 */
  /* Dockerカード */
  .md-typeset .grid.cards:nth-of-type(1) > ul > li:nth-child(1) {
    background: linear-gradient(135deg, #2457c5 0%, #2b88d9 100%);
  }
  
  /* Docker Composeカード */
  .md-typeset .grid.cards:nth-of-type(1) > ul > li:nth-child(2) {
    background: linear-gradient(135deg, #0bb8cc 0%, #0bd1b6 100%);
  }
  
  /* 宝塔パネルカード */
  .md-typeset .grid.cards:nth-of-type(1) > ul > li:nth-child(3) {
    background: linear-gradient(135deg, #f27121 0%, #e94057 100%);
  }
  
  /* クラスター導入カード */
  .md-typeset .grid.cards:nth-of-type(1) > ul > li:nth-child(4) {
    background: linear-gradient(135deg, #654ea3 0%, #8862cf 100%);
  }
  
  /* ローカル開発導入カード */
  .md-typeset .grid.cards:nth-of-type(1) > ul > li:nth-child(5) {
    background: linear-gradient(135deg, #1e6e42 0%, #28a745 100%);
  }
  
  /* ドキュメントカードの色の設定 */
  /* Wikiカード */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(1) {
    background: linear-gradient(135deg, #7303c0 0%, #ec38bc 100%);
  }
  
  /* インストールガイドカード */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(2) {
    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
  }
  
  /* ユーザーガイドカード */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(3) {
    background: linear-gradient(135deg, #3a47d5 0%, #6d80fe 100%);
  }
  
  /* APIドキュメントカード */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(4) {
    background: linear-gradient(135deg, #00c6fb 0%, #005bea 100%);
  }
  
  /* ヘルプサポートカード */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(5) {
    background: linear-gradient(135deg, #228B22 0%, #32CD32 100%);
  }

  /* AIアプリケーションカード */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(6) {
    background: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
  }

  /* ビジネス提携カード */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(7) {
    background: linear-gradient(135deg, #8e44ad 0%, #9b59b6 100%);
  }
  
  /* カードテクスチャ背景の最適化 */
  .md-typeset .grid.cards > ul > li {
    background-blend-mode: soft-light;
    background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%23ffffff' fill-opacity='0.08' fill-rule='evenodd'/%3E%3C/svg%3E");
  }
  
  /* カード内の段落テキストスタイル */
  .md-typeset .grid.cards > ul > li p {
    margin: 0.7em 0;
    color: rgba(255, 255, 255, 0.92);
    line-height: 1.6;
    font-size: 0.95em;
    letter-spacing: 0.01em;
  }
  
  /* カード内の見出しテキストスタイル */
  .md-typeset .grid.cards > ul > li p strong,
  .md-typeset .grid.cards > ul > li strong {
    color: white;
    display: block;
    margin-top: 0.5em;
    margin-bottom: 0.3em;
    font-size: 1.2em;
    font-weight: 700;
    letter-spacing: 0.02em;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.15);
  }
  
  /* カードの区切り線スタイル */
  .md-typeset .grid.cards > ul > li hr {
    margin: 0.9em 0;
    height: 2px;
    border: none;
    background: linear-gradient(
      to right,
      rgba(255, 255, 255, 0.1) 0%,
      rgba(255, 255, 255, 0.4) 50%,
      rgba(255, 255, 255, 0.1) 100%
    );
  }
  
  /* カードアイコンのスタイル */
  .md-typeset .grid.cards > ul > li .twemoji {
    font-size: 3.2em;
    display: block;
    margin: 0 auto 0.6em;
    text-align: center;
    filter: drop-shadow(0 2px 5px rgba(0, 0, 0, 0.2));
    transition: transform 0.3s ease, filter 0.3s ease;
  }
  
  /* カードアイコンのホバー効果 */
  .md-typeset .grid.cards > ul > li:hover .twemoji {
    transform: scale(1.1) rotate(5deg);
    filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.3));
  }
  
  /* カードタイトルのセンタリング */
  .md-typeset .grid.cards > ul > li .title {
    text-align: center;
    font-weight: bold;
    margin-bottom: 0.5em;
  }
  
  /* カードリンクボタンのスタイル */
  .md-typeset .grid.cards > ul > li .more-link {
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
  }
  
  /* カードリンクボタンのホバー効果 */
  .md-typeset .grid.cards > ul > li .more-link:hover {
    background-color: rgba(255, 255, 255, 0.25);
    text-decoration: none;
    box-shadow: 0 5px 12px rgba(0, 0, 0, 0.2);
    transform: translateX(5px);
  }
  
  /* リンクボタンの矢印アニメーション */
  .md-typeset .grid.cards > ul > li .more-link:after {
    content: "→";
    opacity: 0;
    margin-left: -15px;
    transition: all 0.2s ease;
  }
  
  .md-typeset .grid.cards > ul > li .more-link:hover:after {
    opacity: 1;
    margin-left: 5px;
  }
  
  /* カード内の通常リンクテキストの色の調整 */
  .md-typeset .grid.cards > ul > li a:not(.more-link) {
    color: white;
    text-decoration: underline;
    text-decoration-color: rgba(255, 255, 255, 0.3);
    text-decoration-thickness: 1px;
    text-underline-offset: 2px;
    transition: all 0.2s;
  }
  
  /* 通常リンクのホバー効果 */
  .md-typeset .grid.cards > ul > li a:not(.more-link):hover {
    text-decoration-color: rgba(255, 255, 255, 0.8);
    text-shadow: 0 0 8px rgba(255, 255, 255, 0.4);
  }
</style>

## 🎯 **導入方法の選択**

<div class="grid cards" markdown>

-   :fontawesome-brands-docker:{ .twemoji } 
    
    **Docker シングルコンテナ導入**
    
    ---
    
    Dockerイメージを使用してNew APIを迅速に導入します。個人利用や小規模なアプリケーションシナリオに適しています。
    
    [詳細はこちら →](installation/docker-installation.md){ .more-link }

-   :fontawesome-brands-docker:{ .twemoji } 
    
    **Docker Composeによる導入**
    
    ---
    
    Docker Composeを使用して複数のサービスをオーケストレーションします。本番環境やMySQL、Redisなどの依存関係が必要なシナリオに適しています。
    
    [詳細はこちら →](installation/docker-compose-installation.md){ .more-link }

-   :material-server:{ .twemoji } 
    
    **宝塔パネルによる導入**
    
    ---
    
    宝塔パネルのグラフィカルインターフェースを通じて迅速に導入します。コマンドラインに不慣れなユーザーに適しています。
    
    [詳細はこちら →](installation/bt-docker-installation.md){ .more-link }

-   :material-server-network:{ .twemoji } 
    
    **クラスター導入モード**
    
    ---
    
    複数ノードによる分散導入により、高可用性、負荷分散、水平スケーリングを実現します。大規模なアプリケーションやエンタープライズレベルのシナリオに適しています。
    
    [詳細はこちら →](installation/cluster-deployment.md){ .more-link }

-   :material-code-braces:{ .twemoji } 
    
    **ローカル開発環境での導入**
    
    ---
    
    コード貢献や二次開発を行う開発者向けです。完全なローカル開発環境設定ガイドを提供します。
    
    [詳細はこちら →](installation/local-development.md){ .more-link }

</div>

## 📚 **ドキュメントの閲覧**

<div class="grid cards" markdown>

-   :fontawesome-solid-book:{ .twemoji } 
    
    **Wiki**
    
    ---
    
    プロジェクトの紹介、機能説明、技術アーキテクチャ、ロードマップについて理解します。
    
    [詳細はこちら →](wiki/index.md){ .more-link }

-   :fontawesome-solid-user:{ .twemoji } 
    
    **ユーザーガイド**
    
    ---
    
    詳細な使用説明とベストプラクティス。
    
    <!-- [了解更多 →](user-guide/i18n.md){ .more-link } -->
    [ご期待ください](){ .more-link }

-   :fontawesome-solid-code:{ .twemoji } 
    
    **APIドキュメント**
    
    ---
    
    包括的なAPIインターフェースの説明と呼び出し例。
    
    [詳細はこちら →](api/index.md){ .more-link }

-   :fontawesome-solid-headset:{ .twemoji } 
    
    **ヘルプ＆サポート**
    
    ---
    
    よくある質問（FAQ）とコミュニティ交流。
    
    [詳細はこちら →](support/index.md){ .more-link }

-   :fontawesome-solid-list:{ .twemoji }
    
    **利用ガイド**
    
    ---
    
    クイックスタートガイドと詳細な手順説明。
    
    [詳細はこちら →](guide/index.md){ .more-link }

-   :fontawesome-solid-robot:{ .twemoji }
    
    **AIアプリケーション**
    
    ---
    
    New APIに基づいて開発された様々なAIアプリケーションの事例を探求します。
    
    [詳細はこちら →](apps/cherry-studio.md){ .more-link }

-   :fontawesome-solid-handshake:{ .twemoji }
    
    **ビジネス提携**
    
    ---
    
    私たちと協力し、AIエコシステムとビジネス機会を共に開拓しましょう。
    
    [詳細はこちら →](business-cooperation.md){ .more-link }

</div>
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

# ヘルプとサポート

## 💫 サポートサービス

<div class="grid cards" markdown>

-   :material-chat-question:{ .twemoji }

    **よくある質問 (FAQ)**

    ---

    よくある質問を確認し、疑問を迅速に解決してください：
    
    [質問と回答 →](faq.md)

-   :material-account-group:{ .twemoji }

    **コミュニティ交流**

    ---

    私たちのコミュニティに参加し、他のユーザーと交流しましょう：
    
    [QQ交流グループ →](community-interaction.md)

-   :material-bug:{ .twemoji }

    **問題のフィードバック**

    ---

    問題に遭遇しましたか？私たちにフィードバックしてください：
    
    [問題を提出 →](feedback-issues.md)

-   :material-coffee:{ .twemoji }

    **私たちをサポート**

    ---

    もしプロジェクトがあなたのお役に立っていると感じたら：
    
    [コーヒーをご馳走する →](buy-us-a-coffee.md)

</div>

## 📖 サポートに関する説明

!!! tip "ヘルプの取得"
    問題解決のために、複数の方法を提供しています：

    1. **ドキュメントを確認する**：ほとんどの問題はドキュメント内で解決策を見つけることができます
    2. **よくある質問**：よくある質問を参照し、迅速に解決策を見つけてください
    3. **コミュニティ交流**：QQグループに参加し、他のユーザーと経験を共有しましょう
    4. **問題のフィードバック**：GitHubでissueを提出してください。迅速に対応いたします

!!! info "スポンサーシップについて"
    New API は完全に無料のオープンソースプロジェクトであり、いかなる形式のスポンサーシップも強制しません。
    しかし、もしプロジェクトがあなたのお役に立っていると感じたら、コーヒーをご馳走していただけると幸いです。これは以下の活動に役立ちます：

    - サーバーの維持とアップグレード
    - 新機能の開発
    - より良いドキュメントの提供
    - より良いコミュニティの構築

!!! warning "注意事項"
    ヘルプを求める際は、以下の点にご注意ください：

    - 質問する前に、まずドキュメントとよくある質問を確認してください
    - 私たちが問題を理解し、再現できるように十分な情報を提供してください
    - コミュニティのルールを遵守し、友好的な交流の雰囲気を保ってください
    - 返信を辛抱強くお待ちください。私たちはできるだけ早くあなたの問題に対応します
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

# ウィキペディア

## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーへのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス割り当て | Available service quota for users |

## 📚 基本概念

<div class="grid cards" markdown>

-   :material-information-outline:{ .twemoji }

    **プロジェクト紹介**

    ---

    New API プロジェクトの目的やライセンスなどについて理解します：
    
    [詳細を見る →](project-introduction.md)

-   :material-star-outline:{ .twemoji }

    **機能説明**

    ---

    New API が提供するコアな特性と機能：
    
    [詳細を見る →](features-introduction.md)

-   :material-crane:{ .twemoji }

    **技術アーキテクチャ**

    ---

    システムの全体的なアーキテクチャと技術スタック：
    
    [詳細を見る →](technical-architecture.md)

</div>

## 📝 プロジェクト記録

<div class="grid cards" markdown>

-   :material-notebook-edit-outline:{ .twemoji }

    **更新履歴**

    ---

    プロジェクトのバージョンイテレーションと機能更新の記録：
    
    [記録を見る →](changelog.md)

-   :material-heart-outline:{ .twemoji }

    **謝辞**

    ---

    プロジェクトに貢献してくださったすべての個人および組織に感謝いたします：
    
    [リストを見る →](special-thanks.md)

</div>

## 📖 概要

!!! info "New API とは何ですか？"
    New API は、次世代の大規模モデルゲートウェイおよびAIアセット管理システムであり、AIモデルの接続と管理を簡素化し、統一されたAPIインターフェースとリソース管理機能を提供することを目的としています。

!!! tip "New API を選ぶ理由は何ですか？"
    - 統一されたAPIインターフェースで、複数の主要な大規模モデルをサポート
    - 完全なリソース管理および監視機能
    - 完全なエコシステムと二次開発能力
    - 活発なコミュニティサポートと継続的な更新

!!! question "ご質問がありますか？"
    プロジェクトについてご不明な点がある場合は、以下を実行できます：

    1. [よくある質問](../support/faq.md)を確認する
    2. [GitHub](https://github.com/Calcium-Ion/new-api/issues)でIssueを提出する
    3. [コミュニティ交流](../support/community-interaction.md)に参加してサポートを受ける
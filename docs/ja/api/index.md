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

  /* 新增：美化介绍部分 */
  .interface-intro {
    margin: 2rem 0;
    padding: 1.5rem;
    border-radius: 0.8rem;
    background-color: var(--md-primary-fg-color--light);
    color: var(--md-primary-bg-color);
  }

  /* 新增：优化卡片链接样式 */
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

# インターフェース概要

## 💫 リレーインターフェース

<div class="grid cards" markdown>

-   :material-chat:{ .twemoji }

    **チャット（Chat）**

    ---

    複数の主要なチャットモデル形式をサポート：
    
    [OpenAI Chat →](openai-chat.md)
    [OpenAI Responses →](openai-responses.md)
    [Anthropic Chat →](anthropic-chat.md)
    [Deepseek Chat →](deepseek-reasoning-chat.md)
    [Google Chat →](google-gemini-chat.md)

-   :material-alphabetical:{ .twemoji }

    **埋め込み（Embeddings）**

    ---

    テキストベクトル埋め込みサービス：
    
    [OpenAI Embeddings →](openai-embedding.md)

-   :material-swap-vertical:{ .twemoji }

    **リランク（Rerank）**

    ---

    検索結果のリランキングサービス：
    
    [Jina AI Rerank →](jinaai-rerank.md)
    [Cohere Rerank →](cohere-rerank.md)
    [Xinference Rerank →](xinference-rerank.md)

-   :material-lightning-bolt:{ .twemoji }

    **リアルタイム対話（Realtime）**

    ---

    ストリーミングリアルタイム対話をサポート：
    
    [OpenAI Realtime →](openai-realtime.md)

-   :material-image:{ .twemoji }

    **画像（Image）**

    ---

    AI画像生成サービス：
    
    [OpenAI Image →](openai-image.md)
    [Midjourney Proxy →](midjourney-proxy-image.md)

-   :material-volume-high:{ .twemoji }

    **オーディオ（Audio）**

    ---

    音声関連サービス：
    
    [OpenAI Audio →](openai-audio.md)

-   :material-music:{ .twemoji }

    **音楽（Music）**

    ---

    AI音楽生成サービス：
    
    [Suno API →](suno-music.md)

-   :material-video:{ .twemoji }

    **ビデオ（Video）**

    ---

    AIビデオ生成およびクエリサービス：
    
    [ビデオ生成 →](generate-video.md)
    [ビデオ照会 →](query-video.md)

</div>

## 🖥️ フロントエンドインターフェース

<div class="grid cards" markdown>

-   :material-rocket-launch:{ .twemoji }

    **API リファレンス**

    ---

    システムは4段階の認証メカニズムを採用しています：公開、ユーザー、管理者、Root

    インターフェースのプレフィックスは http(s)://`<your-domain>` に統一されています

    ( 認証トークンを保護するため、本番環境では HTTPS を使用する必要があります。 HTTP は開発環境でのみ推奨されます。 )

    [認証システムの説明 →](auth-system-description.md)
    [利用可能なモデルリストの取得 →](get-available-models-list.md)
    [インターフェースモジュールの使用ガイド →](fei-system-initialization.md)

</div>

---

## 📖 インターフェースの説明

!!! abstract "インターフェースの種類"
    New API は主に2種類のインターフェースを提供します：
    
    1. **リレーインターフェース**：AIモデルの呼び出しに使用され、複数の主要なモデル形式をサポートします
    2. **フロントエンドインターフェース**：Webインターフェースの機能呼び出しをサポートするために使用され、完全なフロントエンド機能サポートを提供します

!!! tip "機能サポートの識別子"
    インターフェースドキュメントでは、以下のアイコンを使用して機能のサポート状況を識別します：

    - ✅ **サポート済み**：この機能は完全に実装されており、使用可能です
    - 🟡 **一部サポート**：機能は利用可能ですが、制限があるか、一部の機能のみが提供されています
    - ❌ **未サポート**：この機能は現在開発中または開発予定です

!!! example "クイックスタート"
    1. 上記のカードを参照し、使用したいインターフェースを選択します
    2. 対応するカードの「詳細を見る」をクリックして具体的な使用方法を確認します
    3. ドキュメントの説明に従ってインターフェースを呼び出します
## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセス経路 | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響する | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス利用枠 | Available service quota for users |

# ✨ 機能説明

1. 🎨 全く新しいUIインターフェース（一部のインターフェースはまだ更新待ちです）
2. 🌍 多言語サポート（改善予定）
3. 🎨 [Midjourney-Proxy(Plus)](https://github.com/novicezk/midjourney-proxy)インターフェースのサポートを追加
4. 💰 オンラインチャージ機能のサポート。システム設定で設定可能です：
    - [x] 易支付
5. 🔍 キーを使用して利用枠を照会する機能をサポート：
    - プロジェクト[neko-api-key-tool](https://github.com/Calcium-Ion/neko-api-key-tool)と連携することで、キーによる利用状況の照会を実現できます
6. 📑 ページネーションで1ページあたりの表示数を選択可能
7. 🔄 オリジナル版One APIのデータベースと互換性があり、オリジナル版データベース（one-api.db）を直接使用可能
8. 💵 モデルごとの回数課金をサポート。システム設定 - 運用設定 で設定可能
9. ⚖️ チャネルの **加重ランダム** をサポート
10. 📈 データダッシュボード（コンソール）
11. 🔒 トークンが呼び出し可能なモデルを設定可能
12. 🤖 Telegram認証ログインをサポート：
    1. システム設定 - ログイン登録設定 - Telegram経由でのログインを許可
    2. [@Botfather](https://t.me/botfather)に対してコマンド `/setdomain` を入力
    3. あなたのボットを選択し、`http(s)://あなたのウェブサイトアドレス/login` を入力
    4. Telegram Bot名は、ボットのユーザー名から `@` を除いた文字列です
13. 🎵 [Suno API](https://github.com/Suno-API/Suno-API)インターフェースのサポートを追加
14. 🔄 Rerankモデルをサポート。現在CohereおよびJinaと互換性があり、Difyに接続可能
15. ⚡ **[OpenAI Realtime API](https://platform.openai.com/docs/guides/realtime/integration)** - OpenAIのRealtime APIをサポートし、Azureチャネルにも対応
16. ルート `/chat2link` を使用してチャット画面に入ることをサポート
17. 🧠 モデル名のサフィックス（接尾辞）を通じて reasoning effort を設定することをサポート：
    1. OpenAI oシリーズモデル
        - サフィックス `-high` を追加して high reasoning effort に設定 (例: `o3-mini-high`)
        - サフィックス `-medium` を追加して medium reasoning effort に設定 (例: `o3-mini-medium`)
        - サフィックス `-low` を追加して low reasoning effort に設定 (例: `o3-mini-low`)
    2. Claude 思考モデル
        - サフィックス `-thinking` を追加して思考モードを有効化 (例: `claude-3-7-sonnet-20250219-thinking`)
18. 🔄 思考をコンテンツに変換。`チャネル - 編集 - チャネル追加設定` で `thinking_to_content` オプションを設定することをサポート。デフォルトは`false`で、有効にすると思考内容 `reasoning_content` が `<think>` タグに変換され、コンテンツに結合されて返されます。
19. 🔄 モデルレート制限。`システム設定 - レート制限設定` でモデルのレート制限を設定することをサポート。総リクエスト数制限と成功リクエスト数制限の設定をサポートします。
20. 💰 キャッシュ課金サポート。有効にすると、キャッシュヒット時に設定された比率に基づいて課金できます：
    1. `システム設定 - 運用設定` で「プロンプトキャッシュ倍率」オプションを設定
    2. チャネル内でプロンプトキャッシュ倍率を設定（範囲 0-1）。例えば 0.5 に設定すると、キャッシュヒット時に 50% で課金されます。
    3. サポートされるチャネル：
      - [x] OpenAI
      - [x] Azure
      - [x] DeepSeek
      - [ ] Claude
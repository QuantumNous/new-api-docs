# ✨ 機能説明

1. 🎨 真新しいUIインターフェース（一部のインターフェースはまだ更新待ちです）
2. 🌍 多言語サポート（改善予定）
3. 🎨 [Midjourney-Proxy(Plus)](https://github.com/novicezk/midjourney-proxy)インターフェースのサポートを追加
4. 💰 オンラインチャージ機能のサポート。システム設定で設定できます：
    - [x] 易支付
5. 🔍 キーを使用して利用枠（クォータ）を照会する機能をサポート：
    - プロジェクト[neko-api-key-tool](https://github.com/Calcium-Ion/neko-api-key-tool)と連携することで、キーを使用した利用状況の照会が可能です
6. 📑 ページネーションで1ページあたりの表示数を選択可能
7. 🔄 オリジナル版One APIのデータベースとの互換性があり、オリジナル版データベース（one-api.db）を直接使用できます
8. 💵 モデルごとの回数課金をサポート。システム設定 - 運用設定 で設定できます
9. ⚖️ チャネル（渠道）の **加重ランダム** をサポート
10. 📈 データダッシュボード（コンソール）
11. 🔒 トークン（令牌）が呼び出し可能なモデルを設定可能
12. 🤖 Telegram認証ログインをサポート：
    1. システム設定 - ログイン登録設定 - Telegram経由でのログインを許可
    2. [@Botfather](https://t.me/botfather)にコマンド /setdomain を入力
    3. ボットを選択し、http(s)://あなたのウェブサイトアドレス/login を入力
    4. Telegram Bot 名は、bot username から @ を除いた文字列です
13. 🎵 [Suno API](https://github.com/Suno-API/Suno-API)インターフェースのサポートを追加
14. 🔄 Rerankモデルをサポート。現在、CohereおよびJinaと互換性があり、Difyに接続可能です
15. ⚡ **[OpenAI Realtime API](https://platform.openai.com/docs/guides/realtime/integration)** - OpenAIのRealtime APIをサポートし、Azureチャネル（渠道）もサポート
16. ルーティング `/chat2link` を使用してチャットインターフェースに入ることをサポート
17. 🧠 モデル名サフィックスによる reasoning effort の設定をサポート：
    1. OpenAI oシリーズモデル
        - サフィックス `-high` を追加して high reasoning effort に設定 (例: `o3-mini-high`)
        - サフィックス `-medium` を追加して medium reasoning effort に設定 (例: `o3-mini-medium`)
        - サフィックス `-low` を追加して low reasoning effort に設定 (例: `o3-mini-low`)
    2. Claude 思考モデル
        - サフィックス `-thinking` を追加して思考モードを有効化 (例: `claude-3-7-sonnet-20250219-thinking`)
18. 🔄 思考内容のコンテンツ化。`チャネル-編集-チャネル追加設定` で `thinking_to_content` オプションを設定できます。デフォルトは`false` です。有効にすると、思考内容 `reasoning_content` が `<think>` タグに変換され、コンテンツに連結されて返されます。
19. 🔄 モデルレート制限。`システム設定-レート制限設定` でモデルのレート制限を設定できます。総リクエスト数制限と成功リクエスト数制限の設定をサポートします。
20. 💰 キャッシュ課金サポート。有効にすると、キャッシュヒット時に設定された比率で課金できます：
    1. `システム設定-運用設定` で プロンプトキャッシュ倍率 オプションを設定
    2. チャネルでプロンプトキャッシュ倍率を設定します。範囲は 0-1 で、例えば 0.5 に設定すると、キャッシュヒット時に 50% で課金されます
    3. サポートされているチャネル：
      - [x] OpenAI
      - [x] Azure
      - [x] DeepSeek
      - [ ] Claude
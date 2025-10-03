# LangBot - インスタントメッセージングボット開発プラットフォーム

!!! info
    LangBot は、オープンソースのインスタントメッセージングボット開発プラットフォームであり、Feishu（飛書）、DingTalk（釘釘）、WeChat（微信）、QQ、Telegram、Discord、Slackなど、様々なIMプラットフォームをサポートしています。世界の主要なAIモデルと連携し、ナレッジベース、Agent、MCPなどの多様なAIアプリケーション機能をサポートし、NewAPIに完全に適合しています。

    - 公式サイト：<https://langbot.app/>
    - ダウンロード：<https://github.com/langbot-app/LangBot/releases>
    - 公式ドキュメント：<https://docs.langbot.app/>
    - オープンソース：<https://github.com/langbot-app/LangBot>

## NewAPIへの接続

LangBot は、ローカルにデプロイされた NewAPI および、NewAPIを使用して構築されたサードパーティの NewAPI サービスへの接続をサポートしています。

### 利用方法

1. NewAPIからAPIキーを取得します。
![APIキーの取得](../assets/langbot/get_api_key.png)

    ローカルにデプロイされた NewAPIを使用する場合は、ご自身でAPIアドレスを設定してください（[コンテナネットワーク接続](https://docs.langbot.app/zh/workshop/network-details.html)を参照）。サードパーティの NewAPI サービスを使用する場合は、ページ上でアドレスをコピーできます。注意点として、アドレスの末尾に`/v1`を追加する必要があります。

2. LangBotでモデルを追加し、NewAPIプロバイダーを選択し、対応するAPIキーとAPIアドレスを入力します。
    ![NewAPIモデルの追加](../assets/langbot/add_newapi_model.png)

3. パイプライン内で使用するモデルを選択します。

    ![モデルの選択](../assets/langbot/select_model.png)

4. 対話デバッグでチャットするか、パイプラインにバインドされたロボットとチャットすることで使用できます。

    ![対話](../assets/langbot/debug_chat.png)

    ![WeChat対話](../assets/langbot/wechat.png)

    ロボットのデプロイと設定については、[ロボットのデプロイ](https://docs.langbot.app/zh/deploy/platforms/readme.html)を参照してください。

### LangBotナレッジベースの使用

LangBot は NewAPI の埋め込みモデルの使用をサポートしており、それをナレッジベースのベクトルモデルとして利用できます。

1. LangBotで埋め込みモデルを追加し、NewAPIプロバイダーを選択します。
![埋め込みモデルの追加](../assets/langbot/add_embedding_model.png)

2. 新しいナレッジベースを作成する際に、埋め込みモデルを選択します。
![埋め込みモデルの使用](../assets/langbot/use_embedding_model.png)


その他の利用方法については、LangBot 公式ドキュメントを参照してください：<https://docs.langbot.app/>
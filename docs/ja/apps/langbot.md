## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス割り当て量 | Available service quota for users |

# LangBot - インスタントメッセージングボット開発プラットフォーム

!!! info
    LangBot は、オープンソースのインスタントメッセージングボット開発プラットフォームであり、Feishu、DingTalk、WeChat、QQ、Telegram、Discord、Slack など、様々なIMプラットフォームをサポートしています。世界中の主要なAIモデルに接続し、ナレッジベース、Agent、MCPなどの多様なAIアプリケーション機能をサポートし、NewAPIに完全に適合します。

    - 公式サイトアドレス：<https://langbot.app/>
    - ダウンロードアドレス：<https://github.com/langbot-app/LangBot/releases>
    - 公式ドキュメント：<https://docs.langbot.app/>
    - オープンソースアドレス：<https://github.com/langbot-app/LangBot>

## NewAPIへの接続

LangBot は、ローカルにデプロイされた NewAPI およびサードパーティが NewAPI を使用して構築した NewAPI サービスへの接続をサポートしています。

### 使用方法

1. NewAPI から API key を取得します
![获取 API key](../assets/langbot/get_api_key.png)

    ローカルにデプロイされた NewAPI の場合は、ご自身で API アドレスを設定してください（[コンテナネットワーク接続](https://docs.langbot.app/zh/workshop/network-details.html)を参照）。サードパーティの NewAPI サービスを使用する場合は、ページ上でアドレスをコピーできます。注意：アドレスの後に`/v1`を追加する必要があります。

2. LangBot でモデルを追加し、NewAPI プロバイダーを選択し、対応する API key と API アドレスを入力します
    ![添加 NewAPI 模型](../assets/langbot/add_newapi_model.png)

3. パイプラインでモデルの使用を選択します

    ![选择模型](../assets/langbot/select_model.png)

4. 対話デバッグで会話するか、パイプラインにバインドされたボットと会話することで使用できます

    ![对话](../assets/langbot/debug_chat.png)

    ![微信对话](../assets/langbot/wechat.png)

    ボットのデプロイと設定については、[ボットのデプロイ](https://docs.langbot.app/zh/deploy/platforms/readme.html)を参照してください。

### LangBot ナレッジベースの使用

LangBot は、NewAPI の埋め込みモデルの使用をサポートしており、それをナレッジベースのベクトルモデルとして使用できます。

1. LangBot で埋め込みモデルを追加し、NewAPI プロバイダーを選択します
![添加嵌入模型](../assets/langbot/add_embedding_model.png)

2. 新しいナレッジベースを作成する際に埋め込みモデルを選択します
![使用嵌入模型](../assets/langbot/use_embedding_model.png)

その他の使用方法については、LangBot 公式ドキュメントを参照してください：<https://docs.langbot.app/>
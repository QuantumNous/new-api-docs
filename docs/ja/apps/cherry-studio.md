## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| レート | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格レートに影響を与える | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# Cherry Studio - デスクトップ AI クライアント
!!! tip "チャット設定オプション"
    New API コンソールのシステム設定 -> チャット設定で、以下のショートカットオプションを追加できます。これにより、トークン管理ページから Cherry Studio へワンクリックで設定を反映できます：

    ```json
    { "Cherry Studio": "cherrystudio://providers/api-keys?v=1&data={cherryConfig}" }
    ```
!!! info
    🍒 Cherry Studio は、プロフェッショナルユーザー向けに設計された、強力なデスクトップ AI クライアントです。30以上の業界インテリジェントアシスタントを統合しており、様々な業務シナリオのニーズを満たし、作業効率を大幅に向上させます。

    - 公式サイトアドレス：<https://cherry-ai.com/>
    - ダウンロードアドレス：<https://cherry-ai.com/download>
    - 公式ドキュメント：<https://docs.cherry-ai.com>

## NewAPI 連携方法

### パラメータの入力

プロバイダータイプ：NewAPI がサポートするタイプ  
APIキー：NewAPI で取得  
APIアドレス：NewAPI サイトアドレス  

### 画像付きガイド

1. NewAPI で API キーをコピーします
![复制 API 密钥](../assets/cherry_studio/copy_api_key.png)

2. プロバイダーを追加します
![添加供应商](../assets/cherry_studio/add_provider.png)

3. モデルを追加します
![添加模型](../assets/cherry_studio/add_models.png)

4. チャットページに戻ります
![切换聊天页面](../assets/cherry_studio/back_to_chat.png)

5. NewAPI モデルに切り替えます
![切换模型](../assets/cherry_studio/switch_model.png)

## Cherry Studio での画像生成

1. まず、画像生成をサポートするモデルを追加します
![画图模型](../assets/cherry_studio/add_paint_models.png)

2. 画像生成を実行します
![画图](../assets/cherry_studio/paint.png)
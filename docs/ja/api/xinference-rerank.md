## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数因子 | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響する | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# Xinference リランキング形式（Rerank）

!!! warning "重要なお知らせ"
    New APIでは、Xinferenceのリランキング応答構造はJinaのリランキング応答構造としてフォーマットされ、Jinaのリランキングと同じ使用方法になります。**Difyなどのクライアントユーザーの方へ**：設定時には、Xinferenceではなく、プロバイダータイプとして **Jina AI** を選択し、Xinferenceがサポートするモデル名を使用してください。

## 📝 概要

XinferenceのリランキングAPIは、Jina AIのリランキングAPIと完全に互換性があります。詳細な使用方法、リクエストパラメータ、および応答形式については、[Jina AI リランキング形式（Rerank）](jinaai-rerank.md)ドキュメントを参照してください。

## 💡 使用方法

XinferenceリランキングAPIを使用する場合、`model`パラメータをXinferenceがサポートするリランキングモデルに設定するだけでよく、その他のパラメータと使用方法はJina AIリランキングAPIと同じです。

### 示例リクエスト

```bash
curl https://你的newapi服务器地址/v1/rerank \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "jina-reranker-v2",
    "query": "什么是美国的首都？",
    "documents": [
      "内华达州的首府是卡森城。",
      "北马里亚纳群岛是太平洋上的一组岛屿，其首都是塞班岛。",
      "华盛顿特区（也称为华盛顿或特区，正式名称为哥伦比亚特区）是美国的首都。",
      "英语语法中的大写是在单词开头使用大写字母。英语用法与其他语言的大写不同。",
      "自美国成为一个国家之前，美国就存在死刑。截至2017年，在50个州中有30个州死刑合法。"
    ],
    "top_n": 3
  }'
```

詳細については、[Jina AI リランキング形式（Rerank）](jinaai-rerank.md)ドキュメントを参照してください。
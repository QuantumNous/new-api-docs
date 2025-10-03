# Xinference リランキング形式（Rerank）

!!! warning "重要なお知らせ"
    New APIでは、Xinferenceのrerank応答構造はJinaのrerank応答構造としてフォーマットされ、Jinaのrerankと同じ方法で使用されます。**Difyなどのクライアントユーザーの方へ**：設定時には、Xinferenceではなく **Jina AI** をプロバイダータイプとして選択し、Xinferenceがサポートするモデル名を使用してください。

## 📝 概要

XinferenceのリランキングAPIは、Jina AIのリランキングAPIと完全に互換性があります。詳細な使用方法、リクエストパラメータ、および応答形式については、[Jina AI リランキング形式（Rerank）](jinaai-rerank.md)ドキュメントを参照してください。

## 💡 使用方法

XinferenceリランキングAPIを使用する際は、`model`パラメータをXinferenceがサポートするリランキングモデルに設定するだけで済みます。その他のパラメータと使用方法は、Jina AIリランキングAPIと同じです。

### 示例请求

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
# Jina AI リランキング形式（Rerank）

!!! info "公式ドキュメント"
    [Jina AI Rerank](https://jina.ai/reranker)

!!! note "標準形式"
    New APIでは、Jina AIのRerank形式が標準形式として採用されています。Xinference、Cohereなどの他のすべてのプロバイダーからのRerank応答は、統一された開発体験を提供するために、Jina AIの形式にフォーマットされます。

## 📝 概要

Jina AI Rerankは、クエリに基づいてドキュメントリストを関連性で並べ替えることができる強力なテキストリランキングモデルです。このモデルは多言語をサポートしており、異なる言語のテキストコンテンツを処理し、各ドキュメントに関連性スコアを割り当てることができます。

## 💡 リクエスト例

### 基本的なリランキングリクエスト ✅

```bash
curl https://你的newapi服务器地址/v1/rerank \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "jina-reranker-v2-base-multilingual",
    "query": "Organic skincare products for sensitive skin",
    "top_n": 3,
    "documents": [
      "Organic skincare for sensitive skin with aloe vera and chamomile...",
      "New makeup trends focus on bold colors and innovative techniques...",
      "Bio-Hautpflege für empfindliche Haut mit Aloe Vera und Kamille..."
    ]
  }'
```

**応答例:**

```json
{
  "results": [
    {
      "document": {
        "text": "Organic skincare for sensitive skin with aloe vera and chamomile..."
      },
      "index": 0,
      "relevance_score": 0.8783142566680908
    },
    {
      "document": {
        "text": "Bio-Hautpflege für empfindliche Haut mit Aloe Vera und Kamille..."
      },
      "index": 2,
      "relevance_score": 0.7624675869941711
    }
  ],
  "usage": {
    "prompt_tokens": 815,
    "completion_tokens": 0,
    "total_tokens": 815
  }
}
```

## 📮 リクエスト

### エンドポイント

```
POST /v1/rerank
```

### 認証方法

APIキー認証のために、リクエストヘッダーに以下を含めます。

```
Authorization: Bearer $NEWAPI_API_KEY
```

ここで、`$NEWAPI_API_KEY` はお客様の API キーです。

### リクエストボディパラメータ

#### `model`
- タイプ：文字列
- 必須：いいえ
- デフォルト値：jina-reranker-v2-base-multilingual
- 説明：使用するリランキングモデル

#### `query`
- タイプ：文字列
- 必須：はい
- 説明：ドキュメントの関連性順序付けに使用されるクエリテキスト

#### `top_n`
- タイプ：整数
- 必須：いいえ
- デフォルト値：無制限
- 説明：ソートされた上位 N 個のドキュメントを返します

#### `documents`
- タイプ：文字列配列
- 必須：はい
- 説明：リランキングするドキュメントのリスト
- 制限：各ドキュメントの長さは、モデルの最大トークン制限を超えてはなりません

## 📥 応答

### 成功応答

#### `results`
- タイプ：配列
- 説明：リランキングされたドキュメントのリスト
- 属性：
  - `document`: ドキュメントテキストを含むオブジェクト
  - `index`: 元のリスト内のドキュメントのインデックス
  - `relevance_score`: 関連性スコア (0-1の間)

#### `usage`
- タイプ：オブジェクト
- 説明：トークン使用量の統計
- 属性：
  - `prompt_tokens`: プロンプトで使用されたトークン数
  - `completion_tokens`: 補完で使用されたトークン数
  - `total_tokens`: 合計トークン数
  - `prompt_tokens_details`: プロンプトトークンの詳細情報
    - `cached_tokens`: キャッシュされたトークン数
    - `audio_tokens`: オーディオトークン数
  - `completion_tokens_details`: 補完トークンの詳細情報
    - `reasoning_tokens`: 推論トークン数
    - `audio_tokens`: オーディオトークン数
    - `accepted_prediction_tokens`: 受け入れられた予測トークン数
    - `rejected_prediction_tokens`: 拒否された予測トークン数

### エラー応答

リクエストに問題がある場合、APIはエラー応答を返します。

- `400 Bad Request`: リクエストパラメータが無効です
- `401 Unauthorized`: APIキーが無効または提供されていません
- `429 Too Many Requests`: リクエスト頻度が制限を超えています
- `500 Internal Server Error`: サーバー内部エラー

## 💡 ベストプラクティス

### クエリ最適化の推奨事項

1. 明確で具体的なクエリテキストを使用する
2. 広すぎる、または曖昧なクエリを避ける
3. クエリとドキュメントが同じ言語スタイルを使用していることを確認する

### ドキュメント処理の推奨事項

1. ドキュメントの長さを適切に保ち、モデルの制限を超えないようにする
2. ドキュメントの内容が完全で意味のあるものであることを確認する
3. 多言語ドキュメントを含めることができます。モデルはクロスリンガルマッチングをサポートしています

### パフォーマンスの最適化

1. 不要な計算を減らすために `top_n` パラメータを適切に設定する
2. 大量のドキュメントについては、バッチ処理を検討する
3. 頻繁に使用されるクエリの結果をキャッシュできる

### 多言語サポート

このモデルは、以下を含むがこれらに限定されない、多言語のドキュメントリランキングをサポートしています。

- 英語
- 中国語
- ドイツ語
- スペイン語
- 日本語
- フランス語

言語パラメータを指定する必要はありません。モデルは異なる言語のコンテンツを自動的に識別し、処理します。
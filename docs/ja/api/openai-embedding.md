## コアコンセプト (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| トークン | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| チャネル | Channel | APIサービスプロバイダーへのアクセス経路 | Access channel for API service providers |
| グループ | Group | ユーザーまたはトークンの分類。価格倍率に影響する | Classification of users or tokens, affecting price ratios |
| クォータ | Quota | ユーザーが利用可能なサービス枠 | Available service quota for users |

# OpenAI エンベディング形式（Embeddings）

!!! info "公式ドキュメント"
    [OpenAI Embeddings](https://platform.openai.com/docs/api-reference/embeddings)

## 📝 概要

与えられた入力テキストのベクトル表現を取得します。これらのベクトルは、機械学習モデルやアルゴリズムによって容易に使用できます。関連ガイドについては、[Embeddings Guide](https://platform.openai.com/docs/guides/embeddings) を参照してください。

留意点:

- 一部のモデルでは、入力の合計トークン数に制限がある場合があります

- トークン数を計算するために、[サンプル Python コード](https://github.com/openai/openai-cookbook/blob/main/examples/How_to_count_tokens_with_tiktoken.ipynb)を使用できます

- 例：text-embedding-ada-002 モデルの出力ベクトル次元は 1536 です

## 💡 リクエスト例

### テキストエンベディングの作成 ✅

```bash
curl https://你的newapi服务器地址/v1/embeddings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "input": "The food was delicious and the waiter...",
    "model": "text-embedding-ada-002",
    "encoding_format": "float"
  }'
```

**応答例:**

```json
{
  "object": "list",
  "data": [
    {
      "object": "embedding",
      "embedding": [
        0.0023064255,
        -0.009327292,
        // ... (1536 个浮点数,用于 ada-002)
        -0.0028842222
      ],
      "index": 0
    }
  ],
  "model": "text-embedding-ada-002",
  "usage": {
    "prompt_tokens": 8,
    "total_tokens": 8
  }
}
```

### バッチでのエンベディング作成 ✅

```bash
curl https://你的newapi服务器地址/v1/embeddings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "input": ["The food was delicious", "The waiter was friendly"],
    "model": "text-embedding-ada-002",
    "encoding_format": "float"
  }'
```

**応答例:**

```json
{
  "object": "list",
  "data": [
    {
      "object": "embedding",
      "embedding": [
        0.0023064255,
        // ... (1536 个浮点数)
      ],
      "index": 0
    },
    {
      "object": "embedding",
      "embedding": [
        -0.008815289,
        // ... (1536 个浮点数)  
      ],
      "index": 1
    }
  ],
  "model": "text-embedding-ada-002",
  "usage": {
    "prompt_tokens": 12,
    "total_tokens": 12
  }
}
```

## 📮 リクエスト

### エンドポイント

```
POST /v1/embeddings
```

入力テキストを表すエンベディングベクトルを作成します。

### 認証方法

APIキー認証のために、リクエストヘッダーに以下を含めます：

```
Authorization: Bearer $NEWAPI_API_KEY
```

ここで、`$OPENAI_API_KEY` はあなたの API キーです。

### リクエストボディパラメータ

#### `input`

- タイプ：文字列または配列
- 必須：はい

エンベディングする入力テキスト。文字列またはトークン配列としてエンコードされます。単一のリクエストで複数の入力をエンベディングするには、文字列の配列またはトークン配列の配列を渡します。入力は、モデルの最大入力トークン数（text-embedding-ada-002 の場合は 8192 トークン）を超えてはならず、空の文字列であってはならず、配列の次元は 2048 以下である必要があります。

#### `model`

- タイプ：文字列
- 必須：はい

使用するモデル ID。利用可能なすべてのモデルを確認するには、List models API を使用するか、モデルの概要でそれらの説明を参照してください。

#### `encoding_format`

- タイプ：文字列
- 必須：いいえ
- デフォルト値：float

返されるエンベディングの形式。float または base64 のいずれかです。

#### `dimensions`

- タイプ：整数
- 必須：いいえ

生成される出力エンベディングが持つべき次元数。text-embedding-3 以降のモデルでのみサポートされています。

#### `user`

- タイプ：文字列
- 必須：いいえ

あなたのエンドユーザーを表す一意の識別子。OpenAI が不正行為を監視および検出するのに役立ちます。[詳細はこちら](https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids)。

## 📥 応答

### 成功時の応答

エンベディングオブジェクトのリストを返します。

#### `object`

- タイプ：文字列
- 説明：オブジェクトタイプ。"list" の値を取ります

#### `data`

- タイプ：配列
- 説明：エンベディングオブジェクトを含む配列
- 属性:
  - `object`: オブジェクトタイプ。"embedding" の値を取ります
  - `embedding`: エンベディングベクトル。浮動小数点数のリスト。ベクトルの長さはモデルに依存します
  - `index`: リスト内のエンベディングのインデックス

#### `model`

- タイプ：文字列
- 説明：使用されたモデル名

#### `usage`

- タイプ：オブジェクト
- 説明：トークン使用統計
- 属性:
  - `prompt_tokens`: プロンプトで使用されたトークン数
  - `total_tokens`: 合計トークン数

### エンベディングオブジェクト

エンベディングエンドポイントによって返されるエンベディングベクトルを表します。

```json
{
  "object": "embedding",
  "embedding": [
    0.0023064255,
    -0.009327292,
    // ... (ada-002 总共 1536 个浮点数)
    -0.0028842222
  ],
  "index": 0
}
```

#### `index`

- タイプ：整数
- 説明：リスト内のエンベディングのインデックス

#### `embedding` 

- タイプ：配列
- 説明：エンベディングベクトル。浮動小数点数のリスト。ベクトルの長さはモデルに依存します。詳細については、エンベディングガイドを参照してください

#### `object`

- タイプ：文字列
- 説明：オブジェクトタイプ。常に "embedding" です

### エラー応答

リクエストに問題が発生した場合、API は HTTP ステータスコード 4XX〜5XX の範囲でエラー応答オブジェクトを返します。

#### 一般的なエラー応答コード

- `401 Unauthorized`: API キーが無効であるか、提供されていません
- `400 Bad Request`: リクエストパラメータが無効です（例：入力が空、またはトークン制限を超過）
- `429 Too Many Requests`: API呼び出し制限を超過しました
- `500 Internal Server Error`: サーバー内部エラー

エラー応答例:

```json
{
  "error": {
    "message": "The input exceeds the maximum length. Please reduce the length of your input.",
    "type": "invalid_request_error",
    "param": "input",
    "code": "context_length_exceeded"
  }
}
```
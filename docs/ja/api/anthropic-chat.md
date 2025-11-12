# Anthropic 対話フォーマット（Messages）

!!! info "公式ドキュメント"
    - [Anthropic Messages](https://docs.anthropic.com/en/api/messages)
    - [Anthropic Streaming Messages](https://docs.anthropic.com/en/api/messages-streaming)

## 📝 概要

テキストや画像コンテンツを含む構造化された入力メッセージのリストが与えられると、モデルは対話における次のメッセージを生成します。Messages API は、単一のクエリまたはステートレスな複数ターンの対話に使用できます。

## 💡 リクエスト例

### 基本的なテキスト対話 ✅

```bash
curl https://你的newapi服务器地址/v1/messages \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --header "x-api-key: $NEWAPI_API_KEY" \
     --data \
'{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 1024,
    "messages": [
        {"role": "user", "content": "Hello, world"}
    ]
}'
```

**レスポンス例:**
```json
{
  "content": [
    {
      "text": "Hi! My name is Claude.",
      "type": "text"
    }
  ],
  "id": "msg_013Zva2CMHLNnXjNJKqJ2EF",
  "model": "claude-3-5-sonnet-20241022", 
  "role": "assistant",
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "type": "message",
  "usage": {
    "input_tokens": 2095,
    "output_tokens": 503
  }
}
```

### 画像分析対話 ✅

```bash
curl https://你的newapi服务器地址/v1/messages \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --header "x-api-key: $NEWAPI_API_KEY" \
     --data \
'{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "image",
                    "source": {
                        "type": "base64",
                        "media_type": "image/jpeg",
                        "data": "/9j/4AAQSkZJRg..."
                    }
                },
                {
                    "type": "text",
                    "text": "这张图片里有什么?"
                }
            ]
        }
    ]
}'
```

**レスポンス例:**
```json
{
  "content": [
    {
      "text": "这张图片显示了一只橙色的猫咪正在窗台上晒太阳。猫咪看起来很放松，眯着眼睛享受阳光。窗外可以看到一些绿色的植物。",
      "type": "text"
    }
  ],
  "id": "msg_013Zva2CMHLNnXjNJKqJ2EF",
  "model": "claude-3-5-sonnet-20241022",
  "role": "assistant",
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "type": "message",
  "usage": {
    "input_tokens": 3050,
    "output_tokens": 892
  }
}
```

### ツール呼び出し ✅

```bash
curl https://你的newapi服务器地址/v1/messages \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --header "x-api-key: $NEWAPI_API_KEY" \
     --data \
'{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [
        {
            "role": "user", 
            "content": "今天北京的天气怎么样?"
        }
    ],
    "tools": [
        {
            "name": "get_weather",
            "description": "获取指定位置的当前天气",
            "input_schema": {
                "type": "object",
                "properties": {
                    "location": {
                        "type": "string",
                        "description": "城市名称,如:北京"
                    }
                },
                "required": ["location"]
            }
        }
    ]
}'
```

**レスポンス例:**
```json
{
  "content": [
    {
      "type": "tool_use",
      "id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
      "name": "get_weather",
      "input": { "location": "北京" }
    }
  ],
  "id": "msg_013Zva2CMHLNnXjNJKqJ2EF",
  "model": "claude-3-5-sonnet-20241022",
  "role": "assistant",
  "stop_reason": "tool_use",
  "stop_sequence": null,
  "type": "message",
  "usage": {
    "input_tokens": 2156,
    "output_tokens": 468
  }
}
```

### ストリーミング応答 ✅

```bash
curl https://你的newapi服务器地址/v1/messages \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --header "x-api-key: $NEWAPI_API_KEY" \
     --data \
'{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [
        {
            "role": "user",
            "content": "讲个故事"
        }
    ],
    "stream": true
}'
```

**レスポンス例:**
```json
{
  "type": "message_start",
  "message": {
    "id": "msg_013Zva2CMHLNnXjNJKqJ2EF",
    "model": "claude-3-5-sonnet-20241022",
    "role": "assistant",
    "type": "message"
  }
}
{
  "type": "content_block_start",
  "index": 0,
  "content_block": {
    "type": "text"
  }
}
{
  "type": "content_block_delta",
  "index": 0,
  "delta": {
    "text": "从前"
  }
}
{
  "type": "content_block_delta",
  "index": 0,
  "delta": {
    "text": "有一只"
  }
}
{
  "type": "content_block_delta",
  "index": 0,
  "delta": {
    "text": "小兔子..."
  }
}
{
  "type": "content_block_stop",
  "index": 0
}
{
  "type": "message_delta",
  "delta": {
    "stop_reason": "end_turn",
    "usage": {
      "input_tokens": 2045,
      "output_tokens": 628
    }
  }
}
{
  "type": "message_stop"
}
```

## 📮 リクエスト

### エンドポイント

```
POST /v1/messages
```

### 認証方法

APIキー認証のために、リクエストヘッダーに以下を含めます：

```
x-api-key: $NEWAPI_API_KEY
```

ここで、`$NEWAPI_API_KEY` はお客様の API キーです。API キーはコンソールから取得でき、各キーは1つのワークスペースでのみ使用が制限されます。

### リクエストヘッダーパラメータ

#### `anthropic-beta`

- 型：文字列
- 必須：いいえ

使用するベータ版を指定します。`beta1,beta2` のようにカンマ区切りのリスト、またはこのヘッダーを複数回指定することでサポートされます。

#### `anthropic-version`

- 型：文字列
- 必須：はい

使用する API バージョンを指定します。

### リクエストボディパラメータ

#### `max_tokens`

- 型：整数
- 必須：はい

生成される最大トークン数。モデルごとに異なる制限があります。モデルのドキュメントを参照してください。範囲 `x > 1`。

#### `messages`

- 型：オブジェクト配列
- 必須：はい

入力メッセージのリスト。モデルは、ユーザーとアシスタントが交互に対話を行うようにトレーニングされています。新しいメッセージを作成する際、messages パラメータを使用して以前の対話ターンを指定でき、モデルは対話における次のメッセージを生成します。連続するユーザーまたはアシスタントのメッセージは、単一のターンに結合されます。

各メッセージには `role` および `content` フィールドを含める必要があります。単一のユーザーロールメッセージを指定することも、複数のユーザーおよびアシスタントメッセージを含めることもできます。最後のメッセージがアシスタントロールを使用している場合、応答内容はそのメッセージのコンテンツから直接続行され、これはモデルの応答を制約するために使用できます。

**単一のユーザーメッセージ例:**
```json
[{"role": "user", "content": "Hello, Claude"}]
```

**複数ターンの対話例:**
```json
[
  {"role": "user", "content": "你好。"},
  {"role": "assistant", "content": "你好！我是 Claude。有什么可以帮你的吗？"},
  {"role": "user", "content": "请用简单的话解释什么是 LLM？"}
]
```

**部分的に埋められた応答例:**
```json
[
  {"role": "user", "content": "太阳的希腊语名字是什么? (A) Sol (B) Helios (C) Sun"},
  {"role": "assistant", "content": "正确答案是 ("}
]
```

各メッセージの content は、文字列またはコンテンツブロックの配列のいずれかです。文字列を使用することは、"text" タイプのコンテンツブロック配列の省略形と同等です。以下の2つの記述は同等です：

```json
{"role": "user", "content": "Hello, Claude"}
```

```json
{
  "role": "user", 
  "content": [{"type": "text", "text": "Hello, Claude"}]
}
```

Claude 3 モデル以降、画像コンテンツブロックも送信できます：

```json
{
  "role": "user",
  "content": [
    {
      "type": "image",
      "source": {
        "type": "base64",
        "media_type": "image/jpeg",
        "data": "/9j/4AAQSkZJRg..."
      }
    },
    {
      "type": "text",
      "text": "这张图片里有什么?"
    }
  ]
}
```

> 現在サポートされている画像形式には、base64, image/jpeg、image/png、image/gif、image/webp が含まれます。

##### `messages.role`

- 型：列挙型文字列
- 必須：はい
- 選択可能な値：user, assistant

注意：Messages API には "system" ロールはありません。システムプロンプトが必要な場合は、トップレベルの `system` パラメータを使用してください。

##### `messages.content`

- 型：文字列またはオブジェクト配列
- 必須：はい

メッセージコンテンツは以下のいずれかのタイプである必要があります：

###### テキストコンテンツ (Text)

```json
{
  "type": "text",          // 必須、列挙値: "text"
  "text": "Hello, Claude", // 必須、最小長: 1
  "cache_control": {
    "type": "ephemeral"    // オプション、列挙値: "ephemeral"
  }
}
```

###### 画像コンテンツ (Image)

```json
{
  "type": "image",         // 必須、列挙値: "image"
  "source": {             // 必須
    "type": "base64",     // 必須、列挙値: "base64"
    "media_type": "image/jpeg", // 必須、サポートされる形式: image/jpeg, image/png, image/gif, image/webp
    "data": "/9j/4AAQSkZJRg..."  // 必須、base64エンコードされた画像データ
  },
  "cache_control": {
    "type": "ephemeral"    // オプション、列挙値: "ephemeral"
  }
}
```

###### ツール使用 (Tool Use)

```json
{
  "type": "tool_use",      // 必須、列挙値: "tool_use"
  "id": "toolu_xyz...",    // 必須、ツール使用の一意の識別子
  "name": "get_weather",   // 必須、ツール名、最小長: 1
  "input": {              // 必須、ツールの入力パラメータオブジェクト
    // ツールの入力パラメータ。具体的な形式はツールの input_schema によって定義されます
  },
  "cache_control": {
    "type": "ephemeral"    // オプション、列挙値: "ephemeral"
  }
}
```

###### ツール結果 (Tool Result)

```json
{
  "type": "tool_result",   // 必須、列挙値: "tool_result"
  "tool_use_id": "toolu_xyz...",  // 必須
  "content": "结果内容",   // 必須、文字列またはコンテンツブロック配列のいずれか
  "is_error": false,      // オプション、ブール値
  "cache_control": {
    "type": "ephemeral"    // オプション、列挙値: "ephemeral"
  }
}
```

content がコンテンツブロック配列である場合、各コンテンツブロックはテキストまたは画像であることができます：

```json
{
  "type": "tool_result",
  "tool_use_id": "toolu_xyz...",
  "content": [
    {
      "type": "text",      // 必須、列挙値: "text"
      "text": "分析结果",   // 必須、最小長: 1
      "cache_control": {
        "type": "ephemeral" // オプション、列挙値: "ephemeral"
      }
    },
    {
      "type": "image",     // 必須、列挙値: "image"
      "source": {         // 必須
        "type": "base64", // 必須、列挙値: "base64"
        "media_type": "image/jpeg",
        "data": "..."
      },
      "cache_control": {
        "type": "ephemeral"
      }
    }
  ]
}
```

###### ドキュメント (Document)

```json
{
  "type": "document",      // 必須、列挙値: "document"
  "source": {             // 必須
    // ドキュメントソースデータ
  },
  "cache_control": {
    "type": "ephemeral"    // オプション、列挙値: "ephemeral"
  }
}
```

注意：
1. 各タイプには、オプションの `cache_control` フィールドを含めることができ、コンテンツのキャッシュ動作を制御するために使用されます。
2. テキストコンテンツの最小長は 1 です。
3. すべてのタイプの type フィールドは必須の列挙型文字列です。
4. ツール結果の content フィールドは、文字列またはテキスト/画像を含むコンテンツブロック配列をサポートします。

#### `model`

- 型：文字列
- 必須：はい

使用するモデル名。モデルのドキュメントを参照してください。範囲 `1 - 256` 文字。

#### `metadata`

- 型：オブジェクト
- 必須：いいえ

リクエストのメタデータを記述するオブジェクト。以下のオプションフィールドが含まれます：

- `user_id`: リクエストに関連付けられたユーザーの外部識別子。uuid、ハッシュ値、またはその他の不透明な識別子である必要があります。氏名、メールアドレス、電話番号などの識別情報を含めないでください。最大長：256。

#### `stop_sequences`

- 型：文字列配列
- 必須：いいえ

生成を停止するためのカスタムテキストシーケンス。

#### `stream`

- 型：ブール値
- 必須：いいえ

サーバー送信イベント (SSE) を使用して応答コンテンツをインクリメンタルに返すかどうか。

#### `system`

- 型：文字列
- 必須：いいえ

システムプロンプト。Claude に背景情報と指示を提供します。これは、モデルにコンテキストと特定の目標や役割を与える方法です。これはメッセージ内の role とは異なり、Messages API には "system" ロールがないことに注意してください。

#### `temperature`

- 型：数値
- 必須：いいえ
- デフォルト値：1.0

生成のランダム性を制御します。0.0 - 1.0。範囲 `0 < x < 1`。分析的/選択式のタスクには 0.0 に近い値を、創造的/生成的なタスクには 1.0 に近い値を使用することが推奨されます。

注意：temperature を 0.0 に設定しても、結果が完全に決定論的になるわけではありません。

#### 🆕 `thinking`

- 型：オブジェクト
- 必須：いいえ

Claude の拡張思考機能を設定します。有効にすると、応答には、最終的な回答を出す前の Claude の思考プロセスを示すコンテンツブロックが含まれます。最低 1,024 トークンの予算が必要であり、`max_tokens` 制限に計上されます。

以下の2つのモードのいずれかに設定できます：

##### 1. 有効化モード

```json
{
  "type": "enabled",
  "budget_tokens": 2048
}
```

- `type`: 必須、列挙値: "enabled"
- `budget_tokens`: 必須、整数。Claude が内部推論プロセスに使用できるトークン数を決定します。予算が大きいほど、モデルは複雑な問題に対してより深い分析を行うことができ、応答品質が向上します。1024 以上で、かつ max_tokens より小さい必要があります。範囲 `x > 1024`。

##### 2. 無効化モード

```json
{
  "type": "disabled"
}
```

- `type`: 必須、列挙値: "disabled"

#### `tool_choice`

- 型：オブジェクト
- 必須：いいえ

提供されたツールをモデルがどのように使用するかを制御します。以下の3つのタイプのいずれかになります：

##### 1. Auto モード (自動選択)

```json
{
  "type": "auto",  // 必須、列挙値: "auto"
  "disable_parallel_tool_use": false  // オプション、デフォルト false。true の場合、モデルは最大で1つのツールのみを使用します
}
```

##### 2. Any モード (任意のツール)

```json
{
  "type": "any",  // 必須、列挙値: "any"
  "disable_parallel_tool_use": false  // オプション、デフォルト false。true の場合、モデルはちょうど1つのツールを使用します
}
```

##### 3. Tool モード (指定ツール)

```json
{
  "type": "tool",  // 必須、列挙値: "tool"
  "name": "get_weather",  // 必須、使用するツール名を指定します
  "disable_parallel_tool_use": false  // オプション、デフォルト false。true の場合、モデルはちょうど1つのツールを使用します
}
```

注意：
1. Auto モード：モデルはツールを使用するかどうかを自分で決定できます
2. Any モード：モデルはツールを使用する必要がありますが、利用可能な任意のツールを選択できます
3. Tool モード：モデルは指定されたツールを使用する必要があります

#### `tools`

- 型：オブジェクト配列
- 必須：いいえ

モデルが使用する可能性のあるツールを定義します。ツールはカスタムツールまたは組み込みツールタイプのいずれかです：

##### 1. カスタムツール（Tool）

各カスタムツールの定義には以下が含まれます：

- `type`: オプション、列挙値: "custom"
- `name`: ツール名、必須、1-64 文字
- `description`: ツールの説明、可能な限り詳細に記述することを推奨
- `input_schema`: ツールの入力の JSON Schema 定義、必須
- `cache_control`: キャッシュ制御、オプション、type は "ephemeral"

例：
```json
[
  {
    "type": "custom",
    "name": "get_weather",
    "description": "获取指定位置的当前天气",
    "input_schema": {
      "type": "object",
      "properties": {
        "location": {
          "type": "string",
          "description": "城市名称,如:北京"
        }
      },
      "required": ["location"]
    }
  }
]
```

##### 2. コンピュータツール (ComputerUseTool)

```json
{
  "type": "computer_20241022",  // 必須
  "name": "computer",           // 必須、列挙値: "computer"
  "display_width_px": 1024,     // 必須、表示幅(ピクセル)
  "display_height_px": 768,     // 必須、表示高さ(ピクセル)
  "display_number": 0,          // オプション、X11 ディスプレイ番号
  "cache_control": {
    "type": "ephemeral"         // オプション
  }
}
```

##### 3. Bash ツール (BashTool)

```json
{
  "type": "bash_20241022",      // 必須
  "name": "bash",               // 必須、列挙値: "bash"
  "cache_control": {
    "type": "ephemeral"         // オプション
  }
}
```

##### 4. テキストエディタツール (TextEditor)

```json
{
  "type": "text_editor_20241022", // 必須
  "name": "str_replace_editor",   // 必須、列挙値: "str_replace_editor"
  "cache_control": {
    "type": "ephemeral"           // オプション
  }
}
```

モデルがツールを使用する場合、tool_use コンテンツブロックが返されます：

```json
[
  {
    "type": "tool_use",
    "id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
    "name": "get_weather",
    "input": { "location": "北京" }
  }
]
```

ツールを実行し、tool_result コンテンツブロックを通じて結果を返すことができます：

```json
[
  {
    "type": "tool_result",
    "tool_use_id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
    "content": "北京当前天气晴朗，温度 25°C"
  }
]
```

#### `top_k`

- 型：整数
- 必須：いいえ
- 範囲：x > 0

トークンの上位 K 個のオプションからサンプリングします。低確率の「ロングテール」応答を削除するために使用されます。通常、`temperature` のみを調整すれば十分であり、高度なユースケースでのみ使用することを推奨します。

#### `top_p`

- 型：数値
- 必須：いいえ
- 範囲：0 < x < 1

nucleus サンプリングを使用します。後続の各トークンについて、確率の降順で累積分布を計算し、`top_p` で指定された確率に達した時点で打ち切ります。`temperature` または `top_p` のいずれか一方のみを調整し、両方を同時に使用しないことを推奨します。

## 📥 レスポンス

### 成功応答

以下のフィールドを含むチャット補完オブジェクトを返します：

#### `content`

- 型：オブジェクト配列
- 必須：はい

モデルが生成したコンテンツ。複数のコンテンツブロックで構成されます。各コンテンツブロックには、その形状を決定する `type` があります。コンテンツブロックは以下のタイプのいずれかです：

##### テキストコンテンツブロック (Text)

```json
{
  "type": "text",          // 必須、列挙値: "text"
  "text": "你好，我是 Claude。" // 必須、最大長: 5000000、最小長: 1
}
```

##### ツール使用コンテンツブロック (Tool Use)

```json
{
  "type": "tool_use",      // 必須、列挙値: "tool_use"
  "id": "toolu_xyz...",    // 必須、ツール使用の一意の識別子
  "name": "get_weather",   // 必須、ツール名、最小長: 1
  "input": {              // 必須、ツールの入力パラメータオブジェクト
    // ツールの入力パラメータ。具体的な形式はツールの input_schema によって定義されます
  }
}
```

例：
```json
// テキストコンテンツ例
[{"type": "text", "text": "你好，我是 Claude。"}]

// ツール使用例
[{
  "type": "tool_use",
  "id": "toolu_xyz...",
  "name": "get_weather",
  "input": { "location": "北京" }
}]

// 混合コンテンツ例
[
  {"type": "text", "text": "根据天气查询结果："},
  {
    "type": "tool_use",
    "id": "toolu_xyz...",
    "name": "get_weather",
    "input": { "location": "北京" }
  }
]
```

リクエストの最後のメッセージがアシスタントロールである場合、応答コンテンツはそのメッセージから直接続行されます。例：

```json
// リクエスト
[
  {"role": "user", "content": "太阳的希腊语名字是什么? (A) Sol (B) Helios (C) Sun"},
  {"role": "assistant", "content": "正确答案是 ("}
]

// 応答
[{"type": "text", "text": "B)"}]
```

#### `id`

- 型：文字列
- 必須：はい

応答の一意の識別子。

#### `model`

- 型：文字列
- 必須：はい

使用されたモデル名。

#### `role`

- 型：列挙型文字列
- 必須：はい
- デフォルト値：assistant

生成されたメッセージのセッションロール。常に "assistant" です。

#### `stop_reason`

- 型：列挙型文字列または null
- 必須：はい

生成が停止した理由。考えられる値は以下の通りです：

- `"end_turn"`: モデルが自然な停止点に達した
- `"max_tokens"`: リクエストの `max_tokens` またはモデルの最大制限を超過した
- `"stop_sequence"`: カスタム停止シーケンスのいずれかが生成された
- `"tool_use"`: モデルが1つ以上のツールを呼び出した

非ストリーミングモードでは、この値は常に非ヌルです。ストリーミングモードでは、`message_start` イベントでは null であり、それ以外の場合は非ヌルです。

#### `stop_sequence`

- 型：文字列または null
- 必須：はい

生成されたカスタム停止シーケンス。モデルが `stop_sequences` パラメータで指定されたシーケンスのいずれかに遭遇した場合、このフィールドには一致した停止シーケンスが含まれます。停止シーケンス以外の理由で停止した場合、null になります。

#### `type`

- 型：列挙型文字列
- 必須：はい
- デフォルト値：message
- 選択可能な値：message

オブジェクトタイプ。Messages の場合は常に "message" です。

#### `usage`

- 型：オブジェクト
- 必須：はい

課金およびレート制限に関連する使用量統計。以下のフィールドが含まれます：

- `input_tokens`: 使用された入力トークン数、必須、範囲 x > 0
- `output_tokens`: 使用された出力トークン数、必須、範囲 x > 0
- `cache_creation_input_tokens`: キャッシュエントリの作成に使用された入力トークン数（該当する場合）、必須、範囲 x > 0
- `cache_read_input_tokens`: キャッシュから読み取られた入力トークン数（該当する場合）、必須、範囲 x > 0

注意：API は内部でリクエストの変換と解析を行うため、トークン数はリクエストおよび応答の実際の可視コンテンツと完全に一致しない場合があります。例えば、空文字列の応答であっても、`output_tokens` はゼロ以外の値になります。

### エラー応答

リクエストに問題が発生した場合、API は HTTP ステータスコード 4XX〜5XX の範囲でエラー応答オブジェクトを返します。

#### 一般的なエラー ステータスコード

- `401 Unauthorized`: API キーが無効であるか、提供されていません
- `400 Bad Request`: リクエストパラメータが無効です
- `429 Too Many Requests`: API呼び出し制限を超過しました
- `500 Internal Server Error`: サーバー内部エラー

エラー応答例:

```json
{
  "error": {
    "type": "invalid_request_error",
    "message": "Invalid API key provided",
    "code": "invalid_api_key"
  }
}
```

主なエラータイプ:

- `invalid_request_error`: リクエストパラメータエラー
- `authentication_error`: 認証関連エラー
- `rate_limit_error`: リクエスト頻度超過
- `server_error`: サーバー内部エラー
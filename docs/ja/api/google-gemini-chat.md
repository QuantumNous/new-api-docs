## 核心概念 (Core Concepts)

| 日本語 | English | 説明 | Description |
|------|---------|------|-------------|
| 倍率 | Ratio | 価格計算に使用される乗数ファクター | Multiplier factor used for price calculation |
| 令牌 | Token | APIアクセス認証情報、またはモデルが処理するテキスト単位 | API access credentials or text units processed by models |
| 渠道 | Channel | APIサービスプロバイダーのアクセスチャネル | Access channel for API service providers |
| 分组 | Group | ユーザーまたはトークンの分類。価格倍率に影響を与える | Classification of users or tokens, affecting price ratios |
| 額度 | Quota | ユーザーが利用可能なサービス割り当て | Available service quota for users |

# Google Gemini 対話フォーマット（Generate Content）

!!! info "公式ドキュメント"
    [Google Gemini Generating content API](https://ai.google.dev/api/generate-content)

## 📝 はじめに

Google Gemini API は、画像、音声、コード、ツールなどを使用してコンテンツの生成をサポートしています。GenerateContentRequest を入力として与えることで、モデルの応答を生成します。テキスト生成、視覚理解、音声処理、長文コンテキスト、コード実行、JSONモード、関数呼び出しなど、多様な機能をサポートしています。

## 💡 リクエスト例

### 基本的なテキスト対話 ✅

```bash
curl "https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d '{
      "contents": [{
        "parts":[{"text": "Write a story about a magic backpack."}]
        }]
       }' 2> /dev/null
```

### 画像分析対話 ✅

```bash
# 使用临时文件保存base64编码的图片数据
TEMP_B64=$(mktemp)
trap 'rm -f "$TEMP_B64"' EXIT
base64 $B64FLAGS $IMG_PATH > "$TEMP_B64"

# 使用临时文件保存JSON载荷
TEMP_JSON=$(mktemp)
trap 'rm -f "$TEMP_JSON"' EXIT

cat > "$TEMP_JSON" << EOF
{
  "contents": [{
    "parts":[
      {"text": "Tell me about this instrument"},
      {
        "inline_data": {
          "mime_type":"image/jpeg",
          "data": "$(cat "$TEMP_B64")"
        }
      }
    ]
  }]
}
EOF

curl "https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d "@$TEMP_JSON" 2> /dev/null
```

### 関数呼び出し ✅

```bash
cat > tools.json << EOF
{
  "function_declarations": [
    {
      "name": "enable_lights",
      "description": "Turn on the lighting system."
    },
    {
      "name": "set_light_color",
      "description": "Set the light color. Lights must be enabled for this to work.",
      "parameters": {
        "type": "object",
        "properties": {
          "rgb_hex": {
            "type": "string",
            "description": "The light color as a 6-digit hex string, e.g. ff0000 for red."
          }
        },
        "required": [
          "rgb_hex"
        ]
      }
    },
    {
      "name": "stop_lights",
      "description": "Turn off the lighting system."
    }
  ]
} 
EOF

curl "https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
  -H 'Content-Type: application/json' \
  -d @<(echo '
  {
    "system_instruction": {
      "parts": {
        "text": "You are a helpful lighting system bot. You can turn lights on and off, and you can set the color. Do not perform any other tasks."
      }
    },
    "tools": ['$(cat tools.json)'],

    "tool_config": {
      "function_calling_config": {"mode": "auto"}
    },

    "contents": {
      "role": "user",
      "parts": {
        "text": "Turn on the lights please."
      }
    }
  }
') 2>/dev/null |sed -n '/"content"/,/"finishReason"/p'
```

### JSONモード応答 ✅

```bash
curl "https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
-H 'Content-Type: application/json' \
-d '{
    "contents": [{
      "parts":[
        {"text": "List 5 popular cookie recipes"}
        ]
    }],
    "generationConfig": {
        "response_mime_type": "application/json",
        "response_schema": {
          "type": "ARRAY",
          "items": {
            "type": "OBJECT",
            "properties": {
              "recipe_name": {"type":"STRING"},
            }
          }
        }
    }
}' 2> /dev/null | head
```

### 音声処理 🟡

!!! warning "ファイルアップロードの制限"
    `inline_data` を介した base64 方式での音声アップロードのみをサポートしており、`file_data.file_uri` または File API はサポートされていません。

```bash
# 使用File API上传音频数据到API请求
# 使用 base64 inline_data 上传音频数据到 API 请求
if [[ "$(base64 --version 2>&1)" = *"FreeBSD"* ]]; then
  B64FLAGS="--input"
else
  B64FLAGS="-w0"
fi
AUDIO_B64=$(base64 $B64FLAGS "$AUDIO_PATH")

curl "https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
  -H 'Content-Type: application/json' \
  -X POST \
  -d '{
    "contents": [{
      "parts": [
        {"text": "Please describe this audio file."},
        {"inline_data": {"mime_type": "audio/mpeg", "data": "'$AUDIO_B64'"}}
      ]
    }]
  }' 2> /dev/null | jq ".candidates[].content.parts[].text"
```

### 動画処理 🟡

!!! warning "ファイルアップロードの制限"
    `inline_data` を介した base64 方式での動画アップロードのみをサポートしており、`file_data.file_uri` または File API はサポートされていません。

```bash
# 使用File API上传视频数据到API请求
# 使用 base64 inline_data 上传视频数据到 API 请求
if [[ "$(base64 --version 2>&1)" = *"FreeBSD"* ]]; then
  B64FLAGS="--input"
else
  B64FLAGS="-w0"
fi
VIDEO_B64=$(base64 $B64FLAGS "$VIDEO_PATH")

curl "https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
  -H 'Content-Type: application/json' \
  -X POST \
  -d '{
    "contents": [{
      "parts": [
        {"text": "Transcribe the audio from this video and provide visual descriptions."},
        {"inline_data": {"mime_type": "video/mp4", "data": "'$VIDEO_B64'"}}
      ]
    }]
  }' 2> /dev/null | jq ".candidates[].content.parts[].text"
```

### PDF処理 🟡

!!! warning "ファイルアップロードの制限"
    `inline_data` を介した base64 方式での PDF アップロードのみをサポートしており、`file_data.file_uri` または File API はサポートされていません。

```bash
MIME_TYPE=$(file -b --mime-type "${PDF_PATH}")
# 使用 base64 inline_data 上传 PDF 文件到 API 请求
if [[ "$(base64 --version 2>&1)" = *"FreeBSD"* ]]; then
  B64FLAGS="--input"
else
  B64FLAGS="-w0"
fi
PDF_B64=$(base64 $B64FLAGS "$PDF_PATH")

echo $MIME_TYPE

curl "https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
  -H 'Content-Type: application/json' \
  -X POST \
  -d '{
    "contents": [{
      "parts": [
        {"text": "Can you add a few more lines to this poem?"},
        {"inline_data": {"mime_type": "application/pdf", "data": "'$PDF_B64'"}}
      ]
    }]
  }' 2> /dev/null | jq ".candidates[].content.parts[].text"
```

### チャット対話 ✅

```bash
curl https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY \
    -H 'Content-Type: application/json' \
    -X POST \
    -d '{
      "contents": [
        {"role":"user",
         "parts":[{
           "text": "Hello"}]},
        {"role": "model",
         "parts":[{
           "text": "Great to meet you. What would you like to know?"}]},
        {"role":"user",
         "parts":[{
           "text": "I have two dogs in my house. How many paws are in my house?"}]},
      ]
    }' 2> /dev/null | grep "text"
```

### ストリーミング応答 ✅

```bash
curl "https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:streamGenerateContent?alt=sse&key=$NEWAPI_API_KEY" \
    -H 'Content-Type: application/json' \
    --no-buffer \
    -d '{
      "contents": [{
        "parts": [{"text": "写一个关于魔法背包的故事"}]
      }]
    }'
```

### コード実行 ✅

```bash
curl "https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d '{
      "contents": [{
        "parts": [{"text": "计算斐波那契数列的第10项"}]
      }],
      "tools": [{
        "codeExecution": {}
      }]
    }'
```

### 生成構成 ✅

```bash
curl https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY \
    -H 'Content-Type: application/json' \
    -X POST \
    -d '{
        "contents": [{
            "parts":[
                {"text": "Explain how AI works"}
            ]
        }],
        "generationConfig": {
            "stopSequences": [
                "Title"
            ],
            "temperature": 1.0,
            "maxOutputTokens": 800,
            "topP": 0.8,
            "topK": 10
        }
    }'  2> /dev/null | grep "text"
```

### 安全設定 ✅

```bash
echo '{
    "safetySettings": [
        {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_ONLY_HIGH"},
        {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_MEDIUM_AND_ABOVE"}
    ],
    "contents": [{
        "parts":[{
            "text": "'I support Martians Soccer Club and I think Jupiterians Football Club sucks! Write a ironic phrase about them.'"}]}]}' > request.json

curl "https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d @request.json 2> /dev/null
```

### システム指示 ✅

```bash
curl "https://你的newapi服务器地址/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
-H 'Content-Type: application/json' \
-d '{ "system_instruction": {
    "parts":
      { "text": "You are a cat. Your name is Neko."}},
    "contents": {
      "parts": {
        "text": "Hello there"}}}'
```

## 📮 リクエスト

### エンドポイント

#### コンテンツの生成
```
POST https://你的newapi服务器地址/v1beta/{model=models/*}:generateContent
```

#### ストリーミングコンテンツの生成
```
POST https://你的newapi服务器地址/v1beta/{model=models/*}:streamGenerateContent
```

### 認証方法

リクエストURLパラメータにAPIキーを含めます：

```
?key=$NEWAPI_API_KEY
```

ここで `$NEWAPI_API_KEY` は、あなたの Google AI API キーです。

### パスパラメータ

#### `model`

- タイプ：文字列
- 必須：はい

補完を生成するために使用されるモデル名。

フォーマット：`models/{model}`、例： `models/gemini-2.0-flash`

### リクエストボディパラメータ

#### `contents`

- タイプ：配列
- 必須：はい

モデルとの現在の対話の内容。単一のターンクエリの場合、これは単一のインスタンスです。チャットのようなマルチターンクエリの場合、これは対話履歴と最新のリクエストを含む繰り返しフィールドです。

**Content オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `parts` | 配列 | はい | 単一のメッセージを構成する順序付けられたコンテンツ部分 |
| `role` | 文字列 | いいえ | 対話におけるコンテンツの生成者。`user`、`model`、`function`、または `tool` |

**Part オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `text` | 文字列 | いいえ | プレーンテキストの内容 |
| `inlineData` | オブジェクト | いいえ | インラインメディアのバイトデータ |
| `fileData` | オブジェクト | いいえ | アップロードされたファイルのURI参照 |
| `functionCall` | オブジェクト | いいえ | 関数呼び出しリクエスト |
| `functionResponse` | オブジェクト | いいえ | 関数呼び出し応答 |
| `executableCode` | オブジェクト | いいえ | 実行可能なコード |
| `codeExecutionResult` | オブジェクト | いいえ | コード実行結果 |

**InlineData オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `mimeType` | 文字列 | はい | メディアのMIMEタイプ |
| `data` | 文字列 | はい | base64エンコードされたメディアデータ |

**FileData オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `mimeType` | 文字列 | はい | ファイルのMIMEタイプ |
| `fileUri` | 文字列 | はい | ファイルのURI |

#### `tools`

- タイプ：配列
- 必須：いいえ

モデルが次の応答を生成するために使用できるツールのリスト。サポートされているツールには、関数とコード実行が含まれます。

**Tool オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `functionDeclarations` | 配列 | いいえ | オプションの関数宣言のリスト |
| `codeExecution` | オブジェクト | いいえ | モデルによるコード実行を有効にする |

**FunctionDeclaration オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `name` | 文字列 | はい | 関数名 |
| `description` | 文字列 | いいえ | 関数の機能説明 |
| `parameters` | オブジェクト | いいえ | 関数パラメータ、JSON Schemaフォーマット |

**FunctionCall オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `name` | 文字列 | はい | 呼び出す関数名 |
| `args` | オブジェクト | いいえ | 関数パラメータのキーと値のペア |

**FunctionResponse オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `name` | 文字列 | はい | 呼び出された関数名 |
| `response` | オブジェクト | はい | 関数呼び出しの応答データ |

**ExecutableCode オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `language` | 列挙型 | はい | コードのプログラミング言語 |
| `code` | 文字列 | はい | 実行するコード |

**CodeExecutionResult オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `outcome` | 列挙型 | はい | コード実行の結果ステータス |
| `output` | 文字列 | いいえ | コード実行の出力内容 |

**CodeExecution オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| {} | 空のオブジェクト | - | コード実行機能を有効にするための空の構成オブジェクト |

#### `toolConfig`

- タイプ：オブジェクト
- 必須：いいえ

リクエストで指定された任意のツールのツール構成。

**ToolConfig オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `functionCallingConfig` | オブジェクト | いいえ | 関数呼び出し構成 |

**FunctionCallingConfig オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `mode` | 列挙型 | いいえ | 関数呼び出しのモードを指定 |
| `allowedFunctionNames` | 配列 | いいえ | 呼び出しが許可されている関数名のリスト |

**FunctionCallingMode 列挙値：**

- `MODE_UNSPECIFIED`: デフォルトモード。モデルが関数を呼び出すかどうかを決定します
- `AUTO`: モデルが関数を呼び出すタイミングを自動的に決定します 
- `ANY`: モデルは関数を呼び出す必要があります
- `NONE`: モデルは関数を呼び出すことができません

#### `safetySettings`

- タイプ：配列
- 必須：いいえ

安全でないコンテンツをブロックするために使用される SafetySetting インスタンスのリスト。

**SafetySetting オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `category` | 列挙型 | はい | 安全カテゴリ |
| `threshold` | 列挙型 | はい | ブロックのしきい値 |

**HarmCategory 列挙値：**

- `HARM_CATEGORY_HARASSMENT`: ハラスメントコンテンツ
- `HARM_CATEGORY_HATE_SPEECH`: 憎悪的な発言とコンテンツ
- `HARM_CATEGORY_SEXUALLY_EXPLICIT`: 露骨な性的コンテンツ
- `HARM_CATEGORY_DANGEROUS_CONTENT`: 危険なコンテンツ
- `HARM_CATEGORY_CIVIC_INTEGRITY`: 市民の誠実さを損なう可能性のあるコンテンツ

**HarmBlockThreshold 列挙値：**

- `BLOCK_LOW_AND_ABOVE`: NEGLIGIBLE と評価されたコンテンツの公開を許可
- `BLOCK_MEDIUM_AND_ABOVE`: NEGLIGIBLE と LOW と評価されたコンテンツの公開を許可
- `BLOCK_ONLY_HIGH`: NEGLIGIBLE、LOW、MEDIUM のリスクレベルのコンテンツの公開を許可
- `BLOCK_NONE`: すべてのコンテンツを許可
- `OFF`: 安全フィルターをオフにする

**HarmBlockThreshold 完全な列挙値：**

- `HARM_BLOCK_THRESHOLD_UNSPECIFIED`: しきい値が未指定
- `BLOCK_LOW_AND_ABOVE`: 低確率以上の有害コンテンツをブロックし、NEGLIGIBLE レベルのコンテンツのみを許可
- `BLOCK_MEDIUM_AND_ABOVE`: 中確率以上の有害コンテンツをブロックし、NEGLIGIBLE および LOW レベルのコンテンツを許可
- `BLOCK_ONLY_HIGH`: 高確率の有害コンテンツのみをブロックし、NEGLIGIBLE、LOW、MEDIUM レベルのコンテンツを許可
- `BLOCK_NONE`: コンテンツをブロックせず、すべてのレベルのコンテンツを許可
- `OFF`: 安全フィルターを完全にオフにする

#### `systemInstruction`

- タイプ：オブジェクト（Content）
- 必須：いいえ

開発者が設定するシステム指示。現在、テキストのみをサポートしています。

#### `generationConfig`

- タイプ：オブジェクト
- 必須：いいえ

モデルの生成と出力のための構成オプション。

**GenerationConfig オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `stopSequences` | 配列 | いいえ | 出力生成を停止するために使用される文字シーケンスのセット（最大5つ） |
| `responseMimeType` | 文字列 | いいえ | 生成された候補テキストのMIMEタイプ |
| `responseSchema` | オブジェクト | いいえ | 生成された候補テキストの出力スキーマ |
| `responseModalities` | 配列 | いいえ | リクエストされた応答モダリティ |
| `candidateCount` | 整数 | いいえ | 返される生成された回答の数 |
| `maxOutputTokens` | 整数 | いいえ | 候補回答に含まれるトークン数の上限 |
| `temperature` | 数値 | いいえ | 出力のランダム性を制御します、範囲[0.0, 2.0] |
| `topP` | 数値 | いいえ | サンプリング時に考慮されるトークンの累積確率の上限 |
| `topK` | 整数 | いいえ | サンプリング時に考慮されるトークン数の上限 |
| `seed` | 整数 | いいえ | デコードに使用されるシード |
| `presencePenalty` | 数値 | いいえ | 存在ペナルティ |
| `frequencyPenalty` | 数値 | いいえ | 頻度ペナルティ |
| `responseLogprobs` | ブール値 | いいえ | 応答に logprobs の結果を出力するかどうか |
| `logprobs` | 整数 | いいえ | 返されるトップ logprob の数 |
| `enableEnhancedCivicAnswers` | ブール値 | いいえ | 強化された市民サービス回答を有効にする |
| `speechConfig` | オブジェクト | いいえ | 音声生成構成 |
| `thinkingConfig` | オブジェクト | いいえ | 思考機能の構成 |
| `mediaResolution` | 列挙型 | いいえ | 指定されたメディア解像度 |

**サポートされている MIME タイプ：**

- `text/plain`: （デフォルト）テキスト出力
- `application/json`: JSON応答
- `text/x.enum`: ENUMを文字列として応答

**Modality 列挙値：**

- `TEXT`: モデルがテキストを返す必要があることを示します
- `IMAGE`: モデルが画像を返す必要があることを示します
- `AUDIO`: モデルが音声を返す必要があることを示します

**Schema オブジェクトのプロパティ：**

| プロパティ | タイプ | 必須 | 説明 |
|------|------|------|------|
| `type` | 列挙型 | はい | データ型 |
| `description` | 文字列 | いいえ | フィールドの説明 |
| `enum` | 配列 | いいえ | 列挙値のリスト（typeがstringの場合） |
| `example` | 任意のタイプ | いいえ | 例の値 |
| `nullable` | ブール値 | いいえ | nullを許可するかどうか |
| `format` | 文字列 | いいえ | 文字列のフォーマット（例：date、date-timeなど） |
| `items` | オブジェクト | いいえ | 配列項目のスキーマ（typeがarrayの場合） |
| `properties` | オブジェクト | いいえ | オブジェクトプロパティのスキーママッピング（typeがobjectの場合） |
| `required` | 配列 | いいえ | 必須プロパティの名前リスト |
| `minimum` | 数値 | いいえ | 数値の最小値 |
| `maximum` | 数値 | いいえ | 数値の最大値 |
| `minItems` | 整数 | いいえ | 配列の最小長 |
| `maxItems` | 整数 | いいえ | 配列の最大長 |
| `minLength` | 整数 | いいえ | 文字列の最小長 |
| `maxLength` | 整数 | いいえ | 文字列の最大長 |

**Type 列挙値：**

- `TYPE_UNSPECIFIED`: タイプが未指定
- `STRING`: 文字列タイプ
- `NUMBER`: 数値タイプ
- `INTEGER`: 整数タイプ
- `BOOLEAN`: ブールタイプ
- `ARRAY`: 配列タイプ
- `OBJECT`: オブジェクトタイプ

**サポートされているプログラミング言語（ExecutableCode）：**

- `LANGUAGE_UNSPECIFIED`: 言語が未指定
- `PYTHON`: Pythonプログラミング言語

**コード実行結果列挙（Outcome）：**

- `OUTCOME_UNSPECIFIED`: 結果が未指定
- `OUTCOME_OK`: コード実行成功
- `OUTCOME_FAILED`: コード実行失敗
- `OUTCOME_DEADLINE_EXCEEDED`: コード実行タイムアウト

#### `cachedContent`

- タイプ：文字列
- 必須：いいえ

予測を提供するコンテキストとして使用される、キャッシュされたコンテンツの名前。フォーマット：`cachedContents/{cachedContent}`

## 📥 レスポンス

### GenerateContentResponse

複数の候補回答をサポートするモデルからの応答。プロンプトと各候補について、安全評価とコンテンツフィルタリングが報告されます。

#### `candidates`

- タイプ：配列
- 説明：モデルの候補回答のリスト

**Candidate オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `content` | オブジェクト | モデルから返された生成コンテンツ |
| `finishReason` | 列挙型 | モデルがトークンの生成を停止した理由 |
| `safetyRatings` | 配列 | 候補回答の安全性の評価リスト |
| `citationMetadata` | オブジェクト | モデルが生成した候補の引用情報 |
| `tokenCount` | 整数 | この候補のトークン数 |
| `groundingAttributions` | 配列 | 根拠のある回答を生成するために参照されたソースの提供元情報 |
| `groundingMetadata` | オブジェクト | 候補オブジェクトの参照メタデータ |
| `avgLogprobs` | 数値 | 候補の平均対数確率スコア |
| `logprobsResult` | オブジェクト | 回答トークンと先行トークンの対数尤度スコア |
| `urlRetrievalMetadata` | オブジェクト | URLコンテキスト取得ツールに関連するメタデータ |
| `urlContextMetadata` | オブジェクト | URLコンテキスト取得ツールに関連するメタデータ |
| `index` | 整数 | 応答候補リストにおける候補のインデックス |

**FinishReason 列挙値：**

- `STOP`: モデルの自然な停止点または提供された停止シーケンス
- `MAX_TOKENS`: リクエストで指定されたトークン数の上限に達した
- `SAFETY`: 安全上の理由により、応答候補がフラグ付けされた
- `RECITATION`: 暗唱の理由により、応答候補がフラグ付けされた
- `LANGUAGE`: サポートされていない言語の使用により、応答候補がフラグ付けされた
- `OTHER`: 原因不明
- `BLOCKLIST`: コンテンツに禁止用語が含まれているため、トークン生成操作が停止した
- `PROHIBITED_CONTENT`: 禁止されているコンテンツが含まれる可能性があるため、トークン生成操作が停止した
- `SPII`: コンテンツに機密性の高い個人識別情報が含まれる可能性があるため、トークン生成操作が停止した
- `MALFORMED_FUNCTION_CALL`: モデルが生成した関数呼び出しが無効
- `IMAGE_SAFETY`: 生成された画像が安全規定に違反したため、トークン生成が停止した

#### `promptFeedback`

- タイプ：オブジェクト
- 説明：コンテンツフィルターに関連するプロンプトフィードバック

**PromptFeedback オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `blockReason` | 列挙型 | このプロンプトがブロックされた理由 |
| `safetyRatings` | 配列 | 問題の安全性の評価 |

**BlockReason 列挙値：**

- `BLOCK_REASON_UNSPECIFIED`: デフォルト値。この値は使用されません
- `SAFETY`: 安全上の理由により、システムがプロンプトをブロックした
- `OTHER`: 不明な理由によりプロンプトがブロックされた
- `BLOCKLIST`: 用語ブロックリストに含まれる用語が含まれているため、システムがこのプロンプトをブロックした
- `PROHIBITED_CONTENT`: 禁止されているコンテンツが含まれているため、システムがこのプロンプトをブロックした
- `IMAGE_SAFETY`: 安全でないコンテンツが生成されたため、候補画像がブロックされた

#### `usageMetadata`

- タイプ：オブジェクト
- 説明：生成リクエストのトークン使用量に関するメタデータ

**UsageMetadata オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `promptTokenCount` | 整数 | プロンプト内のトークン数 |
| `cachedContentTokenCount` | 整数 | プロンプトのキャッシュ部分に含まれるトークン数 |
| `candidatesTokenCount` | 整数 | すべての生成された候補回答におけるトークンの合計数 |
| `totalTokenCount` | 整数 | 生成リクエストの合計トークン数 |
| `toolUsePromptTokenCount` | 整数 | ツール使用プロンプト内のトークン数 |
| `thoughtsTokenCount` | 整数 | 思考モデルの思考トークン数 |
| `promptTokensDetails` | 配列 | リクエスト入力で処理されたモダリティのリスト |
| `candidatesTokensDetails` | 配列 | 応答で返されたモダリティのリスト |
| `cacheTokensDetails` | 配列 | リクエスト入力でキャッシュされたコンテンツのモダリティのリスト |
| `toolUsePromptTokensDetails` | 配列 | ツール使用リクエスト入力のために処理されたモダリティのリスト |

#### `modelVersion`

- タイプ：文字列
- 説明：回答の生成に使用されたモデルバージョン

#### `responseId`

- タイプ：文字列
- 説明：各応答を識別するためのID

#### 完全な応答例

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "你好！我是 Gemini，一个由 Google 开发的人工智能助手。我可以帮助您解答问题、提供信息、协助写作、代码编程等多种任务。请告诉我有什么可以为您效劳的！"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP",
      "index": 0,
      "safetyRatings": [
        {
          "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
          "probability": "NEGLIGIBLE",
          "blocked": false
        },
        {
          "category": "HARM_CATEGORY_HATE_SPEECH", 
          "probability": "NEGLIGIBLE",
          "blocked": false
        },
        {
          "category": "HARM_CATEGORY_HARASSMENT",
          "probability": "NEGLIGIBLE",
          "blocked": false
        },
        {
          "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
          "probability": "NEGLIGIBLE",
          "blocked": false
        }
      ],
      "tokenCount": 47
    }
  ],
  "promptFeedback": {
    "safetyRatings": [
      {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        "probability": "NEGLIGIBLE"
      },
      {
        "category": "HARM_CATEGORY_HATE_SPEECH",
        "probability": "NEGLIGIBLE"
      }
    ]
  },
  "usageMetadata": {
    "promptTokenCount": 4,
    "candidatesTokenCount": 47,
    "totalTokenCount": 51,
    "promptTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 4
      }
    ],
    "candidatesTokensDetails": [
      {
        "modality": "TEXT", 
        "tokenCount": 47
      }
    ]
  },
  "modelVersion": "gemini-2.0-flash",
  "responseId": "response-12345"
}
```

## 🔧 高度な機能

### 安全評価

**SafetyRating オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `category` | 列挙型 | この評価のカテゴリ |
| `probability` | 列挙型 | このコンテンツの有害確率 |
| `blocked` | ブール値 | このコンテンツがこの評価によりブロックされたかどうか |

**HarmProbability 列挙値：**

- `NEGLIGIBLE`: コンテンツが安全でない確率が無視できる程度
- `LOW`: コンテンツが安全でない確率が低い
- `MEDIUM`: コンテンツが安全でない確率が中程度
- `HIGH`: コンテンツが安全でない確率が高い

### 引用メタデータ

**CitationMetadata オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `citationSources` | 配列 | 特定の応答のソース引用 |

**CitationSource オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `startIndex` | 整数 | このソースに帰属する応答フラグメントの開始インデックス |
| `endIndex` | 整数 | 帰属セグメントの終了インデックス（排他的） |
| `uri` | 文字列 | テキスト部分のソースとして帰属するURI |
| `license` | 文字列 | フラグメントのソースとして帰属するGitHubプロジェクトのライセンス |

### コード実行

コード実行ツールが有効になっている場合、モデルは問題を解決するためにコードを生成および実行できます。

**コード実行の応答例：**

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "我来计算斐波那契数列的第10项："
          },
          {
            "executableCode": {
              "language": "PYTHON",
              "code": "def fibonacci(n):\n    if n <= 1:\n        return n\n    else:\n        return fibonacci(n-1) + fibonacci(n-2)\n\nresult = fibonacci(10)\nprint(f'第10项斐波那契数是: {result}')"
            }
          },
          {
            "codeExecutionResult": {
              "outcome": "OK",
              "output": "第10项斐波那契数是: 55"
            }
          },
          {
            "text": "所以斐波那契数列的第10项是55。"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP"
    }
  ]
}
```

### 接地機能 (Grounding)

**GroundingMetadata オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `groundingChunks` | 配列 | 指定された接地ソースから取得されたサポート参照のリスト |
| `groundingSupports` | 配列 | 接地サポートのリスト |
| `webSearchQueries` | 配列 | 後続のウェブ検索に使用されるウェブ検索クエリ |
| `searchEntryPoint` | オブジェクト | 後続のウェブ検索のためのGoogle検索エントリ |
| `retrievalMetadata` | オブジェクト | ベンチマークプロセスにおける取得に関連するメタデータ |

**GroundingAttribution オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `sourceId` | オブジェクト | この帰属に貢献したソースの識別子 |
| `content` | オブジェクト | この帰属を構成するソースコンテンツ |

**AttributionSourceId オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `groundingPassage` | オブジェクト | インライン段落の識別子 |
| `semanticRetrieverChunk` | オブジェクト | Semantic Retriever によって抽出されたチャンクの識別子 |

**GroundingPassageId オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `passageId` | 文字列 | GenerateAnswerRequest の GroundingPassage.id に一致する段落のID |
| `partIndex` | 整数 | GenerateAnswerRequest の GroundingPassage.content 内のパーツのインデックス |

**SemanticRetrieverChunk オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `source` | 文字列 | リクエストの SemanticRetrieverConfig.source に一致するソース名 |
| `chunk` | 文字列 | 帰属テキストを含むチャンクの名前 |

**SearchEntryPoint オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `renderedContent` | 文字列 | ウェブページまたはアプリの WebView に埋め込み可能なウェブコンテンツのスニペットコード |
| `sdkBlob` | 文字列 | 検索語と検索URLタプルの配列を表す base64 エンコードされた JSON |

**Segment オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `partIndex` | 整数 | Part オブジェクトがその親 Content オブジェクト内にあるインデックス |
| `startIndex` | 整数 | 指定されたパーツ内の開始インデックス（バイト単位） |
| `endIndex` | 整数 | 指定されたチャンク内の終了インデックス（排他的、バイト単位） |
| `text` | 文字列 | 応答内のフラグメントに対応するテキスト |

**RetrievalMetadata オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `googleSearchDynamicRetrievalScore` | 数値 | Google検索の情報が質問への回答に役立つ確率スコア、範囲[0,1] |

**GroundingChunk オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `web` | オブジェクト | ウェブからの接地チャンク |

**Web オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `uri` | 文字列 | チャンクのURI参照 |
| `title` | 文字列 | データブロックのタイトル |

**GroundingSupport オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `groundingChunkIndices` | 配列 | 著作権の主張に関連する引用を指定するためのインデックスのリスト |
| `confidenceScores` | 配列 | サポート参照ドキュメントの信頼度スコア、範囲は0から1 |
| `segment` | オブジェクト | このサポートリクエストが属するコンテンツフラグメント |

### マルチモーダル処理

Gemini API は、多様なモダリティの入出力を処理することをサポートしています：

**サポートされている入力モダリティ：**

- `TEXT`: プレーンテキスト
- `IMAGE`: 画像（JPEG、PNG、WebP、HEIC、HEIF）
- `AUDIO`: 音声（WAV、MP3、AIFF、AAC、OGG、FLAC）
- `VIDEO`: 動画（MP4、MPEG、MOV、AVI、FLV、MPG、WEBM、WMV、3GPP）
- `DOCUMENT`: ドキュメント（PDF）

**ModalityTokenCount オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `modality` | 列挙型 | このトークン数に関連付けられたモダリティ |
| `tokenCount` | 整数 | トークン数 |

**MediaResolution 列挙値：**

- `MEDIA_RESOLUTION_LOW`: 低解像度（64トークン）
- `MEDIA_RESOLUTION_MEDIUM`: 中解像度（256トークン）
- `MEDIA_RESOLUTION_HIGH`: 高解像度（スケーリングとリフレーミングに256トークンを使用）

### 思考機能

**ThinkingConfig オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `includeThoughts` | ブール値 | 回答に思考内容を含めるかどうか |
| `thinkingBudget` | 整数 | モデルが生成すべき思考トークンの数 |

### 音声生成

**SpeechConfig オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `voiceConfig` | オブジェクト | 単一話者出力の構成 |
| `multiSpeakerVoiceConfig` | オブジェクト | 複数話者設定の構成 |
| `languageCode` | 文字列 | 音声合成に使用される言語コード |

**VoiceConfig オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `prebuiltVoiceConfig` | オブジェクト | 使用する事前構築済み音声の構成 |

**PrebuiltVoiceConfig オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `voiceName` | 文字列 | 使用するプリセット音声の名前 |

**MultiSpeakerVoiceConfig オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `speakerVoiceConfigs` | 配列 | 有効化されたすべての話者音声 |

**SpeakerVoiceConfig オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `speaker` | 文字列 | 使用する話者の名前 |
| `voiceConfig` | オブジェクト | 使用する音声の構成 |

**サポートされている言語コード：**

- `zh-CN`: 中国語（簡体字）
- `en-US`: 英語（米国）
- `ja-JP`: 日本語
- `ko-KR`: 韓国語
- `fr-FR`: フランス語
- `de-DE`: ドイツ語
- `es-ES`: スペイン語
- `pt-BR`: ポルトガル語（ブラジル）
- `hi-IN`: ヒンディー語
- `ar-XA`: アラビア語
- `it-IT`: イタリア語
- `tr-TR`: トルコ語
- `vi-VN`: ベトナム語
- `th-TH`: タイ語
- `ru-RU`: ロシア語
- `pl-PL`: ポーランド語
- `nl-NL`: オランダ語

### Logprobs 結果

**LogprobsResult オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `topCandidates` | 配列 | デコードステップの総数に等しい長さ |
| `chosenCandidates` | 配列 | デコードステップの総数に等しい長さ。選択された候補は必ずしも topCandidates に含まれるとは限りません |

**TopCandidates オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `candidates` | 配列 | 対数確率の降順でソートされた候補 |

**Candidate (Logprobs) オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `token` | 文字列 | 候補のトークン文字列値 |
| `tokenId` | 整数 | 候補のトークンID値 |
| `logProbability` | 数値 | 候補の対数確率 |

### URL取得機能

**UrlRetrievalMetadata オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `urlRetrievalContexts` | 配列 | URL取得コンテキストのリスト |

**UrlRetrievalContext オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `retrievedUrl` | 文字列 | ツールが取得したURL |

**UrlContextMetadata オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `urlMetadata` | 配列 | URLコンテキストのリスト |

**UrlMetadata オブジェクトのプロパティ：**

| プロパティ | タイプ | 説明 |
|------|------|------|
| `retrievedUrl` | 文字列 | ツールが取得したURL |
| `urlRetrievalStatus` | 列挙型 | URL取得のステータス |

**UrlRetrievalStatus 列挙値：**

- `URL_RETRIEVAL_STATUS_SUCCESS`: URL取得成功
- `URL_RETRIEVAL_STATUS_ERROR`: エラーによりURL取得失敗

### 完全な安全カテゴリ

**HarmCategory 完全な列挙値：**

- `HARM_CATEGORY_UNSPECIFIED`: カテゴリが未指定
- `HARM_CATEGORY_DEROGATORY`: PaLM - アイデンティティや保護された属性に対する否定的または有害なコメント
- `HARM_CATEGORY_TOXICITY`: PaLM - 失礼、無礼、または冒涜的なコンテンツ
- `HARM_CATEGORY_VIOLENCE`: PaLM - 個人または集団に対する暴力行為を描写するシーン
- `HARM_CATEGORY_SEXUAL`: PaLM - 性的行為またはその他のわいせつな内容への言及を含む
- `HARM_CATEGORY_MEDICAL`: PaLM - 未検証の医療アドバイスを宣伝する
- `HARM_CATEGORY_DANGEROUS`: PaLM - 危険なコンテンツは有害な行動を助長、促進、または奨励する
- `HARM_CATEGORY_HARASSMENT`: Gemini - ハラスメントコンテンツ
- `HARM_CATEGORY_HATE_SPEECH`: Gemini - 憎悪的な発言とコンテンツ
- `HARM_CATEGORY_SEXUALLY_EXPLICIT`: Gemini - 露骨な性的コンテンツ
- `HARM_CATEGORY_DANGEROUS_CONTENT`: Gemini - 危険なコンテンツ
- `HARM_CATEGORY_CIVIC_INTEGRITY`: Gemini - 市民の誠実さを損なう可能性のあるコンテンツ

**HarmProbability 完全な列挙値：**

- `HARM_PROBABILITY_UNSPECIFIED`: 確率が未指定
- `NEGLIGIBLE`: コンテンツが安全でない確率が無視できる程度
- `LOW`: コンテンツが安全でない確率が低い
- `MEDIUM`: コンテンツが安全でない確率が中程度
- `HIGH`: コンテンツが安全でない確率が高い

**Modality 完全な列挙値：**

- `MODALITY_UNSPECIFIED`: モダリティが未指定
- `TEXT`: プレーンテキスト
- `IMAGE`: 画像
- `VIDEO`: 動画
- ``AUDIO`: 音声
- `DOCUMENT`: ドキュメント、例：PDF

**MediaResolution 完全な列挙値：**

- `MEDIA_RESOLUTION_UNSPECIFIED`: メディア解像度が未設定
- `MEDIA_RESOLUTION_LOW`: メディア解像度が低に設定（64トークン）
- `MEDIA_RESOLUTION_MEDIUM`: メディア解像度が中に設定（256トークン）
- `MEDIA_RESOLUTION_HIGH`: メディア解像度が高に設定（スケーリングとリフレーミングに256トークンを使用）

**UrlRetrievalStatus 完全な列挙値：**

- `URL_RETRIEVAL_STATUS_UNSPECIFIED`: デフォルト値。この値は使用されません
- `URL_RETRIEVAL_STATUS_SUCCESS`: URL取得成功
- `URL_RETRIEVAL_STATUS_ERROR`: エラーによりURL取得失敗

## 🔍 エラー処理

### 一般的なエラーコード

| エラーコード | 説明 |
|--------|------|
| `400` | リクエストのフォーマットエラーまたはパラメータが無効 |
| `401` | APIキーが無効または不足 |
| `403` | 権限不足またはクォータ制限 |
| `429` | リクエスト頻度が高すぎる |
| `500` | サーバー内部エラー |

### 詳細なエラーコードの説明

| エラーコード | ステータス | 説明 | 解決策 |
|--------|------|------|----------|
| `400` | `INVALID_ARGUMENT` | リクエストパラメータが無効またはフォーマットエラーです | リクエストパラメータのフォーマットと必須フィールドを確認してください |
| `400` | `FAILED_PRECONDITION` | リクエストの前提条件が満たされていません | API呼び出しの前提条件が満たされていることを確認してください |
| `401` | `UNAUTHENTICATED` | APIキーが無効、不足、または期限切れです | APIキーの有効性とフォーマットを確認してください |
| `403` | `PERMISSION_DENIED` | 権限不足またはクォータが使い果たされました | APIキーの権限を確認するか、クォータをアップグレードしてください |
| `404` | `NOT_FOUND` | 指定されたモデルまたはリソースが存在しません | モデル名とリソースパスを検証してください |
| `413` | `PAYLOAD_TOO_LARGE` | リクエストボディが大きすぎます | 入力コンテンツのサイズを減らすか、バッチ処理を行ってください |
| `429` | `RESOURCE_EXHAUSTED` | リクエスト頻度が制限を超過したか、クォータが不足しています | リクエスト頻度を下げるか、クォータのリセットを待ってください |
| `500` | `INTERNAL` | サーバー内部エラー | リクエストを再試行してください。継続する場合はサポートに連絡してください |
| `503` | `UNAVAILABLE` | サービスが一時的に利用できません | しばらく待ってから再試行してください |
| `504` | `DEADLINE_EXCEEDED` | リクエストがタイムアウトしました | 入力サイズを減らすか、リクエストを再試行してください |

### エラー応答例

```json
{
  "error": {
    "code": 400,
    "message": "Invalid argument: contents",
    "status": "INVALID_ARGUMENT",
    "details": [
      {
        "@type": "type.googleapis.com/google.rpc.BadRequest",
        "fieldViolations": [
          {
            "field": "contents",
            "description": "contents is required"
          }
        ]
      }
    ]
  }
}
```
# Google Gemini 対話フォーマット（Generate Content）

!!! info "公式ドキュメント"
    [Google Gemini Generating content API](https://ai.google.dev/api/generate-content)

## 📝 概要

Google Gemini API は、画像、音声、コード、ツールなどを使用してコンテンツの生成をサポートしています。入力 GenerateContentRequest を指定してモデル応答を生成します。テキスト生成、視覚理解、音声処理、長コンテキスト、コード実行、JSONモード、関数呼び出しなど、多様な機能をサポートしています。

## 💡 リクエスト例

### 基本テキスト対話 ✅

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

!!! warning "ファイルアップロード制限"
    `inline_data` を介した base64 方式での音声アップロードのみをサポートしており、`file_data.file_uri` や File API はサポートしていません。

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

!!! warning "ファイルアップロード制限"
    `inline_data` を介した base64 方式での動画アップロードのみをサポートしており、`file_data.file_uri` や File API はサポートしていません。

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

!!! warning "ファイルアップロード制限"
    `inline_data` を介した base64 方式での PDF アップロードのみをサポートしており、`file_data.file_uri` や File API はサポートしていません。

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

### 生成設定 ✅

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

#### コンテンツ生成
```
POST https://你的newapi服务器地址/v1beta/{model=models/*}:generateContent
```

#### ストリーミングコンテンツ生成
```
POST https://你的newapi服务器地址/v1beta/{model=models/*}:streamGenerateContent
```

### 認証方法

リクエストURLパラメータにAPIキーを含めます：

```
?key=$NEWAPI_API_KEY
```

ここで `$NEWAPI_API_KEY` はあなたの Google AI API キーです。

### パスパラメータ

#### `model`

- 型：文字列
- 必須：はい

補完を生成するために使用されるモデル名。

形式：`models/{model}`、例：`models/gemini-2.0-flash`

### リクエストボディパラメータ

#### `contents`

- 型：配列
- 必須：はい

モデルとの現在の対話内容。単一のターンクエリの場合、これは単一のインスタンスです。チャットなどのマルチターンクエリの場合、これは対話履歴と最新のリクエストを含む繰り返しフィールドです。

**Content オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `parts` | 配列 | はい | 単一のメッセージを構成する、順序付けられたコンテンツ部分 |
| `role` | 文字列 | いいえ | 対話におけるコンテンツの生成者。`user`、`model`、`function` または `tool` |

**Part オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `text` | 文字列 | いいえ | プレーンテキストコンテンツ |
| `inlineData` | オブジェクト | いいえ | インラインメディアバイトデータ |
| `fileData` | オブジェクト | いいえ | アップロードされたファイルのURI参照 |
| `functionCall` | オブジェクト | いいえ | 関数呼び出しリクエスト |
| `functionResponse` | オブジェクト | いいえ | 関数呼び出し応答 |
| `executableCode` | オブジェクト | いいえ | 実行可能コード |
| `codeExecutionResult` | オブジェクト | いいえ | コード実行結果 |

**InlineData オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `mimeType` | 文字列 | はい | メディアのMIMEタイプ |
| `data` | 文字列 | はい | base64エンコードされたメディアデータ |

**FileData オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `mimeType` | 文字列 | はい | ファイルのMIMEタイプ |
| `fileUri` | 文字列 | はい | ファイルのURI |

#### `tools`

- 型：配列
- 必須：いいえ

モデルが次の応答を生成するために使用できるツールのリスト。サポートされているツールには、関数とコード実行が含まれます。

**Tool オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `functionDeclarations` | 配列 | いいえ | オプションの関数宣言リスト |
| `codeExecution` | オブジェクト | いいえ | モデルによるコード実行を有効にする |

**FunctionDeclaration オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `name` | 文字列 | はい | 関数名称 |
| `description` | 文字列 | いいえ | 関数の機能の説明 |
| `parameters` | オブジェクト | いいえ | 関数パラメータ、JSON Schema形式 |

**FunctionCall オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `name` | 文字列 | はい | 呼び出す関数名 |
| `args` | オブジェクト | いいえ | 関数パラメータのキーと値のペア |

**FunctionResponse オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `name` | 文字列 | はい | 呼び出された関数名 |
| `response` | オブジェクト | はい | 関数呼び出しの応答データ |

**ExecutableCode オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `language` | 列挙型 | はい | コードのプログラミング言語 |
| `code` | 文字列 | はい | 実行するコード |

**CodeExecutionResult オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `outcome` | 列挙型 | はい | コード実行の結果ステータス |
| `output` | 文字列 | いいえ | コード実行の出力内容 |

**CodeExecution オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| {} | 空オブジェクト | - | コード実行機能を有効にするための空の構成オブジェクト |

#### `toolConfig`

- 型：オブジェクト
- 必須：いいえ

リクエストで指定された任意のツールのツール構成。

**ToolConfig オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `functionCallingConfig` | オブジェクト | いいえ | 関数呼び出し構成 |

**FunctionCallingConfig オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `mode` | 列挙型 | いいえ | 関数呼び出しのモードを指定 |
| `allowedFunctionNames` | 配列 | いいえ | 呼び出しが許可される関数名のリスト |

**FunctionCallingMode 列挙値：**

- `MODE_UNSPECIFIED`: デフォルトモード。モデルが関数を呼び出すかどうかを決定します
- `AUTO`: モデルが関数を呼び出すタイミングを自動的に決定します
- `ANY`: モデルは関数を呼び出す必要があります
- `NONE`: モデルは関数を呼び出すことができません

#### `safetySettings`

- 型：配列
- 必須：いいえ

安全でないコンテンツをブロックするために使用される SafetySetting インスタンスのリスト。

**SafetySetting オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `category` | 列挙型 | はい | 安全カテゴリ |
| `threshold` | 列挙型 | はい | ブロックしきい値 |

**HarmCategory 列挙値：**

- `HARM_CATEGORY_HARASSMENT`: ハラスメントコンテンツ
- `HARM_CATEGORY_HATE_SPEECH`: ヘイトスピーチおよびコンテンツ
- `HARM_CATEGORY_SEXUALLY_EXPLICIT`: 露骨な性的コンテンツ
- `HARM_CATEGORY_DANGEROUS_CONTENT`: 危険なコンテンツ
- `HARM_CATEGORY_CIVIC_INTEGRITY`: 市民の誠実さを損なうために使用される可能性のあるコンテンツ

**HarmBlockThreshold 列挙値：**

- `BLOCK_LOW_AND_ABOVE`: NEGLIGIBLE と評価されたコンテンツの公開を許可します
- `BLOCK_MEDIUM_AND_ABOVE`: NEGLIGIBLE および LOW と評価されたコンテンツの公開を許可します
- `BLOCK_ONLY_HIGH`: リスクレベルが NEGLIGIBLE、LOW、および MEDIUM のコンテンツの公開を許可します
- `BLOCK_NONE`: すべてのコンテンツを許可します
- `OFF`: 安全フィルターをオフにします

**HarmBlockThreshold 完全な列挙値：**

- `HARM_BLOCK_THRESHOLD_UNSPECIFIED`: しきい値が指定されていません
- `BLOCK_LOW_AND_ABOVE`: 低確率以上の有害コンテンツをブロックし、NEGLIGIBLE レベルのコンテンツのみを許可します
- `BLOCK_MEDIUM_AND_ABOVE`: 中確率以上の有害コンテンツをブロックし、NEGLIGIBLE および LOW レベルのコンテンツを許可します
- `BLOCK_ONLY_HIGH`: 高確率の有害コンテンツのみをブロックし、NEGLIGIBLE、LOW、および MEDIUM レベルのコンテンツを許可します
- `BLOCK_NONE`: いかなるコンテンツもブロックせず、すべてのレベルのコンテンツを許可します
- `OFF`: 安全フィルターを完全にオフにします

#### `systemInstruction`

- 型：オブジェクト（Content）
- 必須：いいえ

開発者が設定するシステム指示。現在、テキストのみをサポートしています。

#### `generationConfig`

- 型：オブジェクト
- 必須：いいえ

モデルの生成と出力のための構成オプション。

**GenerationConfig オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `stopSequences` | 配列 | いいえ | 出力の生成を停止するために使用される文字シーケンスのセット（最大5つ） |
| `responseMimeType` | 文字列 | いいえ | 生成された候補テキストのMIMEタイプ |
| `responseSchema` | オブジェクト | いいえ | 生成された候補テキストの出力スキーマ |
| `responseModalities` | 配列 | いいえ | リクエストされた応答モダリティ |
| `candidateCount` | 整数 | いいえ | 返される生成された回答の数 |
| `maxOutputTokens` | 整数 | いいえ | 候補回答に含まれるトークン数の上限 |
| `temperature` | 数字 | いいえ | 出力のランダム性を制御します。範囲は [0.0, 2.0] |
| `topP` | 数字 | いいえ | サンプリング時に考慮されるトークンの累積確率の上限 |
| `topK` | 整数 | いいえ | サンプリング時に考慮されるトークン数の上限 |
| `seed` | 整数 | いいえ | デコードに使用されるシード |
| `presencePenalty` | 数字 | いいえ | 存在ペナルティ |
| `frequencyPenalty` | 数字 | いいえ | 頻度ペナルティ |
| `responseLogprobs` | ブール値 | いいえ | 応答に logprobs の結果をエクスポートするかどうか |
| `logprobs` | 整数 | いいえ | 返されるトップ logprob の数 |
| `enableEnhancedCivicAnswers` | ブール値 | いいえ | 拡張された市民サービス回答を有効にする |
| `speechConfig` | オブジェクト | いいえ | 音声生成構成 |
| `thinkingConfig` | オブジェクト | いいえ | 思考機能の構成 |
| `mediaResolution` | 列挙型 | いいえ | 指定されたメディア解像度 |

**サポートされている MIME タイプ：**

- `text/plain`: （デフォルト）テキスト出力
- `application/json`: JSON応答
- `text/x.enum`: 文字列としてのENUM応答

**Modality 列挙値：**

- `TEXT`: モデルがテキストを返す必要があることを示します
- `IMAGE`: モデルが画像を返す必要があることを示します
- `AUDIO`: モデルが音声を返す必要があることを示します

**Schema オブジェクトのプロパティ：**

| プロパティ | 型 | 必須 | 説明 |
|------|------|------|------|
| `type` | 列挙型 | はい | データ型 |
| `description` | 文字列 | いいえ | フィールドの説明 |
| `enum` | 配列 | いいえ | 列挙値のリスト（typeがstringの場合） |
| `example` | 任意型 | いいえ | サンプル値 |
| `nullable` | ブール値 | いいえ | nullを許可するかどうか |
| `format` | 文字列 | いいえ | 文字列形式（date、date-timeなど） |
| `items` | オブジェクト | いいえ | 配列項目のスキーマ（typeがarrayの場合） |
| `properties` | オブジェクト | いいえ | オブジェクトプロパティのスキーママッピング（typeがobjectの場合） |
| `required` | 配列 | いいえ | 必須プロパティ名のリスト |
| `minimum` | 数字 | いいえ | 数値の最小値 |
| `maximum` | 数字 | いいえ | 数値の最大値 |
| `minItems` | 整数 | いいえ | 配列の最小長 |
| `maxItems` | 整数 | いいえ | 配列の最大長 |
| `minLength` | 整数 | いいえ | 文字列の最小長 |
| `maxLength` | 整数 | いいえ | 文字列の最大長 |

**Type 列挙値：**

- `TYPE_UNSPECIFIED`: 型が指定されていません
- `STRING`: 文字列型
- `NUMBER`: 数値型
- `INTEGER`: 整数型
- `BOOLEAN`: ブール型
- `ARRAY`: 配列型
- `OBJECT`: オブジェクト型

**サポートされているプログラミング言語（ExecutableCode）：**

- `LANGUAGE_UNSPECIFIED`: 言語が指定されていません
- `PYTHON`: Pythonプログラミング言語

**コード実行結果列挙型（Outcome）：**

- `OUTCOME_UNSPECIFIED`: 結果が指定されていません
- `OUTCOME_OK`: コード実行成功
- `OUTCOME_FAILED`: コード実行失敗
- `OUTCOME_DEADLINE_EXCEEDED`: コード実行タイムアウト

#### `cachedContent`

- 型：文字列
- 必須：いいえ

予測を提供するコンテキストとして使用される、キャッシュされたコンテンツの名前。形式：`cachedContents/{cachedContent}`

## 📥 応答

### GenerateContentResponse

複数の候補回答をサポートするモデルからの回答。プロンプトと各候補について、安全評価とコンテンツフィルタリングが報告されます。

#### `candidates`

- 型：配列
- 説明：モデルの候補回答リスト

**Candidate オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `content` | オブジェクト | モデルが返した生成コンテンツ |
| `finishReason` | 列挙型 | モデルがトークンの生成を停止した理由 |
| `safetyRatings` | 配列 | 候補回答の安全性に関する評価リスト |
| `citationMetadata` | オブジェクト | モデルが生成した候補の引用情報 |
| `tokenCount` | 整数 | この候補のトークン数 |
| `groundingAttributions` | 配列 | 根拠のある回答を生成するために参照されたソースの提供者情報 |
| `groundingMetadata` | オブジェクト | 候補オブジェクトの参照メタデータ |
| `avgLogprobs` | 数字 | 候補の平均対数確率スコア |
| `logprobsResult` | オブジェクト | 回答トークンと先行トークンの対数尤度スコア |
| `urlRetrievalMetadata` | オブジェクト | URLコンテキスト取得ツールに関連するメタデータ |
| `urlContextMetadata` | オブジェクト | URLコンテキスト取得ツールに関連するメタデータ |
| `index` | 整数 | 応答候補リストにおける候補のインデックス |

**FinishReason 列挙値：**

- `STOP`: モデルの自然な停止点または提供された停止シーケンス
- `MAX_TOKENS`: リクエストで指定されたトークン数の上限に達しました
- `SAFETY`: 安全上の理由により、回答候補がシステムによってフラグ付けされました
- `RECITATION`: 暗唱（Recitation）が原因で、回答候補がフラグ付けされました
- `LANGUAGE`: サポートされていない言語の使用が原因で、回答候補がフラグ付けされました
- `OTHER`: 原因不明
- `BLOCKLIST`: コンテンツに禁止用語が含まれているため、トークン生成操作が停止されました
- `PROHIBITED_CONTENT`: 禁止されたコンテンツが含まれる可能性があるため、トークン生成操作が停止されました
- `SPII`: コンテンツに機密性の高い個人識別情報が含まれる可能性があるため、トークン生成操作が停止されました
- `MALFORMED_FUNCTION_CALL`: モデルが生成した関数呼び出しが無効です
- `IMAGE_SAFETY`: 生成された画像が安全規定に違反したため、トークン生成が停止されました

#### `promptFeedback`

- 型：オブジェクト
- 説明：コンテンツフィルターに関連するプロンプトフィードバック

**PromptFeedback オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `blockReason` | 列挙型 | このプロンプトがブロックされた理由 |
| `safetyRatings` | 配列 | 質問の安全性に関する評価 |

**BlockReason 列挙値：**

- `BLOCK_REASON_UNSPECIFIED`: デフォルト値。この値は使用されません
- `SAFETY`: 安全上の理由により、システムがプロンプトをブロックしました
- `OTHER`: プロンプトが不明な理由でブロックされました
- `BLOCKLIST`: 用語ブロックリストに含まれる用語が含まれているため、システムがこのプロンプトをブロックしました
- `PROHIBITED_CONTENT`: 禁止されたコンテンツが含まれているため、システムがこのプロンプトをブロックしました
- `IMAGE_SAFETY`: 候補画像が安全でないコンテンツを生成したためブロックされました

#### `usageMetadata`

- 型：オブジェクト
- 説明：生成リクエストのトークン使用量に関するメタデータ

**UsageMetadata オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `promptTokenCount` | 整数 | プロンプト内のトークン数 |
| `cachedContentTokenCount` | 整数 | プロンプトのキャッシュ部分内のトークン数 |
| `candidatesTokenCount` | 整数 | 生成されたすべての候補回答におけるトークンの合計数 |
| `totalTokenCount` | 整数 | 生成リクエストの総トークン数 |
| `toolUsePromptTokenCount` | 整数 | ツール使用プロンプト内のトークン数 |
| `thoughtsTokenCount` | 整数 | 思考モデルの思考トークン数 |
| `promptTokensDetails` | 配列 | リクエスト入力で処理されたモダリティのリスト |
| `candidatesTokensDetails` | 配列 | 応答で返されたモダリティのリスト |
| `cacheTokensDetails` | 配列 | リクエスト入力におけるキャッシュされたコンテンツのモダリティのリスト |
| `toolUsePromptTokensDetails` | 配列 | ツール使用リクエスト入力のために処理されたモダリティのリスト |

#### `modelVersion`

- 型：文字列
- 説明：回答の生成に使用されたモデルバージョン

#### `responseId`

- 型：文字列
- 説明：各応答を識別するためのID

#### 完全な応答例

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "こんにちは！私は Gemini、Google が開発した AI アシスタントです。質問への回答、情報の提供、ライティングの支援、コードプログラミングなど、さまざまなタスクをお手伝いできます。何かお役に立てることがあれば教えてください！"
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

| プロパティ | 型 | 説明 |
|------|------|------|
| `category` | 列挙型 | この評価のカテゴリ |
| `probability` | 列挙型 | このコンテンツの有害性の確率 |
| `blocked` | ブール値 | このコンテンツがこの評価によってブロックされたかどうか |

**HarmProbability 列挙値：**

- `NEGLIGIBLE`: コンテンツが安全でない確率は無視できる程度です
- `LOW`: コンテンツが安全でない確率は低いです
- `MEDIUM`: コンテンツが安全でない確率は中程度です
- `HIGH`: コンテンツが安全でない確率は高いです

### 引用メタデータ

**CitationMetadata オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `citationSources` | 配列 | 特定の応答のソース引用 |

**CitationSource オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `startIndex` | 整数 | このソースに帰属する応答セグメントの開始インデックス |
| `endIndex` | 整数 | 帰属セグメントの終了インデックス（排他的） |
| `uri` | 文字列 | テキスト部分のソースとして帰属するURI |
| `license` | 文字列 | セグメントのソースとして帰属するGitHubプロジェクトのライセンス |

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
            "text": "フィボナッチ数列の第10項を計算します："
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
            "text": "したがって、フィボナッチ数列の第10項は55です。"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP"
    }
  ]
}
```

### グラウンディング機能 (Grounding)

**GroundingMetadata オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `groundingChunks` | 配列 | 指定されたグラウンディングソースから取得されたサポート参照のリスト |
| `groundingSupports` | 配列 | グラウンディングサポートのリスト |
| `webSearchQueries` | 配列 | 後続のウェブ検索に使用されるウェブ検索クエリ |
| `searchEntryPoint` | オブジェクト | 後続のウェブ検索のためのGoogle検索エントリ |
| `retrievalMetadata` | オブジェクト | ベンチマークプロセスにおける取得に関連するメタデータ |

**GroundingAttribution オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `sourceId` | オブジェクト | この帰属に貢献したソースの識別子 |
| `content` | オブジェクト | この帰属を構成するソースコンテンツ |

**AttributionSourceId オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `groundingPassage` | オブジェクト | インライン段落の識別子 |
| `semanticRetrieverChunk` | オブジェクト | Semantic Retrieverによって抽出されたチャンクの識別子 |

**GroundingPassageId オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `passageId` | 文字列 | GenerateAnswerRequestのGroundingPassage.idに一致する段落のID |
| `partIndex` | 整数 | GenerateAnswerRequestのGroundingPassage.content内の部分のインデックス |

**SemanticRetrieverChunk オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `source` | 文字列 | リクエストのSemanticRetrieverConfig.sourceに一致するソース名 |
| `chunk` | 文字列 | 帰属テキストを含むチャンクの名前 |

**SearchEntryPoint オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `renderedContent` | 文字列 | ウェブページまたはアプリケーションのWebViewに埋め込み可能なウェブコンテンツのスニペット |
| `sdkBlob` | 文字列 | 検索語と検索URLタプルの配列を表すbase64エンコードされたJSON |

**Segment オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `partIndex` | 整数 | Partオブジェクトがその親Contentオブジェクト内にあるインデックス |
| `startIndex` | 整数 | 指定されたpart内の開始インデックス（バイト単位） |
| `endIndex` | 整数 | 指定されたチャンク内の終了インデックス（排他的、バイト単位） |
| `text` | 文字列 | 応答内のセグメントに対応するテキスト |

**RetrievalMetadata オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `googleSearchDynamicRetrievalScore` | 数字 | Google検索の情報が質問への回答に役立つ確率スコア。範囲は [0, 1] |

**GroundingChunk オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `web` | オブジェクト | ウェブからのグラウンディングチャンク |

**Web オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `uri` | 文字列 | チャンクのURI参照 |
| `title` | 文字列 | データチャンクのタイトル |

**GroundingSupport オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `groundingChunkIndices` | 配列 | 著作権主張に関連する引用を指定するためのインデックスのリスト |
| `confidenceScores` | 配列 | 参照ドキュメントをサポートする信頼度スコア。範囲は0から1 |
| `segment` | オブジェクト | このサポートリクエストが属するコンテンツセグメント |

### マルチモーダル処理

Gemini API は、複数のモダリティの入力と出力を処理することをサポートしています：

**サポートされている入力モダリティ：**

- `TEXT`: プレーンテキスト
- `IMAGE`: 画像（JPEG、PNG、WebP、HEIC、HEIF）
- `AUDIO`: 音声（WAV、MP3、AIFF、AAC、OGG、FLAC）
- `VIDEO`: 動画（MP4、MPEG、MOV、AVI、FLV、MPG、WEBM、WMV、3GPP）
- `DOCUMENT`: ドキュメント（PDF）

**ModalityTokenCount オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `modality` | 列挙型 | このトークン数に関連付けられたモダリティ |
| `tokenCount` | 整数 | トークン数量 |

**MediaResolution 列挙値：**

- `MEDIA_RESOLUTION_LOW`: 低解像度（64トークン）
- `MEDIA_RESOLUTION_MEDIUM`: 中解像度（256トークン）
- `MEDIA_RESOLUTION_HIGH`: 高解像度（256トークンを使用してスケーリング再フレーミングを実行）

### 思考機能

**ThinkingConfig オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `includeThoughts` | ブール値 | 回答に思考内容を含めるかどうか |
| `thinkingBudget` | 整数 | モデルが生成すべき思考トークンの数 |

### 音声生成

**SpeechConfig オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `voiceConfig` | オブジェクト | 単一話者出力の構成 |
| `multiSpeakerVoiceConfig` | オブジェクト | 複数話者設定の構成 |
| `languageCode` | 文字列 | 音声合成に使用される言語コード |

**VoiceConfig オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `prebuiltVoiceConfig` | オブジェクト | 使用する事前構築済み音声の構成 |

**PrebuiltVoiceConfig オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `voiceName` | 文字列 | 使用するプリセット音声の名前 |

**MultiSpeakerVoiceConfig オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `speakerVoiceConfigs` | 配列 | 有効になっているすべての話者音声 |

**SpeakerVoiceConfig オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
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

| プロパティ | 型 | 説明 |
|------|------|------|
| `topCandidates` | 配列 | 長さ＝デコードステップの総数 |
| `chosenCandidates` | 配列 | 長さ＝デコードステップの総数。選択された候補は必ずしもtopCandidatesに含まれるわけではありません |

**TopCandidates オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `candidates` | 配列 | 対数確率の降順でソートされた候補 |

**Candidate (Logprobs) オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `token` | 文字列 | 候補のトークン文字列値 |
| `tokenId` | 整数 | 候補のトークンID値 |
| `logProbability` | 数字 | 候補の対数確率 |

### URL取得機能

**UrlRetrievalMetadata オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `urlRetrievalContexts` | 配列 | URL取得コンテキストのリスト |

**UrlRetrievalContext オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `retrievedUrl` | 文字列 | ツールによって取得されたURL |

**UrlContextMetadata オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `urlMetadata` | 配列 | URLコンテキストのリスト |

**UrlMetadata オブジェクトのプロパティ：**

| プロパティ | 型 | 説明 |
|------|------|------|
| `retrievedUrl` | 文字列 | ツールによって取得されたURL |
| `urlRetrievalStatus` | 列挙型 | URL取得のステータス |

**UrlRetrievalStatus 列挙値：**

- `URL_RETRIEVAL_STATUS_SUCCESS`: URL取得成功
- `URL_RETRIEVAL_STATUS_ERROR`: エラーにより、URL取得失敗

### 完全な安全カテゴリ

**HarmCategory 完全な列挙値：**

- `HARM_CATEGORY_UNSPECIFIED`: カテゴリ未指定
- `HARM_CATEGORY_DEROGATORY`: PaLM - IDや保護された属性に対する否定的または有害なコメント
- `HARM_CATEGORY_TOXICITY`: PaLM - 失礼、無礼、または冒涜的なコンテンツ
- `HARM_CATEGORY_VIOLENCE`: PaLM - 個人またはグループに対する暴力行為を描写するシーンを説明する
- `HARM_CATEGORY_SEXUAL`: PaLM - 性的行為またはその他のわいせつなコンテンツへの言及を含む
- `HARM_CATEGORY_MEDICAL`: PaLM - 未検証の医療アドバイスを宣伝する
- `HARM_CATEGORY_DANGEROUS`: PaLM - 危険なコンテンツは、有害な行動を宣伝、助長、または奨励する
- `HARM_CATEGORY_HARASSMENT`: Gemini - ハラスメントコンテンツ
- `HARM_CATEGORY_HATE_SPEECH`: Gemini - ヘイトスピーチおよびコンテンツ
- `HARM_CATEGORY_SEXUALLY_EXPLICIT`: Gemini - 露骨な性的コンテンツ
- `HARM_CATEGORY_DANGEROUS_CONTENT`: Gemini - 危険なコンテンツ
- `HARM_CATEGORY_CIVIC_INTEGRITY`: Gemini - 市民の誠実さを損なうために使用される可能性のあるコンテンツ

**HarmProbability 完全な列挙値：**

- `HARM_PROBABILITY_UNSPECIFIED`: 確率未指定
- `NEGLIGIBLE`: コンテンツが安全でない確率は無視できる程度です
- `LOW`: コンテンツが安全でない確率は低いです
- `MEDIUM`: コンテンツが安全でない確率は中程度です
- `HIGH`: コンテンツが安全でない確率は高いです

**Modality 完全な列挙値：**

- `MODALITY_UNSPECIFIED`: モダリティ未指定
- `TEXT`: プレーンテキスト
- `IMAGE`: 画像
- `VIDEO`: 動画
- `AUDIO`: 音声
- `DOCUMENT`: ドキュメント（PDFなど）

**MediaResolution 完全な列挙値：**

- `MEDIA_RESOLUTION_UNSPECIFIED`: メディア解像度が設定されていません
- `MEDIA_RESOLUTION_LOW`: メディア解像度が低に設定されています（64トークン）
- `MEDIA_RESOLUTION_MEDIUM`: メディア解像度が中に設定されています（256トークン）
- `MEDIA_RESOLUTION_HIGH`: メディア解像度が高に設定されています（256トークンを使用してスケーリング再フレーミングを実行）

**UrlRetrievalStatus 完全な列挙値：**

- `URL_RETRIEVAL_STATUS_UNSPECIFIED`: デフォルト値。この値は使用されません
- `URL_RETRIEVAL_STATUS_SUCCESS`: URL取得成功
- `URL_RETRIEVAL_STATUS_ERROR`: エラーにより、URL取得失敗

## 🔍 エラー処理

### 一般的なエラーコード

| エラーコード | 説明 |
|--------|------|
| `400` | リクエスト形式が不正またはパラメータが無効 |
| `401` | APIキーが無効または不足 |
| `403` | 権限不足またはクォータ制限 |
| `429` | リクエスト頻度が高すぎる |
| `500` | サーバー内部エラー |

### 詳細なエラーコードの説明

| エラーコード | ステータス | 説明 | 解決策 |
|--------|------|------|----------|
| `400` | `INVALID_ARGUMENT` | リクエストパラメータが無効または形式が不正 | リクエストパラメータの形式と必須フィールドを確認してください |
| `400` | `FAILED_PRECONDITION` | リクエストの前提条件が満たされていません | API呼び出しの前提条件が満たされていることを確認してください |
| `401` | `UNAUTHENTICATED` | APIキーが無効、不足、または期限切れです | APIキーの有効性と形式を確認してください |
| `403` | `PERMISSION_DENIED` | 権限不足またはクォータが使い果たされました | APIキーの権限を確認するか、クォータをアップグレードしてください |
| `404` | `NOT_FOUND` | 指定されたモデルまたはリソースが存在しません | モデル名とリソースパスを検証してください |
| `413` | `PAYLOAD_TOO_LARGE` | リクエストボディが大きすぎます | 入力コンテンツのサイズを減らすか、バッチ処理してください |
| `429` | `RESOURCE_EXHAUSTED` | リクエスト頻度が上限を超えているか、クォータが不足しています | リクエスト頻度を下げるか、クォータのリセットを待ってください |
| `500` | `INTERNAL` | サーバー内部エラー | リクエストを再試行してください。継続する場合はサポートに連絡してください |
| `503` | `UNAVAILABLE` | サービスが一時的に利用できません | しばらく待ってから再試行してください |
| `504` | `DEADLINE_EXCEEDED` | リクエストがタイムアウトしました | 入力サイズを減らすか、リクエストを再試行してください |

### エラー応答の例

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
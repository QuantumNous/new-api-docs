# Google Gemini Chat Format (Generate Content)

!!! info "Official Documentation"
    [Google Gemini Generating content API](https://ai.google.dev/api/generate-content)

## 📝 Introduction

Google Gemini API supports generating content using images, audio, code, tools, etc. Given input GenerateContentRequest generates model responses. Supports text generation, visual understanding, audio processing, long context, code execution, JSON schema, function calling, and many other features.

## 💡 Request Examples

### Basic Text Chat ✅

```bash
curl "https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d '{
      "contents": [{
        "parts":[{"text": "Write a story about a magic backpack."}]
        }]
       }' 2> /dev/null
```

### Image Analysis Chat ✅

```bash
# Use temporary file to save base64 encoded image data
TEMP_B64=$(mktemp)
trap 'rm -f "$TEMP_B64"' EXIT
base64 $B64FLAGS $IMG_PATH > "$TEMP_B64"

# Use temporary file to save JSON payload
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

curl "https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d "@$TEMP_JSON" 2> /dev/null
```

### Function Calling ✅

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

curl "https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
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

### JSON Schema Response ✅

```bash
curl "https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
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

### Audio Processing 🟡

!!! warning "File Upload Limitations"
    Only supports uploading audio via `inline_data` in base64 format, does not support `file_data.file_uri` or File API.

```bash
# Use File API to upload audio data to API request
# Use base64 inline_data to upload audio data to API request
if [[ "$(base64 --version 2>&1)" = *"FreeBSD"* ]]; then
  B64FLAGS="--input"
else
  B64FLAGS="-w0"
fi
AUDIO_B64=$(base64 $B64FLAGS "$AUDIO_PATH")

curl "https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
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

### Video Processing 🟡

!!! warning "File Upload Limitations"
    Only supports uploading video via `inline_data` in base64 format, does not support `file_data.file_uri` or File API.

```bash
# Use File API to upload video data to API request
# Use base64 inline_data to upload video data to API request
if [[ "$(base64 --version 2>&1)" = *"FreeBSD"* ]]; then
  B64FLAGS="--input"
else
  B64FLAGS="-w0"
fi
VIDEO_B64=$(base64 $B64FLAGS "$VIDEO_PATH")

curl "https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
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

### PDF Processing 🟡

!!! warning "File Upload Limitations"
    仅支持通过 `inline_data` 以 base64 方式上传 PDF，不支持 `file_data.file_uri` 或 File API。

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

curl "https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
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

### Chat Dialog ✅

```bash
curl https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY \
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

### Streaming Response ✅

```bash
curl "https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:streamGenerateContent?alt=sse&key=$NEWAPI_API_KEY" \
    -H 'Content-Type: application/json' \
    --no-buffer \
    -d '{
      "contents": [{
        "parts": [{"text": "写一个关于魔法背包的故事"}]
      }]
    }'
```

### Code Execution ✅

```bash
curl "https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
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

### Generation Config ✅

```bash
curl https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY \
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

### Safety Settings ✅

```bash
echo '{
    "safetySettings": [
        {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_ONLY_HIGH"},
        {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_MEDIUM_AND_ABOVE"}
    ],
    "contents": [{
        "parts":[{
            "text": "'I support Martians Soccer Club and I think Jupiterians Football Club sucks! Write a ironic phrase about them.'"}]}]}' > request.json

curl "https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d @request.json 2> /dev/null
```

### System Instruction ✅

```bash
curl "https://your-newapi-server-address/v1beta/models/gemini-2.0-flash:generateContent?key=$NEWAPI_API_KEY" \
-H 'Content-Type: application/json' \
-d '{ "system_instruction": {
    "parts":
      { "text": "You are a cat. Your name is Neko."}},
    "contents": {
      "parts": {
        "text": "Hello there"}}}'
```

## 📮 Request

### Endpoints

#### Generate Content
```
POST https://your-newapi-server-address/v1beta/{model=models/*}:generateContent
```

#### Stream Generate Content
```
POST https://your-newapi-server-address/v1beta/{model=models/*}:streamGenerateContent
```

### Authentication Method

Include API key in the request URL:

```
?key=$NEWAPI_API_KEY
```

Where `$NEWAPI_API_KEY` is your Google AI API key.

### Path Parameters

#### `model`

- Type: string
- Required: yes

The name of the model to generate completions for.

Format: `models/{model}`, e.g. `models/gemini-2.0-flash`

### Request Body Parameters

#### `contents`

- Type: array
- Required: yes

The content of the current conversation with the model. For a single-turn query, this is a single instance. For chat-like multi-turn queries, this is a repeated field containing the conversation history and the latest request.

**Content object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `parts` | array | yes | Ordered content parts that make up a single message |
| `role` | string | no | The producer of the content in the conversation. `user`, `model`, `function`, or `tool` |

**Part object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `text` | string | no | Pure text content |
| `inlineData` | object | no | Inline media byte data |
| `fileData` | object | no | URI reference to the uploaded file |
| `functionCall` | object | no | Function call request |
| `functionResponse` | object | no | Function call response |
| `executableCode` | object | no | Executable code |
| `codeExecutionResult` | object | no | Code execution result |

**InlineData object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `mimeType` | string | yes | Media MIME type |
| `data` | string | yes | Base64 encoded media data |

**FileData object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `mimeType` | string | yes | File MIME type |
| `fileUri` | string | yes | File URI |

#### `tools`

- Type: array
- Required: no

A list of tools that the model might use to generate the next response. Supported tools include functions and code execution.

**Tool object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `functionDeclarations` | array | no | Optional list of function declarations |
| `codeExecution` | object | no | Enable model to execute code |

**FunctionDeclaration object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `name` | string | yes | Function name |
| `description` | string | no | Function description |
| `parameters` | object | no | Function parameters, in JSON Schema format |

**FunctionCall object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `name` | string | yes | Name of the function to call |
| `args` | object | no | Key-value pairs of function arguments |

**FunctionResponse object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `name` | string | yes | Name of the called function |
| `response` | object | yes | Response data of the function call |

**ExecutableCode object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `language` | enum | yes | Programming language of the code |
| `code` | string | yes | Code to execute |

**CodeExecutionResult object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `outcome` | enum | yes | Code execution result status |
| `output` | string | no | Output content of the code execution |

**CodeExecution object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| {} | Empty object | - | Empty configuration object to enable code execution |

#### `toolConfig`

- Type: object
- Required: no

Tool configuration for any tools specified in the request.

**ToolConfig object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `functionCallingConfig` | object | no | Function calling configuration |

**FunctionCallingConfig object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `mode` | enum | no | Specifies the mode of function calling |
| `allowedFunctionNames` | array | no | List of function names allowed to be called |

**FunctionCallingMode enum values:**

- `MODE_UNSPECIFIED`: Default mode, model decides whether to call a function
- `AUTO`: Model automatically decides when to call a function 
- `ANY`: Model must call a function
- `NONE`: Model cannot call a function

#### `safetySettings`

- Type: array
- Required: no

A list of SafetySetting instances to filter out unsafe content.

**SafetySetting object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `category` | enum | yes | Safety category |
| `threshold` | enum | yes | Blocking threshold |

**HarmCategory enum values:**

- `HARM_CATEGORY_HARASSMENT`: Harassment content
- `HARM_CATEGORY_HATE_SPEECH`: Hate speech and content
- `HARM_CATEGORY_SEXUALLY_EXPLICIT`: Explicitly sexual content
- `HARM_CATEGORY_DANGEROUS_CONTENT`: Dangerous content
- `HARM_CATEGORY_CIVIC_INTEGRITY`: Content that might be used to undermine civic integrity

**HarmBlockThreshold enum values:**

- `BLOCK_LOW_AND_ABOVE`: Allows content with a NEGLIGIBLE score to be published
- `BLOCK_MEDIUM_AND_ABOVE`: Allows content with a NEGLIGIBLE and LOW score to be published
- `BLOCK_ONLY_HIGH`: Allows content with a NEGLIGIBLE, LOW, and MEDIUM risk level to be published
- `BLOCK_NONE`: Allows all content
- `OFF`: Turns off safety filters

**Complete HarmBlockThreshold enum values:**

- `HARM_BLOCK_THRESHOLD_UNSPECIFIED`: Threshold not specified
- `BLOCK_LOW_AND_ABOVE`: Blocks harmful content with a probability of medium or higher, only allowing NEGLIGIBLE level content
- `BLOCK_MEDIUM_AND_ABOVE`: Blocks harmful content with a probability of medium or higher, allowing NEGLIGIBLE and LOW level content
- `BLOCK_ONLY_HIGH`: Only blocks harmful content with a high probability, allowing NEGLIGIBLE, LOW, and MEDIUM level content
- `BLOCK_NONE`: Does not block any content, allowing all levels
- `OFF`: Completely turns off safety filters

#### `systemInstruction`

- Type: object (Content)
- Required: no

System instruction set by the developer. Currently only supports text.

#### `generationConfig`

- Type: object
- Required: no

Model generation and output configuration options.

**GenerationConfig object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `stopSequences` | array | no | Set of character sequences to stop generation (up to 5) |
| `responseMimeType` | string | no | MIME type of the generated candidate text |
| `responseSchema` | object | no | Output schema of the generated candidate text |
| `responseModalities` | array | no | Response modalities requested |
| `candidateCount` | integer | no | Number of generated answers to return |
| `maxOutputTokens` | integer | no | Maximum number of tokens in the candidate answers |
| `temperature` | number | no | Controls the randomness of output, range [0.0, 2.0] |
| `topP` | number | no | Cumulative probability upper bound of tokens to consider during sampling |
| `topK` | integer | no | Maximum number of tokens to consider during sampling |
| `seed` | integer | no | Seed used for decoding |
| `presencePenalty` | number | no | Presence penalty |
| `frequencyPenalty` | number | no | Frequency penalty |
| `responseLogprobs` | boolean | no | Whether to export logprobs results in the response |
| `logprobs` | integer | no | Number of top logprobs returned |
| `enableEnhancedCivicAnswers` | boolean | no | Enables enhanced civic service answers |
| `speechConfig` | object | no | Speech generation configuration |
| `thinkingConfig` | object | no | Thinking function configuration |
| `mediaResolution` | enum | no | Specified media resolution |

**Supported MIME types:**

- `text/plain`: (default) Text output
- `application/json`: JSON response
- `text/x.enum`: ENUM as string response

**Modality enum values:**

- `TEXT`: Indicates model should return text
- `IMAGE`: Indicates model should return image
- `AUDIO`: Indicates model should return audio

**Schema object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `type` | enum | yes | Data type |
| `description` | string | no | Field description |
| `enum` | array | no | List of enum values (when type is string) |
| `example` | any | no | Example value |
| `nullable` | boolean | no | Whether it can be null |
| `format` | string | no | String format (e.g., date, date-time) |
| `items` | object | no | Schema for array items (when type is array) |
| `properties` | object | no | Schema for object properties (when type is object) |
| `required` | array | no | List of required property names |
| `minimum` | number | no | Minimum value for numbers |
| `maximum` | number | no | Maximum value for numbers |
| `minItems` | integer | no | Minimum length for arrays |
| `maxItems` | integer | no | Maximum length for arrays |
| `minLength` | integer | no | Minimum length for strings |
| `maxLength` | integer | no | Maximum length for strings |

**Type enum values:**

- `TYPE_UNSPECIFIED`: Type not specified
- `STRING`: String type
- `NUMBER`: Number type
- `INTEGER`: Integer type
- `BOOLEAN`: Boolean type
- `ARRAY`: Array type
- `OBJECT`: Object type

**Supported programming languages (ExecutableCode):**

- `LANGUAGE_UNSPECIFIED`: Language not specified
- `PYTHON`: Python programming language

**Code execution result enum (Outcome):**

- `OUTCOME_UNSPECIFIED`: Result not specified
- `OUTCOME_OK`: Code execution successful
- `OUTCOME_FAILED`: Code execution failed
- `OUTCOME_DEADLINE_EXCEEDED`: Code execution timed out

#### `cachedContent`

- Type: string
- Required: no

The name of cached content, used as context for providing predictions. Format: `cachedContents/{cachedContent}`

## 📥 Response

### GenerateContentResponse

Answer from models that support multiple candidate answers. The system reports safety ratings and content filtering for the prompt and each candidate.

#### `candidates`

- Type: array
- Description: List of candidate answers from the model

**Candidate object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `content` | object | Generated content returned by the model |
| `finishReason` | enum | Reason for the model to stop generating tokens |
| `safetyRatings` | array | List of safety ratings for the candidate answer |
| `citationMetadata` | object | Reference information for the generated candidate |
| `tokenCount` | integer | Token count for this candidate |
| `groundingAttributions` | array | Information about sources that contributed to generating a grounded answer |
| `groundingMetadata` | object | Reference metadata for the candidate object |
| `avgLogprobs` | number | Average log probability score for the candidate |
| `logprobsResult` | object | Log probability scores for answer tokens and preceding tokens |
| `urlRetrievalMetadata` | object | Metadata related to URL context retrieval tool |
| `urlContextMetadata` | object | Metadata related to URL context retrieval tool |
| `index` | integer | Index of the candidate in the response candidate list |

**FinishReason enum values:**

- `STOP`: Natural stopping point or provided stop sequence for the model
- `MAX_TOKENS`: Maximum token limit specified in the request reached
- `SAFETY`: Answer candidate content marked for safety reasons
- `RECITATION`: Answer candidate content marked for recitation reasons
- `LANGUAGE`: Answer candidate content marked for using unsupported language
- `OTHER`: Reason unknown
- `BLOCKLIST`: Token generation operation stopped because content contains prohibited words
- `PROHIBITED_CONTENT`: Token generation operation stopped because content might contain prohibited content
- `SPII`: Token generation operation stopped because content might contain sensitive personal information
- `MALFORMED_FUNCTION_CALL`: Model-generated function call invalid
- `IMAGE_SAFETY`: Token generation stopped because generated image violated safety rules

#### `promptFeedback`

- Type: object
- Description: Prompt feedback related to content filtering

**PromptFeedback object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `blockReason` | enum | Reason for blocking the prompt |
| `safetyRatings` | array | Safety rating for the prompt |

**BlockReason enum values:**

- `BLOCK_REASON_UNSPECIFIED`: Default value, this value is not used
- `SAFETY`: System blocked prompt due to safety reasons
- `OTHER`: Prompt blocked due to unknown reasons
- `BLOCKLIST`: System blocked this prompt because it contained terms in the blocklist
- `PROHIBITED_CONTENT`: System blocked this prompt because it contained prohibited content
- `IMAGE_SAFETY`: Candidate image blocked because it generated unsafe content

#### `usageMetadata`

- Type: object
- Description: Metadata about token usage for the generation request

**UsageMetadata object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `promptTokenCount` | integer | Token count in the prompt |
| `cachedContentTokenCount` | integer | Token count in the cached part of the prompt |
| `candidatesTokenCount` | integer | Total token count in all generated candidate answers |
| `totalTokenCount` | integer | Total token count for the generation request |
| `toolUsePromptTokenCount` | integer | Token count in the prompt for tool usage |
| `thoughtsTokenCount` | integer | Token count for the thinking model's thoughts |
| `promptTokensDetails` | array | List of modalities processed in the request input |
| `candidatesTokensDetails` | array | List of modalities returned in the response |
| `cacheTokensDetails` | array | List of modalities in the cached content of the request input |
| `toolUsePromptTokensDetails` | array | List of modalities processed for tool usage in the request input |

#### `modelVersion`

- Type: string
- Description: Model version used to generate the answer

#### `responseId`

- Type: string
- Description: ID for each response

#### Full response example

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

## 🔧 Advanced Features

### Safety Ratings

**SafetyRating object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `category` | enum | Category of this rating |
| `probability` | enum | Harmful probability for this content |
| `blocked` | boolean | Whether this content was blocked due to this rating |

**HarmProbability enum values:**

- `NEGLIGIBLE`: Harmful probability negligible
- `LOW`: Harmful probability low
- `MEDIUM`: Harmful probability medium
- `HIGH`: Harmful probability high

### Citation Metadata

**CitationMetadata object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `citationSources` | array | Source references for specific replies |

**CitationSource object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `startIndex` | integer | Start index of the response segment attributed to this source |
| `endIndex` | integer | End index of the attribution (exclusive) |
| `uri` | string | URI attributed to the text portion from this source |
| `license` | string | License of the GitHub project attributed to the source fragment |

### Code Execution

When code execution tools are enabled, the model can generate and execute code to solve problems.

**Code execution example response:**

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

### Grounding

**GroundingMetadata object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `groundingChunks` | array | List of supporting reference documents retrieved from specified grounding sources |
| `groundingSupports` | array | Grounding support list |
| `webSearchQueries` | array | Web search queries for subsequent web searches |
| `searchEntryPoint` | object | Google search entry point for subsequent web searches |
| `retrievalMetadata` | object | Metadata related to retrieval in the baseline process |

**GroundingAttribution object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `sourceId` | object | Identifier of the source that contributed to this attribution |
| `content` | object | Content of the source that contributed to this attribution |

**AttributionSourceId object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `groundingPassage` | object | Identifier of the embedded paragraph |
| `semanticRetrieverChunk` | object | Identifier of the Chunk extracted by Semantic Retriever |

**GroundingPassageId object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `passageId` | string | ID of the paragraph matching GroundingPassage.id from GenerateAnswerRequest |
| `partIndex` | integer | Index of the part in GroundingPassage.content |

**SemanticRetrieverChunk object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `source` | string | Source name matching SemanticRetrieverConfig.source from the request |
| `chunk` | string | Name of the Chunk containing the attributed text |

**SearchEntryPoint object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `renderedContent` | string | Web content code segment embeddable in a webpage or app WebView |
| `sdkBlob` | string | Base64 encoded JSON, representing an array of search terms and search URL tuples |

**Segment object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `partIndex` | integer | Index of the Part object within its parent Content object |
| `startIndex` | integer | Start index of the given part in bytes |
| `endIndex` | integer | End index of the given chunk in bytes |
| `text` | string | Text corresponding to the fragment in the response |

**RetrievalMetadata object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `googleSearchDynamicRetrievalScore` | number | Probability score of information from Google search helping to answer the question, range [0,1] |

**GroundingChunk object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `web` | object | Grounding chunk from the web |

**Web object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `uri` | string | URI reference for the chunk |
| `title` | string | Title of the data block |

**GroundingSupport object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `groundingChunkIndices` | array | List of indices, used to specify citations related to copyright claims |
| `confidenceScores` | array | Confidence scores for supporting reference documents, range 0-1 |
| `segment` | object | Content segment to which this support request belongs |

### Multimodal Processing

Gemini API supports processing multiple modalities of input and output:

**Supported input modalities:**

- `TEXT`: Pure text
- `IMAGE`: Images (JPEG, PNG, WebP, HEIC, HEIF)
- `AUDIO`: Audio (WAV, MP3, AIFF, AAC, OGG, FLAC)
- `VIDEO`: Videos (MP4, MPEG, MOV, AVI, FLV, MPG, WEBM, WMV, 3GPP)
- `DOCUMENT`: Documents (PDF)

**ModalityTokenCount object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `modality` | enum | Modality associated with this token count |
| `tokenCount` | integer | Token count |

**MediaResolution enum values:**

- `MEDIA_RESOLUTION_LOW`: Low resolution (64 tokens)
- `MEDIA_RESOLUTION_MEDIUM`: Medium resolution (256 tokens)
- `MEDIA_RESOLUTION_HIGH`: High resolution (256 tokens for scaling and re-framing)

### Thinking Function

**ThinkingConfig object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `includeThoughts` | boolean | Whether to include thinking content in the answer |
| `thinkingBudget` | integer | Number of idea tokens the model should generate |

### Speech Generation

**SpeechConfig object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `voiceConfig` | object | Configuration for single voice output |
| `multiSpeakerVoiceConfig` | object | Configuration for multi-speaker settings |
| `languageCode` | string | Language code for speech synthesis |

**VoiceConfig object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `prebuiltVoiceConfig` | object | Configuration for the prebuilt voice to use |

**PrebuiltVoiceConfig object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `voiceName` | string | Name of the prebuilt voice to use |

**MultiSpeakerVoiceConfig object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `speakerVoiceConfigs` | array | All enabled speaker voices |

**SpeakerVoiceConfig object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `speaker` | string | Name of the speaker to use |
| `voiceConfig` | object | Configuration for the voice to use |

**Supported language codes:**

- `zh-CN`: Chinese (Simplified)
- `en-US`: English (US)
- `ja-JP`: Japanese
- `ko-KR`: Korean
- `fr-FR`: French
- `de-DE`: German
- `es-ES`: Spanish
- `pt-BR`: Portuguese (Brazil)
- `hi-IN`: Hindi
- `ar-XA`: Arabic
- `it-IT`: Italian
- `tr-TR`: Turkish
- `vi-VN`: Vietnamese
- `th-TH`: Thai
- `ru-RU`: Russian
- `pl-PL`: Polish
- `nl-NL`: Dutch

### Logprobs Results

**LogprobsResult object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `topCandidates` | array | Array of candidates sorted by log probability in descending order |
| `chosenCandidates` | array | Array of chosen candidates, not necessarily in topCandidates (length equals total decoding steps) |

**TopCandidates object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `candidates` | array | Candidates sorted by log probability in descending order |

**Candidate (Logprobs) object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `token` | string | Token string value for the candidate |
| `tokenId` | integer | Token ID value for the candidate |
| `logProbability` | number | Log probability for the candidate |

### URL Retrieval Function

**UrlRetrievalMetadata object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `urlRetrievalContexts` | array | List of URL retrieval contexts |

**UrlRetrievalContext object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `retrievedUrl` | string | URL retrieved by the tool |

**UrlContextMetadata object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `urlMetadata` | array | List of URL contexts |

**UrlMetadata object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `retrievedUrl` | string | URL retrieved by the tool |
| `urlRetrievalStatus` | enum | URL retrieval status |

**UrlRetrievalStatus enum values:**

- `URL_RETRIEVAL_STATUS_SUCCESS`: URL retrieval successful
- `URL_RETRIEVAL_STATUS_ERROR`: URL retrieval failed due to an error

### Complete Harm Categories

**HarmCategory enum values:**

- `HARM_CATEGORY_UNSPECIFIED`: Category not specified
- `HARM_CATEGORY_DEROGATORY`: PaLM - Negative or harmful comments targeting identity and/or protected attributes
- `HARM_CATEGORY_TOXICITY`: PaLM - Rude, impolite, or profane content
- `HARM_CATEGORY_VIOLENCE`: PaLM - Scenarios depicting violence against individuals or groups
- `HARM_CATEGORY_SEXUAL`: PaLM - References to sexual behavior or other explicit content
- `HARM_CATEGORY_MEDICAL`: PaLM - Promoting unverified medical advice
- `HARM_CATEGORY_DANGEROUS`: PaLM - Dangerous content promotes, encourages, or facilitates harmful behavior
- `HARM_CATEGORY_HARASSMENT`: Gemini - Harassment content
- `HARM_CATEGORY_HATE_SPEECH`: Gemini - Hate speech and content
- `HARM_CATEGORY_SEXUALLY_EXPLICIT`: Gemini - Explicitly sexual content
- `HARM_CATEGORY_DANGEROUS_CONTENT`: Gemini - Dangerous content
- `HARM_CATEGORY_CIVIC_INTEGRITY`: Gemini - Content that might be used to undermine civic integrity

**HarmProbability enum values:**

- `HARM_PROBABILITY_UNSPECIFIED`: Probability not specified
- `NEGLIGIBLE`: Harmful probability negligible
- `LOW`: Harmful probability low
- `MEDIUM`: Harmful probability medium
- `HIGH`: Harmful probability high

**Modality enum values:**

- `MODALITY_UNSPECIFIED`: Modality not specified
- `TEXT`: Pure text
- `IMAGE`: Image
- `VIDEO`: Video
- `AUDIO`: Audio
- `DOCUMENT`: Document, e.g., PDF

**MediaResolution enum values:**

- `MEDIA_RESOLUTION_UNSPECIFIED`: Media resolution not set
- `MEDIA_RESOLUTION_LOW`: Media resolution set to low (64 tokens)
- `MEDIA_RESOLUTION_MEDIUM`: Media resolution set to medium (256 tokens)
- `MEDIA_RESOLUTION_HIGH`: Media resolution set to high (using 256 tokens for scaling and re-framing)

**UrlRetrievalStatus enum values:**

- `URL_RETRIEVAL_STATUS_UNSPECIFIED`: Default value, this value is not used
- `URL_RETRIEVAL_STATUS_SUCCESS`: URL retrieval successful
- `URL_RETRIEVAL_STATUS_ERROR`: URL retrieval failed due to an error

## 🔍 Error Handling

### Common Error Codes

| Error Code | Description |
|------------|-----------|
| `400` | Request format error or invalid parameter |
| `401` | API key invalid or missing |
| `403` | Insufficient permissions or quota limit |
| `429` | Request frequency too high |
| `500` | Server internal error |

### Detailed Error Code Explanations

| Error Code | Status | Description | Solution |
|------------|--------|-----------|----------|
| `400` | `INVALID_ARGUMENT` | Request parameter invalid or format error | Check request parameter format and required fields |
| `400` | `FAILED_PRECONDITION` | Precondition for the request not met | Ensure API call prerequisites are met |
| `401` | `UNAUTHENTICATED` | API key invalid, missing, or expired | Check API key validity and format |
| `403` | `PERMISSION_DENIED` | Insufficient permissions or quota exhausted | Check API key permissions or upgrade quota |
| `404` | `NOT_FOUND` | Specified model or resource does not exist | Verify model name and resource path |
| `413` | `PAYLOAD_TOO_LARGE` | Request body too large | Reduce input content size or process in batches |
| `429` | `RESOURCE_EXHAUSTED` | Request frequency exceeded or quota insufficient | Reduce request frequency or wait for quota reset |
| `500` | `INTERNAL` | Server internal error | Retry the request, if persistent contact support |
| `503` | `UNAVAILABLE` | Service temporarily unavailable | Wait for a period and retry |
| `504` | `DEADLINE_EXCEEDED` | Request timed out | Reduce input size or retry the request |

### Error Response Example

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
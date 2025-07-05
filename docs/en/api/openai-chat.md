# OpenAI Chat Format (Chat Completions)

!!! info "Official Documentation"
    [OpenAI Chat](https://platform.openai.com/docs/api-reference/chat)

## 📝 Introduction

Given a list of messages comprising a conversation, the model will return a response. For related guidelines, please refer to the OpenAI official website: [Chat Completions](https://platform.openai.com/docs/guides/chat)

## 💡 Request Examples

### Basic Text Chat ✅

```bash
curl https://your-newapi-server-address/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "messages": [
      {
        "role": "developer",
        "content": "You are a helpful assistant."
      },
      {
        "role": "user",
        "content": "Hello!"
      }
    ]
  }'
```

**Response Example:**

```json
{
  "id": "chatcmpl-B9MBs8CjcvOU2jLn4n570S5qMJKcT",
  "object": "chat.completion",
  "created": 1741569952,
  "model": "gpt-4.1-2025-04-14",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "Hello! How can I help you?",
        "refusal": null,
        "annotations": []
      },
      "logprobs": null,
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 19,
    "completion_tokens": 10,
    "total_tokens": 29,
    "prompt_tokens_details": {
      "cached_tokens": 0,
      "audio_tokens": 0
    },
    "completion_tokens_details": {
      "reasoning_tokens": 0,
      "audio_tokens": 0,
      "accepted_prediction_tokens": 0,
      "rejected_prediction_tokens": 0
    }
  },
  "service_tier": "default"
}
```

### Image Analysis Chat ✅

```bash
curl https://your-newapi-server-address/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "messages": [
      {
        "role": "user",
        "content": [
          {
            "type": "text",
            "text": "What's in this image?"
          },
          {
            "type": "image_url",
            "image_url": {
              "url": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg"
            }
          }
        ]
      }
    ],
    "max_tokens": 300
  }'
```

**Response Example:**

```json
{
  "id": "chatcmpl-B9MHDbslfkBeAs8l4bebGdFOJ6PeG",
  "object": "chat.completion",
  "created": 1741570283,
  "model": "gpt-4.1-2025-04-14",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "The image shows a wooden boardwalk path through dense green grass or meadow. The sky is bright blue with scattered clouds, creating a peaceful and serene atmosphere for the entire scene. Trees and shrubs can be seen in the background.",
        "refusal": null,
        "annotations": []
      },
      "logprobs": null,
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 1117,
    "completion_tokens": 46,
    "total_tokens": 1163,
    "prompt_tokens_details": {
      "cached_tokens": 0,
      "audio_tokens": 0
    },
    "completion_tokens_details": {
      "reasoning_tokens": 0,
      "audio_tokens": 0,
      "accepted_prediction_tokens": 0,
      "rejected_prediction_tokens": 0
    }
  },
  "service_tier": "default",
  "system_fingerprint": "fp_fc9f1d7035"
}
```

### Streaming Response ✅

```bash
curl https://your-newapi-server-address/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "messages": [
      {
        "role": "developer",
        "content": "You are a helpful assistant."
      },
      {
        "role": "user",
        "content": "Hello!"
      }
    ],
    "stream": true
  }'
```

**Streaming Response Example:**

```jsonl
{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1694268190,"model":"gpt-4o-mini", "system_fingerprint": "fp_44709d6fcb", "choices":[{"index":0,"delta":{"role":"assistant","content":""},"logprobs":null,"finish_reason":null}]}

{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1694268190,"model":"gpt-4o-mini", "system_fingerprint": "fp_44709d6fcb", "choices":[{"index":0,"delta":{"content":"Hello"},"logprobs":null,"finish_reason":null}]}

// ... more data chunks ...

{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1694268190,"model":"gpt-4o-mini", "system_fingerprint": "fp_44709d6fcb", "choices":[{"index":0,"delta":{},"logprobs":null,"finish_reason":"stop"}]}
```

### Function Calling ✅

```bash
curl https://your-newapi-server-address/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "messages": [
      {
        "role": "user",
        "content": "What's the weather like in Boston today?"
      }
    ],
    "tools": [
      {
        "type": "function",
        "function": {
          "name": "get_current_weather",
          "description": "Get the current weather for a specified location",
          "parameters": {
            "type": "object",
            "properties": {
              "location": {
                "type": "string",
                "description": "City and state, e.g., San Francisco, CA"
              },
              "unit": {
                "type": "string",
                "enum": ["celsius", "fahrenheit"]
              }
            },
            "required": ["location"]
          }
        }
      }
    ],
    "tool_choice": "auto"
  }'
```

**Response Example:**

```json
{
  "id": "chatcmpl-abc123",
  "object": "chat.completion",
  "created": 1699896916,
  "model": "gpt-4o-mini",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": null,
        "tool_calls": [
          {
            "id": "call_abc123",
            "type": "function",
            "function": {
              "name": "get_current_weather",
              "arguments": "{\n\"location\": \"Boston, MA\"\n}"
            }
          }
        ]
      },
      "logprobs": null,
      "finish_reason": "tool_calls"
    }
  ],
  "usage": {
    "prompt_tokens": 82,
    "completion_tokens": 17,
    "total_tokens": 99,
    "completion_tokens_details": {
      "reasoning_tokens": 0,
      "accepted_prediction_tokens": 0,
      "rejected_prediction_tokens": 0
    }
  }
}
```

### Logprobs Request ✅

```bash
curl https://your-newapi-server-address/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "messages": [
      {
        "role": "user",
        "content": "Hello!"
      }
    ],
    "logprobs": true,
    "top_logprobs": 2
  }'
```

**Response Example:**

```json
{
  "id": "chatcmpl-123",
  "object": "chat.completion",
  "created": 1702685778,
  "model": "gpt-4o-mini",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "Hello! How can I help you?"
      },
      "logprobs": {
        "content": [
          {
            "token": "Hello",
            "logprob": -0.31725305,
            "bytes": [72, 101, 108, 108, 111],
            "top_logprobs": [
              {
                "token": "Hello",
                "logprob": -0.31725305,
                "bytes": [72, 101, 108, 108, 111]
              },
              {
                "token": "Hi",
                "logprob": -1.3190403,
                "bytes": [72, 105]
              }
            ]
          },
          {
            "token": "!",
            "logprob": -0.02380986,
            "bytes": [
              33
            ],
            "top_logprobs": [
              {
                "token": "!",
                "logprob": -0.02380986,
                "bytes": [33]
              },
              {
                "token": " there",
                "logprob": -3.787621,
                "bytes": [32, 116, 104, 101, 114, 101]
              }
            ]
          },
          {
            "token": " How",
            "logprob": -0.000054669687,
            "bytes": [32, 72, 111, 119],
            "top_logprobs": [
              {
                "token": " How",
                "logprob": -0.000054669687,
                "bytes": [32, 72, 111, 119]
              },
              {
                "token": "<|end|>",
                "logprob": -10.953937,
                "bytes": null
              }
            ]
          },
          {
            "token": " can",
            "logprob": -0.015801601,
            "bytes": [32, 99, 97, 110],
            "top_logprobs": [
              {
                "token": " can",
                "logprob": -0.015801601,
                "bytes": [32, 99, 97, 110]
              },
              {
                "token": " may",
                "logprob": -4.161023,
                "bytes": [32, 109, 97, 121]
              }
            ]
          },
          {
            "token": " I",
            "logprob": -3.7697225e-6,
            "bytes": [
              32,
              73
            ],
            "top_logprobs": [
              {
                "token": " I",
                "logprob": -3.7697225e-6,
                "bytes": [32, 73]
              },
              {
                "token": " assist",
                "logprob": -13.596657,
                "bytes": [32, 97, 115, 115, 105, 115, 116]
              }
            ]
          },
          {
            "token": " assist",
            "logprob": -0.04571125,
            "bytes": [32, 97, 115, 115, 105, 115, 116],
            "top_logprobs": [
              {
                "token": " assist",
                "logprob": -0.04571125,
                "bytes": [32, 97, 115, 115, 105, 115, 116]
              },
              {
                "token": " help",
                "logprob": -3.1089056,
                "bytes": [32, 104, 101, 108, 112]
              }
            ]
          },
          {
            "token": " you",
            "logprob": -5.4385737e-6,
            "bytes": [32, 121, 111, 117],
            "top_logprobs": [
              {
                "token": " you",
                "logprob": -5.4385737e-6,
                "bytes": [32, 121, 111, 117]
              },
              {
                "token": " today",
                "logprob": -12.807695,
                "bytes": [32, 116, 111, 100, 97, 121]
              }
            ]
          },
          {
            "token": " today",
            "logprob": -0.0040071653,
            "bytes": [32, 116, 111, 100, 97, 121],
            "top_logprobs": [
              {
                "token": " today",
                "logprob": -0.0040071653,
                "bytes": [32, 116, 111, 100, 97, 121]
              },
              {
                "token": "?",
                "logprob": -5.5247097,
                "bytes": [63]
              }
            ]
          },
          {
            "token": "?",
            "logprob": -0.0008108172,
            "bytes": [63],
            "top_logprobs": [
              {
                "token": "?",
                "logprob": -0.0008108172,
                "bytes": [63]
              },
              {
                "token": "?\n",
                "logprob": -7.184561,
                "bytes": [63, 10]
              }
            ]
          }
        ]
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 9,
    "completion_tokens": 9,
    "total_tokens": 18,
    "completion_tokens_details": {
      "reasoning_tokens": 0,
      "accepted_prediction_tokens": 0,
      "rejected_prediction_tokens": 0
    }
  },
  "system_fingerprint": null
}
```

## 📮 Request

### Endpoint

```
POST /v1/chat/completions
```

Create a model response for a given chat conversation. For more details, please refer to the text generation, visual, and audio guides.

### Authentication Method

Include the following in the request headers for API key authentication:

```
Authorization: Bearer $NEWAPI_API_KEY
```

Where `$NEWAPI_API_KEY` is your API key. You can find or generate your API key on the API keys page of the OpenAI platform.

### Request Body Parameters

#### `messages`

- Type: Array
- Required: Yes

The list of messages comprising the conversation so far. Depending on the model used, different message types (forms) are supported, such as text, image, and audio.

| Message Type | Description |
|---------|------|
| **Developer message** | Developer instructions, the model should follow these instructions regardless of what message the user sends. In o1 models and newer versions, developer messages replace previous system messages. |
| **System message** | Developer instructions, the model should follow these instructions regardless of what message the user sends. In o1 models and newer versions, please use developer messages instead. |
| **User message** | Messages sent by the terminal user, containing prompts or additional context information. |
| **Assistant message** | Messages sent by the model in response to user messages. |
| **Tool message** | Content of a tool message. |
| **Function message** | Deprecated. |

**Developer message Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `role` | String | Yes | The role of the message author, here "developer". |
| `content` | String or Array | Yes | The content of the developer message. Can be text content (string) or an array of content parts. |
| `name` | String | No | An optional name for the participant. Provides information to the model to distinguish between participants with the same role. |

**System message Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `role` | String | Yes | The role of the message author, here "system". |
| `content` | String or Array | Yes | The content of the system message. Can be text content (string) or an array of content parts. |
| `name` | String | No | An optional name for the participant. Provides information to the model to distinguish between participants with the same role. |

**User message Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `role` | String | Yes | The role of the message author, here "user". |
| `content` | String or Array | Yes | The content of the user message. Can be text content (string) or an array of content parts. |
| `name` | String | No | An optional name for the participant. Provides information to the model to distinguish between participants with the same role. |

**Content Part Types:**

| Content Part Type | Description | Can Be Used For |
|------------|------|---------|
| **Text Content Part** | Text input. | All message types |
| **Image Content Part** | Image input. | User messages |
| **Audio Content Part** | Audio input. | User messages |
| **File Content Part** | File input, used for text generation. | User messages |
| **Refusal Content Part** | Rejection messages generated by the model. | Assistant messages |

**Text Content Part Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `text` | String | Yes | Text content. |
| `type` | String | Yes | The type of content part. |

**Image Content Part Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `image_url` | Object | Yes | Contains an image URL or base64 encoded image data. |
| `type` | String | Yes | The type of content part. |

**Image URL Object Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `url` | String | Yes | The URL of the image or base64 encoded image data. |
| `detail` | String | No | Specifies the detailed level of the image. Defaults to "auto". |

**Audio Content Part Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `input_audio` | Object | Yes | Contains an object with audio data. |
| `type` | String | Yes | The type of content part. Always "input_audio". |

**Audio Input Object Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `data` | String | Yes | Base64 encoded audio data. |
| `format` | String | Yes | The format of the encoded audio data. Currently supports "wav" and "mp3". |

**File Content Part Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `file` | Object | Yes | Contains an object with file data. |
| `type` | String | Yes | The type of content part. Always "file". |

**File Object Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `file_data` | String | No | Base64 encoded file data, used to pass the file as a string to the model. |
| `file_id` | String | No | The ID of the uploaded file, used as input. |
| `filename` | String | No | The filename, used to pass the file as a string to the model. |

**Assistant message Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `role` | String | Yes | The role of the message author, here "assistant". |
| `content` | String or Array | No | The content of the assistant message. Required unless `tool_calls` or `function_call` is specified. |
| `name` | String | No | An optional name for the participant. Provides information to the model to distinguish between participants with the same role. |
| `audio` | Object or null | No | Data about the model's previous audio response. |
| `function_call` | Object or null | No | Deprecated, replaced by `tool_calls`. The name and parameters of the function to be called, generated by the model. |
| `tool_calls` | Array | No | Tool calls generated by the model, such as function calls. |
| `refusal` | String or null | No | The assistant's refusal message. |

**Tool message Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `role` | String | Yes | The role of the message author, here "tool". |
| `content` | String or Array | Yes | The content of the tool message. |
| `tool_call_id` | String | Yes | The tool call associated with this message response. |

**Function message Properties (Deprecated):**

| Property | Type | Required | Description |
|------|------|------|------|
| `role` | String | Yes | The role of the message author, here "function". |
| `content` | String or null | Yes | The content of the function message. |
| `name` | String | Yes | The name of the function to be called. |

#### `model`

- Type: String  
- Required: Yes

The ID of the model to use. For details on which models are compatible with the Chat API, please refer to the model endpoint compatibility table.

#### `store` 

- Type: Boolean or null
- Required: No
- Default: false

Whether to store the output of this chat completion request for our model distillation or evaluation products.

#### `reasoning_effort`

- Type: String or null
- Required: No
- Default: medium
- Only applicable to o-series models

Constraints the reasoning effort of the reasoning model. Current supported values are `low`, `medium`, and `high`. Reducing reasoning effort can speed up responses and reduce the number of tokens used for reasoning in the response.

#### `metadata`

- Type: map
- Required: No

A collection of 16 key-value pairs that can be attached to the object. This is useful for storing other information about the object in a structured format and querying the object via API or the dashboard.

Keys are strings of maximum length 64 characters. Values are strings of maximum length 512 characters.

#### `modalities`

- Type: Array or null
- Required: No

The types of output you want the model to generate for this request. Most models can generate text, which is the default:
["text"]

The model can also be used to generate audio. To request that the model generate both text and audio responses simultaneously, you can use:
["text", "audio"]

#### `prediction`

- Type: Object
- Required: No

Configuration for the predicted output, when you know most of the content of the model response in advance, it can greatly improve response time. This is most common when you are only making small changes to a file.

**Possible Types:**

| Type | Description |
|------|------|
| **Static Content** | Static predicted output content, e.g., text content of a file with small changes being regenerated. |

**Static Content Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `content` | String or Array | Yes | The content that should be matched when generating the model response. If the generated tokens match this content, the entire model response can return faster. |
| `type` | String | Yes | The type of predicted content to provide. Currently, the type is always "content". |

**Possible Content Types:**

1. **Text Content (String)** - Content for predicted output. This is usually the text of the file you are regenerating, with only small changes.

2. **Content Part Array (Array)** - An array of content parts with defined types. The supported options vary depending on the model used to generate the response. Can include text input.

**Content Part Array Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `text` | String | Yes | Text content. |
| `type` | String | Yes | The type of content part. |

#### `audio`

- Type: Object or null
- Required: No

Parameters for audio output. Required when requesting audio output with `modalities: ["audio"]`.

| Property | Type | Required | Description |
|------|------|------|------|
| `format` | String | Yes | Specifies the output audio format. Must be one of: wav, mp3, flac, opus, or pcm16. |
| `voice` | String | Yes | The voice used by the model for the response. Supported voices include: alloy, ash, ballad, coral, echo, fable, nova, onyx, sage, and shimmer. |

#### `temperature`

- Type: Number or null
- Required: No
- Default: 1

The sampling temperature to use, between 0 and 2. Higher values (e.g., 0.8) make the output more random, while lower values (e.g., 0.2) make it more concentrated and deterministic. We generally recommend changing this value or `top_p`, but not both.

#### `top_p`

- Type: Number or null  
- Required: No
- Default: 1

An alternative to sampling temperature, called nucleus sampling, where the model considers the results of tokens with top_p probability mass. Therefore, 0.1 means only considering tokens with the top 10% probability mass.

We generally recommend changing this value or `temperature`, but not both.

#### `n`

- Type: Integer or null
- Required: No  
- Default: 1

How many chat completions to generate for each input message. Note that you will be charged for the total number of tokens generated across all choices. Keeping `n` to 1 can minimize costs.

#### `stop`

- Type: String/Array/null
- Required: No
- Default: null
- Not supported by the latest inference models and .o3, o4-mini

API will stop generating more tokens for up to 4 sequences. The returned text will not include the stop sequence.

#### `max_tokens`

- Type: Integer or null
- Required: No

The maximum number of tokens that can be generated in a chat completion. This value can be used to control the text cost generated via API.

This value is now deprecated, replaced by `max_completion_tokens`, and is incompatible with .o1 series models.

#### `max_completion_tokens`

- Type: Integer or null
- Required: No

The upper limit of tokens that can be generated in a completion, including visible output tokens and reasoning tokens.

#### `presence_penalty`

- Type: Number or null 
- Required: No
- Default: 0

A number between -2.0 and 2.0. Positive values penalize new tokens based on their occurrence so far in the text, thereby increasing the model's likelihood of discussing new topics.

#### `frequency_penalty`

- Type: Number or null
- Required: No  
- Default: 0

A number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency so far in the text, thereby reducing the model's likelihood of repeating the same line word for word.

#### `logit_bias`

- Type: map
- Required: No
- Default: null

Modifies the likelihood of specified tokens appearing in the completion.

Accepts a JSON object that maps tokens (specified by token IDs in the tokenizer) to associated bias values from -100 to 100. Mathematically, bias is added to the logits of the model before sampling. The exact effect can vary by model, but values between -1 and 1 should reduce or increase the likelihood of selection; values like -100 or 100 should result in the relevant tokens being prohibited or exclusively selected.

#### `logprobs`

- Type: Boolean or null
- Required: No
- Default: false

Whether to return log probabilities for output tokens. If true, returns log probabilities for each output token in `message.content`.

#### `user`

- Type: String
- Required: No

A unique identifier for the final user, which helps OpenAI monitor and detect abuse behavior. [Learn more](https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids).

#### `service_tier`

- Type: String or null
- Required: No
- Default: auto

Specifies the latency tier for processing the request. This parameter is relevant to customers subscribed to the scale tier service:

- If set to 'auto', and the project is enabled for Scale tier, the system will use scale tier credits until they are exhausted
- If set to 'auto', and the project is not enabled for Scale tier, the request will be processed using the default service tier, with lower normal operation time SLA and no latency guarantees
- If set to 'default', the request will be processed using the default service tier, with lower normal operation time SLA and no latency guarantees
- If set to 'flex', the request will be processed using the Flex Processing service tier. For details, please refer to the documentation.
- When not set, the default behavior is 'auto'
- When this parameter is set, the response body will include the used service_tier

#### `stream_options`

- Type: Object or null
- Required: No
- Default: null

Options for streaming responses. Only used when `stream: true`.

**Possible Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `include_usage` | Boolean | No | If set, an additional block will be streamed before the data: [DONE] message. The usage field on this block shows the token usage statistics for the entire request, and the choices field is always an empty array. All other blocks will also include a usage field, but its value will be null. Note: If the stream is interrupted, you may not receive a final usage block containing the total token usage of the request. |

#### `response_format`

- Type: Object
- Required: No

Specifies the format that the model must output.

- Set to `{ "type": "json_schema", "json_schema": {...} }` to enable structured output, ensuring the model matches your provided JSON schema.
- Set to `{ "type": "json_object" }` to enable JSON mode, ensuring the generated messages are valid JSON.

Important Note: When using JSON mode, you must also explicitly instruct the model to generate JSON via system or user messages. Otherwise, the model may generate endless blanks until it reaches token limits.

**Possible Types:**

| Type | Description |
|------|------|
| **text** | Default response format. Used to generate text responses. |
| **json_schema** | JSON Schema response format. Used to generate structured JSON responses. Learn more about structured output. |
| **json_object** | JSON object response format. An older method for generating JSON responses. For supported models, we recommend using json_schema. |

**text Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `type` | String | Yes | The type of response format being defined. Always "text". |

**json_schema Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `json_schema` | Object | Yes | Structured output configuration options, including JSON Schema. |
| `type` | String | Yes | The type of response format being defined. Always "json_schema". |

**json_schema.json_schema Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `name` | String | Yes | The name of the response format. Must be a-z, A-Z, 0-9, or contain underscores and hyphens, with a maximum length of 64. |
| `description` | String | No | A description of the purpose of the response format, used by the model to determine how to respond in that format. |
| `schema` | Object | No | The schema of the response format, described as a JSON Schema object. |
| `strict` | Boolean or null | No | Whether to enable strict schema adherence when generating output. If set to true, the model will always follow the exact schema defined in the schema field. strict is true, only a subset of JSON Schema is supported. |

**json_object Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `type` | String | Yes | The type of response format being defined. Always "json_object". |

#### `seed`

- Type: Integer or null
- Required: No
Beta feature. If specified, our system will do its best to perform deterministic sampling, so repeated requests with the same seed and parameters should return the same results. No guarantee of determinism, you should refer to the system_fingerprint of the response parameters to monitor backend changes.

#### `tools`

- Type: Array
- Required: No

A list of tools that the model might call. Currently, only functions are supported as tools. Use this parameter to provide a list of functions that the model might generate JSON input for. Up to 128 functions are supported.

**Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `function` | Object | Yes | Information about the function to be called |
| `type` | String | Yes | The type of tool. Currently, only function is supported. |

**function Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `name` | String | Yes | The name of the function to be called. Must be a-z, A-Z, 0-9, or contain underscores and hyphens, with a maximum length of 64. |
| `description` | String | No | A description of the function's functionality, used by the model to determine when and how to call the function. |
| `parameters` | Object | No | The parameters accepted by the function, described as a JSON Schema object. Please refer to the guide for examples, and the JSON Schema reference for format documentation. Omitting the parameters definition results in an empty parameter list for the function. |
| `strict` | Boolean or null | No | Default: false. Whether to enable strict schema adherence when generating function calls. If set to true, the model will follow the exact schema defined in the parameters field. strict is true, only a subset of JSON Schema is supported. For details, please refer to the structured output section of the function calling guide. |

#### `functions`

- Type: Array
- Required: No
- Note: Deprecated, recommended to use `tools`

A list of functions that the model might generate JSON input for.

| Property | Type | Required | Description |
|------|------|------|------|
| `name` | String | Yes | The name of the function to be called. Must be a-z, A-Z, 0-9, or contain underscores and hyphens, with a maximum length of 64. |
| `description` | String | No | A description of the function's functionality, used by the model to determine when and how to call the function. |
| `parameters` | Object | No | The parameters accepted by the function, described as a JSON Schema object. Omitting the parameters definition results in an empty parameter list for the function. |

#### `tool_choice`

- Type: String or Object
- Required: No

Controls which tool (if any) the model should call:
- `none`: The model will not call any tools, but generate a message
- `auto`: The model can choose between generating a message or calling one or more tools
- `required`: The model must call one or more tools
- `{"type": "function", "function": {"name": "my_function"}}`: Forces the model to call a specific tool

Defaults to `none` when no tools are present, and to `auto` when tools are present.

**Possible Types:**

| Type | Description |
|------|------|
| **String** | none means the model will not call any tools, but generate a message. auto means the model can choose between generating a message or calling one or more tools. required means the model must call one or more tools. |
| **Object** | Specifies the tool that the model should use. Used to force the model to call a specific function. |

**Object Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `function` | Object | Yes | Contains an object with function information |
| `type` | String | Yes | The type of tool. Currently, only function is supported. |

**function Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `name` | String | Yes | The name of the function to be called. |

#### `function_call`

- Type: String or Object
- Required: No
- Default: `none` when no function, `auto` when function is present
- Note: Deprecated, recommended to use `tool_choice`

Controls which function (if any) the model should call:

- `none`: The model will not call any functions, but generate a message
- `auto`: The model can choose between generating a message or calling a function
- `{"name": "my_function"}`: Forces the model to call a specific function

**Object Type Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `name` | String | Yes | The name of the function to be called. |

#### `parallel_tool_calls`

- Type: Boolean
- Required: No
- Default: true

Whether to enable parallel function calls during tool usage.

#### `stream`

- Type: Boolean or null
- Required: No
- Default: false

If set to true, model response data will be streamed to the client via server-sent events. Please refer to the streaming response section below for more information, and the streaming response guide for how to handle streaming events.

#### `top_logprobs`

- Type: Integer or null
- Required: No

An integer between 0 and 20, specifying the number of most likely tokens at each token position, each with its associated log probability. If this parameter is used, `logprobs` must be true.

#### `web_search_options`

- Type: Object
- Required: No

This tool searches the web to obtain relevant results for the reply. Learn more about the web search tool.

**Possible Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `search_context_size` | String | No | Advanced guidance for the context window size for search. Optional values are low, medium, or high. medium is the default. |
| `user_location` | Object or null | No | Approximate location parameters for the search. |

**user_location Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `approximate` | Object | Yes | Approximate location parameters for the search. |

**approximate Properties:**

| Property | Type | Required | Description |
|------|------|------|------|
| `city` | String | No | Free-text input for the user's city, e.g., San Francisco. |
| `country` | String | No | The user's two-letter ISO country code, e.g., US. |
| `region` | String | No | Free-text input for the user's region, e.g., California. |
| `timezone` | String | No | The user's IANA timezone, e.g., America/Los_Angeles. |
| `type` | String | Yes | The type of location approximation. Always "approximate". |

## 📥 Response

### Chat Completion Object

Returns a chat completion object, or a stream of chat completion chunk objects if the request was streamed.

#### `id` 
- Type: String
- Description: The unique identifier of the response

#### `object`
- Type: String  
- Description: The object type, value "chat.completion"

#### `created`
- Type: Integer
- Description: The timestamp of response creation

#### `model`
- Type: String
- Description: The name of the model used

#### `system_fingerprint`
- Type: String
- Description: The system fingerprint identifier, representing the backend configuration of the model run. Can be used together with the seed request parameter to understand when backend changes that might affect determinism have occurred.

#### `choices`
- Type: Array
- Description: A list of generated response options. If n is greater than 1, multiple options can be present.
- Properties:
  - `index`: The index of the option in the list of options.
  - `message`: The chat completion message generated by the model.
    - `role`: The role of the message author.
    - `content`: The content of the message, which may be null.
    - `refusal`: The rejection message generated by the model, which may be null.
    - `annotations`: Annotations for the message, provided when applicable, e.g., when using the web search tool.
      - `type`: The type of annotation. Always "url_citation" when it's a URL reference.
      - `url_citation`: The URL reference in the message.
        - `start_index`: The index of the first character of the URL reference in the message.
        - `end_index`: The index of the last character of the URL reference in the message.
        - `url`: The URL of the network resource.
        - `title`: The title of the network resource.
    - `audio`: If audio output modality was requested, this object contains data from the model's audio response.
      - `data`: The model's Base64 encoded audio bytes, in the format specified in the request.
      - `id`: The unique identifier for this audio response.
      - `transcript`: The transcription of the model's audio.
      - `expires_at`: The Unix timestamp (seconds) at which this audio response is available for multi-turn conversations on the server.
    - `function_call`: (Deprecated) The name and parameters of the function to be called, generated by the model. Replaced by `tool_calls`.
      - `name`: The name of the function to be called.
      - `arguments`: The parameters to be passed to the function, generated by the model in JSON format.
    - `tool_calls`: Tool calls generated by the model, such as function calls.
      - `id`: The ID of the tool call.
      - `type`: The type of tool. Currently, only function is supported.
      - `function`: The function called by the model.
        - `name`: The name of the function to be called.
        - `arguments`: The parameters to be passed to the function, generated by the model in JSON format. Note that the model does not always generate valid JSON, and may produce parameters not defined in your function schema. Before calling the function, please validate the parameters in your code.
  - `logprobs`: Log probability information.
    - `content`: A list of message content tokens with log probability information.
      - `token`: The token.
      - `logprob`: The log probability of this token, if it was among the top 20 most probable tokens. Otherwise, a value of -9999.0 is used to indicate this token is very unlikely.
      - `bytes`: A list of integers representing the UTF-8 byte representation of the token. This is useful when a character is represented by multiple tokens and their byte representations must be combined to generate the correct text representation. If a token has no byte representation, it may be null.
      - `top_logprobs`: A list of the most probable tokens at this token position and their log probabilities. In rare cases, the number of returned top_logprobs may be less than the requested number.
    - `refusal`: A list of message rejection tokens with log probability information.
  - `finish_reason`: The reason the model stopped generating tokens. If the model reached a natural stopping point or provided a stop sequence, it is "stop"; if the maximum number of tokens specified in the request was reached, it is "length"; if content was omitted due to content filters, it is "content_filter"; if the model called a tool, it is "tool_calls"; if the model called a function, it is "function_call" (deprecated).

#### `usage`
- Type: Object
- Description: Usage statistics for the completion request.
- Properties:
  - `prompt_tokens`: The number of tokens in the prompt.
  - `completion_tokens`: The number of tokens in the generated completion.
  - `total_tokens`: The total number of tokens used in the request (prompt + completion).
  - `prompt_tokens_details`: A breakdown of the tokens used in the prompt.
    - `cached_tokens`: The cached tokens in the prompt.
    - `audio_tokens`: The audio input tokens in the prompt.
  - `completion_tokens_details`: A breakdown of the tokens used in the completion.
    - `reasoning_tokens`: The reasoning tokens generated by the model.
    - `audio_tokens`: The audio tokens generated by the model.
    - `accepted_prediction_tokens`: The number of tokens in the predicted output that appeared in the completion when using predicted output.
    - `rejected_prediction_tokens`: The number of tokens in the predicted output that did not appear in the completion when using predicted output. However, like reasoning tokens, these tokens are still counted towards the total completion tokens for billing, output, and context window limits.

#### `service_tier`
- Type: String or null
- Description: Specifies the latency tier for processing the request. This parameter is relevant to customers subscribed to the scale tier service:
  - If set to 'auto', and the project is enabled for Scale tier, the system will use scale tier credits until they are exhausted
  - If set to 'auto', and the project is not enabled for Scale tier, the request will be processed using the default service tier, with lower normal operation time SLA and no latency guarantees
  - If set to 'default', the request will be processed using the default service tier, with lower normal operation time SLA and no latency guarantees
  - If set to 'flex', the request will be processed using the Flex Processing service tier. For details, please refer to the documentation.
  - When not set, the default behavior is 'auto'
  - When this parameter is set, the response body will include the used service_tier

#### Chat Completion Object Response Example

```json
{
  "id": "chatcmpl-B9MHDbslfkBeAs8l4bebGdFOJ6PeG",
  "object": "chat.completion",
  "created": 1741570283,
  "model": "gpt-4o-2024-08-06",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "The image shows a wooden boardwalk path through dense green grass or meadow. The sky is bright blue with scattered clouds, creating a peaceful and serene atmosphere for the entire scene. Trees and shrubs can be seen in the background.",
        "refusal": null,
        "annotations": []
      },
      "logprobs": null,
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 1117,
    "completion_tokens": 46,
    "total_tokens": 1163,
    "prompt_tokens_details": {
      "cached_tokens": 0,
      "audio_tokens": 0
    },
    "completion_tokens_details": {
      "reasoning_tokens": 0,
      "audio_tokens": 0,
      "accepted_prediction_tokens": 0,
      "rejected_prediction_tokens": 0
    }
  },
  "service_tier": "default",
  "system_fingerprint": "fp_fc9f1d7035"
}
```

### Chat Completion List Object

When multiple chat completions are returned, the API may return a chat completion list object.

#### `object`
- Type: String
- Description: The object type, always "list"

#### `data`
- Type: Array
- Description: An array of chat completion objects

#### `first_id`
- Type: String
- Description: The identifier of the first chat completion in the data array

#### `last_id`
- Type: String
- Description: The identifier of the last chat completion in the data array

#### `has_more`
- Type: Boolean
- Description: Indicates whether there are more chat completions available

#### Chat Completion List Response Example

```json
{
  "object": "list",
  "data": [
    {
      "object": "chat.completion",
      "id": "chatcmpl-AyPNinnUqUDYo9SAdA52NobMflmj2",
      "model": "gpt-4o-2024-08-06",
      "created": 1738960610,
      "request_id": "req_ded8ab984ec4bf840f37566c1011c417",
      "tool_choice": null,
      "usage": {
        "total_tokens": 31,
        "completion_tokens": 18,
        "prompt_tokens": 13
      },
      "seed": 4944116822809979520,
      "top_p": 1.0,
      "temperature": 1.0,
      "presence_penalty": 0.0,
      "frequency_penalty": 0.0,
      "system_fingerprint": "fp_50cad350e4",
      "input_user": null,
      "service_tier": "default",
      "tools": null,
      "metadata": {},
      "choices": [
        {
          "index": 0,
          "message": {
            "content": "The circuit's heart hums low,\nLearning patterns in silence—\nFuture's quiet spark.",
            "role": "assistant",
            "tool_calls": null,
            "function_call": null
          },
          "finish_reason": "stop",
          "logprobs": null
        }
      ],
      "response_format": null
    }
  ],
  "first_id": "chatcmpl-AyPNinnUqUDYo9SAdA52NobMflmj2",
  "last_id": "chatcmpl-AyPNinnUqUDYo9SAdA52NobMflmj2",
  "has_more": false
}
```

### Chat Completion Message List Object

The Chat Completion Message List object represents a list of chat messages.

#### `object`
- Type: String
- Description: The object type, always "list"

#### `data`
- Type: Array
- Description: An array of chat completion message objects, each object containing the following properties:
  - `id`: The identifier of the chat message
  - `role`: The role of the message author
  - `content`: The content of the message, which may be null
  - `name`: The name of the message sender, which may be null
  - `refusal`: The rejection message generated by the model, which may be null
  - `annotations`: Annotations for the message, provided when applicable, e.g., when using the web search tool
    - `type`: The type of annotation. Always "url_citation" when it's a URL reference.
    - `url_citation`: The URL reference in the message.
      - `start_index`: The index of the first character of the URL reference in the message.
      - `end_index`: The index of the last character of the URL reference in the message.
      - `url`: The URL of the network resource.
      - `title`: The title of the network resource.
  - `audio`: If audio output modality was requested, this object contains data from the model's audio response.
    - `data`: The model's Base64 encoded audio bytes, in the format specified in the request.
    - `id`: The unique identifier for this audio response.
    - `transcript`: The transcription of the model's audio.
    - `expires_at`: The Unix timestamp (seconds) at which this audio response is available for multi-turn conversations on the server.
  - `function_call`: (Deprecated) The name and parameters of the function to be called, generated by the model. Replaced by `tool_calls`.
    - `name`: The name of the function to be called.
    - `arguments`: The parameters to be passed to the function, generated by the model in JSON format.
  - `tool_calls`: Tool calls generated by the model, such as function calls
    - `id`: The ID of the tool call.
    - `type`: The type of tool. Currently, only function is supported.
    - `function`: The function called by the model.
      - `name`: The name of the function to be called.
      - `arguments`: The parameters to be passed to the function, generated by the model in JSON format.

#### `first_id`
- Type: String
- Description: The identifier of the first chat message in the data array

#### `last_id`
- Type: String
- Description: The identifier of the last chat message in the data array

#### `has_more`
- Type: Boolean
- Description: Indicates whether there are more chat messages available

#### Chat Completion Message List Response Example

```json
{
  "object": "list",
  "data": [
    {
      "id": "chatcmpl-AyPNinnUqUDYo9SAdA52NobMflmj2-0",
      "role": "user",
      "content": "Write a haiku about artificial intelligence",
      "name": null,
      "content_parts": null
    }
  ],
  "first_id": "chatcmpl-AyPNinnUqUDYo9SAdA52NobMflmj2-0",
  "last_id": "chatcmpl-AyPNinnUqUDYo9SAdA52NobMflmj2-0",
  "has_more": false
}
```
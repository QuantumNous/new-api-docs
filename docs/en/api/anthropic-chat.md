# Anthropic Chat Format (Messages)

!!! info "Official Documentation"
    - [Anthropic Messages](https://docs.anthropic.com/en/api/messages)
    - [Anthropic Streaming Messages](https://docs.anthropic.com/en/api/messages-streaming)

## 📝 Introduction

Given a list of structured input messages containing text and/or image content, the model will generate the next message in the conversation. The Messages API can be used for single queries or stateless multi-turn conversations.

## 💡 Request Examples

### Basic Text Chat ✅

```bash
curl https://your-newapi-server-address/v1/messages \
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

**Response Example:**
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

### Image Analysis Chat ✅

```bash
curl https://your-newapi-server-address/v1/messages \
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
                    "text": "What's in this image?"
                }
            ]
        }
    ]
}'
```

**Response Example:**
```json
{
  "content": [
    {
      "text": "This image shows an orange cat sunbathing on a windowsill. The cat looks very relaxed, squinting its eyes while enjoying the sunlight. Some green plants can be seen outside the window.",
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

### Tool Calling ✅

```bash
curl https://your-newapi-server-address/v1/messages \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --header "x-api-key: $NEWAPI_API_KEY" \
     --data \
'{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [
        {
            "role": "user", 
            "content": "What's the weather like in Beijing today?"
        }
    ],
    "tools": [
        {
            "name": "get_weather",
            "description": "Get the current weather for a specified location",
            "input_schema": {
                "type": "object",
                "properties": {
                    "location": {
                        "type": "string",
                        "description": "City name, e.g.: Beijing"
                    }
                },
                "required": ["location"]
            }
        }
    ]
}'
```

**Response Example:**
```json
{
  "content": [
    {
      "type": "tool_use",
      "id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
      "name": "get_weather",
      "input": { "location": "Beijing" }
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

### Streaming Response ✅

```bash
curl https://your-newapi-server-address/v1/messages \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --header "x-api-key: $NEWAPI_API_KEY" \
     --data \
'{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [
        {
            "role": "user",
            "content": "Tell me a story"
        }
    ],
    "stream": true
}'
```

**Response Example:**
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

## 📮 Request

### Endpoints

```
POST /v1/messages
```

### Authentication Method

Include the following in the request headers for API key authentication:

```
x-api-key: $NEWAPI_API_KEY
```

Where `$NEWAPI_API_KEY` is your API key. You can obtain an API key from the console, and each key is limited to one workspace.

### Request Headers

#### `anthropic-beta`

- Type: String
- Required: No

Specify the beta version to use, supported by comma-separated lists like `beta1,beta2`, or specify this header multiple times.

#### `anthropic-version`

- Type: String
- Required: Yes

Specify the API version to use.

### Request Body Parameters

#### `max_tokens`

- Type: Integer
- Required: Yes

The maximum number of tokens to generate. Different models have different limits, see model documentation. Range `x > 1`.

#### `messages`

- Type: Array of objects
- Required: Yes

The input message list. The model is trained to alternate between user and assistant in the conversation. When creating a new message, you can use the `messages` parameter to specify previous conversation turns, and the model will generate the next message in the conversation. Consecutive user or assistant messages are merged into a single turn.

Each message must contain `role` and `content` fields. You can specify a single user role message, or include multiple user and assistant messages. If the last message uses the assistant role, the response content will continue directly from the content of that message, which can be used to constrain the model's response.

**Single User Message Example:**
```json
[{"role": "user", "content": "Hello, Claude"}]
```

**Multi-turn Conversation Example:**
```json
[
  {"role": "user", "content": "你好。"},
  {"role": "assistant", "content": "你好！我是 Claude。有什么可以帮你的吗？"},
  {"role": "user", "content": "请用简单的话解释什么是 LLM？"}
]
```

**Partially Filled Response Example:**
```json
[
  {"role": "user", "content": "太阳的希腊语名字是什么? (A) Sol (B) Helios (C) Sun"},
  {"role": "assistant", "content": "正确答案是 ("}
]
```

Each message's content can be a string or an array of content blocks. Using a string is equivalent to a shorthand for an array of "text" type content blocks. The following two statements are equivalent:

```json
{"role": "user", "content": "Hello, Claude"}
```

```json
{
  "role": "user", 
  "content": [{"type": "text", "text": "Hello, Claude"}]
}
```

Starting from Claude 3 model, you can also send image content blocks:

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
      "text": "What's in this image?"
    }
  ]
}
```

> Currently supported image formats include: base64, image/jpeg, image/png, image/gif, and image/webp.

##### `messages.role`

- Type: String
- Required: Yes
- Optional Values: user, assistant

Note: The Messages API does not have a "system" role, if a system prompt is needed, please use the top-level `system` parameter.

##### `messages.content`

- Type: String or Array of objects
- Required: Yes

The content of a message can be one of the following types:

###### Text Content (Text)

```json
{
  "type": "text",          // Required, enum value: "text"
  "text": "Hello, Claude", // Required, minimum length: 1
  "cache_control": {
    "type": "ephemeral"    // Optional, enum value: "ephemeral"
  }
}
```

###### Image Content (Image)

```json
{
  "type": "image",         // Required, enum value: "image"
  "source": {             // Required
    "type": "base64",     // Required, enum value: "base64"
    "media_type": "image/jpeg", // Required, supported: image/jpeg, image/png, image/gif, image/webp
    "data": "/9j/4AAQSkZJRg..."  // Required, base64 encoded image data
  },
  "cache_control": {
    "type": "ephemeral"    // Optional, enum value: "ephemeral"
  }
}
```

###### Tool Use (Tool Use)

```json
{
  "type": "tool_use",      // Required, enum value: "tool_use", default value
  "id": "toolu_xyz...",    // Required, unique identifier for tool use
  "name": "get_weather",   // Required, tool name, minimum length: 1
  "input": {              // Required, object containing tool input parameters
    // Tool input parameters, specific format defined by tool's input_schema
  },
  "cache_control": {
    "type": "ephemeral"    // Optional, enum value: "ephemeral"
  }
}
```

###### Tool Result (Tool Result)

```json
{
  "type": "tool_result",   // Required, enum value: "tool_result"
  "tool_use_id": "toolu_xyz...",  // Required
  "content": "Result content",   // Required, can be string or array of content blocks
  "is_error": false,      // Optional, boolean
  "cache_control": {
    "type": "ephemeral"    // Optional, enum value: "ephemeral"
  }
}
```

When content is an array of content blocks, each content block can be text or image:

```json
{
  "type": "tool_result",
  "tool_use_id": "toolu_xyz...",
  "content": [
    {
      "type": "text",      // Required, enum value: "text"
      "text": "Analysis result",   // Required, minimum length: 1
      "cache_control": {
        "type": "ephemeral" // Optional, enum value: "ephemeral"
      }
    },
    {
      "type": "image",     // Required, enum value: "image"
      "source": {         // Required
        "type": "base64", // Required, enum value: "base64"
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

###### Document (Document)

```json
{
  "type": "document",      // Required, enum value: "document"
  "source": {             // Required
    // Document source data
  },
  "cache_control": {
    "type": "ephemeral"    // Optional, enum value: "ephemeral"
  }
}
```

Note:
1. Each type can optionally include a `cache_control` field to control content caching
2. The minimum length of text content is 1
3. All type fields are required enum strings
4. The `content` field of tool results supports string or array of content blocks containing text/image

#### `model`

- Type: String
- Required: Yes

The model name to use, see model documentation. Range `1 - 256` characters.

#### `metadata`

- Type: Object
- Required: No

An object describing the request metadata. Includes the following optional fields:

- `user_id`: An external identifier for the user associated with the request. It should be a uuid, hash, or other opaque identifier. Do not include any identifying information such as name, email, or phone number. Maximum length: 256.

#### `stop_sequences`

- Type: Array of strings
- Required: No

Custom text sequences to stop generation.

#### `stream`

- Type: Boolean
- Required: No

Whether to use server-sent events (SSE) to incrementally return response content.

#### `system`

- Type: String
- Required: No

System prompt, provides background and instructions to Claude. This is a way to provide context and specific goals or roles to the model. Note that this is different from the `role` in messages, and the Messages API does not have a "system" role.

#### `temperature`

- Type: Number
- Required: No
- Default: 1.0

Controls the randomness of generation, 0.0 - 1.0. Range `0 < x < 1`. It is recommended to use a value close to 0.0 for analytical/multiple-choice tasks, and a value close to 1.0 for creative and generative tasks.

Note: Even if temperature is set to 0.0, the result will not be completely deterministic.

#### 🆕 `thinking`

- Type: Object
- Required: No

Configures Claude's extended thinking function. When enabled, the response will include content blocks showing Claude's thought process before giving the final answer. Requires at least 1,024 tokens of budget and is counted towards your max_tokens limit.

Can be set to one of the following two modes:

##### 1. Enabled Mode

```json
{
  "type": "enabled",
  "budget_tokens": 2048
}
```

- `type`: Required, enum value: "enabled"
- `budget_tokens`: Required, integer. Determines the number of tokens that Claude can use for internal reasoning processes. A larger budget allows the model to perform more in-depth analysis on complex questions, improving response quality. Must be ≥1024 and less than max_tokens. Range `x > 1024`.

##### 2. Disabled Mode

```json
{
  "type": "disabled"
}
```

- `type`: Required, enum value: "disabled"

#### `tool_choice`

- Type: Object
- Required: No

Controls how the model uses the provided tools. Can be one of the following three types:

##### 1. Auto Mode (Automatic Selection)

```json
{
  "type": "auto",  // Required, enum value: "auto"
  "disable_parallel_tool_use": false  // Optional, default false. If true, the model will only use one tool at most
}
```

##### 2. Any Mode (Any Tool)

```json
{
  "type": "any",  // Required, enum value: "any"
  "disable_parallel_tool_use": false  // Optional, default false. If true, the model will exactly use one tool
}
```

##### 3. Tool Mode (Specific Tool)

```json
{
  "type": "tool",  // Required, enum value: "tool"
  "name": "get_weather",  // Required, specify the tool name to use
  "disable_parallel_tool_use": false  // Optional, default false. If true, the model will exactly use one tool
}
```

Note:
1. Auto Mode: The model can decide whether to use tools on its own
2. Any Mode: The model must use tools, but can choose any available tool
3. Tool Mode: The model must use the specified tool

#### `tools`

- Type: Array of objects
- Required: No

Defines the tools that the model might use. Tools can be custom tools or built-in tool types:

##### 1. Custom Tool (Tool)

Each custom tool definition includes:

- `type`: Optional, enum value: "custom"
- `name`: Tool name, required, 1-64 characters
- `description`: Tool description, recommended to be as detailed as possible
- `input_schema`: JSON Schema definition for tool input, required
- `cache_control`: Cache control, optional, type is "ephemeral"

Example:
```json
[
  {
    "type": "custom",
    "name": "get_weather",
    "description": "Get the current weather for a specified location",
    "input_schema": {
      "type": "object",
      "properties": {
        "location": {
          "type": "string",
          "description": "City name, e.g.: Beijing"
        }
      },
      "required": ["location"]
    }
  }
]
```

##### 2. Computer Tool (ComputerUseTool)

```json
{
  "type": "computer_20241022",  // Required
  "name": "computer",           // Required, enum value: "computer"
  "display_width_px": 1024,     // Required, display width (pixels)
  "display_height_px": 768,     // Required, display height (pixels)
  "display_number": 0,          // Optional, X11 display number
  "cache_control": {
    "type": "ephemeral"         // Optional
  }
}
```

##### 3. Bash Tool (BashTool)

```json
{
  "type": "bash_20241022",      // Required
  "name": "bash",               // Required, enum value: "bash"
  "cache_control": {
    "type": "ephemeral"         // Optional
  }
}
```

##### 4. Text Editor Tool (TextEditor)

```json
{
  "type": "text_editor_20241022", // Required
  "name": "str_replace_editor",   // Required, enum value: "str_replace_editor"
  "cache_control": {
    "type": "ephemeral"           // Optional
  }
}
```

When the model uses a tool, it returns a tool_use content block:

```json
[
  {
    "type": "tool_use",
    "id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
    "name": "get_weather",
    "input": { "location": "Beijing" }
  }
]
```

You can execute a tool and return the result via a tool_result content block:

```json
[
  {
    "type": "tool_result",
    "tool_use_id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
    "content": "The weather in Beijing today is sunny, with a temperature of 25°C"
  }
]
```

#### `top_k`

- Type: Integer
- Required: No
- Range: x > 0

Samples from the top K options of tokens. Used to remove "long tail" responses with low probabilities. It is recommended to only use this in advanced use cases, usually only adjusting temperature is sufficient.

#### `top_p`

- Type: Number
- Required: No
- Range: 0 < x < 1

Uses nucleus sampling. Calculates the cumulative distribution of probabilities for each subsequent token in descending order, truncates when the probability reaches the specified top_p. It is recommended to adjust only one of temperature or top_p, not both.

## 📥 Response

### Successful Response

Returns a chat completion object, containing the following fields:

#### `content`

- Type: Array of objects
- Required: Yes

The content generated by the model, consisting of multiple content blocks. Each content block has a type that determines its shape. Content blocks can be one of the following types:

##### Text Content Block (Text)

```json
{
  "type": "text",          // Required, enum value: "text", default value
  "text": "你好，我是 Claude。" // Required, maximum length: 5000000, minimum length: 1
}
```

##### Tool Use Content Block (Tool Use)

```json
{
  "type": "tool_use",      // Required, enum value: "tool_use", default value
  "id": "toolu_xyz...",    // Required, unique identifier for tool use
  "name": "get_weather",   // Required, tool name, minimum length: 1
  "input": {              // Required, object containing tool input parameters
    // Tool input parameters, specific format defined by tool's input_schema
  }
}
```

Example:
```json
// Text content example
[{"type": "text", "text": "你好，我是 Claude。"}]

// Tool use example
[{
  "type": "tool_use",
  "id": "toolu_xyz...",
  "name": "get_weather",
  "input": { "location": "Beijing" }
}]

// Mixed content example
[
  {"type": "text", "text": "根据天气查询结果："},
  {
    "type": "tool_use",
    "id": "toolu_xyz...",
    "name": "get_weather",
    "input": { "location": "Beijing" }
  }
]
```

If the last message in the request was an assistant role, the response content will continue directly from that message. For example:

```json
// Request
[
  {"role": "user", "content": "太阳的希腊语名字是什么? (A) Sol (B) Helios (C) Sun"},
  {"role": "assistant", "content": "正确答案是 ("}
]

// Response
[{"type": "text", "text": "B)"}]
```

#### `id`

- Type: String
- Required: Yes

The unique identifier for the response.

#### `model`

- Type: String
- Required: Yes

The model name used.

#### `role`

- Type: String
- Required: Yes
- Default: assistant

The session role for the generated message, always "assistant".

#### `stop_reason`

- Type: String or null
- Required: Yes

The reason for stopping generation, possible values include:

- `"end_turn"`: Model reached a natural stopping point
- `"max_tokens"`: Exceeded requested max_tokens or model's maximum limit
- `"stop_sequence"`: Generated one of the custom stop sequences
- `"tool_use"`: Model called one or more tools

This value is always non-empty in non-streaming mode. In streaming mode, it is null in the `message_start` event, and non-null otherwise.

#### `stop_sequence`

- Type: String or null
- Required: Yes

The generated custom stop sequence. If the model encountered one of the stop_sequences specified in the `stop_sequences` parameter, this field will contain that matching stop sequence. If not stopped by a stop sequence, it is null.

#### `type`

- Type: String
- Required: Yes
- Default: message
- Optional: message

Object type, always "message" for Messages.

#### `usage`

- Type: Object
- Required: Yes

Usage statistics related to billing and rate limits. Includes the following fields:

- `input_tokens`: Number of input tokens used, required, range x > 0
- `output_tokens`: Number of output tokens used, required, range x > 0
- `cache_creation_input_tokens`: Number of input tokens used to create cache entries (if applicable), required, range x > 0
- `cache_read_input_tokens`: Number of input tokens read from cache (if applicable), required, range x > 0

Note: Due to API internal transformations and parsing, token counts may not exactly correspond to the actual visible content of requests and responses. For example, even an empty string response will have a non-zero output_tokens value.

### Error Response

When a request encounters an issue, the API will return an error response object, with HTTP status codes in the 4XX-5XX range.

#### Common Error Status Codes

- `401 Unauthorized`: Invalid API key or not provided
- `400 Bad Request`: Invalid request parameters
- `429 Too Many Requests`: Exceeded API call limit
- `500 Internal Server Error`: Server internal error

Error response example:

```json
{
  "error": {
    "type": "invalid_request_error",
    "message": "Invalid API key provided",
    "code": "invalid_api_key"
  }
}
```

Main error types:

- `invalid_request_error`: Request parameter error
- `authentication_error`: Authentication related error
- `rate_limit_error`: Request frequency exceeded
- `server_error`: Server internal error
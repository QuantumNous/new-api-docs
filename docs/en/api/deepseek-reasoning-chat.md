# Deepseek Reasoning Chat Format (Reasoning Content)

!!! info "Official Documentation"
    [Reasoning Model (deepseek-reasoner)](https://api-docs.deepseek.com/en/guides/reasoning_model)

## 📝 Introduction

Deepseek-reasoner is a reasoning model launched by DeepSeek. Before outputting the final answer, the model will first output a chain-of-thought (reasoning content) to improve the accuracy of the final answer. The API exposes the deepseek-reasoner chain-of-thought content for users to view, display, or distill.

## 💡 Request Examples

### Basic Text Chat ✅

```bash
curl https://api.deepseek.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "deepseek-reasoner",
    "messages": [
      {
        "role": "user",
        "content": "9.11 and 9.8, which is greater?"
      }
    ],
    "max_tokens": 4096
  }'
```

**Response Example:**

```json
{
  "id": "chatcmpl-123",
  "object": "chat.completion",
  "created": 1677652288,
  "model": "deepseek-reasoner",
  "choices": [{
    "index": 0,
    "message": {
      "role": "assistant",
      "reasoning_content": "Let me think step by step:\n1. We need to compare 9.11 and 9.8\n2. Both numbers are decimals, we can compare directly\n3. 9.8 = 9.80\n4. 9.11 < 9.80\n5. So 9.8 is greater",
      "content": "9.8 is greater than 9.11."
    },
    "finish_reason": "stop"
  }],
  "usage": {
    "prompt_tokens": 10,
    "completion_tokens": 15,
    "total_tokens": 25
  }
}
```

### Streaming Response ✅

```bash
curl https://api.deepseek.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "deepseek-reasoner",
    "messages": [
      {
        "role": "user",
        "content": "9.11 and 9.8, which is greater?"
      }
    ],
    "stream": true
  }'
```

**Streaming Response Example:**

```jsonl
{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1694268190,"model":"deepseek-reasoner","choices":[{"index":0,"delta":{"role":"assistant","reasoning_content":"Let me"},"finish_reason":null}]}

{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1694268190,"model":"deepseek-reasoner","choices":[{"index":0,"delta":{"reasoning_content":"think step by step"},"finish_reason":null}]}

{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1694268190,"model":"deepseek-reasoner","choices":[{"index":0,"delta":{"reasoning_content":":"},"finish_reason":null}]}

// ... more reasoning content ...

{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1694268190,"model":"deepseek-reasoner","choices":[{"index":0,"delta":{"content":"9.8"},"finish_reason":null}]}

{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1694268190,"model":"deepseek-reasoner","choices":[{"index":0,"delta":{"content":" is greater"},"finish_reason":null}]}

// ... more final answer content ...

{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1694268190,"model":"deepseek-reasoner","choices":[{"index":0,"delta":{},"finish_reason":"stop"}]}
```

## 📮 Request

### Endpoint

```
POST /v1/chat/completions
```

### Authentication Method

Include the following in the request header for API key authentication:

```
Authorization: Bearer $NEWAPI_API_KEY
```

Where `$DEEPSEEK_API_KEY` is your API key.

### Request Body Parameters

#### `messages`

- Type: Array
- Required: Yes

The list of messages in the conversation so far. Note: If you pass reasoning_content in the input messages sequence, the API will return a 400 error.

#### `model`

- Type: String  
- Required: Yes
- Value: deepseek-reasoner

The model ID to use. Currently only deepseek-reasoner is supported.

#### `max_tokens`

- Type: Integer
- Required: No
- Default: 4096
- Max: 8192

The maximum length of the final answer (excluding reasoning content). Note: The output of the reasoning content can be up to 32K tokens.

#### `stream`

- Type: Boolean
- Required: No
- Default: false

Whether to use streaming response.

### Unsupported Parameters

The following parameters are currently not supported:

- temperature
- top_p  
- presence_penalty
- frequency_penalty
- logprobs
- top_logprobs

Note: For compatibility with existing software, setting temperature, top_p, presence_penalty, frequency_penalty will not cause an error, but will not take effect. Setting logprobs or top_logprobs will cause an error.

### Supported Features

- Chat completion
- Chat prefix continuation (Beta)

### Unsupported Features

- Function Call
- Json Output  
- FIM Completion (Beta)

## 📥 Response

### Successful Response

Returns a chat completion object. If the request is streamed, returns a streaming sequence of chat completion chunk objects.

#### `id` 
- Type: String
- Description: Unique identifier for the response

#### `object`
- Type: String  
- Description: Object type, value is "chat.completion"

#### `created`
- Type: Integer
- Description: Response creation timestamp

#### `model`
- Type: String
- Description: Model name used, value is "deepseek-reasoner"

#### `choices`
- Type: Array
- Description: Contains generated reply options
- Properties:
  - `index`: Option index
  - `message`: Message object containing role, reasoning content, and final answer
    - `role`: Role, value is "assistant"
    - `reasoning_content`: Chain-of-thought content
    - `content`: Final answer content
  - `finish_reason`: Finish reason

#### `usage`
- Type: Object
- Description: Token usage statistics
- Properties:
  - `prompt_tokens`: Number of tokens used for prompt
  - `completion_tokens`: Number of tokens used for completion
  - `total_tokens`: Total number of tokens

## 📝 Context Concatenation Explanation

In each round of conversation, the model outputs reasoning_content (chain-of-thought) and the final answer (content). In the next round of conversation, the reasoning_content output from the previous round will NOT be concatenated into the context, as shown below:

![Deepseek reasoning context concatenation diagram](../assets/deepseek_r1_multiround_example_cn.png)

!!! warning "Note"
    If you pass reasoning_content in the input messages sequence, the API will return a 400 error. Therefore, please remove the reasoning_content field from the API response before making the next API request, as shown in the usage example below.

Usage Example:

```python
from openai import OpenAI
client = OpenAI(api_key="<DeepSeek API Key>", base_url="https://api.deepseek.com")

# First round of conversation
messages = [{"role": "user", "content": "9.11 and 9.8, which is greater?"}]
response = client.chat.completions.create(
    model="deepseek-reasoner",
    messages=messages
)

reasoning_content = response.choices[0].message.reasoning_content
content = response.choices[0].message.content

# Second round of conversation - only concatenate the final answer content
messages.append({'role': 'assistant', 'content': content})
messages.append({'role': 'user', 'content': "How many Rs are there in the word 'strawberry'?"})
response = client.chat.completions.create(
    model="deepseek-reasoner", 
    messages=messages
)
```

Streaming response example:

```python
# First round of conversation
messages = [{"role": "user", "content": "9.11 and 9.8, which is greater?"}]
response = client.chat.completions.create(
    model="deepseek-reasoner",
    messages=messages,
    stream=True
)

reasoning_content = ""
content = ""

for chunk in response:
    if chunk.choices[0].delta.reasoning_content:
        reasoning_content += chunk.choices[0].delta.reasoning_content
    else:
        content += chunk.choices[0].delta.content

# Second round of conversation - only concatenate the final answer content
messages.append({"role": "assistant", "content": content})
messages.append({'role': 'user', 'content': "How many Rs are there in the word 'strawberry'?"})
response = client.chat.completions.create(
    model="deepseek-reasoner",
    messages=messages,
    stream=True
)
```


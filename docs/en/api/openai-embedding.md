# OpenAI Embeddings Format

!!! info "Official Documentation"
    [OpenAI Embeddings](https://platform.openai.com/docs/api-reference/embeddings)

## 📝 Introduction

Get vector representations of given input text that can be easily used by machine learning models and algorithms. For related guides, see [Embeddings Guide](https://platform.openai.com/docs/guides/embeddings).

Important notes:

- Some models may have limits on the total number of tokens in the input

- You can use [example Python code](https://github.com/openai/openai-cookbook/blob/main/examples/How_to_count_tokens_with_tiktoken.ipynb) to calculate token counts

- For example: the text-embedding-ada-002 model outputs vectors with 1536 dimensions

## 💡 Request Examples

### Create Text Embeddings ✅

```bash
curl https://your-newapi-server-address/v1/embeddings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "input": "The food was delicious and the waiter...",
    "model": "text-embedding-ada-002",
    "encoding_format": "float"
  }'
```

**Response Example:**

```json
{
  "object": "list",
  "data": [
    {
      "object": "embedding",
      "embedding": [
        0.0023064255,
        -0.009327292,
        // ... (1536 floating point numbers for ada-002)
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

### Batch Create Embeddings ✅

```bash
curl https://your-newapi-server-address/v1/embeddings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "input": ["The food was delicious", "The waiter was friendly"],
    "model": "text-embedding-ada-002",
    "encoding_format": "float"
  }'
```

**Response Example:**

```json
{
  "object": "list",
  "data": [
    {
      "object": "embedding",
      "embedding": [
        0.0023064255,
        // ... (1536 floating point numbers)
      ],
      "index": 0
    },
    {
      "object": "embedding",
      "embedding": [
        -0.008815289,
        // ... (1536 floating point numbers)  
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

## 📮 Request

### Endpoint

```
POST /v1/embeddings
```

Create embedding vectors that represent the input text.

### Authentication Method

Include the following in the request header for API key authentication:

```
Authorization: Bearer $NEWAPI_API_KEY
```

Where `$NEWAPI_API_KEY` is your API key.

### Request Body Parameters

#### `input`

- Type: String or array
- Required: Yes

The input text to embed, encoded as a string or array of tokens. To embed multiple inputs in a single request, pass an array of strings or an array of token arrays. Input must not exceed the model's maximum input token count (8192 tokens for text-embedding-ada-002), cannot be an empty string, and any array must have dimensions less than or equal to 2048.

#### `model`

- Type: String
- Required: Yes

The ID of the model to use. You can use the List models API to see all available models, or see the model overview for their descriptions.

#### `encoding_format`

- Type: String
- Required: No
- Default: float

The format to return the embeddings in. Can be float or base64.

#### `dimensions`

- Type: Integer
- Required: No

The number of dimensions the generated output embeddings should have. Only supported in text-embedding-3 and newer models.

#### `user`

- Type: String
- Required: No

A unique identifier representing your end user, which can help OpenAI monitor and detect abuse. [Learn more](https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids).

## 📥 Response

### Successful Response

Returns a list of embedding objects.

#### `object`

- Type: String
- Description: Object type, value is "list"

#### `data`

- Type: Array
- Description: Array containing embedding objects
- Properties:
  - `object`: Object type, value is "embedding"
  - `embedding`: Embedding vector, list of floating point numbers. Vector length depends on the model
  - `index`: Index of the embedding in the list

#### `model`

- Type: String
- Description: Name of the model used

#### `usage`

- Type: Object
- Description: Token usage statistics
- Properties:
  - `prompt_tokens`: Number of tokens used for prompt
  - `total_tokens`: Total number of tokens

### Embedding Object

Represents an embedding vector returned by the embeddings endpoint.

```json
{
  "object": "embedding",
  "embedding": [
    0.0023064255,
    -0.009327292,
    // ... (1536 floating point numbers total for ada-002)
    -0.0028842222
  ],
  "index": 0
}
```

#### `index`

- Type: Integer
- Description: Index of the embedding in the list

#### `embedding` 

- Type: Array
- Description: Embedding vector, list of floating point numbers. Vector length depends on the model, see embeddings guide for details

#### `object`

- Type: String
- Description: Object type, always "embedding" 

### Error Response

When there are issues with the request, the API will return an error response object with HTTP status codes in the 4XX-5XX range.

#### Common Error Status Codes

- `401 Unauthorized`: Invalid or missing API key
- `400 Bad Request`: Invalid request parameters, such as empty input or exceeding token limits
- `429 Too Many Requests`: API call limit exceeded
- `500 Internal Server Error`: Internal server error

Error response example:

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

# Jina AI Rerank Format

!!! info "Official Documentation"
    [Jina AI Rerank](https://jina.ai/reranker)

!!! note "Standard Format"
    In New API, Jina AI's rerank format is adopted as the standard format. All other vendors' (such as Xinference, Cohere, etc.) rerank responses will be formatted to Jina AI's format to provide a unified development experience.

## 📝 Introduction

Jina AI Rerank is a powerful text reranking model that can sort document lists by relevance based on queries. The model supports multiple languages and can process text content in different languages, assigning relevance scores to each document.

## 💡 Request Examples

### Basic Rerank Request ✅

```bash
curl https://your-newapi-server-address/v1/rerank \
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

**Response Example:**

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

## 📮 Request

### Endpoint

```
POST /v1/rerank
```

### Authentication Method

Include the following in the request header for API key authentication:

```
Authorization: Bearer $NEWAPI_API_KEY
```

Where `$NEWAPI_API_KEY` is your API key.

### Request Body Parameters

#### `model`
- Type: String
- Required: No
- Default: jina-reranker-v2-base-multilingual
- Description: The reranking model to use

#### `query`
- Type: String
- Required: Yes
- Description: Query text used to sort documents by relevance

#### `top_n`
- Type: Integer
- Required: No
- Default: No limit
- Description: Return the top N documents after sorting

#### `documents`
- Type: Array of strings
- Required: Yes
- Description: List of documents to be reranked
- Limit: Each document's length should not exceed the model's maximum token limit

## 📥 Response

### Successful Response

#### `results`
- Type: Array
- Description: List of reranked documents
- Properties:
  - `document`: Object containing document text
  - `index`: Document's index in the original list
  - `relevance_score`: Relevance score (between 0-1)

#### `usage`
- Type: Object
- Description: Token usage statistics
- Properties:
  - `prompt_tokens`: Number of tokens used for prompt
  - `completion_tokens`: Number of tokens used for completion
  - `total_tokens`: Total number of tokens
  - `prompt_tokens_details`: Detailed prompt token information
    - `cached_tokens`: Number of cached tokens
    - `audio_tokens`: Number of audio tokens
  - `completion_tokens_details`: Detailed completion token information
    - `reasoning_tokens`: Number of reasoning tokens
    - `audio_tokens`: Number of audio tokens
    - `accepted_prediction_tokens`: Number of accepted prediction tokens
    - `rejected_prediction_tokens`: Number of rejected prediction tokens

### Error Response

When there are issues with the request, the API will return an error response:

- `400 Bad Request`: Invalid request parameters
- `401 Unauthorized`: Invalid or missing API key
- `429 Too Many Requests`: Request frequency limit exceeded
- `500 Internal Server Error`: Internal server error

## 💡 Best Practices

### Query Optimization Suggestions

1. Use clear and specific query text
2. Avoid overly broad or vague queries
3. Ensure the query uses the same language style as the documents

### Document Processing Suggestions

1. Keep document length moderate, don't exceed model limits
2. Ensure document content is complete and meaningful
3. Can include multilingual documents, the model supports cross-language matching

### Performance Optimization

1. Reasonably set the top_n parameter to reduce unnecessary calculations
2. For large numbers of documents, consider batch processing
3. Can cache results for common queries

### Multilingual Support

This model supports document reranking in multiple languages, including but not limited to:

- English
- Chinese
- German
- Spanish
- Japanese
- French

No need to specify language parameters, the model will automatically identify and process content in different languages.

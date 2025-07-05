# Cohere Rerank Format

!!! warning "Important Note"
    The interface format of Cohere's Rerank model is the same as [Jina's Rerank model interface](jinaai-rerank.md).

!!! info "Official Documentation"
    [Cohere Rerank](https://docs.cohere.com/reference/rerank)

## 📝 Introduction

Given a query and a list of texts, the Rerank API will sort the texts based on their relevance to the query. Each text is assigned a relevance score, resulting in an ordered array of results. This feature is especially useful for search and retrieval applications, optimizing document ranking and helping users find relevant information faster.

## 💡 Request Examples

### Basic Rerank Request ✅

```bash
curl https://your-newapi-server-address/v1/rerank \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "rerank-v3.5",
    "query": "What is the capital of the United States?",
    "documents": [
      "The capital of Nevada is Carson City.",
      "The Northern Mariana Islands are a group of islands in the Pacific, with Saipan as the capital.",
      "Washington, D.C. (also known as Washington or D.C., officially the District of Columbia) is the capital of the United States.",
      "Capitalization in English grammar is the use of uppercase letters at the beginning of words. English usage differs from other languages in capitalization.",
      "The death penalty existed in the United States before it became a country. As of 2017, 30 out of 50 states have the death penalty legalized."
    ],
    "top_n": 3
  }'
```

**Response Example:**

```json
{
  "results": [
    {
      "index": 2,
      "relevance_score": 0.999071
    },
    {
      "index": 0,
      "relevance_score": 0.32713068
    },
    {
      "index": 1,
      "relevance_score": 0.1867867
    }
  ],
  "id": "07734bd2-2473-4f07-94e1-0d9f0e6843cf",
  "meta": {
    "api_version": {
      "version": "2",
      "is_experimental": false
    },
    "billed_units": {
      "search_units": 1
    }
  }
}
```

### Using Structured Data ✅

```bash
curl https://your-newapi-server-address/v1/rerank \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "rerank-v3.5",
    "query": "Looking for a cost-effective DSLR camera for beginners",
    "documents": [
      "Model: Canon EOS 800D\nPrice: 4299 yuan\nFeatures: 24.1MP, optical viewfinder, Wi-Fi\nSuitable for: Beginners, enthusiasts",
      "Model: Nikon D3500\nPrice: 3099 yuan\nFeatures: 24.16MP, optical viewfinder, battery life up to 1550 shots\nSuitable for: Newbies, students",
      "Model: Sony A7III\nPrice: 12999 yuan\nFeatures: 24.2MP, full-frame, 4K video\nSuitable for: Professional photographers, video creators"
    ],
    "max_tokens_per_doc": 512
  }'
```

**Response Example:**

```json
{
  "results": [
    {
      "index": 1,
      "relevance_score": 0.918472
    },
    {
      "index": 0,
      "relevance_score": 0.854321
    },
    {
      "index": 2,
      "relevance_score": 0.423156
    }
  ],
  "id": "8f734bd2-2473-4f07-94e1-0d9f0e68ebfa",
  "meta": {
    "api_version": {
      "version": "2"
    },
    "billed_units": {
      "search_units": 1
    }
  }
}
```

## 📮 Request

### Endpoint

```
POST /v1/rerank
```

Sort a list of texts based on their relevance to the query.

### Authentication Method

Include the following in the request header for API key authentication:

```
Authorization: Bearer $NEWAPI_API_KEY
```

Where `$NEWAPI_API_KEY` is your API key.

### Request Header Parameters

#### `X-Client-Name`
- Type: String
- Required: No
- Description: Project name initiating the request.

### Request Body Parameters

#### `model`
- Type: String
- Required: Yes
- Description: Model identifier to use, e.g., rerank-v3.5.

#### `query`
- Type: String
- Required: Yes
- Description: Search query text. This is the user's question or query content.

#### `documents`
- Type: Array of strings
- Required: Yes
- Description: List of texts to compare with the query. For best performance, do not send more than 1,000 documents in a single request.
- Notes:
  - Long documents will be automatically truncated to the value specified by max_tokens_per_doc
  - Structured data should be formatted as YAML strings for best performance

#### `top_n`
- Type: Integer
- Required: No
- Description: Limit the number of reranked results returned. If not specified, all reranked results will be returned.

#### `max_tokens_per_doc`
- Type: Integer
- Required: No
- Default: 4096
- Description: Long documents will be automatically truncated to the specified number of tokens.

## 📥 Response

### Successful Response

Returns an object containing the sorted list of documents.

#### `results`
- Type: Array of objects
- Description: List of sorted documents, in descending order of relevance
- Properties:
  - `index`: Integer, the index of the document in the original list
  - `relevance_score`: Float, relevance score in the range [0, 1]. A score close to 1 indicates high relevance, close to 0 indicates low relevance

#### `id`
- Type: String
- Description: Unique identifier for the request

#### `meta`
- Type: Object
- Description: Contains metadata about the request
- Properties:
  - `api_version`: Object, contains API version info
    - `version`: String, API version number
    - `is_deprecated`: Boolean, whether deprecated
    - `is_experimental`: Boolean, whether experimental
  - `billed_units`: Object, contains billing info
    - `search_units`: Float, number of billed search units
  - `tokens`: Object, contains token usage statistics
    - `input_tokens`: Float, number of tokens as model input
    - `output_tokens`: Float, number of tokens generated by the model

#### `warnings`
- Type: Array of strings
- Required: No
- Description: Warning messages returned by the API

### Error Response

When a request encounters an issue, the API may return the following HTTP status codes and corresponding errors:

- `400 Bad Request`: Request format or parameter error
- `401 Unauthorized`: No valid API key provided
- `403 Forbidden`: No permission to access this resource
- `404 Not Found`: Requested resource does not exist
- `422 Unprocessable Entity`: Request is well-formed but contains semantic errors
- `429 Too Many Requests`: Request rate exceeds the limit
- `500 Internal Server Error`: Server internal error
- `503 Service Unavailable`: Service temporarily unavailable

## 🌟 Best Practices

### Document Preparation Tips

1. **Document Length**: Keep each document concise and clear, avoid being too long. Long documents will be automatically truncated.
   
2. **Structured Data**: Format structured data as YAML strings for best performance. For example:
   ```yaml
   title: Product Name
   price: 9999 yuan
   features:
     - Feature 1
     - Feature 2
   ```

3. **Number of Documents**: Do not exceed 1,000 documents per request for best performance.

### Query Optimization

1. **Be Specific**: Formulate clear and specific queries for more accurate ranking results.

2. **Avoid Vague Queries**: Avoid overly vague or generic queries, as this may result in less distinct relevance scores.

### Understanding Relevance Scores

Relevance scores are normalized to the range [0, 1]:

- Scores close to 1 indicate high relevance to the query
- Scores close to 0 indicate low relevance

# Xinference Rerank Format

!!! warning "Important Note"
    In New API, Xinference's rerank response structure will be formatted as Jina's rerank response structure, with the same usage as Jina's rerank. **For Dify and other client users**: When configuring, please select **Jina AI** as the provider type, not Xinference, and use the model names supported by Xinference.

## 📝 Introduction

Xinference's rerank API is fully compatible with Jina AI's rerank API. Please refer to the [Jina AI Rerank Format](jinaai-rerank.md) documentation for detailed usage methods, request parameters, and response formats.

## 💡 Usage

When using Xinference rerank API, simply set the `model` parameter to a rerank model supported by Xinference. All other parameters and usage methods are the same as Jina AI's rerank API.

### Example Request

```bash
curl https://your-newapi-server-address/v1/rerank \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "jina-reranker-v2",
    "query": "What is the capital of the United States?",
    "documents": [
      "The capital of Nevada is Carson City.",
      "The Northern Mariana Islands are a group of islands in the Pacific Ocean, with Saipan as their capital.",
      "Washington, D.C. (also known as Washington or D.C., officially the District of Columbia) is the capital of the United States.",
      "Capitalization in English grammar is the use of capital letters at the beginning of words. English usage differs from capitalization in other languages.",
      "The death penalty has existed in the United States since before it became a country. As of 2017, the death penalty is legal in 30 of the 50 states."
    ],
    "top_n": 3
  }'
```

For more detailed information, please refer to the [Jina AI Rerank Format](jinaai-rerank.md) documentation.
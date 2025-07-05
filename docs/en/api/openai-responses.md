# OpenAI Response Format (Responses)

!!! info "Official Documentation"
    [OpenAI Responses](https://platform.openai.com/docs/api-reference/responses)

## 📝 Introduction

OpenAI's most advanced model response interface. Supports text and image input, as well as text output. Creates stateful interactions with models, using previous response outputs as input. Extends model capabilities through built-in tools such as file search, web search, computer usage, etc. Uses function calling to allow models to access external systems and data.

For related guidelines, please refer to the OpenAI official website: [Responses](https://platform.openai.com/docs/guides/responses)

## 💡 Request Examples

### Basic Text Response ✅

```bash
curl https://your-newapi-server-address/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "input": "Tell a three-sentence bedtime story about a unicorn."
  }'
```

**Response Example:**

```json
{
  "id": "resp_67ccd2bed1ec8190b14f964abc0542670bb6a6b452d3795b",
  "object": "response",
  "created_at": 1741476542,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4.1",
  "output": [
    {
      "type": "message",
      "id": "msg_67ccd2bf17f0819081ff3bb2cf6508e60bb6a6b452d3795b",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "On a peaceful moonlit night, a unicorn named Lumina discovered a hidden pool reflecting the stars. When she dipped her horn into the water, the pool began to shimmer, revealing a path to a magical world with endless night skies. Filled with wonder, Lumina made a wish for all dreamers to find their own hidden magic, and as she looked back, her hoofprints sparkled like stardust.",
          "annotations": []
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 36,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 87,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 123
  },
  "user": null,
  "metadata": {}
}
```

### Image Analysis Response ✅

```bash
curl https://your-newapi-server-address/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "input": [
      {
        "role": "user",
        "content": [
          {"type": "input_text", "text": "Describe what's in this image"},
          {
            "type": "input_image",
            "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg"
          }
        ]
      }
    ]
  }'
```

**Response Example:**

```json
{
  "id": "resp_67ccd3a9da748190baa7f1570fe91ac604becb25c45c1d41",
  "object": "response",
  "created_at": 1741476777,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4.1",
  "output": [
    {
      "type": "message",
      "id": "msg_67ccd3acc8d48190a77525dc6de64b4104becb25c45c1d41",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "This image shows a wooden boardwalk or path through dense green grass, with a blue sky dotted with a few clouds above. The scene presents a peaceful natural area, possibly a park or nature reserve. There are trees and shrubs in the background. The entire landscape showcases a harmonious natural environment, with the boardwalk providing visitors a path through wetlands or grasslands without affecting the surrounding ecosystem.",
          "annotations": []
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 328,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 52,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 380
  },
  "user": null,
  "metadata": {}
}
```

### Web Search Tool ✅

```bash
curl https://your-newapi-server-address/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "tools": [{ "type": "web_search_preview" }],
    "input": "What are some positive news stories today?"
  }'
```

**Response Example:**

```json
{
  "id": "resp_67ccf18ef5fc8190b16dbee19bc54e5f087bb177ab789d5c",
  "object": "response",
  "created_at": 1741484430,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4.1",
  "output": [
    {
      "type": "web_search_call",
      "id": "ws_67ccf18f64008190a39b619f4c8455ef087bb177ab789d5c",
      "status": "completed"
    },
    {
      "type": "message",
      "id": "msg_67ccf190ca3881909d433c50b1f6357e087bb177ab789d5c",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "As of today, March 9, 2025, a noteworthy positive news story is China's breakthrough in renewable energy, successfully developing a new type of highly efficient solar cell with a record conversion efficiency of 35%, which could significantly drive the adoption and application of clean energy. This technology is expected to reduce solar power costs by about 40%, providing a new solution for global carbon emission reduction. This technology is expected to reduce solar power costs by about 40%, providing a new solution for global carbon emission reduction.",
          "annotations": [
            {
              "type": "url_citation",
              "start_index": 42,
              "end_index": 100,
              "url": "https://example.com/renewable-energy-breakthrough/?utm_source=chatgpt.com",
              "title": "China's breakthrough in renewable energy"
            },
            {
              "type": "url_citation",
              "start_index": 101,
              "end_index": 150,
              "url": "https://example.com/solar-cell-efficiency-record/?utm_source=chatgpt.com",
              "title": "New highly efficient solar cell conversion efficiency record"
            },
            {
              "type": "url_citation",
              "start_index": 151,
              "end_index": 200,
              "url": "https://example.com/clean-energy-cost-reduction/?utm_source=chatgpt.com",
              "title": "Solar power costs expected to decrease by 40%"
            }
          ]
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [
    {
      "type": "web_search_preview",
      "domains": [],
      "search_context_size": "medium",
      "user_location": {
        "type": "approximate",
        "city": null,
        "country": "US",
        "region": null,
        "timezone": null
      }
    }
  ],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 328,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 356,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 684
  },
  "user": null,
  "metadata": {}
}
```

### File Search Tool ✅

```bash
curl https://your-newapi-server-address/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "tools": [{
      "type": "file_search",
      "vector_store_ids": ["vs_1234567890"],
      "max_num_results": 20
    }],
    "input": "What are the characteristics and properties of ancient brown dragons?"
  }'
```

**Response Example:**

```json
{
  "id": "resp_67ccf4c55fc48190b71bd0463ad3306d09504fb6872380d7",
  "object": "response",
  "created_at": 1741485253,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4.1",
  "output": [
    {
      "type": "file_search_call",
      "id": "fs_67ccf4c63cd08190887ef6464ba5681609504fb6872380d7",
      "status": "completed",
      "queries": [
        "What are the characteristics and properties of ancient brown dragons?"
      ],
      "results": null
    },
    {
      "type": "message",
      "id": "msg_67ccf4c93e5c81909d595b369351a9d309504fb6872380d7",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "According to the materials, ancient brown dragons have the following characteristics and properties:\n\n1. Physical characteristics: Ancient brown dragons are massive, with a body length of 25-30 meters and a wingspan of about 35 meters. Their scales are dark brown to copper, becoming darker with age. They have characteristic double horns and spine spikes on their heads, strong jaws suitable for tearing prey. They also have excellent burrowing abilities, often digging complex nest systems in deserts or mountains.\n\n2. Abilities: They can spit powerful acid, causing severe corrosion damage to targets. Ancient brown dragons also have excellent burrowing abilities, often digging complex nest systems in deserts or mountains. Ancient brown dragons also have excellent burrowing abilities, often digging complex nest systems in deserts or mountains.\n\n3. Intelligence: Considered the most cunning and patient breed among dragon species, with extremely high intelligence, proficient in multiple languages, and possessing complex tactical thinking.\n\n4. Habitat: Primarily found in arid mountainous and desert regions, preferring hot and dry environments.\n\n5. Treasures: Ancient brown dragons are renowned for their vast treasures, particularly for collecting copper coins, rubies, and flame magic items.\n\n6. Lifespan: One of the longest among all dragon breeds, with a lifespan of 2000-2500 years, and its strength and magical abilities also increase with age.\n\n7. Personality: Extremely territorial, aggressive, and merciless to intruders, but also renowned for its rare patience, capable of waiting for centuries for revenge.",
          "annotations": [
            {
              "type": "file_citation",
              "index": 80,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 233,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 345,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 420,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 520,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 580,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 655,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 781,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            }
          ]
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [
    {
      "type": "file_search",
      "filters": null,
      "max_num_results": 20,
      "ranking_options": {
        "ranker": "auto",
        "score_threshold": 0.0
      },
      "vector_store_ids": [
        "vs_1234567890"
      ]
    }
  ],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 18307,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 348,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 18655
  },
  "user": null,
  "metadata": {}
}
```

### Streaming Response ✅

```bash
curl https://your-newapi-server-address/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "instructions": "You are a helpful assistant.",
    "input": "Hello!",
    "stream": true
  }'
```

**Streaming Response Example:**

```
event: response.created
data: {"type":"response.created","response":{"id":"resp_67c9fdcecf488190bdd9a0409de3a1ec07b8b0ad4e5eb654","object":"response","created_at":1741290958,"status":"in_progress","error":null,"incomplete_details":null,"instructions":"You are a helpful assistant.","max_output_tokens":null,"model":"gpt-4.1-2025-04-14","output":[],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"store":true,"temperature":1.0,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1.0,"truncation":"disabled","usage":null,"user":null,"metadata":{}}}

event: response.in_progress
data: {"type":"response.in_progress","response":{"id":"resp_67c9fdcecf488190bdd9a0409de3a1ec07b8b0ad4e5eb654","object":"response","created_at":1741290958,"status":"in_progress","error":null,"incomplete_details":null,"instructions":"You are a helpful assistant.","max_output_tokens":null,"model":"gpt-4.1-2025-04-14","output":[],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"store":true,"temperature":1.0,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1.0,"truncation":"disabled","usage":null,"user":null,"metadata":{}}}

event: response.output_item.added
data: {"type":"response.output_item.added","output_index":0,"item":{"id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","type":"message","status":"in_progress","role":"assistant","content":[]}}

event: response.content_part.added
data: {"type":"response.content_part.added","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"part":{"type":"output_text","text":"","annotations":[]}}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"Hello"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"!"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"  I"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"can"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"provide"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"what"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"help"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"?"}

event: response.output_text.done
data: {"type":"response.output_text.done","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"text":"Hello!  What can I help you with?"}

event: response.content_part.done
data: {"type":"response.content_part.done","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"part":{"type":"output_text","text":"Hello!  What can I help you with?","annotations":[]}}

event: response.output_item.done
data: {"type":"response.output_item.done","output_index":0,"item":{"id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","type":"message","status":"completed","role":"assistant","content":[{"type":"output_text","text":"Hello!  What can I help you with?","annotations":[]}]}}

event: response.completed
data: {"type":"response.completed","response":{"id":"resp_67c9fdcecf488190bdd9a0409de3a1ec07b8b0ad4e5eb654","object":"response","created_at":1741290958,"status":"completed","error":null,"incomplete_details":null,"instructions":"You are a helpful assistant.","max_output_tokens":null,"model":"gpt-4.1-2025-04-14","output":[{"id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","type":"message","status":"completed","role":"assistant","content":[{"type":"output_text","text":"Hello!  What can I help you with?","annotations":[]}]}],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"store":true,"temperature":1.0,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1.0,"truncation":"disabled","usage":{"input_tokens":37,"output_tokens":11,"output_tokens_details":{"reasoning_tokens":0},"total_tokens":48},"user":null,"metadata":{}}}
```

### Function Calling ✅

```bash
curl https://your-newapi-server-address/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "input": "What is the weather in Boston today?",
    "tools": [
      {
        "type": "function",
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
          "required": ["location", "unit"]
        }
      }
    ],
    "tool_choice": "auto"
  }'
```

**Response Example:**

```json
{
  "id": "resp_67ca09c5efe0819096d0511c92b8c890096610f474011cc0",
  "object": "response",
  "created_at": 1741294021,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4.1-2025-04-14",
  "output": [
    {
      "type": "function_call",
      "id": "fc_67ca09c6bedc8190a7abfec07b1a1332096610f474011cc0",
      "call_id": "call_unLAR8MvFNptuiZK6K6HCy5k",
      "name": "get_current_weather",
      "arguments": "{\"location\":\"Boston, MA\",\"unit\":\"celsius\"}",
      "status": "completed"
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [
    {
      "type": "function",
      "description": "Get the current weather for a specified location",
      "name": "get_current_weather",
      "parameters": {
        "type": "object",
        "properties": {
          "location": {
            "type": "string",
            "description": "City and state, e.g., San Francisco, CA"
          },
          "unit": {
            "type": "string",
            "enum": [
              "celsius",
              "fahrenheit"
            ]
          }
        },
        "required": [
          "location",
          "unit"
        ]
      },
      "strict": true
    }
  ],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 291,
    "output_tokens": 23,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 314
  },
  "user": null,
  "metadata": {}
}
```

### Reasoning Ability ✅

```bash
curl https://your-newapi-server-address/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "o3-mini",
    "input": "How many woodpeckers can peck wood?",
    "reasoning": {
      "effort": "high"
    }
  }'
```

**Response Example:**

```json
{
  "id": "resp_67ccd7eca01881908ff0b5146584e408072912b2993db808",
  "object": "response",
  "created_at": 1741477868,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "o1-2024-12-17",
  "output": [
    {
      "type": "message",
      "id": "msg_67ccd7f7b5848190a6f3e95d809f6b44072912b2993db808",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "This is a quote from the English tongue twister \"How much wood would a woodchuck chuck if a woodchuck could chuck wood\". In reality, woodpeckers (woodpecker) and woodchucks (woodchuck) are different animals, and woodchucks do not \"chuck\" wood. \n\nFrom a scientific perspective, woodpeckers do indeed peck trees every day to find food, build nests, or communicate. On average, a woodpecker might peck a tree about 8000-12000 times per day, depending on the species and specific purpose. If we convert this to wood volume, assuming each peck removes about 0.1-0.2 cubic centimeters of wood, then a woodpecker theoretically might remove about 800-2400 cubic centimeters of wood per day. \n\nHowever, woodpeckers are primarily foraging and nesting, not just removing wood, so this calculation is just an interesting theoretical estimate.",
          "annotations": []
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": "high",
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 81,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 1035,
    "output_tokens_details": {
      "reasoning_tokens": 832
    },
    "total_tokens": 1116
  },
  "user": null,
  "metadata": {}
}
```

## 📮 Request

### Endpoint

```
POST /v1/responses
```

Create a model response. Provide text or image input to generate text or JSON output. Let the model call your own custom code or use built-in tools (such as web search or file search) to use your own data as input for the model response.

### Authentication Method

Include the following in the request header for API key authentication:

```
Authorization: Bearer $NEWAPI_API_KEY
```

Where `$NEWAPI_API_KEY` is your API key.

### Request Body Parameters

#### input

**Type**: String or Array  
**Required**: Yes

The text, image, or file input provided to the model to generate a response.

##### Possible Types

| Type | Description |
|------|------|
| String | Text input, equivalent to text input with user role |
| Input item array | A list of one or more input items of different content types |

##### Input Message Object

| Property | Type | Required | Description |
|------|------|------|------|
| content | String or Array | Yes | The text, image, or audio input provided to the model to generate a response. It can also include previous assistant responses |
| role | String | Yes | The role of the input message. Optional values: `user`, `assistant`, `system`, or `developer` |
| type | String | No | The type of the input message, always `message` |

##### Content Item Types

###### Text Input

| Property | Type | Required | Description |
|------|------|------|------|
| text | String | Yes | The text input provided to the model |
| type | String | Yes | The type of the input item, always `input_text` |

###### Image Input

| Property | Type | Required | Description |
|------|------|------|------|
| detail | String | Yes | The detailed level of the image to send to the model. Optional values: `high`, `low`, or `auto`. Default is `auto` |
| type | String | Yes | The type of the input item, always `input_image` |
| file_id | String | No | The file ID to send to the model |
| image_url | String | No | The image URL to send to the model. It can be a full URL or base64 encoded image in a data URL |

###### File Input

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of the input item, always `input_file` |
| file_data | String | No | The content of the file to send to the model |
| file_id | String | No | The file ID to send to the model |
| filename | String | No | The filename to send to the model |

##### Output Item Types

###### Output Text

| Property | Type | Required | Description |
|------|------|------|------|
| text | String | Yes | The text output generated by the model |
| type | String | Yes | The type of the output item, always `output_text` |
| annotations | Array | Yes | Annotations for the text output |

###### Annotation Types

File Reference:

| Property | Type | Required | Description |
|------|------|------|------|
| file_id | String | Yes | The ID of the file |
| index | Integer | Yes | The index of the file in the file list |
| type | String | Yes | The type of file reference, always `file_citation` |

URL Reference:

| Property | Type | Required | Description |
|------|------|------|------|
| end_index | Integer | Yes | The index of the last character of the URL reference in the message |
| start_index | Integer | Yes | The index of the first character of the URL reference in the message |
| title | String | Yes | The title of the network resource |
| type | String | Yes | The type of URL reference, always `url_citation` |
| url | String | Yes | The URL of the network resource |

File Path:

| Property | Type | Required | Description |
|------|------|------|------|
| file_id | String | Yes | The ID of the file |
| index | Integer | Yes | The index of the file in the file list |
| type | String | Yes | The type of file path, always `file_path` |

###### Rejected Response

| Property | Type | Required | Description |
|------|------|------|------|
| refusal | String | Yes | The model's refusal explanation |
| type | String | Yes | The type of refusal, always `refusal` |

##### Tool Call Types

###### File Search Tool Call

| Property | Type | Required | Description |
|------|------|------|------|
| id | String | Yes | The unique ID of the file search tool call |
| queries | Array | Yes | The queries for searching files |
| status | String | Yes | The status of the file search tool call. Possible values include: `in_progress`, `searching`, `incomplete`, or `failed` |
| type | String | Yes | The type of the file search tool call, always `file_search_call` |
| results | Array or null | No | The results of the file search tool call |

###### Web Search Tool Call

| Property | Type | Required | Description |
|------|------|------|------|
| id | String | Yes | The unique ID of the web search tool call |
| status | String | Yes | The status of the web search tool call |
| type | String | Yes | The type of the web search tool call, always `web_search_call` |

###### Function Tool Call

| Property | Type | Required | Description |
|------|------|------|------|
| arguments | String | Yes | The JSON string of parameters passed to the function |
| call_id | String | Yes | The unique ID of the function tool call generated by the model |
| name | String | Yes | The name of the function to run |
| type | String | Yes | The type of the function tool call, always `function_call` |
| id | String | No | The unique ID of the function tool call |
| status | String | No | The status of the item. Possible values: `in_progress`, `completed`, or `incomplete` |

###### Computer Tool Call

| Property | Type | Required | Description |
|------|------|------|------|
| action | Object | Yes | The computer interaction operation, such as click, drag, etc. |
| call_id | String | Yes | The identifier used when the response tool call output is generated |
| id | String | Yes | The unique ID of the computer call |
| pending_safety_checks | Array | Yes | Pending safety checks for the computer call |
| status | String | Yes | The status of the item. Possible values: `in_progress`, `completed`, or `incomplete` |
| type | String | Yes | The type of the computer call, always `computer_call` |

Computer Operation Types:

| Operation Type | Description |
|---------|------|
| click | Mouse click operation |
| double_click | Mouse double-click operation |
| drag | Drag operation |
| keypress | Key operation |
| move | Mouse move operation |
| screenshot | Screenshot operation |
| scroll | Scroll operation |
| type | Text input operation |
| wait | Wait operation |

###### Computer Tool Call Output

| Property | Type | Required | Description |
|------|------|------|------|
| call_id | String | Yes | The ID of the computer tool call that generated the output |
| output | Object | Yes | The computer screen capture image for computer use tools |
| type | String | Yes | The type of the computer tool call output, always `computer_call_output` |
| acknowledged_safety_checks | Array | No | Safety checks reported by the API that have been confirmed by the developer |
| id | String | No | The ID of the computer tool call output |
| status | String | No | The status of the input message. Possible values: `in_progress`, `completed`, or `incomplete` |

###### Function Tool Call Output

| Property | Type | Required | Description |
|------|------|------|------|
| call_id | String | Yes | The unique ID of the function tool call generated by the model |
| output | String | Yes | The JSON string of the function tool call output |
| type | String | Yes | The type of the function tool call output, always `function_call_output` |
| id | String | No | The unique ID of the function tool call output |
| status | String | No | The status of the item. Possible values: `in_progress`, `completed`, or `incomplete` |

##### Reasoning Related Items

| Property | Type | Required | Description |
|------|------|------|------|
| id | String | Yes | The unique identifier of the reasoning content |
| summary | Array | Yes | The reasoning text content |
| type | String | Yes | The type of the object, always `reasoning` |
| encrypted_content | String or null | No | The encrypted version of the reasoning item - filled when generating a response with the `reasoning.encrypted_content` parameter |
| status | String | No | The status of the item. Possible values: `in_progress`, `completed`, or `incomplete` |

Reasoning Summary:

| Property | Type | Required | Description |
|------|------|------|------|
| text | String | Yes | A brief summary of the reasoning used by the model when generating the response |
| type | String | Yes | The type of the object, always `summary_text` |

##### Item References

| Property | Type | Required | Description |
|------|------|------|------|
| id | String | Yes | The ID of the item to reference |
| type | String | No | The type of the item to reference, always `item_reference` |

#### model

**Type**: String  
**Required**: Yes

The model ID used to generate the response, e.g., gpt-4.1 or o3. OpenAI provides various models with different capabilities, performance characteristics, and price points. Please refer to the model guide to browse and compare available models.

#### include

**Type**: Array or null  
**Required**: No

Specify additional output data to include in the model response. Currently supported values include:

| Value | Description |
|------|------|
| `file_search_call.results` | Includes search results for file search tool calls |
| `message.input_image.image_url` | Includes the image URL in the input message |
| `computer_call_output.output.image_url` | Includes the image URL in the computer call output |
| `reasoning.encrypted_content` | Includes the encrypted version of reasoning tokens in the reasoning item output |

#### instructions

**Type**: String or null  
**Required**: No

Insert a system (or developer) message as the first item in the model context.

When used with `previous_response_id`, the instructions from the previous response will not be carried over to the next response. This makes it easy to switch between system (developer) messages in new responses.

#### max_output_tokens

**Type**: Integer or null  
**Required**: No

The maximum number of tokens that can be generated for the response, including visible output tokens and reasoning tokens.

#### metadata

**Type**: Object  
**Required**: No

A collection of 16 key-value pairs that can be attached to the object. This is useful for storing other information about the object in a structured format and querying it via the API or dashboard.

Keys are strings of maximum length 64 characters. Values are strings of maximum length 512 characters.

#### parallel_tool_calls

**Type**: Boolean or null  
**Required**: No  
**Default**: true

Whether to allow the model to run tool calls in parallel.

#### previous_response_id

**Type**: String or null  
**Required**: No

The unique ID of the model's previous response. Use this parameter to create multi-turn conversations. Learn more about conversation state.

#### reasoning

**Type**: Object or null  
**Required**: No  
**Applies to o-series models**

Configuration options for the reasoning model.

| Property | Type | Required | Description |
|------|------|------|------|
| effort | String or null | No | The effort level of reasoning, optional values: `low`, `medium`, `high`. Default is `medium`. Reducing reasoning effort can speed up the response and reduce the number of tokens used for reasoning |
| summary | String or null | No | The summary of reasoning performed by the model. This is useful for debugging and understanding the model's reasoning process. Optional values: `auto`, `concise`, `detailed` |
| generate_summary | String or null | No | **Deprecated**: Please use `summary` instead. The summary of reasoning performed by the model. Optional values: `auto`, `concise`, `detailed` |

#### service_tier

**Type**: String or null  
**Required**: No  
**Default**: auto

Specifies the latency tier for processing the request. This parameter is relevant for customers subscribed to the scale tier service:

| Value | Description |
|------|------|
| `auto` | If the project is enabled for Scale tier, the system will use scale tier credits until they are exhausted; if the project is not enabled for Scale tier, the request will be processed using the default service tier, with lower normal operation time SLA and no latency guarantees |
| `default` | The request will be processed using the default service tier, with lower normal operation time SLA and no latency guarantees |
| `flex` | The request will be processed using the Flex Processing service tier. For more information, please refer to the official documentation |

When this parameter is not set, the default behavior is `auto`.

When this parameter is set, the response body will include the used `service_tier`.

#### store

**Type**: Boolean or null  
**Required**: No  
**Default**: true

Whether to store the generated model response for later retrieval via API.

#### stream

**Type**: Boolean or null  
**Required**: No  
**Default**: false

If set to true, model response data will be streamed to the client in real-time using server-sent events.

#### temperature

**Type**: Number or null  
**Required**: No  
**Default**: 1

The sampling temperature to use, between 0 and 2. Higher values (e.g., 0.8) make the output more random, while lower values (e.g., 0.2) make it more concentrated and deterministic. We generally recommend changing this value or `top_p`, but not both.

#### text

**Type**: Object  
**Required**: No

Configuration options for the model's text response. It can be pure text or structured JSON data.

| Property | Type | Required | Description |
|------|------|------|------|
| format | Object | No | Specifies the format the model must output |

Configure `{ "type": "json_schema" }` to enable structured output, ensuring the model will match your provided JSON schema. For more information, please refer to the structured output guide.

The default format is `{ "type": "text" }`, with no other options.

**Not recommended for gpt-4o and newer models**:
Set to `{ "type": "json_object" }` to enable the older JSON mode, ensuring the model's messages are valid JSON. For supported models, it is recommended to use `json_schema`.

##### Text Format Types

###### Text (Text)

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | Defines the response format type. Always `text` |

###### JSON Schema (JSON Schema)

| Property | Type | Required | Description |
|------|------|------|------|
| name | String | Yes | The name of the response format. Must contain a-z, A-Z, 0-9, or include underscores and hyphens, with a maximum length of 64 |
| schema | Object | Yes | The schema of the response format, described as a JSON Schema object |
| type | String | Yes | Defines the response format type. Always `json_schema` |
| description | String | No | A description of the purpose of the response format, used by the model to determine how to respond in that format |
| strict | Boolean or null | No | Whether to enable strict mode for strict adherence to the schema. Default is `false`. If set to `true`, the model will always follow the exact schema defined in the `schema` field. In strict mode, only a subset of JSON Schema is supported |

###### JSON Object (JSON Object)

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | Defines the response format type. Always `json_object` |

Note: If no system or user message explicitly indicates that the model should do so, the model will not generate JSON. For supported models, it is recommended to use `json_schema`.

#### tool_choice

**Type**: String or Object  
**Required**: No

How the model chooses the tool (or multiple tools) to use when generating a response. Please refer to the `tools` parameter to learn how to specify the tools that the model can call.

##### Possible Types

###### Tool Selection Mode (Tool choice mode)

**Type**: String

Controls whether the model calls tools and which tool to call.

| Value | Description |
|------|------|
| `none` | The model will not call any tools, but generate a message |
| `auto` | The model can choose between generating a message or calling one or more tools |
| `required` | The model must call one or more tools |

###### Hosted Tool (Hosted tool)

**Type**: Object

Indicates that the model should use a built-in tool to generate a response.

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of hosted tool the model should use. Allowed values are: `file_search`, `web_search_preview`, `computer_use_preview` |

###### Function Tool (Function tool)

**Type**: Object

Use this option to force the model to call a specific function.

| Property | Type | Required | Description |
|------|------|------|------|
| name | String | Yes | The name of the function to call |
| type | String | Yes | For function calls, the type is always `function` |

#### tools

**Type**: Array  
**Required**: No

An array of tools that the model might call when generating a response. You can specify which tool to use by setting the `tool_choice` parameter.

You can provide the model with two types of tools:

- **Built-in Tools**: Tools provided by OpenAI to extend the model's capabilities, such as web search or file search.
- **Function Calls (Custom Tools)**: Functions defined by you, allowing the model to call your own code.

##### File Search Tool (File search)

**Type**: Object

A tool to search for relevant content in uploaded files.

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of file search tool, always `file_search` |
| vector_store_ids | Array | Yes | A list of vector store IDs to search |
| filters | Object | No | Filters to apply |
| max_num_results | Integer | No | The maximum number of results to return. This number should be between 1 and 50 (inclusive) |
| ranking_options | Object | No | Search ranking options |

###### Filter Types

**Comparison Filter (Comparison Filter)**

| Property | Type | Required | Description |
|------|------|------|------|
| key | String | Yes | The key to compare with the value |
| type | String | Yes | Specifies the comparison operator: `eq`, `ne`, `gt`, `gte`, `lt`, `lte`<br>- eq: Equal<br>- ne: Not equal<br>- gt: Greater than<br>- gte: Greater than or equal to<br>- lt: Less than<br>- lte: Less than or equal to |
| value | String/Number/Boolean | Yes | The value to compare with the property key; supports string, number, or boolean types |

**Compound Filter (Compound Filter)**

| Property | Type | Required | Description |
|------|------|------|------|
| filters | Array | Yes | An array of filters to combine. Items can be comparison filters or compound filters |
| type | String | Yes | Operation type: `and` or `or` |

###### Ranking Options

| Property | Type | Required | Description |
|------|------|------|------|
| ranker | String | No | The file search ranking algorithm |
| score_threshold | Number | No | The score threshold for file search, a number between 0 and 1. A number closer to 1 will try to return only the most relevant results, but may return fewer results |

##### Function Tool (Function)

**Type**: Object

Defines functions that the model can optionally call from your own code.

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of function tool, always `function` |
| name | String | Yes | The name of the function to call |
| parameters | Object | Yes | A JSON schema object describing the function parameters |
| strict | Boolean | Yes | Whether to force strict parameter validation. Default is `true` |
| description | String | No | The description of the function. The model uses it to determine whether to call the function |

##### Web Search Tool (Web search preview)

**Type**: Object

This tool searches for relevant results on the web for a response.

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of web search tool. Optional values: `web_search_preview` or `web_search_preview_2025_03_11` |
| search_context_size | String | No | Advanced guidance for the amount of context window space for search. Optional values: `low`, `medium`, `high`. Default is `medium` |
| user_location | Object | No | The user's location |
| domains | Array | No | A list of domain names to restrict search to |

###### User Location

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of location approximation. Always `approximate` |
| city | String | No | A free-text input of the user's city, e.g., "San Francisco" |
| country | String | No | The user's two-letter ISO country code, e.g., "US" |
| region | String | No | A free-text input of the user's region, e.g., "California" |
| timezone | String | No | The user's IANA timezone, e.g., "America/Los_Angeles" |

##### Computer Use Tool (Computer use preview)

**Type**: Object

Controls tools for a virtual computer.

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of computer use tool, always `computer_use_preview` |
| display_height | Integer | Yes | The height of the computer display |
| display_width | Integer | Yes | The width of the computer display |
| environment | String | Yes | The type of computer environment to control |

#### top_p

**Type**: Number or null  
**Required**: No  
**Default**: 1

An alternative to sampling temperature, called nucleus sampling, where the model considers token results with top_p probability mass. Therefore, 0.1 means only considering tokens with the top 10% probability mass.

We generally recommend changing this value or `temperature`, but not both.

#### truncation

**Type**: String or null  
**Required**: No  
**Default**: disabled

Truncation strategy for model responses:

| Value | Description |
|------|------|
| `auto` | If this response and the previous response's context exceeds the model's context window size, the model will truncate the response by deleting input items from the middle of the conversation to fit the context window |
| `disabled` | If the model response exceeds the model's context window size, the request will fail with a 400 error |

#### user

**Type**: String  
**Required**: No

A unique identifier for the final user, helping OpenAI monitor and detect abuse behavior.

## 📥 Response

Returns a response object.

### Successful Response

Returns a response object, and if the request is streamed, returns the response object's streaming sequence.

#### id 
- Type: String
- Description: The unique identifier of the response

#### object
- Type: String  
- Description: The object type, value is "response"

#### created_at
- Type: Integer
- Description: The timestamp when the response was created

#### status
- Type: String
- Description: The response status, e.g., "completed", "in_progress", etc.

#### error
- Type: Object or null
- Description: If an error occurred, it contains error information

#### incomplete_details
- Type: Object or null
- Description: If the response is incomplete, it contains detailed information

#### instructions
- Type: String or null
- Description: System instructions provided to the model

#### max_output_tokens
- Type: Integer or null
- Description: The maximum number of output tokens

#### model
- Type: String
- Description: The name of the used model

#### output
- Type: Array
- Description: Contains the generated reply and tool calls
- May contain:
  - Message objects (`type`: "message")
  - Tool use objects (`type`: "tool_use")

#### parallel_tool_calls
- Type: Boolean
- Description: Whether parallel tool calls are enabled

#### previous_response_id
- Type: String or null
- Description: The ID of the previous response (for multi-turn conversations)

#### reasoning
- Type: Object
- Description: Reasoning related information

#### store
- Type: Boolean
- Description: Whether to store this response

#### temperature
- Type: Number
- Description: The sampling temperature used

#### text
- Type: Object
- Description: Text output format configuration

#### tool_choice
- Type: String
- Description: Tool selection strategy

#### tools
- Type: Array
- Description: List of available tools

#### top_p
- Type: Number
- Description: Nucleus sampling threshold

#### truncation
- Type: String
- Description: Truncation strategy

#### usage
- Type: Object
- Description: Token usage statistics
- Properties:
  - `input_tokens`: Number of tokens used for input
  - `input_tokens_details`: Detailed information about input tokens
  - `output_tokens`: Number of tokens used for output
  - `output_tokens_details`: Detailed information about output tokens
  - `total_tokens`: Total number of tokens

#### user
- Type: String or null
- Description: User identifier 

#### metadata
- Type: Object
- Description: Additional metadata information 
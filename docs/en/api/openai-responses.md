# OpenAI Response Format (Responses)

!!! info "Official Documentation"
    [OpenAI Responses](https://platform.openai.com/docs/api-reference/responses)

## 📝 Introduction

OpenAI's most advanced model response interface. Supports text and image input, as well as text output. Create stateful interactions with the model, using the output of a previous response as input. Extend the model's capabilities using built-in tools such as file search, web search, and computer use. Use function calling to allow the model access to external systems and data.

Related guides can be found on the OpenAI official website: [Responses](https://platform.openai.com/docs/guides/migrate-to-responses)

## 💡 Request Examples

### Basic Text Response ✅

```bash
curl https://你的newapi服务器地址/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "input": "讲一个三句话的关于独角兽的睡前故事。"
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
          "text": "在一个宁静的月夜下，一只名叫璐米娜的独角兽发现了一个倒映着星星的隐藏水池。当她将独角浸入水中时，水池开始闪烁，显现出通往一个有着无尽夜空的魔法世界的路径。充满好奇，璐米娜为所有做梦的人许下愿望，希望他们能找到自己的隐藏魔法，当她回头望去，她的蹄印像星尘一样闪烁。",
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
curl https://你的newapi服务器地址/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "input": [
      {
        "role": "user",
        "content": [
          {"type": "input_text", "text": "描述这张图片中的内容"},
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
          "text": "这张图片展示了一条木制栈道或小径穿过茂密的绿色草地，上方是点缀着几朵云的蓝天。场景呈现出一个宁静的自然区域，可能是公园或自然保护区。背景中有树木和灌木丛。整个景观展现出和谐的自然环境，栈道为游客提供了一条穿过湿地或草原而不影响周围生态系统的路径。",
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
curl https://你的newapi服务器地址/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "tools": [{ "type": "web_search_preview" }],
    "input": "今天有什么积极正面的新闻?"
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
          "text": "截至今天，2025年3月9日，一则值得关注的积极新闻是中国科学家在可再生能源领域取得重大突破，成功研发出一种新型高效太阳能电池，转化率达到了创纪录的35%，这可能会极大推动清洁能源的普及和应用。这项技术预计将使太阳能发电成本降低约40%，为全球减少碳排放提供了新的解决方案。",
          "annotations": [
            {
              "type": "url_citation",
              "start_index": 42,
              "end_index": 100,
              "url": "https://example.com/renewable-energy-breakthrough/?utm_source=chatgpt.com",
              "title": "中国科学家在可再生能源领域取得重大突破"
            },
            {
              "type": "url_citation",
              "start_index": 101,
              "end_index": 150,
              "url": "https://example.com/solar-cell-efficiency-record/?utm_source=chatgpt.com",
              "title": "新型高效太阳能电池转化率创纪录"
            },
            {
              "type": "url_citation",
              "start_index": 151,
              "end_index": 200,
              "url": "https://example.com/clean-energy-cost-reduction/?utm_source=chatgpt.com",
              "title": "太阳能发电成本有望降低40%"
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
curl https://你的newapi服务器地址/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "tools": [{
      "type": "file_search",
      "vector_store_ids": ["vs_1234567890"],
      "max_num_results": 20
    }],
    "input": "古代棕龙有哪些特性和属性?"
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
        "古代棕龙的特性和属性"
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
          "text": "根据资料，古代棕龙具有以下特性和属性：\n\n1. 物理特征：古代棕龙体型庞大，体长可达25-30米，翼展约35米。它们的鳞片呈深棕色至铜色，随着年龄增长会变得更加暗沉。头部有特征性的双角和脊刺，下颚强壮，适合撕裂猎物。\n\n2. 能力：它们能喷吐强力的酸液，对目标造成严重腐蚀伤害。古代棕龙还拥有出色的掘地能力，常在沙漠或山地挖掘复杂的巢穴系统。\n\n3. 智力：被认为是龙族中最为狡猾和有耐心的品种，智力极高，精通多种语言，并具有复杂的战术思维。\n\n4. 栖息地：主要栖息在干旱的山地和沙漠地区，喜欢炎热干燥的环境。\n\n5. 宝藏：古代棕龙以其庞大的宝藏闻名，特别喜爱收集铜币、红宝石和火焰魔法物品。\n\n6. 寿命：是所有龙种中寿命最长的之一，可活2000-2500年，随着年龄增长其力量和魔法能力也会增强。\n\n7. 性格：极度领地意识强，性格暴躁易怒，对侵入者毫不留情，但也以其罕见的耐心著称，能为复仇等待几个世纪。",
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
curl https://你的newapi服务器地址/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "instructions": "你是一个有帮助的助手。",
    "input": "你好！",
    "stream": true
  }'
```

**Streaming Response Example:**

```
event: response.created
data: {"type":"response.created","response":{"id":"resp_67c9fdcecf488190bdd9a0409de3a1ec07b8b0ad4e5eb654","object":"response","created_at":1741290958,"status":"in_progress","error":null,"incomplete_details":null,"instructions":"你是一个有帮助的助手。","max_output_tokens":null,"model":"gpt-4.1-2025-04-14","output":[],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"store":true,"temperature":1.0,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1.0,"truncation":"disabled","usage":null,"user":null,"metadata":{}}}

event: response.in_progress
data: {"type":"response.in_progress","response":{"id":"resp_67c9fdcecf488190bdd9a0409de3a1ec07b8b0ad4e5eb654","object":"response","created_at":1741290958,"status":"in_progress","error":null,"incomplete_details":null,"instructions":"你是一个有帮助的助手。","max_output_tokens":null,"model":"gpt-4.1-2025-04-14","output":[],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"store":true,"temperature":1.0,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1.0,"truncation":"disabled","usage":null,"user":null,"metadata":{}}}

event: response.output_item.added
data: {"type":"response.output_item.added","output_index":0,"item":{"id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","type":"message","status":"in_progress","role":"assistant","content":[]}}

event: response.content_part.added
data: {"type":"response.content_part.added","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"part":{"type":"output_text","text":"","annotations":[]}}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"你好"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"！"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":" 我"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"能"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"为"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"您"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"提供"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"什么"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"帮助"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"吗"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"？"}

event: response.output_text.done
data: {"type":"response.output_text.done","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"text":"你好！ 我能为您提供什么帮助吗？"}

event: response.content_part.done
data: {"type":"response.content_part.done","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"part":{"type":"output_text","text":"你好！ 我能为您提供什么帮助吗？","annotations":[]}}

event: response.output_item.done
data: {"type":"response.output_item.done","output_index":0,"item":{"id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","type":"message","status":"completed","role":"assistant","content":[{"type":"output_text","text":"你好！ 我能为您提供什么帮助吗？","annotations":[]}]}}

event: response.completed
data: {"type":"response.completed","response":{"id":"resp_67c9fdcecf488190bdd9a0409de3a1ec07b8b0ad4e5eb654","object":"response","created_at":1741290958,"status":"completed","error":null,"incomplete_details":null,"instructions":"你是一个有帮助的助手。","max_output_tokens":null,"model":"gpt-4.1-2025-04-14","output":[{"id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","type":"message","status":"completed","role":"assistant","content":[{"type":"output_text","text":"你好！ 我能为您提供什么帮助吗？","annotations":[]}]}],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"store":true,"temperature":1.0,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1.0,"truncation":"disabled","usage":{"input_tokens":37,"output_tokens":11,"output_tokens_details":{"reasoning_tokens":0},"total_tokens":48},"user":null,"metadata":{}}}
```

### Function Calling ✅

```bash
curl https://你的newapi服务器地址/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "input": "波士顿今天的天气如何？",
    "tools": [
      {
        "type": "function",
        "name": "get_current_weather",
        "description": "获取指定位置的当前天气",
        "parameters": {
          "type": "object",
          "properties": {
            "location": {
              "type": "string",
              "description": "城市和州，例如 San Francisco, CA"
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
      "arguments": "{\"location\":\"波士顿, MA\",\"unit\":\"celsius\"}",
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
      "description": "获取指定位置的当前天气",
      "name": "get_current_weather",
      "parameters": {
        "type": "object",
        "properties": {
          "location": {
            "type": "string",
            "description": "城市和州，例如 San Francisco, CA"
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

### Reasoning Capability ✅

```bash
curl https://你的newapi服务器地址/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "o3-mini",
    "input": "一只啄木鸟能啄多少木头?",
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
          "text": "这是一个源自英文绕口令"How much wood would a woodchuck chuck if a woodchuck could chuck wood"的问题。在现实中，啄木鸟(woodpecker)和土拨鼠(woodchuck)是不同的动物，而且土拨鼠实际上并不"啄(chuck)"木头。\n\n从科学角度看，啄木鸟每天确实会啄树木以寻找食物、建造巢穴或进行通讯。一只啄木鸟平均每天可能啄树约8000-12000次，视物种和具体目的而定。如果我们将这转换为木材量，假设每次啄击移除约0.1-0.2立方厘米的木材，那么一只啄木鸟理论上每天可能移除约800-2400立方厘米的木材。\n\n然而，啄木鸟主要是为了觅食和筑巢而啄木，而不是单纯地移除木材，所以这个计算只是一个有趣的理论估算。",
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

Creates a model response. Provide text or image input to generate text or JSON output. Allow the model to call your own custom code or use built-in tools (such as web search or file search) to use your own data as input for the model response.

### Authentication Method

Include the following in the request header for API key authentication:

```
Authorization: Bearer $NEWAPI_API_KEY
```

Where `$NEWAPI_API_KEY` is your API key.

### Request Body Parameters

#### input

**Type**: String or array  
**Required**: Yes

The text, image, or file input provided to the model to generate a response.

##### Possible Types

| Type | Description |
|------|------|
| String | Text input, equivalent to text input with a user role |
| Array of input items | A list containing one or more input items of different content types |

##### Input Message Object

| Property | Type | Required | Description |
|------|------|------|------|
| content | String or array | Yes | The text, image, or audio input provided to the model to generate a response. Can also include previous assistant responses |
| role | String | Yes | The role of the input message. Possible values: `user`, `assistant`, `system`, or `developer` |
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
| detail | String | Yes | The level of detail for the image to be sent to the model. Possible values: `high`, `low`, or `auto`. Defaults to `auto` |
| type | String | Yes | The type of the input item, always `input_image` |
| file_id | String | No | The file ID to be sent to the model |
| image_url | String | No | The image URL to be sent to the model. Can be a full URL or a base64 encoded image in a data URL |

###### File Input

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of the input item, always `input_file` |
| file_data | String | No | The file content to be sent to the model |
| file_id | String | No | The file ID to be sent to the model |
| filename | String | No | The filename to be sent to the model |

##### Output Item Types

###### Output Text

| Property | Type | Required | Description |
|------|------|------|------|
| text | String | Yes | The text output generated by the model |
| type | String | Yes | The type of the output item, always `output_text` |
| annotations | Array | Yes | Annotations for the text output |

###### Annotation Types

File Citation:

| Property | Type | Required | Description |
|------|------|------|------|
| file_id | String | Yes | The ID of the file |
| index | Integer | Yes | The index of the file in the file list |
| type | String | Yes | The type of the file citation, always `file_citation` |

URL Citation:

| Property | Type | Required | Description |
|------|------|------|------|
| end_index | Integer | Yes | The index of the last character of the URL citation in the message |
| start_index | Integer | Yes | The index of the first character of the URL citation in the message |
| title | String | Yes | The title of the web resource |
| type | String | Yes | The type of the URL citation, always `url_citation` |
| url | String | Yes | The URL of the web resource |

File Path:

| Property | Type | Required | Description |
|------|------|------|------|
| file_id | String | Yes | The ID of the file |
| index | Integer | Yes | The index of the file in the file list |
| type | String | Yes | The type of the file path, always `file_path` |

###### Refusal Response

| Property | Type | Required | Description |
|------|------|------|------|
| refusal | String | Yes | The model's explanation for refusal |
| type | String | Yes | The type of refusal, always `refusal` |

##### Tool Call Types

###### File Search Tool Call

| Property | Type | Required | Description |
|------|------|------|------|
| id | String | Yes | The unique ID for the file search tool call |
| queries | Array | Yes | Queries used to search files |
| status | String | Yes | The status of the file search tool call. Possible values include: `in_progress`, `searching`, `incomplete`, or `failed` |
| type | String | Yes | The type of the file search tool call, always `file_search_call` |
| results | Array or null | No | The results of the file search tool call |

###### Web Search Tool Call

| Property | Type | Required | Description |
|------|------|------|------|
| id | String | Yes | The unique ID for the web search tool call |
| status | String | Yes | The status of the web search tool call |
| type | String | Yes | The type of the web search tool call, always `web_search_call` |

###### Function Tool Call

| Property | Type | Required | Description |
|------|------|------|------|
| arguments | String | Yes | The JSON string of arguments passed to the function |
| call_id | String | Yes | The unique ID of the function tool call generated by the model |
| name | String | Yes | The name of the function to run |
| type | String | Yes | The type of the function tool call, always `function_call` |
| id | String | No | The unique ID for the function tool call |
| status | String | No | The status of the item. Possible values: `in_progress`, `completed`, or `incomplete` |

###### Computer Tool Call

| Property | Type | Required | Description |
|------|------|------|------|
| action | Object | Yes | The action for computer interaction, such as click, drag, etc. |
| call_id | String | Yes | The identifier used when responding to the tool call output |
| id | String | Yes | The unique ID for the computer call |
| pending_safety_checks | Array | Yes | Pending safety checks for the computer call |
| status | String | Yes | The status of the item. Possible values: `in_progress`, `completed`, or `incomplete` |
| type | String | Yes | The type of the computer call, always `computer_call` |

Computer Action Types:

| Operation Type | Description |
|---------|------|
| click | Mouse click operation |
| double_click | Mouse double click operation |
| drag | Drag operation |
| keypress | Key press operation |
| move | Mouse move operation |
| screenshot | Screenshot operation |
| scroll | Scroll operation |
| type | Text input operation |
| wait | Wait operation |

###### Computer Tool Call Output

| Property | Type | Required | Description |
|------|------|------|------|
| call_id | String | Yes | The ID of the computer tool call that produced the output |
| output | Object | Yes | The computer screenshot image used for the computer use tool |
| type | String | Yes | The type of the computer tool call output, always `computer_call_output` |
| acknowledged_safety_checks | Array | No | Safety checks reported by the API that have been acknowledged by the developer |
| id | String | No | The ID of the computer tool call output |
| status | String | No | The status of the input message. Possible values: `in_progress`, `completed`, or `incomplete` |

###### Function Tool Call Output

| Property | Type | Required | Description |
|------|------|------|------|
| call_id | String | Yes | The unique ID of the function tool call generated by the model |
| output | String | Yes | The JSON string of the function tool call output |
| type | String | Yes | The type of the function tool call output, always `function_call_output` |
| id | String | No | The unique ID for the function tool call output |
| status | String | No | The status of the item. Possible values: `in_progress`, `completed`, or `incomplete` |

##### Reasoning Related Items

| Property | Type | Required | Description |
|------|------|------|------|
| id | String | Yes | The unique identifier for the reasoning content |
| summary | Array | Yes | Reasoning text content |
| type | String | Yes | The type of the object, always `reasoning` |
| encrypted_content | String or null | No | Encrypted content of the reasoning item - populated when generating a response using the `reasoning.encrypted_content` include parameter |
| status | String | No | The status of the item. Possible values: `in_progress`, `completed`, or `incomplete` |

Reasoning Summary:

| Property | Type | Required | Description |
|------|------|------|------|
| text | String | Yes | A brief summary of the reasoning used by the model when generating the response |
| type | String | Yes | The type of the object, always `summary_text` |

##### Item Reference

| Property | Type | Required | Description |
|------|------|------|------|
| id | String | Yes | The ID of the item to be referenced |
| type | String | No | The type of the item to be referenced, always `item_reference` |

#### model

**Type**: String  
**Required**: Yes

The model ID used to generate the response, such as gpt-4.1 or o3. OpenAI offers various models with different capabilities, performance characteristics, and price points. Please refer to the model guide to browse and compare available models.

#### include

**Type**: Array or null  
**Required**: No

Specifies additional output data to include in the model response. Current supported values include:

| Value | Description |
|------|------|
| `file_search_call.results` | Includes search results for file search tool calls |
| `message.input_image.image_url` | Includes the image URL in the input message |
| `computer_call_output.output.image_url` | Includes the image URL in the computer call output |
| `reasoning.encrypted_content` | Includes the encrypted version of reasoning tokens in the reasoning item output |

#### instructions

**Type**: String or null  
**Required**: No

Inserts a system (or developer) message as the first item in the model context.

When used with `previous_response_id`, instructions from the previous response are not carried over to the next response. This makes it simple to switch the system (developer) message in a new response.

#### max_output_tokens

**Type**: Integer or null  
**Required**: No

An upper bound on the number of tokens that can be generated for the response, including visible output tokens and reasoning tokens.

#### metadata

**Type**: Object  
**Required**: No

A collection of 16 key-value pairs that can be attached to an object. This is useful for storing additional information about the object in a structured format and can be queried via the API or dashboard.

Keys are strings with a maximum length of 64 characters. Values are strings with a maximum length of 512 characters.

#### parallel_tool_calls

**Type**: Boolean or null  
**Required**: No  
**Default Value**: true

Whether the model is allowed to run tool calls in parallel.

#### previous_response_id

**Type**: String or null  
**Required**: No

The unique ID of the model's previous response. Use this parameter to create multi-turn conversations. Learn more about conversation state.

#### reasoning

**Type**: Object or null  
**Required**: No  
**Only applicable to o-series models**

Configuration options for the reasoning model.

| Property | Type | Required | Description |
|------|------|------|------|
| effort | String or null | No | The degree of reasoning effort. Possible values: `low`, `medium`, `high`. Defaults to `medium`. Lowering reasoning effort can speed up the response and reduce the number of tokens used for reasoning in the response |
| summary | String or null | No | A summary of the reasoning performed by the model. This is useful for debugging and understanding the model's reasoning process. Possible values: `auto`, `concise`, `detailed` |
| generate_summary | String or null | No | **Deprecated**: Please use `summary` instead. A summary of the reasoning performed by the model. Possible values: `auto`, `concise`, `detailed` |

#### service_tier

**Type**: String or null  
**Required**: No  
**Default Value**: auto

Specifies the latency tier used to process the request. This parameter is relevant for customers subscribed to the scale tier service:

| Value | Description |
|------|------|
| `auto` | If the project has Scale tier enabled, the system will use Scale tier credits until exhausted; if the project does not have Scale tier enabled, the request will be processed using the default service tier, which has a lower uptime SLA and no latency guarantee |
| `default` | The request will be processed using the default service tier, which has a lower uptime SLA and no latency guarantee |
| `flex` | The request will be processed using the Flex Processing service tier. Learn more in the official documentation |

When this parameter is not set, the default behavior is `auto`.

When this parameter is set, the response body will include the `service_tier` used.

#### store

**Type**: Boolean or null  
**Required**: No  
**Default Value**: true

Whether to store the generated model response for later retrieval via the API.

#### stream

**Type**: Boolean or null  
**Required**: No  
**Default Value**: false

If set to true, the model response data will be streamed to the client using Server-Sent Events as it is generated.

#### temperature

**Type**: Number or null  
**Required**: No  
**Default Value**: 1

What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this value or `top_p` but not both.

#### text

**Type**: Object  
**Required**: No

Configuration options for the model's text response. Can be plain text or structured JSON data.

| Property | Type | Required | Description |
|------|------|------|------|
| format | Object | No | Specifies the format the model must output |

Configuring `{ "type": "json_schema" }` enables structured output, ensuring the model will match the JSON schema you provide. See the Structured Output guide for more information.

The default format is `{ "type": "text" }`, with no other options.

**Not recommended for gpt-4o and newer models**:
Setting to `{ "type": "json_object" }` enables the older JSON mode, ensuring the model generates a valid JSON message. For supported models, `json_schema` is preferred.

##### Text Format Types

###### Text (Text)

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The defined response format type. Always `text` |

###### JSON Schema (JSON Schema)

| Property | Type | Required | Description |
|------|------|------|------|
| name | String | Yes | The name of the response format. Must contain a-z, A-Z, 0-9, or include underscores and dashes, maximum length 64 |
| schema | Object | Yes | The schema for the response format, described as a JSON Schema object |
| type | String | Yes | The defined response format type. Always `json_schema` |
| description | String | No | A description of the response format's purpose, which the model uses to determine how to respond in that format |
| strict | Boolean or null | No | Whether to enable strict mode adherence when generating output. Defaults to `false`. If set to `true`, the model will strictly follow the exact schema defined in the schema field. Only a subset of JSON Schema is supported in strict mode |

###### JSON Object (JSON Object)

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The defined response format type. Always `json_object` |

Note: The model will not generate JSON unless instructed to do so by a system or user message. For supported models, `json_schema` is recommended.

#### tool_choice

**Type**: String or object  
**Required**: No

How the model selects the tool (or tools) to use when generating a response. See the `tools` parameter for how to specify tools the model can call.

##### Possible Types

###### Tool choice mode (Tool choice mode)

**Type**: String

Controls whether and which tool the model calls.

| Value | Description |
|------|------|
| `none` | The model will not call any tools, but instead generate a message |
| `auto` | The model can choose between generating a message or calling one or more tools |
| `required` | The model must call one or more tools |

###### Hosted tool (Hosted tool)

**Type**: Object

Instructs the model to use a built-in tool to generate a response.

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of hosted tool the model should use. Allowed values are: `file_search`, `web_search_preview`, `computer_use_preview` |

###### Function tool (Function tool)

**Type**: Object

Use this option to force the model to call a specific function.

| Property | Type | Required | Description |
|------|------|------|------|
| name | String | Yes | The name of the function to call |
| type | String | Yes | For function calls, the type is always `function` |

#### tools

**Type**: Array  
**Required**: No

An array of tools the model may call when generating a response. You can specify which tool to use by setting the `tool_choice` parameter.

The two categories of tools you can provide to the model are:

- **Built-in tools**: Tools provided by OpenAI to extend model capabilities, such as web search or file search.
- **Function calling (custom tools)**: Functions defined by you, enabling the model to call your own code.

##### File search tool (File search)

**Type**: Object

A tool that searches for relevant content within uploaded files.

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of the file search tool, always `file_search` |
| vector_store_ids | Array | Yes | A list of vector store IDs to search |
| filters | Object | No | Filters to apply |
| max_num_results | Integer | No | The maximum number of results to return. This number should be between 1 and 50 (inclusive) |
| ranking_options | Object | No | Search ranking options |

###### Filter Types

**Comparison Filter (Comparison Filter)**

| Property | Type | Required | Description |
|------|------|------|------|
| key | String | Yes | The key to compare against the value |
| type | String | Yes | Specifies the comparison operator: `eq`, `ne`, `gt`, `gte`, `lt`, `lte`<br>- eq: equals<br>- ne: not equals<br>- gt: greater than<br>- gte: greater than or equals<br>- lt: less than<br>- lte: less than or equals |
| value | String/Number/Boolean | Yes | The value to compare against the property key; supports string, number, or boolean types |

**Compound Filter (Compound Filter)**

| Property | Type | Required | Description |
|------|------|------|------|
| filters | Array | Yes | An array of filters to combine. Items can be comparison filters or compound filters |
| type | String | Yes | The operation type: `and` or `or` |

###### Ranking Options

| Property | Type | Required | Description |
|------|------|------|------|
| ranker | String | No | The ranker used for file search |
| score_threshold | Number | No | The score threshold for file search, a number between 0 and 1. A number close to 1 will attempt to return only the most relevant results but may return fewer results |

##### Function tool (Function)

**Type**: Object

Defines a function in your own code that the model can choose to call.

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of the function tool, always `function` |
| name | String | Yes | The name of the function to call |
| parameters | Object | Yes | A JSON schema object describing the function parameters |
| strict | Boolean | Yes | Whether to enforce strict parameter validation. Defaults to `true` |
| description | String | No | A description of the function. The model uses this to determine whether to call the function |

##### Web search tool (Web search preview)

**Type**: Object

This tool searches the web for relevant results to use in the response.

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of the web search tool. Possible values: `web_search_preview` or `web_search_preview_2025_03_11` |
| search_context_size | String | No | High-level guidance on the amount of context window space to use for searching. Possible values: `low`, `medium`, `high`. Defaults to `medium` |
| user_location | Object | No | User's location |
| domains | Array | No | A list of domains to restrict the search to |

###### User Location

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | Location approximation type. Always `approximate` |
| city | String | No | Free text input for the user's city, e.g., "San Francisco" |
| country | String | No | The user's two-letter ISO country code, e.g., "US" |
| region | String | No | Free text input for the user's region, e.g., "California" |
| timezone | String | No | The user's IANA timezone, e.g., "America/Los_Angeles" |

##### Computer use tool (Computer use preview)

**Type**: Object

A tool for controlling a virtual computer.

| Property | Type | Required | Description |
|------|------|------|------|
| type | String | Yes | The type of the computer use tool. Always `computer_use_preview` |
| display_height | Integer | Yes | The height of the computer display |
| display_width | Integer | Yes | The width of the computer display |
| environment | String | Yes | The type of computer environment to control |

#### top_p

**Type**: Number or null  
**Required**: No  
**Default Value**: 1

An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of tokens with the top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.

We generally recommend altering this value or `temperature` but not both.

#### truncation

**Type**: String or null  
**Required**: No  
**Default Value**: disabled

Truncation policy used for model responses:

| Value | Description |
|------|------|
| `auto` | If the context of this response and the previous response exceeds the model's context window size, the model will truncate the response by removing input items in the middle of the conversation to fit the context window |
| `disabled` | If the model response would exceed the model's context window size, the request will fail with a 400 error |

#### user

**Type**: String  
**Required**: No

A unique identifier representing the end-user, which can help OpenAI to monitor and detect abuse.

## 📥 Response

Returns a response object.

### Successful Response

Returns a response object, or a streaming sequence of response objects if the request was streamed.

#### id 
- Type: String
- Description: The unique identifier for the response

#### object
- Type: String  
- Description: Object type, value is "response"

#### created_at
- Type: Integer
- Description: Timestamp of when the response was created

#### status
- Type: String
- Description: Response status, such as "completed", "in_progress", etc.

#### error
- Type: Object or null
- Description: Contains error information if an error occurred

#### incomplete_details
- Type: Object or null
- Description: Contains detailed information if the response is incomplete

#### instructions
- Type: String or null
- Description: System instructions provided to the model

#### max_output_tokens
- Type: Integer or null
- Description: Maximum number of output tokens

#### model
- Type: String
- Description: Name of the model used

#### output
- Type: Array
- Description: Contains the generated reply and tool calls
- Possible contents:
  - Message object (`type`: "message")
  - Tool use object (`type`: "tool_use")

#### parallel_tool_calls
- Type: Boolean
- Description: Whether parallel tool calls are enabled

#### previous_response_id
- Type: String or null
- Description: ID of the previous response (used for multi-turn conversations)

#### reasoning
- Type: Object
- Description: Reasoning related information

#### store
- Type: Boolean
- Description: Whether this response is stored

#### temperature
- Type: Number
- Description: Sampling temperature used

#### text
- Type: Object
- Description: Text output format configuration

#### tool_choice
- Type: String
- Description: Tool choice strategy

#### tools
- Type: Array
- Description: List of available tools

#### top_p
- Type: Number
- Description: Nucleus sampling threshold

#### truncation
- Type: String
- Description: Truncation policy

#### usage
- Type: Object
- Description: Token usage statistics
- Properties:
  - `input_tokens`: Number of tokens used for input
  - `input_tokens_details`: Input token details
  - `output_tokens`: Number of tokens used for output
  - `output_tokens_details`: Output token details
  - `total_tokens`: Total number of tokens

#### user
- Type: String or null
- Description: User identifier

#### metadata
- Type: Object
- Description: Additional metadata information
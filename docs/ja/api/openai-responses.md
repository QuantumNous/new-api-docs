# OpenAI レスポンス形式（Responses）

!!! info "公式ドキュメント"
    [OpenAI Responses](https://platform.openai.com/docs/api-reference/responses)

## 📝 概要

OpenAIの最先端モデルのレスポンスインターフェースです。テキストおよび画像入力、ならびにテキスト出力をサポートしています。モデルとのステートフルな対話を作成し、以前のレスポンスの出力を入力として使用します。ファイル検索、ウェブ検索、コンピューター使用などの組み込みツールを通じてモデルの機能を拡張します。関数呼び出しを使用することで、モデルが外部システムやデータにアクセスできるようにします。

関連ガイドについては、OpenAI公式サイトを参照してください：[Responses](https://platform.openai.com/docs/guides/responses)

## 💡 リクエスト例

### 基礎テキストレスポンス ✅

```bash
curl https://你的newapi服务器地址/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "input": "讲一个三句话的关于独角兽的睡前故事。"
  }'
```

**レスポンス例:**

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

### 画像分析レスポンス ✅

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

**レスポンス例:**

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

### ウェブ検索ツール ✅

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

**レスポンス例:**

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

### ファイル検索ツール ✅

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

**レスポンス例:**

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

### ストリーミングレスポンス ✅

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

**ストリーミングレスポンス例:**

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

### 関数呼び出し ✅

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

**レスポンス例:**

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

### 推論能力 ✅

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

**レスポンス例:**

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

## 📮 リクエスト

### エンドポイント

```
POST /v1/responses
```

モデルレスポンスを作成します。テキストまたは画像入力を提供して、テキストまたはJSON出力を生成します。モデルに独自のカスタムコードを呼び出させたり、組み込みツール（ウェブ検索やファイル検索など）を使用して独自のデータをモデルレスポンスの入力として使用させたりできます。

### 認証方法

リクエストヘッダーに以下を含めて API キー認証を行います：

```
Authorization: Bearer $NEWAPI_API_KEY
```

ここで `$NEWAPI_API_KEY` はあなたの API キーです。

### リクエストボディパラメータ

#### input

**タイプ**: 文字列または配列  
**必須**: はい

モデルに提供される、レスポンス生成に使用されるテキスト、画像、またはファイル入力。

##### 可能なタイプ

| タイプ | 説明 |
|------|------|
| 文字列 | テキスト入力。ユーザーロールを持つテキスト入力と同等です |
| 入力項目配列 | 異なるコンテンツタイプを持つ1つ以上の入力項目のリスト |

##### 入力メッセージオブジェクト

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| content | 文字列または配列 | はい | モデルに提供されるテキスト、画像、または音声入力。レスポンス生成に使用されます。以前のアシスタントレスポンスを含めることもできます |
| role | 文字列 | はい | 入力メッセージのロール。選択可能な値：`user`、`assistant`、`system`、または `developer` |
| type | 文字列 | いいえ | 入力メッセージのタイプ。常に `message` |

##### コンテンツ項目のタイプ

###### テキスト入力

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| text | 文字列 | はい | モデルに提供されるテキスト入力 |
| type | 文字列 | はい | 入力項目のタイプ。常に `input_text` |

###### 画像入力

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| detail | 文字列 | はい | モデルに送信する画像の詳細レベル。選択可能な値：`high`、`low`、または `auto`。デフォルトは `auto` |
| type | 文字列 | はい | 入力項目のタイプ。常に `input_image` |
| file_id | 文字列 | いいえ | モデルに送信するファイルID |
| image_url | 文字列 | いいえ | モデルに送信する画像URL。完全なURLまたはデータURL内のbase64エンコード画像を指定できます |

###### ファイル入力

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| type | 文字列 | はい | 入力項目のタイプ。常に `input_file` |
| file_data | 文字列 | いいえ | モデルに送信するファイルコンテンツ |
| file_id | 文字列 | いいえ | モデルに送信するファイルID |
| filename | 文字列 | いいえ | モデルに送信するファイル名 |

##### 出力項目のタイプ

###### 出力テキスト

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| text | 文字列 | はい | モデルによって生成されたテキスト出力 |
| type | 文字列 | はい | 出力項目のタイプ。常に `output_text` |
| annotations | 配列 | はい | テキスト出力の注釈 |

###### 注釈タイプ

ファイル参照:

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| file_id | 文字列 | はい | ファイルのID |
| index | 整数 | はい | ファイルリスト内でのファイルのインデックス |
| type | 文字列 | はい | ファイル参照のタイプ。常に `file_citation` |

URL参照:

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| end_index | 整数 | はい | メッセージ内のURL参照の最後の文字のインデックス |
| start_index | 整数 | はい | メッセージ内のURL参照の最初の文字のインデックス |
| title | 文字列 | はい | ウェブリソースのタイトル |
| type | 文字列 | はい | URL参照のタイプ。常に `url_citation` |
| url | 文字列 | はい | ウェブリソースのURL |

ファイルパス:

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| file_id | 文字列 | はい | ファイルのID |
| index | 整数 | はい | ファイルリスト内でのファイルのインデックス |
| type | 文字列 | はい | ファイルパスのタイプ。常に `file_path` |

###### 拒否レスポンス

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| refusal | 文字列 | はい | モデルによる拒否の説明 |
| type | 文字列 | はい | 拒否のタイプ。常に `refusal` |

##### ツール呼び出しタイプ

###### ファイル検索ツール呼び出し

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| id | 文字列 | はい | ファイル検索ツール呼び出しの一意のID |
| queries | 配列 | はい | ファイル検索に使用されるクエリ |
| status | 文字列 | はい | ファイル検索ツール呼び出しのステータス。可能な値：`in_progress`、`searching`、`incomplete`、または `failed` |
| type | 文字列 | はい | ファイル検索ツール呼び出しのタイプ。常に `file_search_call` |
| results | 配列またはnull | いいえ | ファイル検索ツール呼び出しの結果 |

###### ウェブ検索ツール呼び出し

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| id | 文字列 | はい | ウェブ検索ツール呼び出しの一意のID |
| status | 文字列 | はい | ウェブ検索ツール呼び出しのステータス |
| type | 文字列 | はい | ウェブ検索ツール呼び出しのタイプ。常に `web_search_call` |

###### 関数ツール呼び出し

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| arguments | 文字列 | はい | 関数に渡される引数のJSON文字列 |
| call_id | 文字列 | はい | モデルによって生成された関数ツール呼び出しの一意のID |
| name | 文字列 | はい | 実行する関数の名前 |
| type | 文字列 | はい | 関数ツール呼び出しのタイプ。常に `function_call` |
| id | 文字列 | いいえ | 関数ツール呼び出しの一意のID |
| status | 文字列 | いいえ | 項目のステータス。可能な値：`in_progress`、`completed`、または `incomplete` |

###### コンピューターツール呼び出し

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| action | オブジェクト | はい | クリック、ドラッグなどのコンピューター操作 |
| call_id | 文字列 | はい | ツール呼び出しの出力に応答する際に使用される識別子 |
| id | 文字列 | はい | コンピューター呼び出しの一意のID |
| pending_safety_checks | 配列 | はい | コンピューター呼び出しの保留中の安全チェック |
| status | 文字列 | はい | 項目のステータス。可能な値：`in_progress`、`completed`、または `incomplete` |
| type | 文字列 | はい | コンピューター呼び出しのタイプ。常に `computer_call` |

コンピューター操作タイプ:

| 操作タイプ | 説明 |
|---------|------|
| click | マウスクリック操作 |
| double_click | マウスダブルクリック操作 |
| drag | ドラッグ操作 |
| keypress | キー操作 |
| move | マウス移動操作 |
| screenshot | スクリーンショット操作 |
| scroll | スクロール操作 |
| type | テキスト入力操作 |
| wait | 待機操作 |

###### コンピューターツール呼び出し出力

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| call_id | 文字列 | はい | 出力を生成したコンピューターツール呼び出しのID |
| output | オブジェクト | はい | コンピューター使用ツール用のコンピューターのスクリーンショット画像 |
| type | 文字列 | はい | コンピューターツール呼び出し出力のタイプ。常に `computer_call_output` |
| acknowledged_safety_checks | 配列 | いいえ | 開発者によって確認されたとAPIが報告した安全チェック |
| id | 文字列 | いいえ | コンピューターツール呼び出し出力のID |
| status | 文字列 | いいえ | 入力メッセージのステータス。可能な値：`in_progress`、`completed`、または `incomplete` |

###### 関数ツール呼び出し出力

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| call_id | 文字列 | はい | モデルによって生成された関数ツール呼び出しの一意のID |
| output | 文字列 | はい | 関数ツール呼び出し出力のJSON文字列 |
| type | 文字列 | はい | 関数ツール呼び出し出力のタイプ。常に `function_call_output` |
| id | 文字列 | いいえ | 関数ツール呼び出し出力の一意のID |
| status | 文字列 | いいえ | 項目のステータス。可能な値：`in_progress`、`completed`、または `incomplete` |

##### 推論関連項目

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| id | 文字列 | はい | 推論コンテンツの一意の識別子 |
| summary | 配列 | はい | 推論テキストコンテンツ |
| type | 文字列 | はい | オブジェクトのタイプ。常に `reasoning` |
| encrypted_content | 文字列またはnull | いいえ | 推論項目の暗号化されたコンテンツ - `reasoning.encrypted_content` パラメータを使用してレスポンスが生成された場合に設定されます |
| status | 文字列 | いいえ | 項目のステータス。可能な値：`in_progress`、`completed`、または `incomplete` |

推論の要約:

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| text | 文字列 | はい | モデルがレスポンスを生成する際に使用した推論の簡単な要約 |
| type | 文字列 | はい | オブジェクトのタイプ。常に `summary_text` |

##### 項目参照

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| id | 文字列 | はい | 参照する項目の一意のID |
| type | 文字列 | いいえ | 参照する項目のタイプ。常に `item_reference` |

#### model

**タイプ**: 文字列  
**必須**: はい

レスポンスの生成に使用するモデルID。例: gpt-4.1 または o3。OpenAIは、異なる能力、パフォーマンス特性、および価格帯を持つ様々なモデルを提供しています。利用可能なモデルを参照および比較するには、モデルガイドを参照してください。

#### include

**タイプ**: 配列またはnull  
**必須**: いいえ

モデルレスポンスに含める追加の出力データを指定します。現在サポートされている値は次のとおりです：

| 値 | 説明 |
|------|------|
| `file_search_call.results` | ファイル検索ツール呼び出しの検索結果を含めます |
| `message.input_image.image_url` | 入力メッセージ内の画像URLを含めます |
| `computer_call_output.output.image_url` | コンピューター呼び出し出力内の画像URLを含めます |
| `reasoning.encrypted_content` | 推論項目出力に推論マーカーの暗号化バージョンを含めます |

#### instructions

**タイプ**: 文字列またはnull  
**必須**: いいえ

システム（または開発者）メッセージとしてモデルコンテキストの最初の項目に挿入されます。

`previous_response_id` と一緒に使用する場合、前のレスポンスの指示は次のレスポンスに引き継がれません。これにより、新しいレスポンスでシステム（開発者）メッセージを簡単に切り替えることができます。

#### max_output_tokens

**タイプ**: 整数またはnull  
**必須**: いいえ

可視出力トークンと推論トークンを含む、レスポンスに対して生成できるトークン数の上限。

#### metadata

**タイプ**: オブジェクト  
**必須**: いいえ

オブジェクトに添付できる16個のキーと値のペアのコレクション。これは、構造化された形式でオブジェクトに関する追加情報を保存するのに役立ち、APIまたはダッシュボードを通じてオブジェクトをクエリできます。

キーは最大長64文字の文字列です。値は最大長512文字の文字列です。

#### parallel_tool_calls

**タイプ**: ブール値またはnull  
**必須**: いいえ  
**デフォルト値**: true

モデルがツール呼び出しを並行して実行することを許可するかどうか。

#### previous_response_id

**タイプ**: 文字列またはnull  
**必須**: いいえ

モデルの前のレスポンスの一意のID。このパラメータを使用して、マルチターンの会話を作成します。会話の状態についてさらに学ぶ。

#### reasoning

**タイプ**: オブジェクトまたはnull  
**必須**: いいえ  
**oシリーズモデルにのみ適用**

推論モデルの設定オプション。

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| effort | 文字列またはnull | いいえ | 推論の努力レベル。選択可能な値: `low`、`medium`、`high`。デフォルト値は `medium` です。推論の努力を減らすと、応答が速くなり、応答に使用される推論トークン数が減少する可能性があります |
| summary | 文字列またはnull | いいえ | モデルが実行した推論の要約。デバッグやモデルの推論プロセスを理解するのに役立ちます。選択可能な値: `auto`、`concise`、`detailed` |
| generate_summary | 文字列またはnull | いいえ | **非推奨**: 代わりに `summary` を使用してください。モデルが実行した推論の要約。選択可能な値: `auto`、`concise`、`detailed` |

#### service_tier

**タイプ**: 文字列またはnull  
**必須**: いいえ  
**デフォルト値**: auto

リクエストの処理に使用する遅延レベルを指定します。このパラメータは、スケールティアサービスを購読している顧客に関連します：

| 値 | 説明 |
|------|------|
| `auto` | プロジェクトでスケールティアが有効になっている場合、クレジットがなくなるまでスケールティアが使用されます。プロジェクトでスケールティアが有効になっていない場合、リクエストはデフォルトのサービスティアで処理され、稼働時間SLAが低く、遅延保証はありません |
| `default` | リクエストはデフォルトのサービスティアで処理され、稼働時間SLAが低く、遅延保証はありません |
| `flex` | リクエストはFlex Processingサービスティアで処理されます。詳細については公式ドキュメントを参照してください |

このパラメータが設定されていない場合、デフォルトの動作は `auto` です。

このパラメータが設定されている場合、レスポンスボディには使用された `service_tier` が含まれます。

#### store

**タイプ**: ブール値またはnull  
**必須**: いいえ  
**デフォルト値**: true

生成されたモデルレスポンスを、後でAPIを通じて取得できるように保存するかどうか。

#### stream

**タイプ**: ブール値またはnull  
**必須**: いいえ  
**デフォルト値**: false

trueに設定されている場合、モデルレスポンスデータは、生成時にサーバー送信イベントを使用してクライアントにストリーミングされます。

#### temperature

**タイプ**: 数値またはnull  
**必須**: いいえ  
**デフォルト値**: 1

使用するサンプリング温度。0から2の間で指定します。高い値（例：0.8）は出力をよりランダムにし、低い値（例：0.2）は出力をより集中的かつ決定論的にします。通常、この値または `top_p` のいずれかを変更することをお勧めしますが、両方を同時に変更することはお勧めしません。

#### text

**タイプ**: オブジェクト  
**必須**: いいえ

モデルのテキストレスポンスの設定オプション。プレーンテキストまたは構造化JSONデータのいずれかです。

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| format | オブジェクト | いいえ | モデルが出力しなければならない形式を指定します |

`{ "type": "json_schema" }` を設定すると、構造化出力が有効になり、モデルが提供されたJSONスキーマに一致することが保証されます。詳細については、構造化出力ガイドを参照してください。

デフォルトの形式は `{ "type": "text" }` であり、他のオプションはありません。

**gpt-4oおよびそれ以降のモデルでは非推奨**：
`{ "type": "json_object" }` に設定すると、古いJSONモードが有効になり、モデルによって生成されるメッセージが有効なJSONであることが保証されます。サポートされているモデルでは、`json_schema` の使用が推奨されます。

##### テキスト形式タイプ

###### テキスト (Text)

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| type | 文字列 | はい | 定義されたレスポンス形式のタイプ。常に `text` |

###### JSONスキーマ (JSON Schema)

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| name | 文字列 | はい | レスポンス形式の名前。a-z、A-Z、0-9、またはアンダースコアとハイフンを含める必要があり、最大長は64です |
| schema | オブジェクト | はい | JSONスキーマオブジェクトとして記述されたレスポンス形式のスキーマ |
| type | 文字列 | はい | 定義されたレスポンス形式のタイプ。常に `json_schema` |
| description | 文字列 | いいえ | レスポンス形式の用途の説明。モデルはこれを使用して、その形式でどのように応答するかを決定します |
| strict | ブール値またはnull | いいえ | 出力を生成する際に厳密なスキーマ準拠を強制するかどうか。デフォルトは `false` です。`true` に設定されている場合、モデルは `schema` フィールドで定義された正確なスキーマに常に従います。厳密モードでは、JSONスキーマのサブセットのみがサポートされます |

###### JSONオブジェクト (JSON Object)

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| type | 文字列 | はい | 定義されたレスポンス形式のタイプ。常に `json_object` |

注意：モデルにそうするように指示するシステムメッセージやユーザーメッセージがない限り、モデルはJSONを生成しません。サポートされているモデルでは、`json_schema` の使用が推奨されます。

#### tool_choice

**タイプ**: 文字列またはオブジェクト  
**必須**: いいえ

モデルがレスポンス生成時に使用するツール（または複数のツール）を選択する方法。モデルが呼び出すことができるツールを指定する方法については、`tools` パラメータを参照してください。

##### 可能なタイプ

###### ツール選択モード (Tool choice mode)

**タイプ**: 文字列

モデルがツールを呼び出すかどうか、およびどのツールを呼び出すかを制御します。

| 値 | 説明 |
|------|------|
| `none` | モデルはツールを呼び出さず、メッセージを生成します |
| `auto` | モデルはメッセージの生成、または1つ以上のツールの呼び出しを選択できます |
| `required` | モデルは1つ以上のツールを呼び出す必要があります |

###### ホスト型ツール (Hosted tool)

**タイプ**: オブジェクト

モデルが組み込みツールを使用してレスポンスを生成する必要があることを示します。

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| type | 文字列 | はい | モデルが使用すべきホスト型ツールのタイプ。許可される値：`file_search`、`web_search_preview`、`computer_use_preview` |

###### 関数ツール (Function tool)

**タイプ**: オブジェクト

このオプションを使用して、モデルに特定の関数を強制的に呼び出させます。

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| name | 文字列 | はい | 呼び出す関数の名前 |
| type | 文字列 | はい | 関数呼び出しの場合、タイプは常に `function` |

#### tools

**タイプ**: 配列  
**必須**: いいえ

モデルがレスポンス生成時に呼び出す可能性のあるツールの配列。`tool_choice` パラメータを設定することで、どのツールを使用するかを指定できます。

モデルに提供できるツールには、次の2種類があります：

- **組み込みツール**：ウェブ検索やファイル検索など、モデルの機能を拡張するためにOpenAIによって提供されるツール。
- **関数呼び出し（カスタムツール）**：モデルが独自のコードを呼び出せるように、あなたが定義する関数。

##### ファイル検索ツール (File search)

**タイプ**: オブジェクト

アップロードされたファイル内の関連コンテンツを検索するツール。

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| type | 文字列 | はい | ファイル検索ツールのタイプ。常に `file_search` |
| vector_store_ids | 配列 | はい | 検索するベクトルストアIDのリスト |
| filters | オブジェクト | いいえ | 適用するフィルター |
| max_num_results | 整数 | いいえ | 返される最大結果数。この数値は1から50の間（両端を含む）である必要があります |
| ranking_options | オブジェクト | いいえ | 検索ランキングオプション |

###### フィルタータイプ

**比較フィルター (Comparison Filter)**

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| key | 文字列 | はい | 値と比較するキー |
| type | 文字列 | はい | 比較演算子を指定します: `eq`、`ne`、`gt`、`gte`、`lt`、`lte`<br>- eq: 等しい<br>- ne: 等しくない<br>- gt: より大きい<br>- gte: 以上<br>- lt: より小さい<br>- lte: 以下 |
| value | 文字列/数値/ブール値 | はい | 属性キーと比較する値。文字列、数値、またはブール型をサポートします |

**複合フィルター (Compound Filter)**

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| filters | 配列 | はい | 組み合わせるフィルターの配列。項目は比較フィルターまたは複合フィルターのいずれかです |
| type | 文字列 | はい | 操作タイプ: `and` または `or` |

###### ランキングオプション

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| ranker | 文字列 | いいえ | ファイル検索で使用されるランカー |
| score_threshold | 数値 | いいえ | ファイル検索のスコアしきい値。0から1の間の数値。1に近い数値は、最も関連性の高い結果のみを返そうとしますが、結果の数が少なくなる可能性があります |

##### 関数ツール (Function)

**タイプ**: オブジェクト

モデルが呼び出すことを選択できる、独自のコード内の関数を定義します。

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| type | 文字列 | はい | 関数ツールのタイプ。常に `function` |
| name | 文字列 | はい | 呼び出す関数の名前 |
| parameters | オブジェクト | はい | 関数のパラメータを記述するJSONスキーマオブジェクト |
| strict | ブール値 | はい | 厳密なパラメータ検証を強制するかどうか。デフォルトは `true` です |
| description | 文字列 | いいえ | 関数の説明。モデルはこれを使用して関数を呼び出すかどうかを決定します |

##### ウェブ検索ツール (Web search preview)

**タイプ**: オブジェクト

このツールは、レスポンスに使用する関連結果をウェブで検索します。

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| type | 文字列 | はい | ウェブ検索ツールのタイプ。選択可能な値: `web_search_preview` または `web_search_preview_2025_03_11` |
| search_context_size | 文字列 | いいえ | 検索に使用されるコンテキストウィンドウのスペース量に関する高レベルのガイダンス。選択可能な値: `low`、`medium`、`high`。デフォルトは `medium` |
| user_location | オブジェクト | いいえ | ユーザーの位置情報 |
| domains | 配列 | いいえ | 検索を制限するドメインのリスト |

###### ユーザーの位置情報

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| type | 文字列 | はい | 位置の近似タイプ。常に `approximate` |
| city | 文字列 | いいえ | ユーザーの都市の自由形式テキスト入力。例: "San Francisco" |
| country | 文字列 | いいえ | ユーザーの2文字のISO国コード。例: "US" |
| region | 文字列 | いいえ | ユーザーの地域の自由形式テキスト入力。例: "California" |
| timezone | 文字列 | いいえ | ユーザーのIANAタイムゾーン。例: "America/Los_Angeles" |

##### コンピューター使用ツール (Computer use preview)

**タイプ**: オブジェクト

仮想コンピューターを制御するためのツール。

| 属性 | タイプ | 必須 | 説明 |
|------|------|------|------|
| type | 文字列 | はい | コンピューター使用ツールのタイプ。常に `computer_use_preview` |
| display_height | 整数 | はい | コンピューターディスプレイの高さ |
| display_width | 整数 | はい | コンピューターディスプレイの幅 |
| environment | 文字列 | はい | 制御するコンピューター環境のタイプ |

#### top_p

**タイプ**: 数値またはnull  
**必須**: いいえ  
**デフォルト値**: 1

核サンプリングと呼ばれる、サンプリング温度の代替方法。モデルは、top_pの確率質量を持つトークン結果を考慮します。したがって、0.1は、上位10%の確率質量を含むトークンのみが考慮されることを意味します。

通常、この値または `temperature` のいずれかを変更することをお勧めしますが、両方を同時に変更することはお勧めしません。

#### truncation

**タイプ**: 文字列またはnull  
**必須**: いいえ  
**デフォルト値**: disabled

モデルレスポンスに使用される切り捨て（トランケーション）ポリシー：

| 値 | 説明 |
|------|------|
| `auto` | このレスポンスと前のレスポンスのコンテキストがモデルのコンテキストウィンドウサイズを超えた場合、モデルは会話の中間の入力項目を削除することでレスポンスを切り捨て、コンテキストウィンドウに収まるようにします |
| `disabled` | モデルレスポンスがモデルのコンテキストウィンドウサイズを超えると、リクエストは400エラーで失敗します |

#### user

**タイプ**: 文字列  
**必須**: いいえ

エンドユーザーを表す一意の識別子。OpenAIが不正行為を監視および検出するのに役立ちます。

## 📥 レスポンス

レスポンスオブジェクトを返します。

### 成功レスポンス

レスポンスオブジェクトを返します。リクエストがストリーミングされた場合は、レスポンスオブジェクトのストリーミングシーケンスを返します。

#### id 
- タイプ：文字列
- 説明：レスポンスの一意の識別子

#### object
- タイプ：文字列  
- 説明：オブジェクトタイプ。値は "response"

#### created_at
- タイプ：整数
- 説明：レスポンス作成のタイムスタンプ

#### status
- タイプ：文字列
- 説明：レスポンスステータス。例: "completed"、"in_progress" など

#### error
- タイプ：オブジェクトまたはnull
- 説明：エラーが発生した場合、エラー情報が含まれます

#### incomplete_details
- タイプ：オブジェクトまたはnull
- 説明：レスポンスが不完全な場合、詳細情報が含まれます

#### instructions
- タイプ：文字列またはnull
- 説明：モデルに提供されたシステム指示

#### max_output_tokens
- タイプ：整数またはnull
- 説明：最大出力トークン数

#### model
- タイプ：文字列
- 説明：使用されたモデル名

#### output
- タイプ：配列
- 説明：生成された応答とツール呼び出しが含まれます
- 含まれる可能性のあるもの:
  - メッセージオブジェクト（`type`: "message"）
  - ツール使用オブジェクト（`type`: "tool_use"）

#### parallel_tool_calls
- タイプ：ブール値
- 説明：並列ツール呼び出しが有効になっているかどうか

#### previous_response_id
- タイプ：文字列またはnull
- 説明：前のレスポンスのID（マルチターンの会話用）

#### reasoning
- タイプ：オブジェクト
- 説明：推論関連情報

#### store
- タイプ：ブール値
- 説明：このレスポンスを保存するかどうか

#### temperature
- タイプ：数値
- 説明：使用されたサンプリング温度

#### text
- タイプ：オブジェクト
- 説明：テキスト出力形式の設定

#### tool_choice
- タイプ：文字列
- 説明：ツール選択戦略

#### tools
- タイプ：配列
- 説明：利用可能なツールのリスト

#### top_p
- タイプ：数値
- 説明：核サンプリングのしきい値

#### truncation
- タイプ：文字列
- 説明：切り捨てポリシー

#### usage
- タイプ：オブジェクト
- 説明：トークン使用統計
- 属性:
  - `input_tokens`: 入力に使用されたトークン数
  - `input_tokens_details`: 入力トークンの詳細情報
  - `output_tokens`: 出力に使用されたトークン数
  - `output_tokens_details`: 出力トークンの詳細情報
  - `total_tokens`: 合計トークン数

#### user
- タイプ：文字列またはnull
- 説明：ユーザー識別子

#### metadata
- タイプ：オブジェクト
- 説明：添付されたメタデータ情報
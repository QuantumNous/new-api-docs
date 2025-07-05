# ✨ Feature Overview

1. 🎨 Brand new UI (some pages are still being updated)
2. 🌍 Multi-language support (to be improved)
3. 🎨 Added [Midjourney-Proxy(Plus)](https://github.com/novicezk/midjourney-proxy) API support
4. 💰 Supports online top-up, can be set in system settings:
    - [x] EasyPay
5. 🔍 Supports checking usage by key:
    - With the project [neko-api-key-tool](https://github.com/Calcium-Ion/neko-api-key-tool), you can check usage by key
6. 📑 Pagination supports selecting the number of items per page
7. 🔄 Compatible with the original One API database, can directly use the original database (one-api.db)
8. 💵 Supports per-call model billing, can be set in System Settings - Operation Settings
9. ⚖️ Supports **random channel weighting**
10. 📈 Data dashboard (dashboard)
11. 🔒 Can set which models a token can call
12. 🤖 Supports Telegram OAuth login:
    1. System Settings - Configure Login/Register - Allow login via Telegram
    2. Send command /setdomain to [@Botfather](https://t.me/botfather)
    3. Select your bot, then enter http(s)://your-website-address/login
    4. Telegram Bot name is the bot username without the @
13. 🎵 Added [Suno API](https://github.com/Suno-API/Suno-API) support
14. 🔄 Supports Rerank models, currently compatible with Cohere and Jina, can be integrated with Dify
15. ⚡ **[OpenAI Realtime API](https://platform.openai.com/docs/guides/realtime/integration)** - Supports OpenAI's Realtime API, supports Azure channels
16. Supports entering the chat interface via /chat2link route
17. 🧠 Supports setting reasoning effort via model name suffix:
    1. OpenAI o-series models
        - Add suffix `-high` for high reasoning effort (e.g.: `o3-mini-high`)
        - Add suffix `-medium` for medium reasoning effort (e.g.: `o3-mini-medium`)
        - Add suffix `-low` for low reasoning effort (e.g.: `o3-mini-low`)
    2. Claude reasoning models
        - Add suffix `-thinking` to enable reasoning mode (e.g.: `claude-3-7-sonnet-20250219-thinking`)
18. 🔄 Reasoning-to-content: supports setting `thinking_to_content` in Channel - Edit - Channel Extra Settings, default is `false`. When enabled, reasoning content `reasoning_content` will be converted to `<think>` tag and appended to the content in the response.
19. 🔄 Model rate limiting: supports setting model rate limits in System Settings - Rate Limit Settings, supports setting total request limit and successful request limit
20. 💰 Cache billing support: after enabling, you can bill according to the set ratio when cache hits occur:
    1. Set prompt cache ratio option in System Settings - Operation Settings
    2. Set prompt cache ratio in channels, range 0-1, e.g. 0.5 means 50% billing on cache hit
    3. Supported channels:
      - [x] OpenAI
      - [x] Azure
      - [x] DeepSeek
      - [ ] Claude 
# LangBot - IM Bot Development Platform

!!! info
    LangBot is an open-source IM bot development platform that supports multiple instant messaging platforms such as Lark, DingTalk, WeChat, QQ, Telegram, Discord, Slack, and more. It integrates with globally leading AI models, supports knowledge bases, Agent, MCP, and various other AI application capabilities, and is perfectly compatible with NewAPI.

    - Official Website: <https://langbot.app/en>
    - Download: <https://github.com/langbot-app/LangBot/releases>
    - Official Documentation: <https://docs.langbot.app/en/insight/guide.html>
    - Open Source Repository: <https://github.com/langbot-app/LangBot>

## Integrating with NewAPI

LangBot supports integration with locally deployed NewAPI and third-party NewAPI services built using NewAPI.

### Usage Instructions

1. Get API key from NewAPI
![Get API key](../assets/langbot/get_api_key.png)

    For locally deployed NewAPI, please configure the API address yourself (refer to [Container Network Connection](https://docs.langbot.app/en/workshop/network-details.html)). If using third-party NewAPI services, you can copy the address from the page. Note that `/v1` needs to be added after the address.

2. Add a model in LangBot, select NewAPI as the provider, and fill in the corresponding API key and API address
    ![Add NewAPI Model](../assets/langbot/add_newapi_model.png)

3. Select the model to use in the pipeline

    ![Select Model](../assets/langbot/select_model.png)

4. Chat in the conversation debug or with the bot bound to the pipeline to use it

    ![Slack Chat](../assets/langbot/slack.png)

    For deploying and configuring bots, please refer to [Deploy Bots](https://docs.langbot.app/en/deploy/platforms/readme.html).

### Using LangBot Knowledge Base

LangBot supports using NewAPI's embedding models as vector models for knowledge bases.

1. Add an embedding model in LangBot, select NewAPI as the provider
![Add Embedding Model](../assets/langbot/add_embedding_model.png)

2. Choose the embedding model when creating a new knowledge base
![Use Embedding Model](../assets/langbot/use_embedding_model.png)


For more usage methods, please refer to LangBot's official documentation: <https://docs.langbot.app/en/insight/guide.html>
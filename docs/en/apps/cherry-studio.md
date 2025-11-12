# Cherry Studio - Desktop AI Client
!!! tip "Chat settings option"
    In the New API Console under System Settings -> Chat settings, you can add the following quick option to enable one-click fill to Cherry Studio from the API Keys page:

    ```json
    { "Cherry Studio": "cherrystudio://providers/api-keys?v=1&data={cherryConfig}" }
    ```
!!! info
    🍒 Cherry Studio is a powerful desktop AI client designed for professional users, integrating 30+ industry-specific AI assistants to meet various work scenario requirements and significantly improve work efficiency.

    - Official Website: <https://cherry-ai.com/>
    - Download: <https://cherry-ai.com/download>
    - Documentation: <https://docs.cherry-ai.com>

## NewAPI Integration Method

### Parameter Configuration

Provider Type: Any type supported by NewAPI  
API Key: Obtain from NewAPI  
API Host: NewAPI site address  

### Step-by-Step Guide

1. Copy API key from NewAPI
![Copy API Key](../assets/cherry_studio/copy_api_key.png)

2. Add Provider
![Add Provider](../assets/cherry_studio/add_provider.png)

3. Add Models
![Add Models](../assets/cherry_studio/add_models.png)

4. Return to Chat Page
![Switch to Chat Page](../assets/cherry_studio/back_to_chat.png)

5. Switch to NewAPI Model
![Switch Model](../assets/cherry_studio/switch_model.png)

## Drawing in Cherry Studio

*First, you need to configure an API provider that supports drawing*

1. First, add models that support drawing
![Drawing Models](../assets/cherry_studio/add_paint_models.png)

2. Drawing
![Drawing](../assets/cherry_studio/paint.png) 
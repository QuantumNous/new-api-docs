# ❓ Frequently Asked Questions

## 💰 Quota Related Questions

??? tip "What is quota? How is it calculated?"
    
    The quota calculation formula is as follows:
    
    Quota = Group Multiplier * Model Multiplier * (Prompt Token Count + Completion Token Count * Completion Multiplier)

    Completion Multiplier explanation:
    
    - GPT3.5: Fixed at 1.33
    - GPT4: Fixed at 2 (same as official)

    Notes:
    
    - In non-streaming mode, the official API returns the total tokens consumed, but the multipliers for prompt and completion are different
    - New API's default multipliers are consistent with the official ones and have been adjusted accordingly

??? tip "Why does it say 'insufficient quota' even though my account has enough?"
    
    This is because token quota and account quota are separate:
    
    - Token quota is only used to set the maximum usage limit
    - Users can freely set token quota
    - Please check if your token quota is sufficient

## 🔧 Channel Configuration Questions

??? tip "What are weight and priority in channels?"
    
    Weight and priority are two important parameters that control the usage order and distribution of channels:

    - Priority: The higher the number, the higher the priority. Channels with higher priority are used first
    - Weight: Among channels with the same priority, requests are distributed according to the weight ratio

    For example:
    
    - A channel with priority 2 will be used before a channel with priority 1
    - Two channels with priority 1 and a weight ratio of 2:1 will receive requests in a 2:1 ratio

??? tip "Prompt says no available channel?"
    
    Please check the following settings:

    1. User group settings
    2. Channel group settings
    3. Model settings for the channel

??? tip "Channel test error: invalid character '<' looking for beginning of value"
    
    This error means the return value is not valid JSON, but an HTML page.
    
    The most likely reason: Your deployment server's IP or proxy node has been blocked by CloudFlare.

??? tip "Channel test error: Multiplier or price not configured, please ask the admin to set it"

    Please check if the multiplier or price is configured in 'System Settings - Operation Settings - Model Multiplier Settings'.

    Or enable 'Self-use Mode' in 'System Settings - Operation Settings'.

## 🌐 Deployment & Connection Issues

??? tip "ChatGPT Next Web error: Failed to fetch"
    
    Please check the following:

    1. Do not set BASE_URL during deployment
    2. Make sure the API endpoint and API Key are correct
    3. Check if HTTPS is enabled (browsers block HTTP requests under HTTPS domains)

??? tip "Error: Current group load is saturated, please try again later"
    
    This means the upstream channel returned a 429 error (too many requests).

## 📦 Database & Upgrade Issues

??? tip "Will my data be lost after upgrading?"
    
    It depends on the database type:

    - MySQL: Data will not be lost
    - SQLite: You need to mount the volume for the one-api.db database file as per the deployment command, otherwise data will be lost after container restart

??? tip "Do I need to change the database before upgrading?"
    
    Generally, no. The system will automatically adjust during initialization.
    
    If special handling is needed, it will be explained in the release notes with corresponding scripts provided.

??? tip "Error after manually modifying the database: Database consistency has been broken, please contact the admin?"
    
    This error means an invalid channel ID record was detected in the ability table. Common reasons:
    
    - When deleting records from the channel table, the corresponding invalid channels in the ability table were not cleaned up
    - Each model supported by a channel must have a corresponding record in the ability table

!!! note "Can't find your question?"
    If your question is not answered here, you are welcome to:
    
    1. View the [full documentation](../getting-started.md)
    2. Submit an [issue on GitHub](feedback-issues.md)
    3. Join the [QQ group for help](community-interaction.md) 
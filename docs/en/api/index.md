---
hide:
  - footer
---

<style>
  .md-typeset .grid.cards > ul {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr));
    gap: 1rem;
    margin: 1em 0;
  }
  
  .md-typeset .grid.cards > ul > li {
    border: none;
    border-radius: 0.8rem;
    box-shadow: var(--md-shadow-z2);
    padding: 1.5rem;
    transition: transform 0.25s, box-shadow 0.25s;
    background: linear-gradient(135deg, var(--md-primary-fg-color), var(--md-accent-fg-color));
    color: var(--md-primary-bg-color);
  }

  .md-typeset .grid.cards > ul > li:hover {
    transform: scale(1.02);
    box-shadow: var(--md-shadow-z3);
  }

  .md-typeset .grid.cards > ul > li > hr {
    margin: 0.8rem 0;
    border: none;
    border-bottom: 2px solid var(--md-primary-bg-color);
    opacity: 0.2;
  }

  .md-typeset .grid.cards > ul > li > p {
    margin: 0.5rem 0;
  }

  .md-typeset .grid.cards > ul > li > p > em {
    color: var(--md-primary-bg-color);
    opacity: 0.8;
    font-style: normal;
  }

  .md-typeset .grid.cards > ul > li > p > .twemoji {
    font-size: 2.5rem;
    display: block;
    margin: 0.5rem auto;
  }

  /* Enhanced: Beautify introduction section */
  .interface-intro {
    margin: 2rem 0;
    padding: 1.5rem;
    border-radius: 0.8rem;
    background-color: var(--md-primary-fg-color--light);
    color: var(--md-primary-bg-color);
  }

  /* Enhanced: Optimize card link styles */
  .md-typeset .grid.cards > ul > li a {
    display: inline-flex;
    align-items: center;
    margin-top: 1.2em;
    padding: 0.5em 1.2em;
    color: white;
    background-color: rgba(255, 255, 255, 0.15);
    border-radius: 2em;
    transition: all 0.3s ease;
    font-weight: 500;
    font-size: 0.9em;
    letter-spacing: 0.03em;
    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
    position: relative;
    overflow: hidden;
    text-decoration: none;
  }

  .md-typeset .grid.cards > ul > li a:hover {
    background-color: rgba(255, 255, 255, 0.25);
    text-decoration: none;
    box-shadow: 0 5px 12px rgba(0, 0, 0, 0.2);
    transform: translateX(5px);
  }

  .md-typeset .grid.cards > ul > li a:after {
    content: "→";
    opacity: 0;
    margin-left: -15px;
    transition: all 0.2s ease;
  }

  .md-typeset .grid.cards > ul > li a:hover:after {
    opacity: 1;
    margin-left: 5px;
  }
</style>

# API Overview

## 💫 Relay Interfaces

<div class="grid cards" markdown>

-   :material-chat:{ .twemoji }

    **Chat**

    ---

    Support for multiple mainstream chat model formats:
    
    [OpenAI Chat →](openai-chat.md)
    [OpenAI Responses →](openai-responses.md)
    [Anthropic Chat →](anthropic-chat.md)
    [Deepseek Chat →](deepseek-reasoning-chat.md)
    [Google Chat →](google-gemini-chat.md)

-   :material-alphabetical:{ .twemoji }

    **Embeddings**

    ---

    Text vector embedding services:
    
    [OpenAI Embeddings →](openai-embedding.md)

-   :material-swap-vertical:{ .twemoji }

    **Rerank**

    ---

    Search result reranking services:
    
    [Jina AI Rerank →](jinaai-rerank.md)
    [Cohere Rerank →](cohere-rerank.md)
    [Xinference Rerank →](xinference-rerank.md)

-   :material-lightning-bolt:{ .twemoji }

    **Realtime Chat**

    ---

    Support for streaming real-time conversations:
    
    [OpenAI Realtime →](openai-realtime.md)

-   :material-image:{ .twemoji }

    **Image**

    ---

    AI image generation services:
    
    [OpenAI Image →](openai-image.md)
    [Midjourney Proxy →](midjourney-proxy-image.md)

-   :material-volume-high:{ .twemoji }

    **Audio**

    ---

    Speech-related services:
    
    [OpenAI Audio →](openai-audio.md)

-   :material-music:{ .twemoji }

    **Music**

    ---

    AI music generation services:
    
    [Suno API →](suno-music.md)

</div>

## 🖥️ Frontend Interfaces

<div class="grid cards" markdown>

-   :material-rocket-launch:{ .twemoji }

    **Coming Soon**

    ---

    Frontend API documentation is being written, stay tuned!
    
    [Learn More →](../coming-soon.md)

</div>

---

## 📖 Interface Description

!!! abstract "Interface Types"
    New API provides two main types of interfaces:
    
    1. **Relay Interfaces**: For AI model calls, supporting multiple mainstream model formats
    2. **Frontend Interfaces**: For supporting Web interface functionality calls, providing complete frontend functionality support

!!! tip "Feature Support Indicators"
    In the API documentation, we use the following icons to indicate feature support status:

    - ✅ **Supported**: This feature is fully implemented and available for use
    - 🟡 **Partially Supported**: Feature is available but has limitations or provides only partial capabilities
    - ❌ **Not Supported**: This feature is under development or planned for development

!!! example "Quick Start"
    1. Browse the cards above to select the interface you need to use
    2. Click "View Details" on the corresponding card to learn specific usage
    3. Follow the documentation instructions for interface calls 
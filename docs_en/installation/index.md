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

# Installation Guide

## 🚀 Deployment Methods

<div class="grid cards" markdown>

-   :material-docker:{ .twemoji }

    **Docker Deployment**

    ---

    The simplest single-node deployment method:
    
    [View Tutorial →](docker-installation.md)

-   :material-docker:{ .twemoji }

    **Docker Compose Deployment**

    ---

    Recommended single-node deployment method:
    
    [View Tutorial →](docker-compose-installation.md)

-   :material-server:{ .twemoji }

    **BT Panel Deployment**

    ---

    Visual deployment using BT Panel:
    
    [View Tutorial →](bt-docker-installation.md)

-   :material-server-network:{ .twemoji }

    **Cluster Deployment**

    ---

    The best choice for large-scale deployment:
    
    [View Tutorial →](cluster-deployment.md)

-   :material-code-braces:{ .twemoji }

    **Local Development Deployment**

    ---

    Suitable for developers and contributors:
    
    [View Tutorial →](local-development.md)

</div>

## ⚙️ Configuration & Maintenance

<div class="grid cards" markdown>

-   :material-update:{ .twemoji }

    **System Update**

    ---

    Learn how to update to the latest version:
    
    [View Guide →](system-update.md)

-   :material-variable:{ .twemoji }

    **Environment Variables**

    ---

    All configurable environment variables explained:
    
    [View Documentation →](environment-variables.md)

-   :material-file-cog:{ .twemoji }

    **Configuration File**

    ---

    Detailed explanation of Docker Compose configuration file:
    
    [View Guide →](docker-compose-yml.md)

</div>

## 📖 Deployment Notes

!!! tip "Recommended Choices"
    - For personal users, Docker or Docker Compose deployment is recommended
    - Users familiar with BT Panel can choose BT Panel deployment
    - For enterprise users, cluster deployment is recommended for better scalability

!!! warning "Notes"
    Before deployment, please ensure:

    1. All required base software is installed
    2. You are familiar with basic Linux and Docker commands
    3. The server meets the minimum requirements
    4. All required API keys are ready

!!! info "Get Help"
    If you encounter problems during deployment:

    1. Check the [FAQ](../support/faq.md)
    2. Submit an issue on [GitHub](https://github.com/Calcium-Ion/new-api/issues)
    3. Join the [community group](../support/community-interaction.md) for help 
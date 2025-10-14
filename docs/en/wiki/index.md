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

# Wiki

## 📚 Basic Concepts

<div class="grid cards" markdown>

-   :material-information-outline:{ .twemoji }

    **Project Introduction**

    ---

    Learn about the goals, licenses, and more for the New API project:
    
    [View Details →](project-introduction.md)

-   :material-star-outline:{ .twemoji }

    **Feature Description**

    ---

    Core features and functionalities provided by New API:
    
    [View Details →](features-introduction.md)

-   :material-crane:{ .twemoji }

    **Technical Architecture**

    ---

    The overall system architecture and technology stack:
    
    [View Details →](technical-architecture.md)

-   :material-chart-line:{ .twemoji }

    **Website Traffic Analysis**

    ---

    Configure Google Analytics and Umami analysis tools:
    
    [View Details →](analytics-setup.md)

</div>

## 📝 Project Records

<div class="grid cards" markdown>

-   :material-notebook-edit-outline:{ .twemoji }

    **Changelog**

    ---

    Records of project version iterations and feature updates:
    
    [View Records →](changelog.md)

-   :material-heart-outline:{ .twemoji }

    **Special Thanks**

    ---

    Thanks to all individuals and organizations who have contributed to the project:
    
    [View List →](special-thanks.md)

</div>

## 📖 Overview

!!! info "What is New API?"
    New API is a next-generation large model gateway and AI asset management system, designed to simplify the integration and management of AI models, providing unified API interfaces and resource management capabilities.

!!! tip "Why choose New API?"
    - Unified API interface supporting various mainstream large models
    - Comprehensive resource management and monitoring capabilities
    - Complete ecosystem and secondary development capabilities
    - Active community support and continuous updates

!!! question "Have Questions?"
    If you have any questions about the project, you can:

    1. Check the [Frequently Asked Questions](../support/faq.md)
    2. Submit an issue on [GitHub](https://github.com/Calcium-Ion/new-api/issues)
    3. Join the [Community Interaction](../support/community-interaction.md) for help
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

# Support & Help

## 💫 Support Services

<div class="grid cards" markdown>

-   :material-chat-question:{ .twemoji }

    **FAQ**

    ---

    View frequently asked questions and quickly resolve your doubts:
    
    [FAQ →](faq.md)

-   :material-account-group:{ .twemoji }

    **Community**

    ---

    Join our community and connect with other users:
    
    [QQ Group →](community-interaction.md)

-   :material-bug:{ .twemoji }

    **Feedback & Issues**

    ---

    Encountered a problem? Let us know:
    
    [Submit an Issue →](feedback-issues.md)

-   :material-coffee:{ .twemoji }

    **Support Us**

    ---

    If you find this project helpful:
    
    [Buy us a coffee →](buy-us-a-coffee.md)

</div>

## 📖 Support Instructions

!!! tip "Get Help"
    We offer multiple ways to help you solve problems:

    1. **Read the documentation**: Most questions can be answered in the docs
    2. **FAQ**: Browse the FAQ for quick solutions
    3. **Community**: Join the QQ group to exchange experiences with other users
    4. **Feedback & Issues**: Submit an issue on GitHub and we will handle it promptly

!!! info "About Sponsorship"
    New API is a completely free and open-source project. We do not require any form of sponsorship.
    But if you find the project helpful, feel free to buy us a coffee. This will help us:

    - Maintain and upgrade servers
    - Develop new features
    - Provide better documentation
    - Build a stronger community

!!! warning "Notice"
    When seeking help, please note:

    - Check the documentation and FAQ before asking
    - Provide enough information for us to understand and reproduce the issue
    - Follow community rules and maintain a friendly atmosphere
    - Please be patient—we will handle your issue as soon as possible 
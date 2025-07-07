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

# 使用指南 <small>根据导航和侧边栏的页面顺序进行分类</small>

<div class="grid cards" markdown>

-   :material-home:{ .twemoji }

    **首页**

    ---

    New API 系统首页介绍：
    
    [了解详情 →](home.md)

-   :material-view-dashboard:{ .twemoji }

    **控制台界面**

    ---

    New API 系统的控制台介绍：
    
    [了解详情 →](console/dashboard.md)

-   :material-crown:{ .twemoji }

    **定价界面**

    ---

    New API 系统定价界面介绍：
    
    [了解详情 →](pricing.md)

-   :material-book-open-page-variant:{ .twemoji }

    **文档界面**

    ---

     New API 系统导航栏的文档介绍：
    
    [了解详情 →](document.md)

-   :material-information-outline:{ .twemoji }

    **关于界面**

    ---

     New API 系统的关于界面介绍：
    
    [了解详情 →](about.md)

</div>

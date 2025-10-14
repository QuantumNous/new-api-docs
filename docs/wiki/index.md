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

# 维基百科

## 📚 基本概念

<div class="grid cards" markdown>

-   :material-information-outline:{ .twemoji }

    **项目介绍**

    ---

    了解 New API 项目的目标和许可证等：
    
    [查看详情 →](project-introduction.md)

-   :material-star-outline:{ .twemoji }

    **特性说明**

    ---

    New API 提供的核心特性和功能：
    
    [查看详情 →](features-introduction.md)

-   :material-crane:{ .twemoji }

    **技术架构**

    ---

    系统的整体架构和技术栈：
    
    [查看详情 →](technical-architecture.md)

-   :material-chart-line:{ .twemoji }

    **网站访问数据分析**

    ---

    配置 Google Analytics 和 Umami 分析工具：
    
    [查看详情 →](analytics-setup.md)

</div>

## 📝 项目记录

<div class="grid cards" markdown>

-   :material-notebook-edit-outline:{ .twemoji }

    **更新日志**

    ---

    项目版本迭代和功能更新记录：
    
    [查看记录 →](changelog.md)

-   :material-heart-outline:{ .twemoji }

    **特别鸣谢**

    ---

    感谢所有为项目做出贡献的个人和组织：
    
    [查看名单 →](special-thanks.md)

</div>

## 📖 概述

!!! info "什么是New API？"
    New API 是一个新一代大模型网关与AI资产管理系统，旨在简化AI模型的接入和管理，提供统一的API接口和资源管理能力。

!!! tip "为什么选择 New API？"
    - 统一的API接口，支持多种主流大模型
    - 完善的资源管理和监控能力
    - 完整的生态和二次开发能力
    - 活跃的社区支持和持续更新

!!! question "有问题？"
    如果您对项目有任何疑问，可以：

    1. 查看[常见问题](../support/faq.md)
    2. 在[GitHub](https://github.com/Calcium-Ion/new-api/issues)上提交issue
    3. 加入[社区交流](../support/community-interaction.md)获取帮助 
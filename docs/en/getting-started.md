---
hide:
  - footer
  - navigation
  - toc
---

<style>
  /* 卡片容器样式优化 */
  .md-typeset .grid.cards > ul {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr));
    gap: 1.2rem;
    margin: 2em 0;
  }
  
  /* 卡片基础样式 */
  .md-typeset .grid.cards > ul > li {
    border: none;
    border-radius: 1rem;
    display: flex;
    flex-direction: column;
    margin: 0;
    padding: 1.8em 1.5em;
    transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    color: white;
    position: relative;
    overflow: hidden;
    line-height: 1.5;
    z-index: 1;
  }
  
  /* 卡片悬停效果增强 */
  .md-typeset .grid.cards > ul > li:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.18);
  }
  
  /* 卡片悬停时的光效 */
  .md-typeset .grid.cards > ul > li:before {
    content: "";
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(
      90deg, 
      rgba(255, 255, 255, 0) 0%, 
      rgba(255, 255, 255, 0.2) 50%, 
      rgba(255, 255, 255, 0) 100%
    );
    transition: all 0.6s;
    z-index: 2;
  }
  
  .md-typeset .grid.cards > ul > li:hover:before {
    left: 100%;
  }
  
  /* 卡片暗色遮罩优化 */
  .md-typeset .grid.cards > ul > li:after {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: radial-gradient(circle at center, rgba(0, 0, 0, 0.05) 0%, rgba(0, 0, 0, 0.2) 100%);
    pointer-events: none;
    z-index: 1;
  }
  
  /* 卡片内容层叠设置 */
  .md-typeset .grid.cards > ul > li > * {
    position: relative;
    z-index: 3;
  }
  
  /* 部署方式卡片颜色设置 */
  /* Docker Compose card */
  .md-typeset .grid.cards:nth-of-type(1) > ul > li:nth-child(1) {
    background: linear-gradient(135deg, #0bb8cc 0%, #0bd1b6 100%);
  }
  
  /* Docker card */
  .md-typeset .grid.cards:nth-of-type(1) > ul > li:nth-child(2) {
    background: linear-gradient(135deg, #2457c5 0%, #2b88d9 100%);
  }
  
  /* 宝塔面板卡片 */
  .md-typeset .grid.cards:nth-of-type(1) > ul > li:nth-child(3) {
    background: linear-gradient(135deg, #f27121 0%, #e94057 100%);
  }
  
  /* 集群部署卡片 */
  .md-typeset .grid.cards:nth-of-type(1) > ul > li:nth-child(4) {
    background: linear-gradient(135deg, #654ea3 0%, #8862cf 100%);
  }
  
  /* 本地开发部署卡片 */
  .md-typeset .grid.cards:nth-of-type(1) > ul > li:nth-child(5) {
    background: linear-gradient(135deg, #1e6e42 0%, #28a745 100%);
  }
  
  /* 文档卡片颜色设置 */
  /* 维基百科卡片 */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(1) {
    background: linear-gradient(135deg, #7303c0 0%, #ec38bc 100%);
  }
  
  /* 安装指南卡片 */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(2) {
    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
  }
  
  /* 用户指南卡片 */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(3) {
    background: linear-gradient(135deg, #3a47d5 0%, #6d80fe 100%);
  }
  
  /* 接口文档卡片 */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(4) {
    background: linear-gradient(135deg, #00c6fb 0%, #005bea 100%);
  }
  
  /* 帮助支持卡片 */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(5) {
    background: linear-gradient(135deg, #228B22 0%, #32CD32 100%);
  }

  /* AI Applications card */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(6) {
    background: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
  }

  /* Business Cooperation card */
  .md-typeset .grid.cards:nth-of-type(2) > ul > li:nth-child(7) {
    background: linear-gradient(135deg, #8e44ad 0%, #9b59b6 100%);
  }
  
  /* 卡片纹理背景优化 */
  .md-typeset .grid.cards > ul > li {
    background-blend-mode: soft-light;
    background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%23ffffff' fill-opacity='0.08' fill-rule='evenodd'/%3E%3C/svg%3E");
  }
  
  /* 卡片内段落文本样式 */
  .md-typeset .grid.cards > ul > li p {
    margin: 0.7em 0;
    color: rgba(255, 255, 255, 0.92);
    line-height: 1.6;
    font-size: 0.95em;
    letter-spacing: 0.01em;
  }
  
  /* 卡片内标题文本样式 */
  .md-typeset .grid.cards > ul > li p strong,
  .md-typeset .grid.cards > ul > li strong {
    color: white;
    display: block;
    margin-top: 0.5em;
    margin-bottom: 0.3em;
    font-size: 1.2em;
    font-weight: 700;
    letter-spacing: 0.02em;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.15);
  }
  
  /* 卡片分隔线样式 */
  .md-typeset .grid.cards > ul > li hr {
    margin: 0.9em 0;
    height: 2px;
    border: none;
    background: linear-gradient(
      to right,
      rgba(255, 255, 255, 0.1) 0%,
      rgba(255, 255, 255, 0.4) 50%,
      rgba(255, 255, 255, 0.1) 100%
    );
  }
  
  /* 卡片图标样式 */
  .md-typeset .grid.cards > ul > li .twemoji {
    font-size: 3.2em;
    display: block;
    margin: 0 auto 0.6em;
    text-align: center;
    filter: drop-shadow(0 2px 5px rgba(0, 0, 0, 0.2));
    transition: transform 0.3s ease, filter 0.3s ease;
  }
  
  /* 卡片图标悬停效果 */
  .md-typeset .grid.cards > ul > li:hover .twemoji {
    transform: scale(1.1) rotate(5deg);
    filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.3));
  }
  
  /* 卡片标题居中 */
  .md-typeset .grid.cards > ul > li .title {
    text-align: center;
    font-weight: bold;
    margin-bottom: 0.5em;
  }
  
  /* 卡片链接按钮样式 */
  .md-typeset .grid.cards > ul > li .more-link {
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
  }
  
  /* 卡片链接按钮悬停效果 */
  .md-typeset .grid.cards > ul > li .more-link:hover {
    background-color: rgba(255, 255, 255, 0.25);
    text-decoration: none;
    box-shadow: 0 5px 12px rgba(0, 0, 0, 0.2);
    transform: translateX(5px);
  }
  
  /* 链接按钮箭头动画 */
  .md-typeset .grid.cards > ul > li .more-link:after {
    content: "→";
    opacity: 0;
    margin-left: -15px;
    transition: all 0.2s ease;
  }
  
  .md-typeset .grid.cards > ul > li .more-link:hover:after {
    opacity: 1;
    margin-left: 5px;
  }
  
  /* 调整卡片内的普通链接文本颜色 */
  .md-typeset .grid.cards > ul > li a:not(.more-link) {
    color: white;
    text-decoration: underline;
    text-decoration-color: rgba(255, 255, 255, 0.3);
    text-decoration-thickness: 1px;
    text-underline-offset: 2px;
    transition: all 0.2s;
  }
  
  /* 普通链接悬停效果 */
  .md-typeset .grid.cards > ul > li a:not(.more-link):hover {
    text-decoration-color: rgba(255, 255, 255, 0.8);
    text-shadow: 0 0 8px rgba(255, 255, 255, 0.4);
  }
</style>

## 🎯 **Choose Your Deployment Method**

<div class="grid cards" markdown>

-   :fontawesome-brands-docker:{ .twemoji } 
    
    **Docker Compose Deployment** ⭐Recommended
    
    ---
    
    Orchestrate multiple services with Docker Compose – ideal for production or setups requiring MySQL, Redis, etc.
    
    [Learn more →](installation/docker-compose-installation.md){ .more-link }

-   :fontawesome-brands-docker:{ .twemoji } 
    
    **Docker Single-Container Deployment**
    
    ---
    
    Deploy New API quickly with a single Docker image – perfect for personal or small-scale scenarios.
    
    [Learn more →](installation/docker-installation.md){ .more-link }

-   :material-server:{ .twemoji } 
    
    **BT Panel Deployment**
    
    ---
    
    Deploy via the BT Panel GUI – great for users who prefer not to use the command line.
    
    [Learn more →](installation/bt-docker-installation.md){ .more-link }

-   :material-server-network:{ .twemoji } 
    
    **Cluster Deployment Mode**
    
    ---
    
    Multi-node distributed deployment for high availability, load balancing and horizontal scaling – designed for large-scale or enterprise scenarios.
    
    [Learn more →](installation/cluster-deployment.md){ .more-link }

-   :material-code-braces:{ .twemoji } 
    
    **Local Development Environment**
    
    ---
    
    Intended for contributors and secondary development, offering a full local setup guide.
    
    [Learn more →](installation/local-development.md){ .more-link }

</div>

## 📚 **Explore Our Documentation**

<div class="grid cards" markdown>

-   :fontawesome-solid-book:{ .twemoji } 
    
    **Wiki**
    
    ---
    
    Explore the project introduction, feature overview, technical architecture and roadmap.
    
    [Learn more →](wiki/index.md){ .more-link }

-   :fontawesome-solid-user:{ .twemoji } 
    
    **User Guide**
    
    ---
    
    Detailed usage instructions and best practices.
    
    [Coming Soon](){ .more-link }

-   :fontawesome-solid-code:{ .twemoji } 
    
    **API Reference**
    
    ---
    
    Comprehensive API descriptions and usage examples.
    
    [Learn more →](api/index.md){ .more-link }

-   :fontawesome-solid-headset:{ .twemoji } 
    
    **Help & Support**
    
    ---
    
    FAQs and community discussion.
    
    [Learn more →](support/index.md){ .more-link }

-   :fontawesome-solid-list:{ .twemoji } 
    
    **Quick Start Guide**
    
    ---
    
    Quick start instructions and step-by-step walkthrough.
    
    [Learn more →](guide/index.md){ .more-link }

-   :fontawesome-solid-robot:{ .twemoji } 
    
    **AI Applications**
    
    ---
    
    Explore various AI application examples built with New API.
    
    [Learn more →](apps/cherry-studio.md){ .more-link }

-   :fontawesome-solid-handshake:{ .twemoji } 
    
    **Business Cooperation**
    
    ---
    
    Partner with us to expand the AI ecosystem and business opportunities.
    
    [Learn more →](business-cooperation.md){ .more-link }

</div>

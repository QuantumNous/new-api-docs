# OpenAI Codex CLI
-------------------------------------

<style>
    .inline-badge img {
        display: inline-block; /* 或者使用 display: inline; */
        vertical-align: middle; /* 对齐方式，如果需要的话 */
    }
</style>
<div class="inline-badge" style="line-height: 1; display: block;">
  <img src="https://img.shields.io/badge/-Windows-0078D6?logo=windows&style=flat&logoColor=white" alt="Windows" style="height: 20px; margin: 0; vertical-align: top;">
  <img src="https://img.shields.io/badge/-macOS-black?logo=apple&style=flat&logoColor=white" alt="macOS" style="height: 20px; margin: 0; vertical-align: top;">
  <img src="https://img.shields.io/badge/-Linux-FCC624?logo=linux&style=flat&logoColor=black" alt="Linux" style="height: 20px; margin: 0; vertical-align: top;">
</div>

!!! info "项目介绍"
    Codex CLI is a coding agent from OpenAI that runs locally on your computer.

    Codex CLI 是一个来自 OpenAI 的编码代理，可在您的计算机上本地运行。

    1. 官方主页：<a href="https://chatgpt.com/codex" target="_blank">https://chatgpt.com/codex</a>
    1. 项目主页：<a href="https://github.com/openai/codex" target="_blank">https://github.com/openai/codex</a>
    1. 安装方法：见本页下方教程

## 效果演示
-------------------------------------

![introduce-01.webp](../assets/codex/introduce-01.webp)

### 特性

| **功能分类** | **特性** |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| 终端式编码助手 | Codex CLI 是一个基于终端的交互式编码助理，用于在命令行中编辑代码、生成补丁并运行命令。 |
| 工具驱动架构 | 提供 `apply_patch`、`shell`、`update_plan`、`multi_tool_use` 等工具，用于对仓库文件和操作进行可控修改。 |
| 原子补丁编辑 | 使用专门的补丁格式通过 `apply_patch` 原子地添加/更新/删除文件，便于审计与回滚。 |
| 沙箱与审批 | 支持沙箱策略（如 `workspace-write`、`read-only`）和审批模式（`on-request`、`on-failure`、`never`），控制写入与网络访问权限。 |
| 计划追踪 | `update_plan` 用于列出步骤并跟踪状态，要求始终只有一个 `in_progress` 步骤以保持明确进度。 |
| 交互规范 | 在重要操作前发送简短前导说明，保持语气友好、简洁并提供进度更新。 |
| 安全约束 | 遵循严格规则（不随意更改无关文件、不添加版权头、不执行破坏性命令），需要用户批准敏感操作。 |
| 测试与格式化 | 推荐在修改后运行相关测试与格式化工具，但不负责修复与当前任务无关的问题。 |
| 输出与风格 | 最终输出遵循 CLI 渲染规范（例如 `**` 标题、反引号表示路径/命令），保持可扫描的简洁结构。 |
| 并行执行 | 支持通过 `multi_tool_use.parallel` 并行运行多个工具以提升效率。 |

## AI 模型配置方法

### Windows 端图文指引

#### 1.打开终端

![windows_open_terminal](../assets/codex/windows_open_terminal.png)

#### 2.安装 WSL

为在 Windows 上获得最佳性能，请安装并使用 Windows Subsystem for Linux (WSL2)。

!!! info "安装 WSL2，重启 Windows 计算机"
    ```
    wsl --install
    ```
    安装完成后重启 Windows 计算机

!!! caution "Windows 注意事项"
    - 建议使用 PowerShell 而不是 CMD
    - 如果遇到权限问题，尝试以管理员身份运行
    - 某些杀毒软件可能会误报，需要添加白名单

![windows-img-03.webp](../assets/codex/windows-img-03.webp)

!!! info "下载 Node Version Manager (NVM)"
    ```
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    ```

![windows-img-04.webp](../assets/codex/windows-img-04.webp)

!!! info "NVM 安装 Node.js 22"
    标签栏新开一个 PowerShell 窗口，打开 WSL
    ```
    wsl
    ```

    安装 Node.js
    
    版本号有时效性，请根据 OpenAI 官网要求安装对应版本：https://developers.openai.com/codex/windows
    ```
    nvm install 22
    ```

![windows-img-05.webp](../assets/codex/windows-img-05.webp)

#### 3.安装 Codex CLI

!!! info "安装 Codex CLI"
    ```
    npm i -g @openai/codex
    ```
    这个命令会从 npm 官方仓库下载并安装最新版本的 Codex CLI。

![windows-img-06.webp](../assets/codex/windows-img-06.webp)

#### 4.修改配置文件

!!! info "一键修改 Codex CLI 配置文件"
    ```
    iex (irm 'https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/codex-cli-setup.ps1')
    ```

![windows-configure](../assets/codex/windows_configure.png)

#### 5.开始使用 Codex CLI

现在你可以开始使用 Codex CLI 了！

!!! info "启动 Codex CLI"
    启动 WSL2
    ```
    wsl
    ```
    直接启动 Codex CLI:
    ```
    codex
    ```
    在特定项目中使用:
    ```
    cd mnt/c/path/to/your/project
    ```
    ```
    codex
    ```
    Enter 启动 Codex CLI

![windows-img-09.webp](../assets/codex/windows-img-09.webp)

![windows-img-10.webp](../assets/codex/windows-img-10.webp)
> 设置 Codex CLI 的权限：1.允许 Codex 直接修改文件；2.Codex 修改文件需要手动授权

!!! info "选择模型"
    ```
    /model
    ```

![windows-img-11.webp](../assets/codex/windows-img-11.webp)

![windows-img-12.webp](../assets/codex/windows-img-12.webp)

![windows-img-13.webp](../assets/codex/windows-img-13.webp)

![windows-img-14.webp](../assets/codex/windows-img-14.webp)
> 注意：修改接口地址后，使用所有模型（包括官方预设模型）均调用自定义接入点，而不使用官方账号额度。

### macOS 端图文指引

#### 1.安装 Homebrew (已安装请跳过)

Homebrew 是 macOS 缺失的软件包的管理器。

官网：https://brew.sh

![macos-img-01.webp](../assets/codex/macos-img-01.webp)

!!! info "安装 Homebrew"
    ```
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

![macos-img-02.webp](../assets/codex/macos-img-02.webp)

![macos-img-03.webp](../assets/codex/macos-img-03.webp)

![macos-img-04.webp](../assets/codex/macos-img-04.webp)

#### 2.安装 Node.js 环境

!!! info "Node.js 环境安装步骤"
    更新 Homebrew
    ```
    brew update
    ```
    安装 Node.js
    ```
    brew install node
    ```

!!! caution "macOS 注意事项"
    - 如果遇到权限问题，可能需要使用`sudo`
    - 首次运行可能需要在系统偏好设置中允许
    - 建议使用`Terminal`或`iTerm2`

![macos-img-05.webp](../assets/codex/macos-img-05.webp)

![macos-img-06.webp](../assets/codex/macos-img-06.webp)

!!! information "验证安装是否成功"
    安装完成后，打开终端，输入以下命令：
    ```
    node --version
    npm --version
    ```
    如果显示版本号，说明安装成功

#### 3.安装 Codex CLI

!!! info "安装 Codex CLI"
    打开终端，运行以下命令：
    ```
    # 全局安装 Codex CLI
    npm install -g @openai/codex
    ```
    如果遇到权限问题，可以使用 sudo：
    ```
    sudo npm install -g @openai/codex
    ```

![macos-img-07.webp](../assets/codex/macos-img-07.webp)

!!! info "验证 Codex CLI 安装"
    安装完成后，输入以下命令检查是否安装成功：
    ```
    codex --version
    ```
    如果显示版本号，恭喜你！Codex CLI 已经成功安装了。

#### 4.修改配置文件

!!! info "一键修改 Codex CLI 配置文件"
    ```
    curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/codex-cli-setup.sh | bash
    ```

![macos-configure](../assets/codex/macos_configure.png)

#### 5.开始使用 Codex CLI

现在你可以开始使用 Codex CLI 了！

!!! info "启动 Codex CLI"
    直接启动 Codex CLI:
    ```
    codex
    ```
    在特定项目中使用:
    ```
    cd mnt/c/path/to/your/project
    ```
    ```
    codex
    ```
    Enter 启动 Codex CLI

![macos-img-09.webp](../assets/codex/macos-img-09.webp)

![macos-img-10.webp](../assets/codex/macos-img-10.webp)
> 设置 Codex CLI 的权限：1.允许 Codex 直接修改文件；2.Codex 修改文件需要手动授权

![macos-img-11.webp](../assets/codex/macos-img-11.webp)

![macos-img-12.webp](../assets/codex/macos-img-12.webp)

![macos-img-13.webp](../assets/codex/macos-img-13.webp)

![macos-img-14.webp](../assets/codex/macos-img-14.webp)
> 注意：修改接口地址后，使用所有模型（包括官方预设模型）均调用自定义接入点，而不使用官方账号额度。

#### 6.macOS 常见问题解决

??? example "安装时提示权限错误"
    尝试以下解决方法：

    - 使用`sudo`安装：`sudo npm install -g @openai/codex`
    - 或者配置`npm`使用用户目录：`npm config set prefix ~/.npm-global`

??? example "macOS 安全设置阻止运行"
    如果系统阻止运行 Codex CLI：

    - 打开"系统偏好设置" → "安全性与隐私"
    - 点击"仍要打开"或"允许"
    - 或者在`Terminal`中运行：`sudo spctl --master-disable`

### Linux 端图文指引

#### 1.安装 Node.js 环境

Codex CLI 需要 Node.js 环境才能运行。

!!! info "Node.js 环境安装步骤"
    添加 NodeSource 仓库
    ```
    sudo curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    ```
    安装 Node.js
    ```
    sudo apt-get install -y nodejs
    ```

!!! caution "Linux 注意事项"
    - 某些发行版可能需要安装额外的依赖
    - 如果遇到权限问题，使用 sudo
    - 确保你的用户在 npm 的全局目录有写权限

![linux-img-01.webp](../assets/codex/linux-img-01.webp)

![linux-img-02.webp](../assets/codex/linux-img-02.webp)

!!! information "验证安装是否成功"
    安装完成后，打开终端，输入以下命令：
    ```
    node --version
    npm --version
    ```
    如果显示版本号，说明安装成功

#### 2.安装 Codex CLI

!!! info "安装 Codex CLI"
    打开终端，运行以下命令：
    ```
    # 全局安装 Codex CLI
    npm install -g @openai/codex
    ```
    如果遇到权限问题，可以使用 sudo：
    ```
    sudo npm install -g @openai/codex
    ```
![linux-img-03.webp](../assets/codex/linux-img-03.webp)

!!! info "验证 Codex CLI 安装"
    安装完成后，输入以下命令检查是否安装成功：
    ```
    codex --version
    ```
    如果显示版本号，恭喜你！Codex CLI 已经成功安装了。

#### 3.修改配置文件

!!! info "一键修改 Codex CLI 配置文件"
    ```
    curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/codex-cli-setup.sh | bash
    ```
    
![macos-configure](../assets/codex/macos_configure.png)

#### 4.开始使用 Codex CLI

现在你可以开始使用 Codex CLI 了！

!!! info "启动 Codex CLI"
    直接启动 Codex CLI:
    ```
    # 启动 Codex CLI
    codex
    ```
    在特定项目中使用:
    ```
    # 进入你的项目目录
    cd /path/to/your/project
    ```
    ```
    # 启动 Codex CLI
    codex
    ```
    Enter 启动 Codex CLI

![linux-img-05.webp](../assets/codex/linux-img-05.webp)

![linux-img-06.webp](../assets/codex/linux-img-06.webp)
> 设置 Codex CLI 的权限：1.允许 Codex 直接修改文件；2.Codex 修改文件需要手动授权

![linux-img-07.webp](../assets/codex/linux-img-07.webp)

![linux-img-08.webp](../assets/codex/linux-img-08.webp)

![linux-img-09.webp](../assets/codex/linux-img-09.webp)

![linux-img-10.webp](../assets/codex/linux-img-10.webp)
> 注意：修改接口地址后，使用所有模型（包括官方预设模型）均调用自定义接入点，而不使用官方账号额度。

#### 5.Linux 常见问题解决

??? example "安装时提示权限错误"
    尝试以下解决方法：

    - 使用`sudo`安装：`sudo npm install -g @openai/codex`

    - 或者配置`npm`使用用户目录：`npm config set prefix ~/.npm-global`

    - 然后添加到`PATH`：`export PATH=~/.npm-global/bin:$PATH`

??? example "缺少依赖库"
    某些 Linux 发行版需要安装额外依赖：
    ```
    # Ubuntu/Debian
    sudo apt install build-essential
    ```
    ```
    # CentOS/RHEL
    sudo dnf groupinstall "Development Tools"
    ```

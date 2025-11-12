# Claude Code
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

!!! info "Project Introduction"
    Unleash Claude’s raw power directly in your terminal. Search million-line codebases instantly. Turn hours-long workflows into a single command. Your tools. Your workflow. Your codebase, evolving at thought speed.

    直接在你的终端中，释放 Claude 的强大威力。瞬间搜索百万行代码库。将数小时的工作流化为一条命令。你的工具。你的工作流。你的代码库，以思维速度进化。

    1. Official Homepage: <a href="https://www.anthropic.com/claude-code" target="_blank">https://www.anthropic.com/claude-code</a>
    1. Installation Method: See the tutorial below on this page

## Demonstration
-------------------------------------

![introduce-01.webp](../assets/claude_code/introduce-01.webp)

![introduce-02.webp](../assets/claude_code/introduce-02.webp)

### Features

| **Function Category** | **Feature** |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| **Code Understanding** | - Deep codebase analysis, utilizing intelligent agents to search and understand project structure and dependencies |
|                | - Automatically generate high-level code overviews, quickly helping users understand the codebase |
| **Code Editing** | - Supports multi-file collaborative editing, suitable for complex code modifications |
|                | - Provides practical and usable code suggestions that conform to project patterns and architecture |
| **Integration Capabilities** | - Supports direct execution in the terminal without context switching |
|                | - Seamless integration with VS Code and JetBrains IDEs, eliminating the need for copy-pasting |
| **Code Generation and Optimization** | - Automatically generate code, create tests, fix errors, supporting the complete workflow from concept to commit |
|                | - Optimized for code generation and understanding, incorporating advanced models like Claude Opus 4 |
| **Security and Flexibility** | - Changes require explicit user authorization, making file and command operations safer |
|                | - Adapts to user code standards and supports custom configuration |
| **Toolchain Integration** | - Supports integration with tools like GitHub and GitLab to achieve automated workflows |
|                | - Integrates with testing suites and build systems, enhancing existing development tools |
| **Cross-Platform and Extensibility** | - Supports Windows, macOS, and Linux operating systems |
|                | - Configurable to run in SDKs or GitHub Actions, flexibly adapting to different requirements |
| **Primary Use Cases** | - Codebase onboarding and understanding, rapid ramp-up for new members |
|                | - Code issue fixing and optimization workflow, from problem analysis to PR submission |
|                | - Project code refactoring and new feature implementation |
| **User Feedback Highlights** | - Improves daily development efficiency, saving time spent on routine tasks |
|                | - Excellent performance in handling complex multi-step tasks, expanding development possibilities |

## AI Model Configuration Method

### Windows Graphical Guide

#### 1. Install Node.js Environment

Claude Code requires the Node.js environment to run.

!!! info "Node.js Environment Installation Steps"
    - Open your browser and visit https://nodejs.org/
    - Click to download the "LTS" version (Long-Term Support version recommended)
    - After the download is complete, double-click the .msi file
    - Follow the installation wizard to complete the installation, keeping the default settings

!!! caution "Windows Notes"
    - It is recommended to use PowerShell instead of CMD
    - If you encounter permission issues, try running as administrator
    - Some antivirus software may flag it incorrectly; you might need to add it to a whitelist

![windows-img-01.webp](../assets/claude_code/windows-img-01.webp)

![windows-img-02.webp](../assets/claude_code/windows-img-02.webp)

![windows-img-03.webp](../assets/claude_code/windows-img-03.webp)

![windows-img-04.webp](../assets/claude_code/windows-img-04.webp)

![windows-img-05.webp](../assets/claude_code/windows-img-05.webp)

!!! caution "Verify Successful Installation"
    After installation is complete, open PowerShell or CMD and enter the following commands:
    ```
    node --version
    npm --version
    ```
    If the version number is displayed, the installation was successful

#### 2. Install Git Bash

!!! caution "Windows Notes"
    In the Windows environment, Git Bash is required to install Claude Code. After installation, environment variable setup and using Claude Code should still be done in standard PowerShell or CMD.

!!! info "Download and Install Git for Windows"
    - Visit https://git-scm.com/downloads/win
    - Click "Download for Windows" to download the installer
    - Run the downloaded .exe installation file
    - Keep the default settings during the installation process and click "Next" to complete the installation

![windows-img-06.webp](../assets/claude_code/windows-img-06.webp)

![windows-img-07.webp](../assets/claude_code/windows-img-07.webp)

![windows-img-08.webp](../assets/claude_code/windows-img-08.webp)

!!! caution "Verify Git Bash Installation"
    After installation is complete, open Git Bash and enter the following command to verify:
    ```
    git --version
    ```
    If the version number is displayed, the installation was successful

#### 3. Install Claude Code

!!! info "Install Claude Code"
    Open PowerShell and run the following command:
    ```
    npm install -g @anthropic-ai/claude-code
    ```
    This command downloads and installs the latest version of Claude Code from the official npm repository.

![windows-img-09.webp](../assets/claude_code/windows-img-09.webp)

!!! info "Add ~/.local/bin to PATH (Only if prompted)"
    ```
    [Environment]::SetEnvironmentVariable('Path', ([Environment]::GetEnvironmentVariable('Path','User') + ";$HOME\.local\bin"), 'User')
    ```

!!! info "Verify Claude Code Installation"
    After installation is complete, enter the following command to check if the installation was successful:
    ```
    claude --version
    ```
    If the version number is displayed, congratulations! Claude Code has been successfully installed.

#### 4. Set Environment Variables

!!! info "One-Click Setup Command (Windows System)"
    To allow Claude Code to connect to your relay service, you need to set multiple environment variables:
    ```
    iex (irm 'https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/claude-cli-setup.ps1')
    ```

![windows-configure](../assets/claude_code/windows_configure.png)

#### 5. Start Using Claude Code

You can now start using Claude Code!

!!! info "Launch Claude Code"
    Open PowerShell and launch Claude Code directly:
    ```
    # 启动 Claude Code
    claude
    ```
    To use in a specific project:
    ```
    # 进入你的项目目录
    cd C:\path\to\your\project
    ```
    ```
    # 启动 Claude Code
    claude
    ```

![windows-img-11.webp](../assets/claude_code/windows-img-11.webp)

![windows-img-12.webp](../assets/claude_code/windows-img-12.webp)

![windows-img-13.webp](../assets/claude_code/windows-img-13.webp)

![windows-img-14.webp](../assets/claude_code/windows-img-14.webp)

![windows-img-15.webp](../assets/claude_code/windows-img-15.webp)

!!! info "Select Model"
    Enter the command:
    ```
    /model
    ```
    Press Enter to select the model; usually, the default settings are sufficient.

![windows-img-16.webp](../assets/claude_code/windows-img-16.webp)

![windows-img-17.webp](../assets/claude_code/windows-img-17.webp)
> Note: After setting and modifying environment variables, all models used (including official preset models) will call the custom access point and will not consume official account Quota.

### macOS Graphical Guide

#### 1. Install Claude Code CLI

Open Terminal

![macos-img-01.webp](../assets/claude_code/macos-img-01.webp)

!!! info "Install Claude Code"
    Open Terminal and run the following command:
    ```
    curl -fsSL https://claude.ai/install.sh | bash
    ```
    Optional: Run the provided command if prompted
    ```
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
    ```

![macos-img-02.webp](../assets/claude_code/macos-img-02.webp)

#### 2. Set Environment Variables

To allow Claude Code to connect to a third-party relay service, you need to set environment variables:

!!! info "One-Click Setup for Claude Code Environment Variables"
    Enter the command:
    ```
    curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/claude-cli-setup.sh | bash
    ```

![macos-configure](../assets/claude_code/macos_configure.png)


!!! info "Verify Claude Code Installation"
    After installation is complete, enter the following command to check if the installation was successful:
    ```
    claude --version
    ```
    If the version number is displayed, congratulations! Claude Code has been successfully installed.

#### 3. Start Using Claude Code

You can now start using Claude Code!

!!! info "Launch Claude Code"
    Launch Claude Code directly:
    ```
    # 启动 Claude Code
    claude
    ```
    To use in a specific project:
    ```
    # 进入你的项目目录
    cd /path/to/your/project
    ```
    ```
    # 启动 Claude Code
    claude
    ```

![macos-img-04.webp](../assets/claude_code/macos-img-04.webp)

![macos-img-05.webp](../assets/claude_code/macos-img-05.webp)

![macos-img-06.webp](../assets/claude_code/macos-img-06.webp)

![macos-img-07.webp](../assets/claude_code/macos-img-07.webp)

![macos-img-08.webp](../assets/claude_code/macos-img-08.webp)

!!! info "Select Model (Optional)"
    Enter the command:
    ```
    /model
    ```
    Press Enter to select the official model; usually, the default model is sufficient

![macos-img-09.webp](../assets/claude_code/macos-img-09.webp)

![macos-img-10.webp](../assets/claude_code/macos-img-10.webp)

![macos-img-11.webp](../assets/claude_code/macos-img-11.webp)
> Note: After setting and modifying the environment variable `ANTHROPIC_BASE_URL`, all models used (including official preset models) will call the custom access point and will not consume official account Quota.

#### 6. macOS Common Issues Resolution

??? example "macOS Security Settings Block Execution"
    If the system prevents Claude Code from running:

    - Open "System Preferences" → "Security & Privacy"
    - Click "Open Anyway" or "Allow"
    - Or run in `Terminal`: `sudo spctl --master-disable`

### Linux Graphical Guide

#### 1. Install Claude Code

![linux-img-01.webp](../assets/claude_code/linux-img-01.webp)

!!! info "Install Claude Code"
    Open Terminal and run the following command:
    ```
    curl -fsSL https://claude.ai/install.sh | bash
    ```
    If you encounter permission issues, you can use sudo:
    ```
    sudo curl -fsSL https://claude.ai/install.sh | bash
    ```
![linux-img-03.webp](../assets/claude_code/linux-img-03.webp)

!!! info "Verify Claude Code Installation"
    After installation is complete, enter the following command to check if the installation was successful:
    ```
    claude --version
    ```
    If the version number is displayed, congratulations! Claude Code has been successfully installed.

#### 2. Set Environment Variables

To allow Claude Code to connect to your relay service, you need to set two environment variables:

!!! info "One-Click Environment Variable Modification"
    Enter the command:
    ```
    curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/claude-cli-setup.sh | bash
    ```

![macos-configure](../assets/claude_code/macos_configure.png)

#### 4. Start Using Claude Code

You can now start using Claude Code!

!!! info "Launch Claude Code"
    Launch Claude Code directly:
    ```
    # 启动 Claude Code
    claude
    ```
    To use in a specific project:
    ```
    # 进入你的项目目录
    cd /path/to/your/project
    ```
    ```
    # 启动 Claude Code
    claude
    ```

![linux-img-03.webp](../assets/claude_code/linux-img-03.webp)

![linux-img-04.webp](../assets/claude_code/linux-img-04.webp)

![linux-img-05.webp](../assets/claude_code/linux-img-05.webp)

!!! info "Select Model"
    Enter the command:
    ```
    /model
    ```
    Press Enter to select the official model; usually, the default model is sufficient

![linux-img-06.webp](../assets/claude_code/linux-img-06.webp)

![linux-img-07.webp](../assets/claude_code/linux-img-07.webp)

![linux-img-08.webp](../assets/claude_code/linux-img-08.webp)

![linux-img-09.webp](../assets/claude_code/linux-img-09.webp)
> Note: After setting and modifying the environment variable `ANTHROPIC_BASE_URL`, all models used (including official preset models) will call the custom access point and will not consume official account Quota.

#### 5. Linux Common Issues Resolution

??? example "Missing Dependency Libraries"
    Some Linux distributions require the installation of additional dependencies:
    ```
    # Ubuntu/Debian
    sudo apt install build-essential
    ```
    ```
    # CentOS/RHEL
    sudo dnf groupinstall "Development Tools"
    ```

??? example "Environment Variables Not Taking Effect"
    Check the following points:

    - Confirm that the correct configuration file (`.bashrc` or `.zshrc`) was modified
    - Restart the terminal or run `source ~/.bashrc`
    - Verify settings: `echo $ANTHROPIC_BASE_URL`
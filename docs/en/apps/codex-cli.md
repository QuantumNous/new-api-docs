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

!!! info "Project Introduction"
    Codex CLI is a coding agent from OpenAI that runs locally on your computer.

    Codex CLI is a coding agent from OpenAI that runs locally on your computer.

    1. Official Homepage: <a href="https://chatgpt.com/codex" target="_blank">https://chatgpt.com/codex</a>
    1. Project Homepage: <a href="https://github.com/openai/codex" target="_blank">https://github.com/openai/codex</a>
    1. Installation Method: See the tutorial below on this page

## Demonstration
-------------------------------------

![introduce-01.webp](../assets/codex/introduce-01.webp)

### Features

| **Function Category** | **Feature** |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| Terminal-Based Coding Assistant | Codex CLI is a terminal-based interactive coding assistant used for editing code, generating patches, and running commands in the command line. |
| Tool-Driven Architecture | Provides tools such as `apply_patch`, `shell`, `update_plan`, and `multi_tool_use` for controlled modifications to repository files and operations. |
| Atomic Patch Editing | Uses a specialized patch format to atomically add/update/delete files via `apply_patch`, facilitating auditing and rollback. |
| Sandboxing and Approval | Supports sandboxing policies (e.g., `workspace-write`, `read-only`) and approval modes (`on-request`, `on-failure`, `never`) to control write and network access permissions. |
| Plan Tracking | `update_plan` is used to list steps and track status, requiring only one `in_progress` step at all times to maintain clear progress. |
| Interaction Guidelines | Sends brief introductory explanations before important operations, maintaining a friendly, concise tone and providing progress updates. |
| Security Constraints | Adheres to strict rules (no arbitrary changes to unrelated files, no adding copyright headers, no executing destructive commands), requiring user approval for sensitive operations. |
| Testing and Formatting | Recommended to run relevant tests and formatting tools after modification, but not responsible for fixing issues unrelated to the current task. |
| Output and Style | Final output adheres to CLI rendering specifications (e.g., `**` headings, backticks for paths/commands), maintaining a scannable and concise structure. |
| Parallel Execution | Supports running multiple tools in parallel via `multi_tool_use.parallel` to improve efficiency. |

## AI Model Configuration Method

### Windows Graphical Guide

#### 1. Open Terminal

![windows_open_terminal](../assets/codex/windows_open_terminal.png)

#### 2. Install WSL

For optimal performance on Windows, please install and use the Windows Subsystem for Linux (WSL2).

!!! info "Install WSL2, Restart Windows Computer"
    ```
    wsl --install
    ```
    Restart the Windows computer after installation

!!! caution "Windows Notes"
    - It is recommended to use PowerShell instead of CMD
    - If you encounter permission issues, try running as administrator
    - Some antivirus software may flag this as a false positive; you may need to add it to a whitelist

![windows-img-03.webp](../assets/codex/windows-img-03.webp)

!!! info "Download Node Version Manager (NVM)"
    ```
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    ```

![windows-img-04.webp](../assets/codex/windows-img-04.webp)

!!! info "NVM Install Node.js 22"
    Open a new PowerShell window in the tab bar and start WSL
    ```
    wsl
    ```

    Install Node.js
    
    The version number is time-sensitive; please install the corresponding version according to the OpenAI official website requirements: https://developers.openai.com/codex/windows
    ```
    nvm install 22
    ```

![windows-img-05.webp](../assets/codex/windows-img-05.webp)

#### 3. Install Codex CLI

!!! info "Install Codex CLI"
    ```
    npm i -g @openai/codex
    ```
    This command downloads and installs the latest version of Codex CLI from the official npm repository.

![windows-img-06.webp](../assets/codex/windows-img-06.webp)

#### 4. Modify Configuration File

!!! info "One-Click Modification of Codex CLI Configuration File"
    ```
    iex (irm 'https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/codex-cli-setup.ps1')
    ```

![windows-configure](../assets/codex/windows_configure.png)

#### 5. Start Using Codex CLI

You can now start using Codex CLI!

!!! info "Launch Codex CLI"
    Start WSL2
    ```
    wsl
    ```
    Launch Codex CLI directly:
    ```
    codex
    ```
    Use in a specific project:
    ```
    cd mnt/c/path/to/your/project
    ```
    ```
    codex
    ```
    Press Enter to launch Codex CLI

![windows-img-09.webp](../assets/codex/windows-img-09.webp)

![windows-img-10.webp](../assets/codex/windows-img-10.webp)
> Set Codex CLI permissions: 1. Allow Codex to modify files directly; 2. Codex requires manual authorization to modify files

!!! info "Select Model"
    ```
    /model
    ```

![windows-img-11.webp](../assets/codex/windows-img-11.webp)

![windows-img-12.webp](../assets/codex/windows-img-12.webp)

![windows-img-13.webp](../assets/codex/windows-img-13.webp)

![windows-img-14.webp](../assets/codex/windows-img-14.webp)
> Note: After modifying the interface address, all models (including official preset models) will call the custom access point and will not use the official account quota.

### macOS Graphical Guide

#### 1. Install Homebrew (Skip if already installed)

Homebrew is the package manager for macOS that installs missing software.

Official Website: https://brew.sh

![macos-img-01.webp](../assets/codex/macos-img-01.webp)

!!! info "Install Homebrew"
    ```
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

![macos-img-02.webp](../assets/codex/macos-img-02.webp)

![macos-img-03.webp](../assets/codex/macos-img-03.webp)

![macos-img-04.webp](../assets/codex/macos-img-04.webp)

#### 2. Install Node.js Environment

!!! info "Node.js Environment Installation Steps"
    Update Homebrew
    ```
    brew update
    ```
    Install Node.js
    ```
    brew install node
    ```

!!! caution "macOS Notes"
    - If you encounter permission issues, you may need to use `sudo`
    - The first run may require permission in System Preferences
    - It is recommended to use `Terminal` or `iTerm2`

![macos-img-05.webp](../assets/codex/macos-img-05.webp)

![macos-img-06.webp](../assets/codex/macos-img-06.webp)

!!! information "Verify Successful Installation"
    After installation, open the terminal and enter the following commands:
    ```
    node --version
    npm --version
    ```
    If the version number is displayed, the installation was successful

#### 3. Install Codex CLI

!!! info "Install Codex CLI"
    Open the terminal and run the following command:
    ```
    # Install Codex CLI globally
    npm install -g @openai/codex
    ```
    If you encounter permission issues, you can use sudo:
    ```
    sudo npm install -g @openai/codex
    ```

![macos-img-07.webp](../assets/codex/macos-img-07.webp)

!!! info "Verify Codex CLI Installation"
    After installation, enter the following command to check if the installation was successful:
    ```
    codex --version
    ```
    If the version number is displayed, congratulations! Codex CLI has been successfully installed.

#### 4. Modify Configuration File

!!! info "One-Click Modification of Codex CLI Configuration File"
    ```
    curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/codex-cli-setup.sh | bash
    ```

![macos-configure](../assets/codex/macos_configure.png)

#### 5. Start Using Codex CLI

You can now start using Codex CLI!

!!! info "Launch Codex CLI"
    Launch Codex CLI directly:
    ```
    codex
    ```
    Use in a specific project:
    ```
    cd mnt/c/path/to/your/project
    ```
    ```
    codex
    ```
    Press Enter to launch Codex CLI

![macos-img-09.webp](../assets/codex/macos-img-09.webp)

![macos-img-10.webp](../assets/codex/macos-img-10.webp)
> Set Codex CLI permissions: 1. Allow Codex to modify files directly; 2. Codex requires manual authorization to modify files

![macos-img-11.webp](../assets/codex/macos-img-11.webp)

![macos-img-12.webp](../assets/codex/macos-img-12.webp)

![macos-img-13.webp](../assets/codex/macos-img-13.webp)

![macos-img-14.webp](../assets/codex/macos-img-14.webp)
> Note: After modifying the interface address, all models (including official preset models) will call the custom access point and will not use the official account quota.

#### 6. macOS Common Issues Resolution

??? example "Permission Error During Installation"
    Try the following solutions:

    - Install using `sudo`: `sudo npm install -g @openai/codex`
    - Or configure `npm` to use the user directory: `npm config set prefix ~/.npm-global`

??? example "macOS Security Settings Block Execution"
    If the system blocks Codex CLI from running:

    - Open "System Preferences" → "Security & Privacy"
    - Click "Open Anyway" or "Allow"
    - Or run in `Terminal`: `sudo spctl --master-disable`

### Linux Graphical Guide

#### 1. Install Node.js Environment

Codex CLI requires the Node.js environment to run.

!!! info "Node.js Environment Installation Steps"
    Add NodeSource repository
    ```
    sudo curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    ```
    Install Node.js
    ```
    sudo apt-get install -y nodejs
    ```

!!! caution "Linux Notes"
    - Some distributions may require installing additional dependencies
    - Use sudo if you encounter permission issues
    - Ensure your user has write permissions in the npm global directory

![linux-img-01.webp](../assets/codex/linux-img-01.webp)

![linux-img-02.webp](../assets/codex/linux-img-02.webp)

!!! information "Verify Successful Installation"
    After installation, open the terminal and enter the following commands:
    ```
    node --version
    npm --version
    ```
    If the version number is displayed, the installation was successful

#### 2. Install Codex CLI

!!! info "Install Codex CLI"
    Open the terminal and run the following command:
    ```
    # Install Codex CLI globally
    npm install -g @openai/codex
    ```
    If you encounter permission issues, you can use sudo:
    ```
    sudo npm install -g @openai/codex
    ```
![linux-img-03.webp](../assets/codex/linux-img-03.webp)

!!! info "Verify Codex CLI Installation"
    After installation, enter the following command to check if the installation was successful:
    ```
    codex --version
    ```
    If the version number is displayed, congratulations! Codex CLI has been successfully installed.

#### 3. Modify Configuration File

!!! info "One-Click Modification of Codex CLI Configuration File"
    ```
    curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/codex-cli-setup.sh | bash
    ```
    
![macos-configure](../assets/codex/macos_configure.png)

#### 4. Start Using Codex CLI

You can now start using Codex CLI!

!!! info "Launch Codex CLI"
    Launch Codex CLI directly:
    ```
    # Launch Codex CLI
    codex
    ```
    Use in a specific project:
    ```
    # Navigate to your project directory
    cd /path/to/your/project
    ```
    ```
    # Launch Codex CLI
    codex
    ```
    Press Enter to launch Codex CLI

![linux-img-05.webp](../assets/codex/linux-img-05.webp)

![linux-img-06.webp](../assets/codex/linux-img-06.webp)
> Set Codex CLI permissions: 1. Allow Codex to modify files directly; 2. Codex requires manual authorization to modify files

![linux-img-07.webp](../assets/codex/linux-img-07.webp)

![linux-img-08.webp](../assets/codex/linux-img-08.webp)

![linux-img-09.webp](../assets/codex/linux-img-09.webp)

![linux-img-10.webp](../assets/codex/linux-img-10.webp)
> Note: After modifying the interface address, all models (including official preset models) will call the custom access point and will not use the official account quota.

#### 5. Linux Common Issues Resolution

??? example "Permission Error During Installation"
    Try the following solutions:

    - Install using `sudo`: `sudo npm install -g @openai/codex`

    - Or configure `npm` to use the user directory: `npm config set prefix ~/.npm-global`

    - Then add to `PATH`: `export PATH=~/.npm-global/bin:$PATH`

??? example "Missing Dependency Libraries"
    Some Linux distributions require installing additional dependencies:
    ```
    # Ubuntu/Debian
    sudo apt install build-essential
    ```
    ```
    # CentOS/RHEL
    sudo dnf groupinstall "Development Tools"
    ```
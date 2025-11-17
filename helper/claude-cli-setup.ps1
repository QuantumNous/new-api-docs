#!/usr/bin/env pwsh

# claude-cli-setup.ps1 - Interactive setup for Anthropic Claude Code CLI
# 配置 ANTHROPIC_* 环境变量到 PowerShell 配置文件

# 确保交互式终端
if (-not [console]::IsInputRedirected) {
    # 正常交互式终端，无需额外操作
} else {
    Write-Host "错误: 请在交互式终端中运行此脚本。" -ForegroundColor Red
    exit 1
}

# -------- 工具函数 --------
function Test-CommandExists {
    param([string]$Command)
    return [bool](Get-Command -Name $Command -ErrorAction SilentlyContinue)
}

function Test-Trim {
    param([string]$String)
    return $String.Trim()
}

function Read-TTY {
    param([string]$Prompt)
    $input = Read-Host -Prompt $Prompt -ErrorAction SilentlyContinue
    return $input
}

function Read-SecretTTY {
    param([string]$Prompt)
    $input = Read-Host -Prompt $Prompt -AsSecureString -ErrorAction SilentlyContinue
    if ($input) {
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($input)
        return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    }
    return ""
}

function Get-SingleQuote {
    param([string]$String)
    return "'$($String -replace "'", "''")'"
}

# 从环境变量读取值，同时检查进程和用户级别
function Get-EnvironmentVariableValue {
    param([string]$Key)
    
    if (-not $Key) {
        return ""
    }
    
    # 首先尝试从当前进程获取
    $value = [Environment]::GetEnvironmentVariable($Key, 'Process')
    if (-not [string]::IsNullOrEmpty($value)) {
        return $value
    }
    
    # 然后尝试从用户环境获取
    $value = [Environment]::GetEnvironmentVariable($Key, 'User')
    if (-not [string]::IsNullOrEmpty($value)) {
        return $value
    }
    
    return ""
}

# 从URL中提取主机名
function Get-HostFromUrl {
    param([string]$Url)
    
    if (-not $Url) {
        return ""
    }
    
    # 移除协议 (http:// 或 https://)
    $hostPart = $Url -replace '^https?://', ''
    # 提取到第一个斜杠之前的部分
    $hostPart = $hostPart -split '/', 2 | Select-Object -First 1
    
    return $hostPart
}

# 确保URL包含协议
function Ensure-Scheme {
    param([string]$Url)
    
    if (-not $Url) {
        return ""
    }
    
    # 确保base_url包含协议；默认为https
    if ($Url -match '^https?://') {
        return $Url
    } else {
        return "https://$Url"
    }
}

# 提示输入新的API URL
function Get-NewApiUrl {
    param(
        [string]$AppLabel = "Anthropic Claude Code CLI",
        [string]$BaseSuffix = "",
        [string]$ExistingBaseUrl = ""
    )
    
    $exampleUrl = "https://你的new-api站点$BaseSuffix"
    
    Write-Host ""
    Write-Host "当前仅支持自定义 $AppLabel API 站点。"
    Write-Host "示例: $exampleUrl"
    
    if (-not [string]::IsNullOrEmpty($ExistingBaseUrl)) {
        Write-Host "提示：按 Enter 保持现有 base_url 不变（当前: $ExistingBaseUrl）"
        $choice = Read-TTY "直接回车保持不变，或输入 'y' 进入自定义输入: "
        
        if ($choice -ne 'y' -and $choice -ne 'Y') {
            Write-Host "保持现有 base_url: $ExistingBaseUrl"
            return $ExistingBaseUrl
        }
    }
    
    # 强制自定义输入流程
    Write-Host ""
    Write-Host "请输入完整 base_url（以 http(s):// 开头）。"
    Write-Host "示例: $exampleUrl"
    
    do {
        $customUrl = Read-TTY "自定义 base_url: "
        $customUrl = Test-Trim $customUrl
        
        if ([string]::IsNullOrEmpty($customUrl)) {
            Write-Host "错误: base_url 不能为空。" -ForegroundColor Red
        }
    } while ([string]::IsNullOrEmpty($customUrl))
    
    $customUrl = Ensure-Scheme $customUrl
    return $customUrl
}

# 提示输入API Token
function Get-ApiToken {
    param(
        [string]$TokenLabel = "ANTHROPIC_AUTH_TOKEN",
        [string]$Hostname = ""
    )
    
    $tokenUrl = "https://$Hostname/console/token"
    
    Write-Host ""
    Write-Host "请在浏览器中访问以下地址获取 ${TokenLabel}："
    Write-Host "  $tokenUrl"
    Write-Host "获取后，请粘贴你的 ${TokenLabel}："
    
    do {
        $tokenInput = Read-SecretTTY "粘贴你的 ${TokenLabel}: "
        $tokenInput = Test-Trim $tokenInput
        
        # 移除内部的任何CR/LF
        $tokenInput = $tokenInput -replace "[\r\n]", ""
        
        if ([string]::IsNullOrEmpty($tokenInput)) {
            Write-Host "错误: ${TokenLabel} 不能为空。" -ForegroundColor Red
        }
    } while ([string]::IsNullOrEmpty($tokenInput))
    
    return $tokenInput
}

# 主函数
function Main {
    Write-Host "=== Anthropic Claude Code CLI 配置工具 ==="
    Write-Host ""
    
    # 读取现有配置
    $existingBase = Get-EnvironmentVariableValue "ANTHROPIC_BASE_URL"
    $existingKey = Get-EnvironmentVariableValue "ANTHROPIC_AUTH_TOKEN"
    
    # 提示输入新的API URL
    $newBaseUrl = Get-NewApiUrl "Anthropic Claude Code CLI" "" $existingBase
    
    # 提示输入API Token
    $hostForToken = Get-HostFromUrl $newBaseUrl
    if ([string]::IsNullOrEmpty($hostForToken)) {
        Write-Host "错误: 无法从 base_url '$newBaseUrl' 提取主机名。" -ForegroundColor Red
        exit 1
    }
    
    $newApiKey = Get-ApiToken "ANTHROPIC_AUTH_TOKEN" $hostForToken
    
    # 直接设置环境变量，与example.ps1保持一致
    [Environment]::SetEnvironmentVariable('ANTHROPIC_BASE_URL', $newBaseUrl, 'User')
    [Environment]::SetEnvironmentVariable('ANTHROPIC_AUTH_TOKEN', $newApiKey, 'User')
    
    # 同时设置当前进程环境变量，使其立即生效
    $env:ANTHROPIC_BASE_URL = $newBaseUrl
    $env:ANTHROPIC_AUTH_TOKEN = $newApiKey
    
    Write-Host ""
    Write-Host "✅ Anthropic Claude Code CLI 配置完成。" -ForegroundColor Green
    Write-Host "  ANTHROPIC_BASE_URL: $newBaseUrl $(if ($newBaseUrl -eq $existingBase) { "(保持不变)" } else { "(自定义)" })"
    Write-Host "  ANTHROPIC_AUTH_TOKEN: $(if ($newApiKey -eq $existingKey) { "保持不变" } else { "已更新" })"
    Write-Host ""
    Write-Host "提示：新开一个 PowerShell 窗口或在当前会话已即时生效。"
    Write-Host ""
    Write-Host "注意：配置通过环境变量生效，无需额外的配置文件。"
}

# 执行主函数
Main
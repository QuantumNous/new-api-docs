#!/usr/bin/env pwsh

# OpenAI Codex CLI 配置脚本 PowerShell 版本
# 配置 ~\.codex\config.toml 和 ~\.codex\auth.json

# 确保交互式终端
if (-not [console]::IsInputRedirected) {
    # 正常交互式终端，无需额外操作
} else {
    Write-Host "错误: 请在交互式终端中运行此脚本。" -ForegroundColor Red
    exit 1
}

# 颜色输出函数
function Write-Info {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Yellow
}

function Write-ErrorMsg {
    param([string]$Message)
    Write-Host "错误: $Message" -ForegroundColor Red
}

# 读取用户输入
function Get-UserInput {
    param(
        [string]$Prompt,
        [string]$Default = ""
    )
    
    if ($Default) {
        $input = Read-Host -Prompt "$Prompt [$Default]" -ErrorAction SilentlyContinue
        if ($input) { return $input } else { return $Default }
    } else {
        $input = Read-Host -Prompt $Prompt -ErrorAction SilentlyContinue
        return $input
    }
}

# 读取密码输入（隐藏输入）
function Get-SecretInput {
    param([string]$Prompt)
    
    $input = Read-Host -Prompt $Prompt -AsSecureString -ErrorAction SilentlyContinue
    if ($input) {
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($input)
        return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    }
    return ""
}

# 确保URL包含协议并添加/v1后缀
function Normalize-Url {
    param([string]$Url)
    
    if (-not $Url) {
        return ""
    }
    
    # 添加协议
    if (-not ($Url -match '^https?://')) {
        $Url = "https://$Url"
    }
    
    # 添加/v1后缀（如果没有）
    if (-not ($Url -match '/v1$')) {
        if ($Url -match '/$') {
            $Url = "${Url}v1"
        } else {
            $Url = "${Url}/v1"
        }
    }
    
    return $Url
}

# 提取主机名
function Get-HostnameFromUrl {
    param([string]$Url)
    
    if (-not $Url) {
        return ""
    }
    
    # 移除协议
    $host = $Url -replace '^https?://', ''
    # 提取直到第一个斜杠的部分
    $host = $host -split '/', 2 | Select-Object -First 1
    
    return $host
}

# JSON转义函数
function ConvertTo-JsonEscaped {
    param([string]$String)
    
    if (-not $String) {
        return ""
    }
    
    # 替换特殊字符
    $String = $String -replace '\\', '\\\\'  # 转义反斜杠
    $String = $String -replace '"', '\\"'     # 转义双引号
    $String = $String -replace "\n", '\\n'   # 转义换行符
    $String = $String -replace "\r", '\\r'   # 转义回车符
    $String = $String -replace "\t", '\\t'   # 转义制表符
    
    return $String
}

# 主函数
function Main {
    Write-Info "=== OpenAI Codex CLI 配置工具 ==="
    Write-Host ""
    
    # 配置文件路径
    $COD_DIR = "$HOME\.codex"
    $CONFIG_FILE = "$COD_DIR\config.toml"
    $AUTH_FILE = "$COD_DIR\auth.json"
    
    # 读取现有配置
    $existing_base_url = ""
    $existing_api_key = ""
    
    if (Test-Path -Path $CONFIG_FILE) {
        # 使用正则表达式提取base_url
        $content = Get-Content -Path $CONFIG_FILE -Raw -ErrorAction SilentlyContinue
        if ($content -match 'base_url\s*=\s*["'']([^"'']*)["'']') {
            $existing_base_url = $matches[1]
        }
    }
    
    if (Test-Path -Path $AUTH_FILE) {
        # 使用正则表达式提取API密钥
        $content = Get-Content -Path $AUTH_FILE -Raw -ErrorAction SilentlyContinue
        if ($content -match '"OPENAI_API_KEY"\s*:\s*["'']([^"'']*)["'']') {
            $existing_api_key = $matches[1] -replace '[\r\n]', ''
        }
    }
    
    # 获取Base URL
    Write-Warning "配置API基础地址"
    if ($existing_base_url) {
        Write-Host "当前配置: $existing_base_url"
        $keep_existing = Get-UserInput "是否保持当前地址? (y/n)" "y"
        
        if ($keep_existing -match '^[Yy]') {
            $base_url = $existing_base_url
        } else {
            do {
                $raw_url = Get-UserInput "请输入API基础地址，末尾不带/v1 (如 http://localhost:3000)"
                if (-not $raw_url) {
                    Write-ErrorMsg "API基础地址不能为空"
                }
            } while (-not $raw_url)
            
            $base_url = Normalize-Url $raw_url
        }
    } else {
        do {
            $raw_url = Get-UserInput "请输入API基础地址，末尾不带/v1 (如 http://localhost:3000)"
            if (-not $raw_url) {
                Write-ErrorMsg "API基础地址不能为空"
            }
        } while (-not $raw_url)
        
        $base_url = Normalize-Url $raw_url
    }
    
    # 获取API Key
    Write-Warning "配置API密钥"
    if ($existing_api_key) {
        $keep_key = Get-UserInput "是否保持当前API密钥? (y/n)" "y"
        
        if ($keep_key -match '^[Yy]') {
            $api_key = $existing_api_key
        } else {
            do {
                $api_key = Get-SecretInput "请输入API密钥"
                if (-not $api_key) {
                    Write-ErrorMsg "API密钥不能为空"
                }
            } while (-not $api_key)
            
            # 确保API Key不包含换行符和回车符
            $api_key = $api_key -replace '[\r\n]', ''
        }
    } else {
        do {
            $api_key = Get-SecretInput "请输入API密钥"
            if (-not $api_key) {
                Write-ErrorMsg "API密钥不能为空"
            }
        } while (-not $api_key)
        
        # 确保API Key不包含换行符和回车符
        $api_key = $api_key -replace '[\r\n]', ''
    }
    
    # 创建配置目录
    if (-not (Test-Path -Path $COD_DIR)) {
        New-Item -ItemType Directory -Path $COD_DIR -Force | Out-Null
    }
    
    # 写入config.toml
    Write-Info "写入配置文件: $CONFIG_FILE"
    
    # 转义base_url中的双引号
    $escaped_base_url = $base_url -replace '"', '""'
    
    $configContent = @"
model = "gpt-5-codex"
model_provider = "custom"
model_reasoning_effort = "medium"
disable_response_storage = true

[model_providers.custom]
name = "custom"
base_url = "$escaped_base_url"
wire_api = "responses"
"@
    
    Set-Content -Path $CONFIG_FILE -Value $configContent -Force
    
    # 写入auth.json
    Write-Info "写入认证文件: $AUTH_FILE"
    
    $escaped_api_key = ConvertTo-JsonEscaped $api_key
    
    $authContent = @"
{
  "OPENAI_API_KEY": "$escaped_api_key"
}
"@
    
    Set-Content -Path $AUTH_FILE -Value $authContent -Force
    
    # 设置文件权限 (Windows下设置为只读)
    try {
        $acl = Get-Acl -Path $CONFIG_FILE
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            [System.Security.Principal.WindowsIdentity]::GetCurrent().Name,
            "ReadAndExecute",
            "Allow")
        $acl.SetAccessRule($rule)
        Set-Acl -Path $CONFIG_FILE -AclObject $acl
        
        $acl = Get-Acl -Path $AUTH_FILE
        $acl.SetAccessRule($rule)
        Set-Acl -Path $AUTH_FILE -AclObject $acl
    } catch {
        # 如果权限设置失败，继续执行脚本
        Write-Warning "提示: 无法设置文件权限，但配置已成功保存"
    }
    
    # 显示配置结果
    Write-Info "✅ 配置完成!"
    Write-Host "  基础地址: $base_url"
    
    # 显示API密钥的最后4个字符
    $maskedKey = "****"
    if ($api_key.Length -gt 4) {
        $maskedKey = "****$($api_key.Substring($api_key.Length - 4))"
    }
    
    Write-Host "  API密钥: 已设置 ($maskedKey)"
    Write-Host "  配置文件: $CONFIG_FILE"
    Write-Host "  认证文件: $AUTH_FILE"
    Write-Host ""
    Write-Warning "提示: 如需重新配置，请再次运行此脚本"
}

# 运行主函数
Main
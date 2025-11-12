#!/usr/bin/env pwsh

# factory-cli-setup.ps1 - Interactive setup for Factory CLI custom models
# 支持：
#   - 配置 ~\.factory\config.json 中的自定义模型
#   - 适用于Windows环境

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

function Get-Timestamp {
    return Get-Date -Format "yyyyMMdd-HHmmss"
}

function ConvertTo-JsonEscaped {
    param([string]$String)
    
    if (-not $String) {
        return ""
    }
    
    # 最小化的JSON字符串转义器
    $String = $String -replace '\\', '\\\\'  # 转义反斜杠
    $String = $String -replace '"', '\\"'     # 转义双引号
    $String = $String -replace "\t", '\\t'   # 转义制表符
    $String = $String -replace "\r", '\\r'   # 转义回车符
    $String = $String -replace "\n", '\\n'   # 转义换行符
    
    return $String
}

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

function Ensure-V1Suffix {
    param([string]$Url)
    
    if (-not $Url) {
        return ""
    }
    
    # 确保base_url末尾带有/v1
    if (-not ($Url -match '/v1$')) {
        # 检查是否以斜杠结尾
        if ($Url -match '/$') {
            return "${Url}v1"
        } else {
            return "${Url}/v1"
        }
    } else {
        return $Url
    }
}

# 从JSON文件中提取值（使用PowerShell内置的JSON处理）
function Get-ValueFromJsonFile {
    param(
        [string]$FilePath,
        [string]$PropertyPath
    )
    
    if (-not (Test-Path -Path $FilePath)) {
        return ""
    }
    
    try {
        $json = Get-Content -Path $FilePath -Raw | ConvertFrom-Json
        # 简单的属性路径处理，只支持一级和二级属性
        if ($PropertyPath -match '\.(.+)') {
            $firstLevel = $matches[1].Split('.')[0]
            $secondLevel = $matches[1].Split('.')[1]
            
            if ($json.$firstLevel -and $json.$firstLevel.Count -gt 0 -and $json.$firstLevel[0].$secondLevel) {
                return $json.$firstLevel[0].$secondLevel
            }
        }
    } catch {
        # JSON解析失败，使用正则表达式作为后备方案
        $content = Get-Content -Path $FilePath -Raw
        if ($PropertyPath -eq 'custom_models[0].base_url' -and $content -match '"base_url"\s*:\s*"([^"]*)"') {
            return $matches[1]
        } elseif ($PropertyPath -eq 'custom_models[0].api_key' -and $content -match '"api_key"\s*:\s*"([^"]*)"') {
            return $matches[1]
        }
    }
    
    return ""
}

# -------- 主函数 --------
function Main {
    Write-Host "=== Factory CLI 自定义模型配置向导 ==="
    Write-Host ""
    Write-Host "此脚本将帮助您配置 Factory CLI 使用第三方 API。"
    Write-Host ""

    $FACTORY_DIR = "$HOME\.factory"
    $FACTORY_CFG = "$FACTORY_DIR\config.json"
    
    # 创建配置目录
    if (-not (Test-Path -Path $FACTORY_DIR)) {
        New-Item -ItemType Directory -Path $FACTORY_DIR -Force | Out-Null
    }

    # 读取现有值
    $existing_base = ""
    $existing_key = ""
    
    if (Test-Path -Path $FACTORY_CFG) {
        $existing_base = Get-ValueFromJsonFile $FACTORY_CFG 'custom_models[0].base_url'
        $existing_key = Get-ValueFromJsonFile $FACTORY_CFG 'custom_models[0].api_key'
    }

    # 1. 提示输入API URL
    Write-Host "请输入第三方API的base_url："
    if (-not [string]::IsNullOrEmpty($existing_base)) {
        Write-Host "提示：按 Enter 保持现有 base_url 不变（当前: $existing_base）"
    }
    
    $input_base = Read-TTY "Base URL "
    $input_base = Test-Trim $input_base
    
    if ([string]::IsNullOrEmpty($input_base)) {
        if (-not [string]::IsNullOrEmpty($existing_base)) {
            Write-Host "保持现有 base_url: $existing_base"
            $input_base = $existing_base
        } else {
            Write-Host "错误: base_url 不能为空。" -ForegroundColor Red
            exit 1
        }
    } else {
        # 确保URL包含协议并以/v1结尾
        $input_base = Ensure-Scheme $input_base
        $input_base = Ensure-V1Suffix $input_base
        Write-Host "已规范化 base_url: $input_base"
    }

    # 2. 提示输入API Key
    Write-Host ""
    Write-Host "请输入第三方API的API Key："
    if (-not [string]::IsNullOrEmpty($existing_key)) {
        Write-Host "提示：按 Enter 保持现有 API Key 不变"
    }
    
    $input_key = Read-SecretTTY "API Key: "
    $input_key = Test-Trim $input_key
    # 确保去除所有换行符和回车符
    $input_key = $input_key -replace '[\r\n]', ''
    
    if ([string]::IsNullOrEmpty($input_key)) {
        if (-not [string]::IsNullOrEmpty($existing_key)) {
            Write-Host "保持现有 API Key"
            $input_key = $existing_key
            # 对现有key也进行清理
            $input_key = $input_key -replace '[\r\n]', ''
        } else {
            Write-Host "错误: API Key 不能为空。" -ForegroundColor Red
            exit 1
        }
    }

    # 3. 写入配置文件
    Write-Host ""
    Write-Host "正在写入配置文件..."
    
    # 创建备份
    if (Test-Path -Path $FACTORY_CFG) {
        $backupPath = "$FACTORY_CFG.bak.$(Get-Timestamp)"
        Copy-Item -Path $FACTORY_CFG -Destination $backupPath -Force
        Write-Host "已创建配置备份: $backupPath"
    }

    # JSON转义
    $key_json = ConvertTo-JsonEscaped $input_key
    $base_json = ConvertTo-JsonEscaped $input_base

    # 写入配置文件
    $configContent = @"
{
  "custom_models": [
    {
      "model_display_name": "GPT-5 [自定义]",
      "model": "gpt-5",
      "base_url": "$base_json",
      "api_key": "$key_json",
      "provider": "openai",
      "max_tokens": 128000
    },
    {
      "model_display_name": "GPT-5 High [自定义]",
      "model": "gpt-5-high",
      "base_url": "$base_json",
      "api_key": "$key_json",
      "provider": "openai",
      "max_tokens": 128000
    },
    {
      "model_display_name": "GPT-5-Codex [自定义]",
      "model": "gpt-5-codex",
      "base_url": "$base_json",
      "api_key": "$key_json",
      "provider": "openai",
      "max_tokens": 128000
    },
    {
      "model_display_name": "GPT-5-Codex High [自定义]",
      "model": "gpt-5-codex-high",
      "base_url": "$base_json",
      "api_key": "$key_json",
      "provider": "openai",
      "max_tokens": 128000
    },
    {
      "model_display_name": "GPT-5-mini [自定义]",
      "model": "gpt-5-mini",
      "base_url": "$base_json",
      "api_key": "$key_json",
      "provider": "openai",
      "max_tokens": 128000
    },
    {
      "model_display_name": "GPT-5-mini High [自定义]",
      "model": "gpt-5-mini-high",
      "base_url": "$base_json",
      "api_key": "$key_json",
      "provider": "openai",
      "max_tokens": 128000
    }
  ]
}
"@

    Set-Content -Path $FACTORY_CFG -Value $configContent -Force

    # 设置文件权限 (Windows下设置为只读)
    try {
        $acl = Get-Acl -Path $FACTORY_CFG
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            [System.Security.Principal.WindowsIdentity]::GetCurrent().Name,
            "ReadAndExecute",
            "Allow")
        $acl.SetAccessRule($rule)
        Set-Acl -Path $FACTORY_CFG -AclObject $acl
    } catch {
        # 如果权限设置失败，继续执行脚本
        Write-Host "提示: 无法设置文件权限，但配置已成功保存" -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "✅ 配置已成功写入 $FACTORY_CFG" -ForegroundColor Green
    Write-Host ""
    Write-Host "使用说明："
    Write-Host "- 配置的模型将在 Factory CLI 中显示为 'GPT-5 [自定义]' 等"
    Write-Host "- 如需修改配置，可以再次运行本脚本"
    Write-Host "- 如有问题，请检查 $FACTORY_CFG 文件"
}

# 执行主函数
Main
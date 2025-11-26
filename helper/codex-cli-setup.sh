#!/usr/bin/env bash

# OpenAI Codex CLI 配置脚本
# 配置 ~/.codex/config.toml 和 ~/.codex/auth.json

set -e
umask 077

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() {
    echo -e "${GREEN}${1}${NC}"
}

echo_warning() {
    echo -e "${YELLOW}${1}${NC}"
}

echo_error() {
    echo -e "${RED}错误: ${1}${NC}"
}

# 读取用户输入
read_input() {
    local prompt="$1"
    local default="$2"
    local input
    
    # 使用/dev/tty确保直接从终端读取，不受管道影响
    if [ -n "$default" ]; then
        echo -n "$prompt [$default]: " >/dev/tty
    else
        echo -n "$prompt: " >/dev/tty
    fi
    
    read input </dev/tty || true
    echo "${input:-$default}"
}

# 读取密码输入
read_password() {
    local prompt="$1"
    local input
    
    # 使用/dev/tty确保直接从终端读取，不受管道影响
    echo -n "$prompt: " >/dev/tty
    read -s input </dev/tty || true
    echo >/dev/tty
    echo "$input"
}

# 确保URL包含协议并添加/v1后缀
normalize_url() {
    local url="$1"
    
    # 添加协议
    if [[ ! "$url" =~ ^https?:// ]]; then
        url="https://$url"
    fi
    
    # 添加/v1后缀（如果没有）
    if [[ "$url" != */v1 ]]; then
        if [[ "$url" == */ ]]; then
            url="${url}v1"
        else
            url="${url}/v1"
        fi
    fi
    
    echo "$url"
}

# 提取主机名
extract_hostname() {
    local url="$1"
    # 移除协议
    local host="${url#http://}"
    host="${host#https://}"
    # 提取直到第一个斜杠的部分
    host="${host%%/*}"
    echo "$host"
}

# JSON转义函数
json_escape() {
    local str="$1"
    # 替换特殊字符
    str="${str//\\/\\\\}"
    str="${str//"/\\"}"
    str="${str//$'\n'/\\n}"
    str="${str//$'\r'/\\r}"
    str="${str//$'\t'/\\t}"
    echo "$str"
}

# 主函数
main() {
    echo_info "=== OpenAI Codex CLI 配置工具 ==="
    echo
    
    # 配置文件路径
    local COD_DIR="$HOME/.codex"
    local CONFIG_FILE="$COD_DIR/config.toml"
    local AUTH_FILE="$COD_DIR/auth.json"
    
    # 读取现有配置
    local existing_base_url=""
    local existing_api_key=""
    
    if [ -f "$CONFIG_FILE" ]; then
        existing_base_url=$(grep -m 1 "base_url" "$CONFIG_FILE" | sed 's/[^=]*= \([^\"]*\)/\1/' | sed 's/"//g')
    fi
    
    if [ -f "$AUTH_FILE" ]; then
        existing_api_key=$(grep -m 1 "OPENAI_API_KEY" "$AUTH_FILE" | sed 's/[^:]*: \([^\"]*\)/\1/' | sed 's/"//g' | tr -d '\r\n')
    fi
    
    # 获取Base URL
    echo_warning "配置API基础地址"
    if [ -n "$existing_base_url" ]; then
        echo "当前配置: $existing_base_url"
        local keep_existing=$(read_input "是否保持当前地址? (y/n)" "y")
        
        if [[ "$keep_existing" == [Yy]* ]]; then
            base_url="$existing_base_url"
        else
            local raw_url=$(read_input "请输入API基础地址，末尾不带/v1 (如 http://localhost:3000)" "")
            base_url=$(normalize_url "$raw_url")
        fi
    else
        local raw_url=$(read_input "请输入API基础地址，末尾不带/v1 (如 http://localhost:3000)" "")
        base_url=$(normalize_url "$raw_url")
    fi
    
    # 获取API Key
    echo_warning "\n配置API密钥"
    if [ -n "$existing_api_key" ]; then
        local keep_key=$(read_input "是否保持当前API密钥? (y/n)" "y")
        
        if [[ "$keep_key" == [Yy]* ]]; then
            api_key="$existing_api_key"
        else
            api_key=$(read_password "请输入API密钥")
            # 确保API Key不包含换行符和回车符
            api_key=$(echo "$api_key" | tr -d '\r\n')
        fi
    else
        api_key=$(read_password "请输入API密钥")
        # 确保API Key不包含换行符和回车符
        api_key=$(echo "$api_key" | tr -d '\r\n')
    fi
    
    # 创建配置目录
    mkdir -p "$COD_DIR"
    
    # 写入config.toml
    echo_info "\n写入配置文件: $CONFIG_FILE"
    cat > "$CONFIG_FILE" <<EOF
model = "gpt-5-codex"
model_provider = "custom"
model_reasoning_effort = "medium"
disable_response_storage = true

[model_providers.custom]
name = "custom"
base_url = "$(echo "$base_url" | sed 's/"/""/g')"
wire_api = "responses"
EOF
    
    # 写入auth.json
    echo_info "写入认证文件: $AUTH_FILE"
    cat > "$AUTH_FILE" <<EOF
{
  "OPENAI_API_KEY": "$(json_escape "$api_key")"
}
EOF
    
    # 设置文件权限
    chmod 700 "$COD_DIR" 2>/dev/null || true
    chmod 600 "$CONFIG_FILE" "$AUTH_FILE" 2>/dev/null || true
    
    # 显示配置结果
    echo_info "\n✅ 配置完成!"
    echo "  基础地址: $base_url"
    echo "  API密钥: 已设置 (****${api_key: -4})"
    echo "  配置文件: $CONFIG_FILE"
    echo "  认证文件: $AUTH_FILE"
    echo
    echo_warning "提示: 如需重新配置，请再次运行此脚本"
}

# 运行主函数
main
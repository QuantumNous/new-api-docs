#!/usr/bin/env bash

# factory-cli-setup.sh - Interactive setup for Factory CLI custom models
# 支持：
#   - 配置 ~/.factory/config.json 中的自定义模型
#   - 兼容 macOS (BSD) 和 Linux (GNU)

set -Eeuo pipefail
umask 077

# Ensure interactive terminal when piped
if ! [ -r /dev/tty ]; then
  echo "错误: /dev/tty 不可读。请在终端中运行。" >&2
  exit 1
fi

# -------- 工具函数 --------
has_cmd() { command -v "$1" >/dev/null 2>&1; }
trim() { printf "%s" "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'; }
read_tty() { local __p="${1:-}"; local input; read -r -p "$__p" input < /dev/tty || true; printf "%s" "${input:-}"; }
read_secret_tty() { local __p="${1:-}"; local input; read -r -s -p "$__p" input < /dev/tty || true; echo; printf "%s" "${input:-}"; }
timestamp() { date +"%Y%m%d-%H%M%S"; }

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

ensure_scheme() {
  # 确保base_url包含协议；默认为https
  case "$1" in
    http://*|https://*) printf "%s" "$1" ;;
    *) printf "https://%s" "$1" ;;
  esac
}

ensure_v1_suffix() {
  # 确保base_url末尾带有/v1
  local url="$1"
  if [[ "$url" != */v1 ]]; then
    # 检查是否以斜杠结尾
    if [[ "$url" == */ ]]; then
      printf "%sv1" "$url"
    else
      printf "%s/v1" "$url"
    fi
  else
    printf "%s" "$url"
  fi
}

# -------- 主函数 --------
main() {
  echo "=== Factory CLI 自定义模型配置向导 ==="
  echo
  echo "此脚本将帮助您配置 Factory CLI 使用第三方 API。"
  echo

  local FACTORY_DIR="$HOME/.factory"
  local FACTORY_CFG="$FACTORY_DIR/config.json"
  mkdir -p "$FACTORY_DIR"

  # 读取现有值
  local existing_base="" existing_key=""
  if [ -f "$FACTORY_CFG" ]; then
    if has_cmd jq && jq -e . "$FACTORY_CFG" >/dev/null 2>&1; then
      existing_base="$(jq -r '.custom_models[0].base_url // empty' "$FACTORY_CFG")"
      existing_key="$(jq -r '.custom_models[0].api_key // empty' "$FACTORY_CFG")"
    else
      # 如果没有jq，使用sed/grep作为后备方案
      existing_base="$(sed -n 's/.*"base_url"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$FACTORY_CFG" | head -n1 || true)"
      existing_key="$(sed -n 's/.*"api_key"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$FACTORY_CFG" | head -n1 || true)"
    fi
  fi

  # 1. 提示输入API URL
  echo "请输入第三方API的base_url："
  if [ -n "${existing_base:-}" ]; then
    echo "提示：按 Enter 保持现有 base_url 不变（当前: ${existing_base}）"
  fi
  local input_base
  input_base="$(read_tty "Base URL: ")"
  input_base="$(trim "$input_base")"
  
  if [ -z "$input_base" ]; then
    if [ -n "${existing_base:-}" ]; then
      echo "保持现有 base_url: $existing_base"
      input_base="$existing_base"
    else
      echo "错误: base_url 不能为空。" >&2
      exit 1
    fi
  else
    # 确保URL包含协议并以/v1结尾
    input_base="$(ensure_scheme "$input_base")"
    input_base="$(ensure_v1_suffix "$input_base")"
    echo "已规范化 base_url: $input_base"
  fi

  # 2. 提示输入API Key
  echo
  echo "请输入第三方API的API Key："
  if [ -n "${existing_key:-}" ]; then
    echo "提示：按 Enter 保持现有 API Key 不变"
  fi
  local input_key
  input_key="$(read_secret_tty "API Key: ")"
  input_key="$(trim "$input_key")"
  # 确保去除所有换行符和回车符
  input_key="$(printf '%s' "$input_key" | tr -d '\r\n')"
  
  if [ -z "$input_key" ]; then
    if [ -n "${existing_key:-}" ]; then
      echo "保持现有 API Key"
      input_key="$existing_key"
      # 对现有key也进行清理
      input_key="$(printf '%s' "$input_key" | tr -d '\r\n')"
    else
      echo "错误: API Key 不能为空。" >&2
      exit 1
    fi
  fi

  # 3. 写入配置文件
  echo
  echo "正在写入配置文件..."
  
  if [ -f "$FACTORY_CFG" ]; then
    cp "$FACTORY_CFG" "$FACTORY_CFG.bak.$(timestamp)" || true
    echo "已创建配置备份: $FACTORY_CFG.bak.$(timestamp)"
  fi

  # JSON转义
  local key_json base_json
  key_json="$(json_escape "$input_key")"
  base_json="$(json_escape "$input_base")"

  # 写入配置文件
  cat > "$FACTORY_CFG" <<EOF
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
EOF

  echo
  echo "✅ 配置已成功写入 $FACTORY_CFG"
  echo
  echo "使用说明："
  echo "- 配置的模型将在 Factory CLI 中显示为 'GPT-5 [自定义]' 等"
  echo "- 如需修改配置，可以再次运行本脚本"
  echo "- 如有问题，请检查 ~/.factory/config.json 文件"
}

# 执行主函数
main
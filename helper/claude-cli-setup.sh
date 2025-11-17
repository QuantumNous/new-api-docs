#!/usr/bin/env bash

# claude-cli-setup.sh - Interactive setup for Anthropic Claude Code CLI
# 配置 ANTHROPIC_* 环境变量到 ~/.bashrc 和 ~/.zshrc

set -Eeuo pipefail
umask 077

# 确保交互式终端
if ! [ -r /dev/tty ]; then
  echo "错误: /dev/tty 不可读。请在终端中运行。" >&2
  exit 1
fi

# -------- 工具函数 --------
has_cmd() { command -v "$1" >/dev/null 2>&1; }
trim() { printf "%s" "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'; }
read_tty() { local __p="${1:-}"; local input; read -r -p "$__p" input < /dev/tty || true; printf "%s" "${input:-}"; }
read_secret_tty() { local __p="${1:-}"; local input; read -r -s -p "$__p" input < /dev/tty || true; echo; printf "%s" "${input:-}"; }

sh_single_quote() { printf "'%s'" "$(printf "%s" "${1:-}" | sed "s/'/'\\''/g")"; }

# 将环境变量导出添加或更新到rc文件中
upsert_export() {
  local rcfile="${1:-}" key="${2:-}" val="${3:-}"
  [ -z "$rcfile" ] && return 1
  [ -z "$key" ] && return 1
  [ -z "$val" ] && return 0
  mkdir -p "$(dirname "$rcfile")"
  [ -f "$rcfile" ] || touch "$rcfile"

  local line="export $key=$(sh_single_quote "$val")"
  local pattern="^[[:space:]]*(export[[:space:]]+)?$key="

  if grep -Eq "$pattern" "$rcfile"; then
    # 替换现有行，创建备份文件
    sed -i.bak -E "s|$pattern.*$|$line|g" "$rcfile"
    # 成功编辑后立即删除备份文件
    rm -f "$rcfile.bak" 2>/dev/null || true
  else
    printf "%s\n" "$line" >> "$rcfile"
  fi
}

# 从运行时或rc文件中读取环境变量值（尽力而为）
read_env_from_rcs() {
  local key="${1:-}" val=""
  [ -z "$key" ] && { printf "%s" ""; return 0; }
  val="$(printenv "$key" || true)"
  if [ -n "$val" ]; then printf "%s" "$val"; return 0; fi
  for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    [ -f "$rc" ] || continue
    local line
    line="$(grep -E '^[[:space:]]*(export[[:space:]]+)?'"$key"'=' "$rc" | tail -n1 || true)"
    [ -z "$line" ] && continue
    line="${line#export }"
    line="${line#"$key"=}"
    line="$(trim "$line")"
    line="$(printf "%s" "$line" | sed -E "s/^'(.*)'$/\1/; s/^\"(.*)\"$/\1/")"
    val="$line"
    break
  done
  printf "%s" "$val"
}

# 从URL中提取主机名
extract_host() {
  # From https://host/xxx -> host
  local url="${1:-}"
  # 移除协议 (http:// 或 https://)
  local host_part="${url#http://}"
  host_part="${host_part#https://}"
  # 提取到第一个斜杠之前的部分
  printf "%s" "${host_part%%/*}"
}

# 确保URL包含协议
ensure_scheme() {
  # 确保base_url包含协议；默认为https
  case "$1" in
    http://*|https://*) printf "%s" "$1" ;;
    *) printf "https://%s" "$1" ;;
  esac
}

# 提示输入新的API URL
prompt_new_api_url() {
  # 参数: app_label base_suffix existing_base_url
  local app_label="${1:-Anthropic Claude Code CLI}" base_suffix="${2:-}" existing="${3:-}"
  local example_url="https://你的new-api站点${base_suffix:+$base_suffix}"

  echo >&2
  echo "当前仅支持自定义 $app_label API 站点。" >&2
  echo "示例: $example_url" >&2

  if [ -n "${existing:-}" ]; then
    echo "提示：按 Enter 保持现有 base_url 不变（当前: ${existing}）" >&2
    local choice
    choice="$(read_tty "直接回车保持不变，或输入 'y' 进入自定义输入: ")"
    choice="${choice:-}"
    if [ "$choice" != "y" ] && [ "$choice" != "Y" ]; then
        if [ -n "${existing:-}" ]; then
            echo "保持现有 base_url: $existing" >&2
            printf "%s" "$existing"
            return 0
        fi
    fi
    # 如果用户输入了'y'或'Y'，继续自定义输入流程
  fi

  # 强制自定义输入流程
  echo >&2
  echo "请输入完整 base_url（以 http(s):// 开头）。" >&2
  echo "示例: $example_url" >&2
  local custom
  custom="$(read_tty "自定义 base_url: ")"
  custom="$(trim "$custom")"
  if [ -z "$custom" ]; then
    echo "错误: base_url 不能为空。" >&2
    exit 1
  fi
  custom="$(ensure_scheme "$custom")"
  printf "%s" "$custom"
}

# 提示输入API Token
prompt_api_token() {
  # 参数: token_label host
  local token_label="${1:-ANTHROPIC_AUTH_TOKEN}"
  local host="${2:-}"
  local token_url="https://${host}/console/token"

  echo >&2
  echo "请在浏览器中访问以下地址获取 ${token_label}：" >&2
  echo "  $token_url" >&2
  echo "获取后，请粘贴你的 ${token_label}：" >&2

  local token_input
  token_input="$(read_secret_tty "粘贴你的 ${token_label}: ")"
  token_input="$(trim "$token_input")"
  # 移除内部的任何CR/LF
  token_input="$(printf '%s' "$token_input" | tr -d '\r\n')"

  if [ -z "$token_input" ]; then
    echo "错误: ${token_label} 不能为空。" >&2
    exit 1
  fi
  printf "%s" "$token_input"
}

# 主函数
main() {
  echo "=== Anthropic Claude Code CLI 配置工具 ==="
  echo
  
  # 读取现有配置
  local existing_base existing_key
  existing_base="$(read_env_from_rcs "ANTHROPIC_BASE_URL")"
  existing_key="$(read_env_from_rcs "ANTHROPIC_AUTH_TOKEN")"

  # 提示输入新的API URL
  local new_base_url
  new_base_url="$(prompt_new_api_url "Anthropic Claude Code CLI" "" "$existing_base")"

  # 提示输入API Token
  local host_for_token; host_for_token="$(extract_host "$new_base_url")"
  if [ -z "$host_for_token" ]; then
    echo "错误: 无法从 base_url '$new_base_url' 提取主机名。" >&2
    exit 1
  fi
  local new_api_key
  new_api_key="$(prompt_api_token "ANTHROPIC_AUTH_TOKEN" "$host_for_token")"

  # 写入环境变量到shell配置文件
  # 更新到RC文件
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    upsert_export "$rc" "ANTHROPIC_BASE_URL" "$new_base_url"
    upsert_export "$rc" "ANTHROPIC_AUTH_TOKEN" "$new_api_key"
  done

  echo
  echo "✅ Anthropic Claude Code CLI 配置完成。"
  echo "  ANTHROPIC_BASE_URL: $new_base_url $(if [ "$new_base_url" = "$existing_base" ]; then echo "(保持不变)"; else echo "(自定义)"; fi)"
  echo "  ANTHROPIC_AUTH_TOKEN: $(if [ "$new_api_key" = "$existing_key" ]; then echo "保持不变"; else echo "已更新"; fi)"
  echo
  echo "提示：请执行以下命令之一让环境变量立即生效，或重新打开终端："
  echo "  source ~/.bashrc    # bash"
  echo "  source ~/.zshrc     # zsh"
  echo
  echo "注意：配置通过环境变量生效，无需额外的配置文件。"
}

# 执行主函数
main "$@"
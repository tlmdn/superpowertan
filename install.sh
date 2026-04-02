#!/bin/bash
set -e

PLUGIN_NAME="superpowertan"
PLUGIN_VERSION="1.0.0"
PLUGIN_LOCAL_CACHE="$HOME/.claude/plugins/cache/${PLUGIN_NAME}-local/${PLUGIN_VERSION}"
SKILLS_SOURCE="$(cd "$(dirname "$0")" && pwd)/skills"

echo "=== superpowertan 安装脚本 ==="

# 1. 创建插件缓存目录结构
echo "[1/5] 创建插件目录..."
mkdir -p "$PLUGIN_LOCAL_CACHE/.claude-plugin"
mkdir -p "$PLUGIN_LOCAL_CACHE/skills"

# 2. 复制并转换 skills 文件结构（.md → SKILL.md 子目录）
echo "[2/5] 转换 skills 文件结构..."
for md_file in "$SKILLS_SOURCE"/*.md; do
  skill_name=$(basename "$md_file" .md)
  target_dir="$PLUGIN_LOCAL_CACHE/skills/$skill_name"
  mkdir -p "$target_dir"
  cp "$md_file" "$target_dir/SKILL.md"
  echo "  - $skill_name ✓"
done

# 3. 创建 plugin.json
echo "[3/5] 创建 plugin.json..."
cat > "$PLUGIN_LOCAL_CACHE/.claude-plugin/plugin.json" << 'EOF'
{
  "name": "superpowertan",
  "version": "1.0.0",
  "description": "AI 任务编排开发框架 - SP 外层 + 职能层执行纪律",
  "author": { "name": "superpowertan" },
  "keywords": ["orchestration", "development", "workflow", "ai"]
}
EOF

# 4. 创建 marketplace.json
echo "[4/5] 创建 marketplace.json..."
cat > "$PLUGIN_LOCAL_CACHE/.claude-plugin/marketplace.json" << 'EOF'
{
  "identifier": "superpowertan-local",
  "name": "superpowertan",
  "version": "1.0.0",
  "description": "AI 任务编排开发框架"
}
EOF

# 5. 注册到 installed_plugins.json（如果不存在）
echo "[5/5] 注册插件..."
INSTALLED_PLUGINS="$HOME/.claude/plugins/installed_plugins.json"
if [ ! -f "$INSTALLED_PLUGINS" ]; then
  echo '{"version":2,"plugins":{}}' > "$INSTALLED_PLUGINS"
fi

# 检查是否已注册
if grep -q "\"${PLUGIN_NAME}@${PLUGIN_NAME}-local\"" "$INSTALLED_PLUGINS" 2>/dev/null; then
  echo "  插件已注册，跳过"
else
  # 临时文件用于 JSON 修改
  TEMP_FILE=$(mktemp)

  # 使用 Python 处理 JSON，更可靠
  python3 << PYEOF
import json
import sys

with open("$INSTALLED_PLUGINS", "r") as f:
    data = json.load(f)

plugin_entry = {
    "scope": "user",
    "installPath": "$PLUGIN_LOCAL_CACHE",
    "version": "$PLUGIN_VERSION",
    "installedAt": "2026-04-02T04:00:00.000Z",
    "lastUpdated": "2026-04-02T04:00:00.000Z",
    "gitCommitSha": "local"
}

key = "${PLUGIN_NAME}@${PLUGIN_NAME}-local"
if key not in data["plugins"]:
    data["plugins"][key] = [plugin_entry]
else:
    # 更新已存在的
    data["plugins"][key] = [plugin_entry]

with open("$TEMP_FILE", "w") as f:
    json.dump(data, f, indent=2)

print("done")
PYEOF

  mv "$TEMP_FILE" "$INSTALLED_PLUGINS"
  echo "  注册完成 ✓"
fi

# 6. 更新 settings.json 的 enabledPlugins
echo "[6/7] 更新 settings.json..."
SETTINGS_FILE="$HOME/.claude/settings.json"

python3 << PYEOF
import json
import sys
import os

settings_path = os.path.expanduser("$SETTINGS_FILE")
with open(settings_path, "r") as f:
    settings = json.load(f)

# 添加到 enabledPlugins
enabled_key = "${PLUGIN_NAME}@${PLUGIN_NAME}-local"
if "enabledPlugins" not in settings:
    settings["enabledPlugins"] = {}
settings["enabledPlugins"][enabled_key] = True

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)

print("settings updated")
PYEOF

# 7. 注册到 known_marketplaces.json
echo "[7/7] 注册 marketplace..."
KNOWN_MARKETS="$HOME/.claude/plugins/known_marketplaces.json"
if [ -f "$KNOWN_MARKETS" ]; then
  python3 << PYEOF
import json
import os

km_path = os.path.expanduser("$KNOWN_MARKETS")
with open(km_path, "r") as f:
    km = json.load(f)

key = "${PLUGIN_NAME}-local"
if key not in km:
    km[key] = {
        "source": {"source": "local"},
        "installLocation": "$PLUGIN_LOCAL_CACHE",
        "lastUpdated": "2026-04-02T04:00:00.000Z"
    }

with open(km_path, "w") as f:
    json.dump(km, f, indent=2)
print("marketplace registered")
PYEOF
fi

echo ""
echo "=== 安装完成 ==="
echo ""
echo "请重启 Claude Code 使插件生效，然后使用："
echo "  /skill orchestrated-development"
echo ""
echo "或查看所有 skills："
echo "  /skills"
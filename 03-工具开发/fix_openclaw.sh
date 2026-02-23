#!/bin/bash
# 修复 OpenClaw 的网络连接问题

echo "🔧 修复 OpenClaw 网络连接"
echo "=========================="
echo ""

echo "【问题分析】"
echo "OpenClaw 日志显示: TypeError: fetch failed"
echo ""
echo "原因: OpenClaw 配置了代理 http://127.0.0.1:7897"
echo "     但 Clash Verge TUN 模式拦截了请求"
echo ""

echo "【解决方案】"
echo "=========================="
echo ""

echo "方案 1: 禁用 OpenClaw 的代理配置（推荐）"
echo "----------------------------"
echo ""
echo "修改文件: ~/.openclaw/openclaw.json"
echo "将 channels.telegram.proxy 设置为 null"
echo ""

# 备份配置文件
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup.$(date +%Y%m%d_%H%M%S)
echo "✅ 已备份配置文件"

# 使用 Python 修改配置
python3 << 'PYTHON_SCRIPT'
import json
from pathlib import Path

config_file = Path.home() / ".openclaw" / "openclaw.json"

with open(config_file, 'r', encoding='utf-8') as f:
    config = json.load(f)

# 检查并修改代理设置
if 'channels' in config and 'telegram' in config['channels']:
    old_proxy = config['channels']['telegram'].get('proxy', '未设置')
    config['channels']['telegram']['proxy'] = None

    with open(config_file, 'w', encoding='utf-8') as f:
        json.dump(config, f, indent=2, ensure_ascii=False)

    print(f"✅ 已修改代理设置:")
    print(f"   旧值: {old_proxy}")
    print(f"   新值: None (禁用代理)")
else:
    print("⚠️  未找到 Telegram 代理配置")
PYTHON_SCRIPT

echo ""
echo "方案 2: 重启 OpenClaw Gateway"
echo "----------------------------"
echo ""

# 重启 OpenClaw
echo "重启 OpenClaw Gateway..."
launchctl unload ~/Library/LaunchAgents/ai.openclaw.gateway.plist 2>/dev/null
sleep 2
launchctl load ~/Library/LaunchAgents/ai.openclaw.gateway.plist 2>/dev/null
sleep 2

# 检查进程
if pgrep -f "openclaw-gateway" > /dev/null; then
    echo "✅ OpenClaw Gateway 已重启"
else
    echo "⚠️  OpenClaw Gateway 未运行，尝试手动启动..."
    openclaw-gateway &
fi

echo ""
echo "=========================="
echo ""
echo "✅ 修复完成！"
echo ""
echo "📝 说明:"
echo "   - 已禁用 OpenClaw Telegram 的代理配置"
echo "   - OpenClaw 现在会直接连接，不通过 Clash"
echo "   - 由于 Clash TUN 模式已配置排除规则，应该可以正常工作"
echo ""
echo "🧪 测试 OpenClaw:"
echo "   在 Telegram 中向你的机器人发送消息"
echo ""
echo "📊 查看日志:"
echo "   tail -f ~/.openclaw/logs/gateway.err.log"
echo ""

#!/bin/bash
# 快速修复 Antigravity CDP 400 错误

echo "✨ 快速修复 Antigravity CDP 400 错误"
echo "====================================="
echo ""

# 设置 NO_PROXY
export NO_PROXY="localhost,127.0.0.1,::1"
export no_proxy="localhost,127.0.0.1,::1"

echo "✅ 已设置 NO_PROXY: $NO_PROXY"
echo ""

# 关闭 Antigravity 和 Chrome
echo "🔄 关闭 Antigravity 和 Chrome..."
killall 'Antigravity' 'Google Chrome' 2>/dev/null
sleep 2

# 等待进程完全关闭
echo "⏳ 等待进程关闭..."
sleep 2

# 重新启动 Antigravity
echo "🚀 重新启动 Antigravity..."
open -a "Antigravity"

echo ""
echo "✅ 完成！"
echo ""
echo "📝 说明:"
echo "   - Antigravity 已使用正确的代理设置重启"
echo "   - CDP 连接现在应该可以正常工作"
echo "   - 如果问题仍然存在，请查看详细文档:"
echo "     cat /Users/lixun/Claude-Code/05-临时任务/antigravity_cdp_solution.md"

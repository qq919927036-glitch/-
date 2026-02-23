#!/bin/bash
# 完全重置 Chrome，为 Antigravity 准备干净环境

echo "🔄 完全重置 Chrome 环境"
echo "=============================="
echo ""

echo "【步骤 1】关闭所有 Chrome 和 Antigravity"
echo "----------------------------"
killall 'Google Chrome' 'Antigravity' 2>/dev/null
sleep 3

# 确保所有进程都已关闭
if pgrep -f "Google Chrome" > /dev/null; then
    echo "强制关闭 Chrome..."
    killall -9 'Google Chrome' 2>/dev/null
    sleep 2
fi

if pgrep -f "Antigravity" > /dev/null; then
    echo "强制关闭 Antigravity..."
    killall -9 'Antigravity' 2>/dev/null
    sleep 2
fi

echo "✅ 所有进程已关闭"

echo ""
echo "【步骤 2】检查端口 9222"
echo "----------------------------"
if lsof -i :9222 > /dev/null 2>&1; then
    echo "⚠️  端口 9222 仍被占用，尝试清理..."
    lsof -ti :9222 | xargs kill -9 2>/dev/null
    sleep 2
fi

if lsof -i :9222 > /dev/null 2>&1; then
    echo "❌ 端口 9222 仍被占用，请手动重启"
    lsof -i :9222
else
    echo "✅ 端口 9222 已释放"
fi

echo ""
echo "【步骤 3】清理临时配置文件"
echo "----------------------------"
rm -rf /tmp/antigravity-no-proxy /tmp/chrome-debug-profile
echo "✅ 临时配置已清理"

echo ""
echo "【步骤 4】验证环境"
echo "----------------------------"
echo ""
echo "检查 Antigravity 浏览器配置文件:"
ls -d ~/.gemini/antigravity-browser-profile* 2>/dev/null | while read dir; do
    echo "  - $dir"
done

echo ""
echo "检查 Clash Verge TUN 状态:"
if ifconfig | grep -q "utun1024"; then
    echo "  ⚠️  TUN 模式已启用 (utun1024)"
    echo "  确认已配置排除规则: 127.0.0.0/8"
    grep -A 2 "route-exclude-address" ~/Library/Application\ Support/io.github.clash-verge-rev.clash-verge-rev/clash-verge.yaml 2>/dev/null | grep "127.0.0.0/8" && echo "  ✅ 排除规则已配置" || echo "  ❌ 排除规则未配置"
else
    echo "  ✅ TUN 模式未启用"
fi

echo ""
echo "【步骤 5】重启 Antigravity"
echo "----------------------------"
open -a "Antigravity"
sleep 3

if pgrep -f "Antigravity" > /dev/null; then
    echo "✅ Antigravity 已启动"
else
    echo "⚠️  Antigravity 启动失败"
fi

echo ""
echo "=============================="
echo ""
echo "✅ 重置完成！"
echo ""
echo "📝 下一步操作："
echo "   1. 在 Antigravity 中执行需要浏览器的操作"
echo "   2. 观察 Chrome 是否自动启动"
echo "   3. 检查是否还有 502 错误"
echo ""
echo "🧪 验证命令："
echo "   bash /Users/lixun/Claude-Code/05-临时任务/verify_antigravity.sh"
echo ""

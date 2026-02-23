#!/bin/bash
# 最终验证脚本

echo "🎉 ZeroOmega 修复 - 最终验证"
echo "=============================="
echo ""

echo "【检查 1】ZeroOmega 状态"
echo "----------------------------"
omega_count=$(find ~/.gemini/antigravity-browser-profile* -name "pfnededegaaopdmhkdmcofjmoldfiped" -type d | grep -v disabled | wc -l | tr -d ' ')
if [ "$omega_count" -eq 0 ]; then
    echo "✅ 所有配置文件中的 ZeroOmega 已禁用"
else
    echo "⚠️  仍有 $omega_count 个 ZeroOmega 实例未禁用"
fi

echo ""
echo "【检查 2】Antigravity 状态"
echo "----------------------------"
if pgrep -f "Antigravity.app" > /dev/null; then
    echo "✅ Antigravity 正在运行"
else
    echo "⚠️  Antigravity 未运行"
    echo "   启动中..."
    open -a "Antigravity"
    sleep 3
fi

echo ""
echo "【检查 3】Chrome 浏览器状态"
echo "----------------------------"
chrome_count=$(ps aux | grep "Google Chrome" | grep "remote-debugging-port" | grep -v grep | wc -l | tr -d ' ')
if [ "$chrome_count" -gt 0 ]; then
    echo "✅ Chrome 正在运行（带调试端口）"
else
    echo "⏳ Chrome 未启动（按需启动）"
    echo "   💡 请在 Antigravity 中执行一个浏览器操作"
fi

echo ""
echo "【检查 4】CDP 连接测试"
echo "----------------------------"
if curl -s http://localhost:9222/json/version > /dev/null 2>&1; then
    echo "✅ CDP HTTP 端点可访问"
    browser_info=$(curl -s http://localhost:9222/json/version | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('Browser', 'N/A'))" 2>/dev/null)
    echo "   浏览器: $browser_info"

    # 测试 WebSocket
    ws_url=$(curl -s http://localhost:9222/json/version | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('webSocketDebuggerUrl', ''))" 2>/dev/null)
    if [ -n "$ws_url" ]; then
        echo "✅ WebSocket URL: $ws_url"
    fi
else
    echo "⏳ CDP 端点未就绪"
    echo "   💡 请先在 Antigravity 中执行一个浏览器操作"
fi

echo ""
echo "=============================="
echo ""
echo "📝 下一步操作："
echo "   1. 在 Antigravity 中执行一个浏览器操作"
echo "   2. 观察是否能成功控制浏览器"
echo "   3. 如果成功，恭喜！CDP 400 错误已解决！"
echo ""
echo "🧪 运行完整测试："
echo "   python3 /Users/lixun/Claude-Code/05-临时任务/test_cdp_now.py"
echo ""

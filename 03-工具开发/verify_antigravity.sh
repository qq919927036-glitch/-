#!/bin/bash
# Antigravity 详细验证脚本

echo "🔍 Antigravity 详细验证"
echo "=============================="
echo ""

# 1. 检查 Antigravity 进程
echo "【检查 1】Antigravity 进程"
echo "----------------------------"
if pgrep -f "Antigravity.app/Contents/MacOS/Electron" > /dev/null; then
    echo "✅ Antigravity 主进程正在运行"
    pgrep -f "Antigravity.app/Contents/MacOS/Electron" | head -1 | xargs ps -p | tail -1
else
    echo "❌ Antigravity 未运行"
fi

echo ""

# 2. 检查 Chrome 进程
echo "【检查 2】Chrome 浏览器进程"
echo "----------------------------"
chrome_count=$(ps aux | grep "Google Chrome" | grep "remote-debugging-port=9222" | grep -v grep | wc -l | tr -d ' ')
if [ "$chrome_count" -gt 0 ]; then
    echo "✅ 找到 $chrome_count 个 Chrome 实例（带调试端口）"

    # 显示配置文件
    echo ""
    echo "Chrome 配置文件:"
    ps aux | grep "Google Chrome" | grep "remote-debugging-port=9222" | grep -v grep | head -1 | awk '{for(i=1;i<=NF;i++){if($i~/--user-data-dir/){print "  " $(i) " " $(i+1)}}}'
else
    echo "⏳ Chrome 未启动（Antigravity 按需启动）"
    echo "   💡 请在 Antigravity 中执行需要浏览器的操作"
fi

echo ""

# 3. 检查 CDP 端点
echo "【检查 3】CDP 端点 (localhost:9222)"
echo "----------------------------"
if curl -s http://localhost:9222/json/version > /dev/null 2>&1; then
    echo "✅ CDP HTTP 端点可访问"

    # 获取浏览器信息
    browser_info=$(curl -s http://localhost:9222/json/version | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(f\"浏览器: {d.get('Browser', 'N/A')}\")
    print(f\"协议版本: {d.get('Protocol-Version', 'N/A')}\")
    print(f\"WebSocket: {d.get('webSocketDebuggerUrl', 'N/A')[:50]}...\")
except:
    print('无法解析')
" 2>/dev/null)
    echo "$browser_info"

    # 测试 WebSocket 连接
    echo ""
    echo "测试 WebSocket 连接..."
    ws_url=$(curl -s http://localhost:9222/json/version | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('webSocketDebuggerUrl',''))" 2>/dev/null)

    if [ -n "$ws_url" ]; then
        echo "  ✅ WebSocket URL: $ws_url"
    else
        echo "  ❌ 无法获取 WebSocket URL"
    fi
else
    echo "❌ CDP 端点不可访问"
    echo "   可能原因："
    echo "   - Chrome 未启动"
    echo "   - 端口被占用"
    echo "   - 防火墙阻止"
fi

echo ""

# 4. 检查 Clash TUN
echo "【检查 4】Clash Verge TUN 模式"
echo "----------------------------"
if ifconfig | grep -q "utun1024"; then
    echo "⚠️  TUN 模式已启用"

    # 检查排除规则
    if grep -q "127.0.0.0/8" ~/Library/Application\ Support/io.github.clash-verge-rev.clash-verge-rev/clash-verge.yaml 2>/dev/null; then
        echo "✅ 排除规则已配置 (127.0.0.0/8)"
    else
        echo "❌ 排除规则未配置！"
        echo "   这是 502 错误的可能原因"
    fi
else
    echo "✅ TUN 模式未启用"
fi

echo ""

# 5. 检查代理设置
echo "【检查 5】系统代理设置"
echo "----------------------------"
echo "HTTP_PROXY: $HTTP_PROXY"
echo "HTTPS_PROXY: $HTTPS_PROXY"
echo "NO_PROXY: $NO_PROXY"

if [[ "$NO_PROXY" == *"127.0.0.1"* ]] || [[ "$NO_PROXY" == *"localhost"* ]]; then
    echo "✅ NO_PROXY 已配置"
else
    echo "⚠️  NO_PROXY 未配置或不含 localhost"
fi

echo ""

# 6. 测试实际连接
echo "【检查 6】实际连接测试"
echo "----------------------------"
echo "测试 1: 直连 CDP（绕过代理）"
curl_output=$(curl --noproxy "*" -s -w "\nHTTP_CODE:%{http_code}" http://localhost:9222/json/version 2>&1)
http_code=$(echo "$curl_output" | grep "HTTP_CODE" | cut -d: -f2)
if [ "$http_code" = "200" ]; then
    echo "  ✅ 直连成功"
else
    echo "  ❌ 直连失败 (HTTP $http_code)"
fi

echo ""
echo "测试 2: 通过 NO_PROXY 连接"
curl_output=$(curl -s -w "\nHTTP_CODE:%{http_code}" http://localhost:9222/json/version 2>&1)
http_code=$(echo "$curl_output" | grep "HTTP_CODE" | cut -d: -f2)
if [ "$http_code" = "200" ]; then
    echo "  ✅ 通过 NO_PROXY 成功"
else
    echo "  ❌ 通过 NO_PROXY 失败 (HTTP $http_code)"
fi

echo ""
echo "=============================="
echo ""

# 诊断建议
echo "📋 诊断建议"
echo "----------------------------"
echo ""

if lsof -i :9222 > /dev/null 2>&1; then
    if curl -s http://localhost:9222/json/version > /dev/null 2>&1; then
        echo "✅ CDP 连接正常"
        echo ""
        echo "如果 Antigravity 仍然报告 502 错误，可能原因："
        echo "  1. Antigravity 使用了不同的连接方式"
        echo "  2. Antigravity 的浏览器配置有问题"
        echo "  3. Antigravity 的网络层被拦截"
        echo ""
        echo "建议："
        echo "  - 查看 Antigravity 的详细日志"
        echo "  - 尝试完全重置 Antigravity"
    else
        echo "⚠️  端口 9222 被占用但无法连接"
        echo ""
        echo "可能原因："
        echo "  - 有其他程序占用了端口 9222"
        echo ""
        echo "建议："
        echo "  - 运行重置脚本：bash /Users/lixun/Claude-Code/05-临时任务/reset_for_antigravity.sh"
    fi
else
    echo "⏳ 端口 9222 未监听"
    echo ""
    echo "Chrome 尚未启动，这是正常的。"
    echo "Antigravity 会在需要时自动启动浏览器。"
fi

echo ""
echo "=============================="

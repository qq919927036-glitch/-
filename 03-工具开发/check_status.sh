#!/bin/bash
# Antigravity 状态检查脚本

echo "🔍 Antigravity 状态检查"
echo "======================="
echo ""

# 1. 检查 Antigravity 进程
echo "【1】Antigravity 进程:"
if pgrep -f "Antigravity.app" > /dev/null; then
    echo "   ✅ Antigravity 正在运行"
    ps aux | grep -i "Antigravity.app" | grep -v grep | grep Electron | head -1
else
    echo "   ❌ Antigravity 未运行"
fi

echo ""

# 2. 检查 Chrome 进程（带调试端口）
echo "【2】Chrome 浏览器进程（带调试端口）:"
chrome_count=$(ps aux | grep "Google Chrome" | grep "remote-debugging-port" | grep -v grep | wc -l | tr -d ' ')
if [ "$chrome_count" -gt 0 ]; then
    echo "   ✅ 找到 $chrome_count 个 Chrome 实例"
    ps aux | grep "Google Chrome" | grep "remote-debugging-port" | grep -v grep | head -1
else
    echo "   ⚠️  未找到带调试端口的 Chrome 进程"
    echo "   💡 Antigravity 可能还没有启动浏览器"
    echo "   💡 请在 Antigravity 中执行一个需要浏览器的操作"
fi

echo ""

# 3. 检查 CDP 端口
echo "【3】CDP 端口 9222:"
if lsof -i :9222 > /dev/null 2>&1; then
    echo "   ✅ 端口 9222 正在监听"
    curl -s http://localhost:9222/json/version 2>&1 | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'   浏览器: {d.get(\"Browser\", \"N/A\")}')" 2>/dev/null || echo "   但无法获取版本信息"
else
    echo "   ❌ 端口 9222 未监听"
    echo "   💡 Chrome 调试端口未开启"
fi

echo ""

# 4. 检查代理设置
echo "【4】代理设置:"
echo "   HTTP_PROXY: $HTTP_PROXY"
echo "   HTTPS_PROXY: $HTTPS_PROXY"
echo "   http_proxy: $http_proxy"
echo "   https_proxy: $https_proxy"
echo "   NO_PROXY: $NO_PROXY"
echo "   no_proxy: $no_proxy"

if [[ "$NO_PROXY" == *"localhost"* ]] || [[ "$NO_PROXY" == *"127.0.0.1"* ]]; then
    echo "   ✅ NO_PROXY 已正确配置（包含 localhost/127.0.0.1）"
else
    echo "   ⚠️  NO_PROXY 未配置或不包含 localhost"
    echo "   💡 运行: export NO_PROXY=\"localhost,127.0.0.1,::1\""
fi

echo ""
echo "======================="
echo "✅ 检查完成"

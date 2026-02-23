#!/bin/bash
# Chrome CDP 重启脚本

echo "============================================================"
echo "Chrome CDP 重启脚本"
echo "============================================================"

# 1. 关闭所有 Chrome 实例
echo "\n[1/3] 关闭所有 Chrome 实例..."
killall 'Google Chrome' 2>/dev/null
sleep 2

# 2. 清理旧的调试配置（可选）
echo "[2/3] 清理旧的调试配置..."
rm -rf /tmp/chrome-debug-profile
mkdir -p /tmp/chrome-debug-profile

# 3. 启动带调试端口的 Chrome
echo "[3/3] 启动带调试端口的 Chrome..."
'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-debug-profile \
  --no-first-run \
  --no-default-browser-check \
  --disable-features=VizDisplayCompositor \
  --disable-web-security \
  --disable-features=IsolateOrigins,site-per-process &

echo "\n等待 Chrome 启动..."
sleep 3

# 4. 测试连接
echo "\n测试 CDP 连接..."
curl -s http://localhost:9222/json/version | python3 -m json.tool

echo "\n============================================================"
echo "✅ Chrome 已重启！"
echo "============================================================"
echo "\nCDP WebSocket URL:"
echo "  ws://localhost:9222/devtools/browser/$(curl -s http://localhost:9222/json/version | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['webSocketDebuggerUrl'].split('/')[-1])")"
echo "\n现在可以尝试连接你的自动化工具了。"

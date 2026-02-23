#!/bin/bash
# 为 Antigravity 创建完全绕过代理的浏览器

echo "🔧 为 Antigravity 创建干净浏览器（无代理）"
echo "=========================================="
echo ""

# 1. 关闭现有的 Chrome
echo "【步骤 1】关闭现有 Chrome 实例"
killall 'Google Chrome' 2>/dev/null
sleep 2
echo "✅ Chrome 已关闭"

echo ""
echo "【步骤 2】创建不使用代理的浏览器配置"

# 创建新的配置文件
CLEAN_PROFILE="/tmp/antigravity-no-proxy"
rm -rf "$CLEAN_PROFILE"
mkdir -p "$CLEAN_PROFILE"

echo "✅ 配置文件: $CLEAN_PROFILE"

echo ""
echo "【步骤 3】启动 Chrome（完全绕过代理）"

# 设置环境变量，禁用所有代理
export http_proxy=""
export https_proxy=""
export HTTP_PROXY=""
export HTTPS_PROXY=""
export no_proxy="*"
export NO_PROXY="*"

# 启动 Chrome，禁用扩展，使用独立配置
'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' \
  --remote-debugging-port=9222 \
  --user-data-dir="$CLEAN_PROFILE" \
  --no-first-run \
  --no-default-browser-check \
  --disable-extensions \
  --disable-plugins \
  --disable-background-networking \
  --disable-sync \
  --disable-translate \
  --disable-features=VizDisplayCompositor \
  --proxy-server="direct://" \
  --disable-web-security &

echo "✅ Chrome 已启动（直连模式）"

sleep 3

echo ""
echo "【步骤 4】验证配置"
echo ""

# 检查 Chrome 是否启动
if pgrep -f "Google Chrome.*$CLEAN_PROFILE" > /dev/null; then
    echo "✅ Chrome 进程正在运行"
else
    echo "⚠️  Chrome 进程未找到"
fi

# 检查 CDP 端口
if curl -s http://localhost:9222/json/version > /dev/null 2>&1; then
    echo "✅ CDP 端点可访问"
    echo ""
    echo "浏览器信息:"
    curl -s http://localhost:9222/json/version | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(f'  浏览器: {d.get(\"Browser\")}')
print(f'  协议: {d.get(\"Protocol-Version\")}')
" 2>/dev/null
else
    echo "⚠️  CDP 端点不可访问"
fi

echo ""
echo "=========================================="
echo ""
echo "✅ 配置完成！"
echo ""
echo "📝 说明："
echo "  - Chrome 已启动，完全不使用任何代理"
echo "  - 所有扩展已禁用"
echo "  - 直接连接到互联网"
echo ""
echo "🧪 测试步骤："
echo "  1. 现在在 Antigravity 中尝试访问推特"
echo "  2. 应该可以正常工作（不会出现 502 错误）"
echo ""
echo "⚠️  注意："
echo "  - 这是临时的测试配置"
echo "  - Chrome 关闭后配置会丢失"
echo "  - 如果需要永久解决方案，需要修改 Antigravity 的启动配置"
echo ""
echo "🔄 如果需要重启此浏览器："
echo "  killall 'Google Chrome'"
echo "  bash /Users/lixun/Claude-Code/05-临时任务/create_clean_browser.sh"
echo ""

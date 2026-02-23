#!/bin/bash
# 修复 ZeroOmega 拦截 localhost 的问题

echo "🔧 修复 ZeroOmega 拦截 localhost 问题"
echo "====================================="
echo ""

# 方案 1: 禁用 ZeroOmega 扩展
echo "【方案 1】禁用 ZeroOmega 扩展"
echo ""

# 找到 ZeroOmega 扩展目录
OMEGA_DIR="$HOME/.gemini/antigravity-browser-profile-proxy-3/Default/Extensions/pfnededegaaopdmhkdmcofjmoldfiped"

if [ -d "$OMEGA_DIR" ]; then
    echo "找到 ZeroOmega 扩展: $OMEGA_DIR"
    echo ""
    echo "禁用扩展（重命名目录）..."
    mv "$OMEGA_DIR" "${OMEGA_DIR}.disabled" 2>/dev/null && echo "✅ ZeroOmega 已禁用" || echo "⚠️  禁用失败"
else
    echo "⚠️  未找到 ZeroOmega 扩展"
fi

echo ""
echo "【方案 2】创建不使用代理的 Chrome 配置"
echo ""

# 关闭所有 Chrome
echo "关闭所有 Chrome 实例..."
killall 'Google Chrome' 2>/dev/null
sleep 2

# 创建新的 Chrome 配置文件，不安装任何扩展
CLEAN_PROFILE="/tmp/antigravity-clean-profile"
rm -rf "$CLEAN_PROFILE"
mkdir -p "$CLEAN_PROFILE"

echo "✅ 已创建干净配置: $CLEAN_PROFILE"

# 启动 Chrome 时不加载扩展
echo ""
echo "启动 Chrome（禁用扩展模式）..."
'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' \
  --remote-debugging-port=9222 \
  --user-data-dir="$CLEAN_PROFILE" \
  --no-first-run \
  --no-default-browser-check \
  --disable-extensions \
  --disable-features=VizDisplayCompositor \
  --disable-web-security &

sleep 3

echo ""
echo "【方案 3】测试 ZeroOmega 绕过规则"
echo ""
echo "如果方案 1 和 2 不适用，你可以手动配置 ZeroOmega:"
echo ""
echo "1. 打开 Chrome 扩展管理页面: chrome://extensions/"
echo "2. 找到 ZeroOmega，点击 '选项'"
echo "3. 添加以下绕过规则:"
echo ""
cat << 'EOF'
在 ZeroOmega 中创建规则（使用智能切换模式）：

规则名称: Antigravity Fix
条件: *.local; 127.0.0.1; localhost
配置: 直接连接

或者使用正则表达式：
^https?://(localhost|127\.0\.0\.1|.*\.local)(:\d+)?$
→ 直接连接
EOF

echo ""
echo "====================================="
echo "测试 CDP 连接..."
sleep 2

if curl -s http://localhost:9222/json/version > /dev/null 2>&1; then
    echo "✅ CDP 端点可访问"
    curl -s http://localhost:9222/json/version | python3 -m json.tool | head -5
else
    echo "❌ CDP 端点不可访问"
fi

echo ""
echo "====================================="
echo "完成！"
echo ""
echo "💡 提示:"
echo "   - 方案 1: 禁用了 ZeroOmega 扩展"
echo "   - 方案 2: 创建了不加载扩展的 Chrome 实例"
echo "   - 方案 3: 手动配置 ZeroOmega 白名单（如需保留扩展）"
echo ""
echo "📝 如果需要恢复 ZeroOmega:"
echo "   mv ${OMEGA_DIR}.disabled $OMEGA_DIR"

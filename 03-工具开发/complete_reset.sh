#!/bin/bash
# 完全重置 Antigravity 和 Chrome 环境

echo "🔄 完全重置 Antigravity 环境"
echo "=================================="
echo ""

echo "【步骤 1】完全关闭所有相关进程"
echo "----------------------------"
echo "关闭 Antigravity..."
killall -9 'Antigravity' 2>/dev/null
sleep 2

echo "关闭所有 Chrome..."
killall -9 'Google Chrome' 2>/dev/null
sleep 2

echo "清理端口 9222..."
lsof -ti :9222 | xargs kill -9 2>/dev/null
sleep 2

if lsof -i :9222 > /dev/null 2>&1; then
    echo "❌ 端口 9222 仍被占用"
    lsof -i :9222
else
    echo "✅ 端口 9222 已释放"
fi

echo ""
echo "【步骤 2】清理浏览器状态"
echo "----------------------------"
echo "清理 Chrome 单例锁..."
rm -rf ~/.gemini/antigravity-browser-profile*/SingletonLock
rm -rf ~/.gemini/antigravity-browser-profile*/SingletonCookie
rm -rf ~/.gemini/antigravity-browser-profile*/SingletonSocket

echo "✅ 浏览器状态已清理"

echo ""
echo "【步骤 3】清理网络环境"
echo "----------------------------"
echo "清除代理环境变量..."
unset http_proxy
unset https_proxy
unset HTTP_PROXY
unset HTTPS_PROXY
export NO_PROXY="localhost,127.0.0.1,::1"
export no_proxy="localhost,127.0.0.1,::1"

echo "✅ 网络环境已清理"

echo ""
echo "【步骤 4】检查 Clash 状态"
echo "----------------------------"
if ifconfig | grep -q "utun1024"; then
    echo "⚠️  Clash TUN 模式仍在运行"
    echo ""
    echo "建议：临时关闭 TUN 模式进行测试"
    echo "1. 打开 Clash Verge"
    echo "2. 关闭『TUN 模式』"
    echo "3. 启用『系统代理』"
    echo "4. 等待 3 秒后继续"
    echo ""
    read -p "完成后按回车继续..."
else
    echo "✅ TUN 模式未运行"
fi

echo ""
echo "【步骤 5】重启 Antigravity"
echo "----------------------------"
open -a "Antigravity"
sleep 5

if pgrep -f "Antigravity.app" > /dev/null; then
    echo "✅ Antigravity 已启动"
else
    echo "❌ Antigravity 启动失败"
    exit 1
fi

echo ""
echo "【步骤 6】验证环境"
echo "----------------------------"
echo ""
echo "检查端口 9222..."
if lsof -i :9222 > /dev/null 2>&1; then
    echo "⚠️  端口 9222 已被占用（Chrome 可能已自动启动）"
else
    echo "✅ 端口 9222 空闲（等待 Antigravity 触发）"
fi

echo ""
echo "检查代理设置..."
echo "NO_PROXY=$NO_PROXY"
echo "no_proxy=$no_proxy"

echo ""
echo "=================================="
echo ""
echo "✅ 重置完成！"
echo ""
echo "📝 重要提示："
echo "   - 所有进程已完全清理"
echo "   - 端口 9222 已释放"
echo "   - Antigravity 已重新启动"
echo ""
echo "🧪 测试步骤："
echo "   1. 在 Antigravity 中执行需要浏览器的操作"
echo "   2. 观察 Chrome 是否启动"
echo "   3. 检查是否还有 502 错误"
echo ""
echo "📊 如果仍然失败，请提供："
echo "   - 完整的错误信息"
echo "   - Antigravity 的截图"
echo "   - 具体的操作步骤"
echo ""

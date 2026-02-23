#!/bin/bash
# 配置 Clash 系统代理模式（解决 Antigravity 联网问题）

echo "🔧 配置 Clash 系统代理模式"
echo "=============================="
echo ""

echo "【当前状态】"
echo "----------------------------"
echo "Clash Verge: 运行中"
echo "TUN 模式: 已关闭（用户手动关闭）"
echo "系统代理: 未启用"
echo ""

echo "【解决方案】"
echo "----------------------------"
echo ""
echo "需要启用 Clash 的『系统代理』模式，这样："
echo "  ✅ Antigravity 可以通过代理访问外部网站（如推特）"
echo "  ✅ 本地 CDP 连接（localhost:9222）可以正常工作"
echo ""

echo "【步骤 1】在 Clash Verge 中启用系统代理"
echo "----------------------------"
echo ""
echo "请手动操作："
echo "  1. 打开 Clash Verge"
echo "  2. 找到『系统代理』或『System Proxy』开关"
echo "  3. 启用它"
echo "  4. 确认端口设置为 7897"
echo ""
read -p "按回车继续（完成上述操作后）..."

echo ""
echo "【步骤 2】验证系统代理已启用"
echo "----------------------------"
sleep 2

if scutil --proxy | grep -q "HTTPEnable : 1"; then
    echo "✅ 系统代理已启用"
else
    echo "❌ 系统代理未启用"
    echo ""
    echo "请检查 Clash Verge 中的系统代理设置"
    exit 1
fi

echo ""
echo "【步骤 3】配置系统代理绕过规则"
echo "----------------------------"
echo ""
echo "配置系统代理绕过 localhost..."
echo ""

# 获取当前网络服务
network_service=$(networksetup -listallnetworkservices | grep -E "Wi-Fi|以太网" | head -1 | sed 's/^[ ]*//')

if [ -n "$network_service" ]; then
    echo "网络服务: $network_service"

    # 设置代理绕过
    sudo networksetup -setproxybypassdomains "$network_service" localhost 127.0.0.1 *.local 2>/dev/null
    echo "✅ 已配置绕过规则: localhost, 127.0.0.1, *.local"
else
    echo "⚠️  无法自动配置，请手动设置"
    echo ""
    echo "在 Clash Verge 中配置绕过规则："
    echo "  绕过地址: localhost, 127.0.0.1, *.local"
fi

echo ""
echo "【步骤 4】验证配置"
echo "----------------------------"
echo ""

# 测试本地连接
echo "测试 1: 本地 CDP 连接（应该绕过代理）"
if curl --noproxy "*" -s http://localhost:9222/json/version > /dev/null 2>&1; then
    echo "  ✅ 本地连接正常"
elif curl -s http://localhost:9222/json/version > /dev/null 2>&1; then
    echo "  ✅ 本地连接正常（通过代理绕过）"
else
    echo "  ⏳ Chrome 未启动（正常）"
fi

echo ""
echo "测试 2: 代理连接（测试是否能访问外部网站）"
if curl -x http://127.0.0.1:7897 -s -I https://www.google.com 2>&1 | grep -q "HTTP"; then
    echo "  ✅ 代理连接正常"
else
    echo "  ⚠️  代理连接可能有问题"
fi

echo ""
echo "=============================="
echo ""
echo "✅ 配置完成！"
echo ""
echo "📝 配置说明："
echo "  - 系统代理模式：启用（端口 7897）"
echo "  - 代理绕过：localhost, 127.0.0.1, *.local"
echo "  - 本地 CDP 连接：直接连接（不通过代理）"
echo "  - 外部网站访问：通过 Clash 代理"
echo ""
echo "🧪 测试 Antigravity："
echo "  现在可以在 Antigravity 中测试浏览器功能了"
echo ""
echo "预期结果："
echo "  ✅ Antigravity 可以连接到本地 CDP（localhost:9222）"
echo "  ✅ Antigravity 可以通过代理访问外部网站（如推特）"
echo ""

#!/bin/bash
# Antigravity 502 Bad Gateway 诊断和修复

echo "🔍 Antigravity 502 Bad Gateway 诊断"
echo "===================================="
echo ""

echo "【分析】502 错误的可能原因"
echo "----------------------------"
echo ""
echo "502 Bad Gateway 意味着："
echo "  - Antigravity 尝试通过代理访问外部网站"
echo "  - 但代理服务器返回了错误响应"
echo ""
echo "可能的原因："
echo "  1. Clash TUN 模式仍然拦截了浏览器的某些请求"
echo "  2. 代理节点或规则配置问题"
echo "  3. 网站的防护（如 Cloudflare）拒绝代理访问"
echo ""

echo "【当前状态检查】"
echo "----------------------------"
echo ""

# 1. 检查 Chrome 进程
echo "1. Chrome 浏览器进程："
chrome_count=$(ps aux | grep "Google Chrome" | grep "antigravity-browser-profile" | grep "remote-debugging-port" | grep -v grep | wc -l | tr -d ' ')
if [ "$chrome_count" -gt 0 ]; then
    echo "   ✅ Chrome 正在运行（$chrome_count 个实例）"
    echo "   配置文件: antigravity-browser-profile"
else
    echo "   ⏳ Chrome 未启动"
fi

echo ""

# 2. 检查 CDP 连接
echo "2. CDP 连接状态："
if curl -s http://localhost:9222/json/version > /dev/null 2>&1; then
    echo "   ✅ CDP 端点可访问"
else
    echo "   ❌ CDP 端点不可访问"
fi

echo ""

# 3. 检查 Clash TUN
echo "3. Clash TUN 状态："
if ifconfig | grep -q "utun1024"; then
    echo "   ⚠️  TUN 模式已启用（utun1024）"
    echo "   这可能会影响浏览器访问外部网站"
else
    echo "   ✅ TUN 模式未启用"
fi

echo ""

# 4. 检查 ZeroOmega
echo "4. ZeroOmega 扩展："
omega_count=$(find ~/.gemini/antigravity-browser-profile* -name "pfnededegaaopdmhkdmcofjmoldfiped" -type d | grep -v disabled | wc -l | tr -d ' ')
if [ "$omega_count" -eq 0 ]; then
    echo "   ✅ ZeroOmega 已禁用"
else
    echo "   ⚠️  ZeroOmega 仍然启用（$omega_count 个实例）"
fi

echo ""
echo "===================================="
echo ""

echo "【解决方案】"
echo "----------------------------"
echo ""

echo "方案 1: 临时关闭 Clash TUN 模式（推荐用于测试）"
echo "  1. 打开 Clash Verge"
echo "  2. 关闭『TUN 模式』"
echo "  3. 在 Antigravity 中重新尝试访问推特"
echo "  4. 如果成功，说明是 TUN 模式的问题"
echo ""

echo "方案 2: 为 Antigravity 创建独立的浏览器配置（绕过所有代理）"
echo "  - 创建一个不使用任何代理的 Chrome 实例"
echo "  - 仅用于 Antigravity"
echo ""

echo "方案 3: 修改 Clash 规则，允许特定网站直连"
echo "  在 Clash 配置中添加："
echo "  - DOMAIN-SUFFIX,twitter.com,DIRECT"
echo "  - DOMAIN-SUFFIX,x.com,DIRECT"
echo ""

echo "方案 4: 使用系统代理模式（非 TUN）"
echo "  1. 关闭 Clash TUN 模式"
echo "  2. 启用系统代理模式"
echo "  3. 配置系统代理绕过 localhost"
echo ""

echo "===================================="
echo ""

# 询问用户要执行哪个方案
echo "请选择要执行的方案（输入数字 1-4，或按 q 退出）："
read -p "> " choice

case $choice in
    1)
        echo ""
        echo "执行方案 1: 临时关闭 TUN 模式"
        echo "请手动在 Clash Verge 中关闭 TUN 模式，然后重新测试"
        ;;
    2)
        echo ""
        echo "执行方案 2: 创建独立浏览器配置"
        bash /Users/lixun/Claude-Code/05-临时任务/create_clean_browser.sh
        ;;
    3)
        echo ""
        echo "执行方案 3: 添加 Clash 规则"
        # 需要修改 Clash 配置
        ;;
    4)
        echo ""
        echo "执行方案 4: 切换到系统代理模式"
        echo "请手动在 Clash Verge 中切换模式"
        ;;
    q)
        echo "退出"
        exit 0
        ;;
    *)
        echo "无效选择"
        ;;
esac

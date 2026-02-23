#!/bin/bash
# 重启 Clash Verge 使配置生效

echo "🔄 重启 Clash Verge"
echo "===================="
echo ""

echo "【步骤 1】关闭 Clash Verge..."
killall 'Clash Verge' 'verge-mihomo' 2>/dev/null
sleep 2
echo "✅ Clash Verge 已关闭"

echo ""
echo "【步骤 2】等待 2 秒..."
sleep 2

echo ""
echo "【步骤 3】重新启动 Clash Verge..."
open -a "Clash Verge"

echo ""
echo "⏳ 等待 Clash Verge 启动（约 3-5 秒）..."
sleep 5

echo ""
echo "【步骤 4】检查 TUN 接口..."
if ifconfig | grep -q "utun1024"; then
    echo "✅ TUN 接口已启用 (utun1024)"
    tun_ip=$(ifconfig utun1024 | grep "inet " | awk '{print $2}')
    echo "   IP: $tun_ip"
else
    echo "⏳ TUN 接口尚未启用，请手动在 Clash Verge 中启用 TUN 模式"
fi

echo ""
echo "===================="
echo ""
echo "📝 下一步操作："
echo ""
echo "1. 打开 Clash Verge"
echo "2. 确认『TUN 模式』已启用"
echo "3. 如果未启用，点击启用 TUN 模式"
echo ""
echo "4. 然后在 Antigravity 中测试浏览器操作"
echo ""
echo "5. 运行验证："
echo "   bash /Users/lixun/Claude-Code/05-临时任务/verify_fix.sh"
echo ""

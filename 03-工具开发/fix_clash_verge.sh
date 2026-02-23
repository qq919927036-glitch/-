#!/bin/bash
# Clash Verge TUN 模式导致 CDP 400 错误 - 修复脚本

echo "🔧 Clash Verge TUN 模式 - CDP 连接修复"
echo "========================================"
echo ""

echo "【检测】Clash Verge 状态"
echo "----------------------------"

# 检查 Clash 进程
if pgrep -f "Clash Verge" > /dev/null; then
    echo "✅ Clash Verge 正在运行"
    ps aux | grep -i "clash" | grep -v grep | head -3
else
    echo "⚠️  Clash Verge 未运行"
fi

echo ""

# 检查 TUN 接口
if ifconfig | grep -q "utun1024"; then
    echo "⚠️  检测到 TUN 虚拟网卡 (utun1024)"
    echo "   这意味着 Clash Verge 的 TUN 模式已启用"
    echo "   TUN 模式会拦截所有流量，包括 localhost"
    echo ""

    # 获取 TUN 接口详情
    tun_ip=$(ifconfig utun1024 | grep "inet " | awk '{print $2}')
    echo "   TUN IP: $tun_ip"
else
    echo "✅ 未检测到 TUN 接口"
fi

echo ""
echo "========================================"
echo ""
echo "🎯 问题根源："
echo "   Clash Verge 的 TUN 模式在系统层拦截所有网络流量"
echo "   包括 CDP 连接 (localhost:9222)"
echo ""
echo "✅ 解决方案："
echo ""

echo "【方案 1】在 Clash Verge 中配置绕过规则（推荐）"
echo "----------------------------"
echo ""
echo "1. 打开 Clash Verge"
echo "2. 进入『偏好设置』→『TUN 模式』"
echo "3. 找到『绕过』或『排除』规则"
echo "4. 添加以下内容："
echo ""
cat << 'EOF'
   - 127.0.0.1/8
   - localhost
   - 192.168.0.0/16
   - 10.0.0.0/8
   - 172.16.0.0/12
EOF
echo ""
echo "或者使用域名格式："
echo ""
cat << 'EOF'
   - localhost
   - *.local
   - 127.0.0.1
EOF
echo ""

echo "【方案 2】临时关闭 TUN 模式（快速测试）"
echo "----------------------------"
echo ""
echo "1. 打开 Clash Verge"
echo "2. 关闭『TUN 模式』开关"
echo "3. 或关闭『增强模式』"
echo "4. 等待几秒后测试 CDP 连接"
echo ""

echo "【方案 3】使用代理模式（非 TUN）"
echo "----------------------------"
echo ""
echo "1. 打开 Clash Verge"
echo "2. 切换到『规则』或『全局』模式"
echo "3. 不使用 TUN/增强模式"
echo "4. 这样只有代理流量会被接管，localhost 直接连接"
echo ""

echo "【方案 4】为 Antigravity 配置特定规则（进阶）"
echo "----------------------------"
echo ""
echo "在 Clash Verge 的规则配置中添加："
echo ""
cat << 'EOF'
rules:
  # CDP 连接不使用代理
  - IP-CIDR,127.0.0.0/8,DIRECT
  - DOMAIN-SUFFIX,local,DIRECT
  - DOMAIN,localhost,DIRECT
  # 其他规则...
EOF
echo ""

echo "========================================"
echo ""
echo "🧪 测试 CDP 连接"
echo "----------------------------"
echo ""
echo "修改配置后，运行以下命令测试："
echo "  bash /Users/lixun/Claude-Code/05-临时任务/verify_fix.sh"
echo ""
echo "或在 Antigravity 中执行浏览器操作"
echo ""

echo "========================================"
echo ""
echo "📝 技术说明："
echo ""
echo "Clash Verge TUN 模式工作原理："
echo ""
echo "  应用 → 网络请求 → TUN 虚拟网卡 → Clash → 真实网络"
echo "                      ↑"
echo "                 拦截所有流量"
echo "                 包括 localhost!"
echo ""
echo "配置绕过后："
echo ""
echo "  应用 → localhost 请求 → 直接连接（绕过 TUN）✅"
echo "  应用 → 其他请求 → TUN → Clash → 代理 ✅"
echo ""

#!/bin/bash
# 修复 Clash Verge TUN 模式的 route-exclude-address 配置

echo "🔧 修复 Clash Verge TUN 模式配置"
echo "=================================="
echo ""

CONFIG_FILE="$HOME/Library/Application Support/io.github.clash-verge-rev.clash-verge-rev/clash-verge.yaml"

# 备份配置文件
echo "【步骤 1】备份配置文件"
cp "$CONFIG_FILE" "$CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
echo "✅ 已备份到: $CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"

echo ""
echo "【步骤 2】修改 TUN 配置"

# 使用 Python 修改 YAML 文件
python3 << 'PYTHON_SCRIPT'
import yaml
import sys
from pathlib import Path

config_file = Path(sys.argv[1])

try:
    with open(config_file, 'r', encoding='utf-8') as f:
        config = yaml.safe_load(f)

    if 'tun' in config and config['tun']:
        # 修改 route-exclude-address
        config['tun']['route-exclude-address'] = [
            '0.0.0.0/32',          # 保留
            '192.168.0.0/16',     # 局域网
            '10.0.0.0/8',         # 局域网
            '172.16.0.0/12',      # 局域网
            '127.0.0.0/8',        # 本地回环 ⭐ 关键！
            '224.0.0.0/4',        # 组播
            '255.255.255.255/32'  # 广播
        ]

        # 写回文件
        with open(config_file, 'w', encoding='utf-8') as f:
            yaml.dump(config, f, allow_unicode=True, default_flow_style=False, sort_keys=False)

        print("✅ 已添加 TUN 排除地址:")
        for addr in config['tun']['route-exclude-address']:
            print(f"   - {addr}")
    else:
        print("❌ 未找到 TUN 配置")
        sys.exit(1)

except Exception as e:
    print(f"❌ 修改失败: {e}")
    sys.exit(1)
PYTHON_SCRIPT

if [ $? -eq 0 ]; then
    echo ""
    echo "【步骤 3】重启 Clash Verge"
    echo ""
    echo "配置文件已修改，需要重启 Clash Verge 使配置生效。"
    echo ""
    echo "请手动操作："
    echo "  1. 打开 Clash Verge"
    echo "  2. 点击『重启内核』或重新启用『TUN 模式』"
    echo "  3. 或完全退出 Clash Verge 后重新打开"
    echo ""
    echo "重启后运行以下命令验证："
    echo "  bash /Users/lixun/Claude-Code/05-临时任务/verify_fix.sh"
else
    echo ""
    echo "❌ 自动修改失败，请手动修改配置文件："
    echo ""
    echo "文件: $CONFIG_FILE"
    echo ""
    echo "找到 tun 部分，修改为："
    echo ""
    cat << 'EOF'
tun:
  auto-detect-interface: true
  auto-route: true
  device: utun1024
  dns-hijack:
  - any:53
  mtu: 1500
  route-exclude-address:          # ⬅️ 修改这里
  - 0.0.0.0/32
  - 192.168.0.0/16
  - 10.0.0.0/8
  - 172.16.0.0/12
  - 127.0.0.0/8                   # ⭐ 关键：排除本地回环
  - 224.0.0.0/4
  - 255.255.255.255/32
  stack: gvisor
  strict-route: false
  enable: true
EOF
fi

echo ""
echo "=================================="

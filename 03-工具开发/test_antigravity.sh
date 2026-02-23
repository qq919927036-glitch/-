#!/bin/bash
# 测试 Antigravity CDP 是否工作

echo "🧪 测试 Antigravity CDP 修复"
echo "============================="
echo ""

echo "步骤 1: 在 Antigravity 中执行一个需要浏览器的操作"
echo "  例如："
echo "  - 打开一个网页"
echo "  - 执行网页搜索"
echo "  - 使用任何浏览器自动化功能"
echo ""

echo "步骤 2: 等待几秒后，按回车键检查状态..."
read

echo ""
echo "============================="
echo "检查 CDP 端口状态:"
if lsof -i :9222 > /dev/null 2>&1; then
    echo "✅ 端口 9222 正在监听"

    echo ""
    echo "获取浏览器信息:"
    curl -s http://localhost:9222/json/version | python3 -m json.tool

    echo ""
    echo "打开的页面:"
    curl -s http://localhost:9222/json | python3 -c "
import sys, json
pages = json.load(sys.stdin)
for p in pages:
    if p.get('type') == 'page':
        print(f\"  - {p.get('title')}: {p.get('url')}\")
"

    echo ""
    echo "✅ CDP 连接正常！"
    echo "✅ Antigravity 现在应该可以正常接管浏览器了！"
else
    echo "⚠️  端口 9222 未监听"
    echo "   可能的原因："
    echo "   - Antigravity 还没有启动浏览器"
    echo "   - 浏览器已经关闭"
    echo "   - 请在 Antigravity 中执行需要浏览器的操作"
fi

echo ""
echo "============================="

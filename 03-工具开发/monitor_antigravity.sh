#!/bin/bash
# 实时监控 Antigravity 启动 Chrome 时的状态

echo "🔍 实时监控 Antigravity 浏览器启动"
echo "==================================="
echo ""
echo "请现在在 Antigravity 中执行需要浏览器的操作"
echo "（例如：打开某个网站）"
echo ""
echo "脚本将监控 Chrome 的启动并记录详细信息..."
echo ""

while true; do
    # 检查 Chrome 是否启动
    if pgrep -f "Google Chrome.*remote-debugging-port=9222" > /dev/null; then
        echo ""
        echo "==================================="
        echo "🎯 检测到 Chrome 已启动！"
        echo "==================================="
        echo ""

        # 获取进程信息
        echo "【Chrome 进程信息】"
        ps aux | grep "Google Chrome" | grep "remote-debugging-port=9222" | grep -v grep | head -3
        echo ""

        # 等待 2 秒让 CDP 端点就绪
        echo "等待 CDP 端点就绪..."
        sleep 2

        # 测试 CDP 连接
        echo ""
        echo "【CDP 连接测试】"

        # 测试 1: 检查端口
        if lsof -i :9222 > /dev/null 2>&1; then
            echo "✅ 端口 9222 正在监听"
            lsof -i :9222 | grep LISTEN
        else
            echo "❌ 端口 9222 未监听"
        fi

        # 测试 2: HTTP 端点
        echo ""
        echo "测试 HTTP 端点..."
        if curl -s http://localhost:9222/json/version > /dev/null 2>&1; then
            echo "✅ HTTP 端点可访问"

            # 显示浏览器信息
            echo ""
            echo "浏览器信息:"
            curl -s http://localhost:9222/json/version | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(f\"  浏览器: {d.get('Browser')}\")
print(f\"  协议: {d.get('Protocol-Version')}\")
print(f\"  用户代理: {d.get('User-Agent')[:50]}...\")
" 2>/dev/null

            # 显示打开的页面
            echo ""
            echo "打开的页面:"
            curl -s http://localhost:9222/json | python3 -c "
import sys, json
pages = json.load(sys.stdin)
for p in pages:
    if p.get('type') == 'page':
        print(f\"  - {p.get('title')}: {p.get('url')}\")
" 2>/dev/null
        else
            echo "❌ HTTP 端点不可访问"
            echo ""
            echo "尝试诊断..."

            # 检查网络连接
            echo ""
            echo "网络诊断:"

            # 检查 TUN
            if ifconfig | grep -q "utun1024"; then
                echo "  ⚠️  TUN 模式已启用"
            fi

            # 检查代理
            echo "  HTTP_PROXY=$HTTP_PROXY"
            echo "  HTTPS_PROXY=$HTTPS_PROXY"
            echo "  NO_PROXY=$NO_PROXY"

            # 尝试 telnet
            echo ""
            echo "尝试直接连接端口..."
            if command -v nc > /dev/null; then
                timeout 2 nc -z localhost 9222 && echo "  ✅ 端口可连接" || echo "  ❌ 端口不可连接"
            fi
        fi

        echo ""
        echo "==================================="
        echo ""
        echo "监控完成。Antigravity 现在应该能够控制浏览器了。"
        echo ""
        echo "如果仍然遇到 502 错误，请运行："
        echo "  bash /Users/lixun/Claude-Code/05-临时任务/diagnose_502.sh"
        echo ""
        break
    fi

    # 显示等待提示
    echo -ne "."
    sleep 1

    # 每 30 秒换行
    if [ $((SECONDS % 30)) -eq 0 ]; then
        echo ""
        echo "等待中... (已等待 $SECONDS 秒)"
    fi
done

#!/bin/bash
# Antigravity CDP 修复脚本 - 排除代理干扰

echo "============================================================"
echo "Antigravity CDP 修复脚本"
echo "============================================================"

# 1. 显示当前代理设置
echo "\n【当前代理设置】"
echo "HTTP_PROXY: $HTTP_PROXY"
echo "HTTPS_PROXY: $HTTPS_PROXY"
echo "http_proxy: $http_proxy"
echo "https_proxy: $https_proxy"
echo "NO_PROXY: $NO_PROXY"

# 2. 设置 NO_PROXY 环境变量，排除 localhost 和 127.0.0.1
echo "\n【设置 NO_PROXY】"
export NO_PROXY="localhost,127.0.0.1,::1"
export no_proxy="localhost,127.0.0.1,::1"
echo "NO_PROXY: $NO_PROXY"
echo "no_proxy: $no_proxy"

# 3. 测试 CDP 连接（绕过代理）
echo "\n【测试 CDP 连接】"
echo "直接连接（绕过代理）:"
curl --noproxy "*" -s http://localhost:9222/json/version | python3 -m json.tool | head -5

echo "\n通过 NO_PROXY 连接:"
curl -s http://localhost:9222/json/version | python3 -m json.tool | head -5

# 4. 创建启动 Antigravity 的脚本
echo "\n【创建 Antigravity 启动脚本】"
cat > ~/start-antigravity.sh << 'EOF'
#!/bin/bash
# Antigravity 启动脚本 - 带正确的代理设置

# 设置排除 localhost 的代理
export NO_PROXY="localhost,127.0.0.1,::1"
export no_proxy="localhost,127.0.0.1,::1"
# 保留原有的代理设置（如果需要）
export http_proxy=http://127.0.0.1:7897
export https_proxy=http://127.0.0.1:7897
export HTTP_PROXY=http://127.0.0.1:7897
export HTTPS_PROXY=http://127.0.0.1:7897

echo "启动 Antigravity（已配置 NO_PROXY）..."
echo "NO_PROXY=$NO_PROXY"
echo "no_proxy=$no_proxy"

# 启动 Antigravity
open -a "Antigravity"
EOF

chmod +x ~/start-antigravity.sh

echo "\n============================================================"
echo "✅ 修复完成！"
echo "============================================================"

echo "\n📝 问题原因:"
echo "   代理服务器 (127.0.0.1:7897) 干扰了 Antigravity 对"
echo "   localhost:9222 的 CDP 连接，导致 CDP 400 错误。"

echo "\n✅ 解决方案:"
echo "   已设置 NO_PROXY 环境变量，排除 localhost 和 127.0.0.1"

echo "\n📌 下一步操作:"
echo "   1. 关闭 Antigravity"
echo "   2. 运行: ~/start-antigravity.sh"
echo "   3. 测试浏览器自动化功能"

echo "\n💡 永久修复（可选）:"
echo "   将以下内容添加到 ~/.zshrc 或 ~/.bashrc:"
echo ""
echo "   # 排除 localhost 的代理设置"
echo "   export NO_PROXY=\"localhost,127.0.0.1,::1\""
echo "   export no_proxy=\"localhost,127.0.0.1,::1\""
echo ""

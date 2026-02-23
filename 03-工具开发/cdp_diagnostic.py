#!/usr/bin/env python3
"""
CDP 400 错误诊断工具
"""
import subprocess
import requests
import json

print("=" * 70)
print("CDP 400 错误诊断工具")
print("=" * 70)

# 1. 检查 Chrome 进程和启动参数
print("\n【检查 1】Chrome 启动参数")
print("-" * 70)
try:
    result = subprocess.run(['ps', 'aux'], capture_output=True, text=True)
    for line in result.stdout.split('\n'):
        if 'Google Chrome' in line and '--remote-debugging-port' in line:
            print("找到 Chrome 进程:")
            parts = line.split()
            for i, part in enumerate(parts):
                if part.startswith('--'):
                    print(f"  {part}")
            break
    else:
        print("⚠️  未找到使用 --remote-debugging-port 的 Chrome 进程")
except Exception as e:
    print(f"❌ 检查失败: {e}")

# 2. 测试 CDP 端点
print("\n【检查 2】CDP 端点可用性")
print("-" * 70)
try:
    response = requests.get("http://localhost:9222/json/version")
    if response.status_code == 200:
        data = response.json()
        print(f"✅ CDP 端点正常")
        print(f"  浏览器: {data.get('Browser', 'N/A')}")
        print(f"  协议版本: {data.get('Protocol-Version', 'N/A')}")
        ws_url = data.get('webSocketDebuggerUrl', '')
        print(f"  WebSocket: {ws_url}")
    else:
        print(f"❌ CDP 端点返回错误: {response.status_code}")
except Exception as e:
    print(f"❌ 无法连接到 CDP: {e}")

# 3. 检查常见的 CDP 400 错误原因
print("\n【检查 3】常见问题检查")
print("-" * 70)

issues = []
solutions = []

# 检查是否有多个 Chrome 实例
try:
    result = subprocess.run(['ps', 'aux'], capture_output=True, text=True)
    chrome_count = sum(1 for line in result.stdout.split('\n')
                      if 'Google Chrome' in line and 'Chrome Helper' not in line
                      and 'chrome_crashpad_handler' not in line)
    if chrome_count > 1:
        issues.append("检测到多个 Chrome 主进程")
        solutions.append("关闭其他 Chrome 实例，只保留一个使用调试端口的实例")
except:
    pass

# 检查端口冲突
try:
    result = subprocess.run(['lsof', '-i', ':9222'], capture_output=True, text=True)
    listeners = [line for line in result.stdout.split('\n') if 'LISTEN' in line]
    if len(listeners) > 1:
        issues.append("端口 9222 有多个监听进程")
        solutions.append("确保只有一个进程监听 9222 端口")
except:
    pass

# 检查代理设置
import os
if os.environ.get('http_proxy') or os.environ.get('https_proxy'):
    issues.append("检测到代理环境变量")
    solutions.append("CDP 连接可能受代理影响，尝试取消代理设置")

if issues:
    print("⚠️  发现以下问题:")
    for i, issue in enumerate(issues, 1):
        print(f"  {i}. {issue}")
else:
    print("✅ 未发现明显问题")

# 4. 推荐的解决方案
print("\n【解决方案】")
print("-" * 70)

print("\n1. 确保 Chrome 使用正确的启动参数:")
chrome_cmd = """'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' \\
  --remote-debugging-port=9222 \\
  --user-data-dir=/tmp/chrome-debug-profile \\
  --no-first-run \\
  --no-default-browser-check \\
  --disable-features=VizDisplayCompositor"""
print(chrome_cmd)

print("\n2. 如果是工具特定问题:")
print("   • 检查工具的日志文件，查找详细错误信息")
print("   • 确认工具连接的 URL 格式正确")
print("   • 尝试使用 ws://localhost:9222 而非 http://localhost:9222")

print("\n3. 重启相关服务:")
print("   • 关闭所有 Chrome 实例")
print("   • 重新启动带有调试端口的 Chrome")
print("   • 重启你的自动化工具")

print("\n4. 测试连接:")
print("   运行: python3 test_cdp_websocket.py")

# 5. 创建快捷重启脚本
print("\n5. 一键重启脚本:")
restart_script = """#!/bin/bash
# 关闭所有 Chrome 实例
killall 'Google Chrome' 2>/dev/null
sleep 2

# 启动带调试端口的 Chrome
'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' \\
  --remote-debugging-port=9222 \\
  --user-data-dir=/tmp/chrome-debug-profile \\
  --no-first-run \\
  --no-default-browser-check \\
  --disable-features=VizDisplayCompositor &

echo "Chrome 已重启，等待 3 秒..."
sleep 3

# 测试连接
curl -s http://localhost:9222/json/version | python3 -m json.tool
"""

print("\n" + "=" * 70)
print("诊断完成！")
print("=" * 70)

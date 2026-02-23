#!/bin/bash
# Antigravity 日志查看工具

echo "🔍 Antigravity 日志查看"
echo "======================"
echo ""

echo "【方法 1】查看最近的对话日志"
echo "----------------------------"
latest_conversation=$(ls -t "$HOME/.gemini/antigravity/conversations/" 2>/dev/null | head -1)
if [ -n "$latest_conversation" ]; then
    echo "最新对话: $latest_conversation"
    echo ""
    ls -la "$HOME/.gemini/antigravity/conversations/$latest_conversation/"
    echo ""
    echo "查看最近的错误..."
    find "$HOME/.gemini/antigravity/conversations/$latest_conversation/" -type f -name "*.txt" -o -name "*.json" 2>/dev/null | while read file; do
        echo "文件: $file"
        head -20 "$file"
        echo ""
    done
else
    echo "未找到对话日志"
fi

echo ""
echo "【方法 2】查看浏览器录制"
echo "----------------------------"
latest_recording=$(ls -t "$HOME/.gemini/antigravity/browser_recordings/" 2>/dev/null | head -1)
if [ -n "$latest_recording" ]; then
    echo "最新录制: $latest_recording"
    ls -la "$HOME/.gemini/antigravity/browser_recordings/$latest_recording/"
else
    echo "未找到浏览器录制"
fi

echo ""
echo "【方法 3】使用系统日志查看器"
echo "----------------------------"
echo "运行以下命令打开 Console.app:"
echo ""
echo "open -a Console"
echo ""
echo "然后在 Console.app 中搜索 'Antigravity' 或 'browser'"
echo ""

echo "【方法 4】实时监控日志（如果有的话）"
echo "----------------------------"
echo "运行以下命令实时查看系统日志:"
echo ""
echo "log stream --predicate 'process == \"Antigravity\"' --level debug"
echo ""

echo "======================"
echo ""
echo "📝 如果需要查看特定时间段的错误，请提供："
echo "   - 错误发生的时间"
echo "   - 具体的错误信息"
echo "   - 你在 Antigravity 中执行的操作"

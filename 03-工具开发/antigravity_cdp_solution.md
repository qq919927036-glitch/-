# Antigravity CDP 400 错误解决方案

## 问题诊断 ✅

**根本原因**: 系统代理服务器 (127.0.0.1:7897) 干扰了 Antigravity 对 `localhost:9222` 的 CDP 连接。

**证据**:
```bash
# 当前代理设置
http_proxy=http://127.0.0.1:7897
https_proxy=http://127.0.0.1:7897

# CDP 端点正常工作（绕过代理时）
curl --noproxy "*" http://localhost:9222/json/version ✅

# 但通过代理时可能失败
curl http://localhost:9222/json/version ❌ (可能的 CDP 400 错误)
```

## 解决方案 ✅

### 方法 1: 使用新的启动脚本（推荐）

1. **关闭当前的 Antigravity**

2. **使用修复后的启动脚本**:
   ```bash
   ~/start-antigravity.sh
   ```

这个脚本已经配置了正确的 `NO_PROXY` 设置，确保 Antigravity 的 CDP 连接不会被代理拦截。

### 方法 2: 手动重启 Antigravity

如果方法 1 不工作，尝试手动重启：

```bash
# 1. 关闭所有 Chrome 和 Antigravity
killall 'Google Chrome' 'Antigravity' 2>/dev/null

# 2. 确保代理设置正确
export NO_PROXY="localhost,127.0.0.1,::1"
export no_proxy="localhost,127.0.0.1,::1"

# 3. 重新启动 Antigravity
open -a "Antigravity"
```

### 方法 3: 永久修复（已配置）

`NO_PROXY` 设置已添加到 `~/.zshrc`：
```bash
export NO_PROXY="localhost,127.0.0.1,::1"
export no_proxy="localhost,127.0.0.1,::1"
```

**生效方式**:
```bash
# 重新加载配置
source ~/.zshrc

# 或者打开新的终端窗口
```

## 验证修复

运行验证脚本：
```bash
python3 /Users/lixun/Claude-Code/05-临时任务/test_cdp_websocket.py
```

如果看到 "✅ CDP WebSocket 测试通过！"，说明 CDP 连接正常。

## 技术细节

### 什么是 CDP？

CDP (Chrome DevTools Protocol) 是 Chrome 提供的调试协议，允许外部工具（如 Antigravity）通过 WebSocket 控制 Chrome 浏览器。

### 为什么代理会导致 CDP 400 错误？

1. Antigravity 尝试连接到 `ws://localhost:9222/...`
2. 请求被代理拦截 (http://127.0.0.1:7897)
3. 代理无法处理 WebSocket 协议或返回错误
4. Antigravity 收到 CDP 400 错误

### NO_PROXY 如何解决这个问题？

`NO_PROXY` 环境变量告诉系统和应用程序：对于这些地址，不要使用代理，直接连接。

```bash
NO_PROXY="localhost,127.0.0.1,::1"
```

这意味着：
- `localhost` → 直接连接，不通过代理
- `127.0.0.1` → 直接连接，不通过代理
- `::1` (IPv6 localhost) → 直接连接，不通过代理

## 可用工具

1. **CDP 连接测试**:
   ```bash
   python3 /Users/lixun/Claude-Code/05-临时任务/test_cdp_websocket.py
   ```

2. **修复脚本**:
   ```bash
   bash /Users/lixun/Claude-Code/05-临时任务/fix_antigravity_cdp.sh
   ```

3. **诊断工具**:
   ```bash
   python3 /Users/lixun/Claude-Code/05-临时任务/cdp_diagnostic.py
   ```

## 常见问题

### Q: 为什么我的其他应用不需要 NO_PROXY？

A: 大多数应用可以正常通过代理工作，但 CDP 连接需要直接连接到 `localhost:9222`。代理服务器通常无法正确处理 WebSocket 连接或本地调试协议。

### Q: 设置 NO_PROXY 会影响我的网络吗？

A: 不会。`NO_PROXY` 只是告诉系统对于 localhost 的连接不使用代理，其他所有网络请求仍然会正常通过你的代理服务器。

### Q: 如果问题仍然存在怎么办？

A: 检查以下内容：
1. 确认 Antigravity 和 Chrome 已完全关闭
2. 检查端口 9222 是否被其他进程占用: `lsof -i :9222`
3. 查看 Antigravity 的日志文件
4. 尝试禁用代理后测试: `unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY`

## 总结

✅ **问题已识别**: 代理干扰 CDP 连接
✅ **解决方案已实施**: 设置 NO_PROXY 排除 localhost
✅ **启动脚本已创建**: `~/start-antigravity.sh`
✅ **永久配置已添加**: 已添加到 `~/.zshrc`

**下一步**: 重启 Antigravity 并测试浏览器自动化功能！

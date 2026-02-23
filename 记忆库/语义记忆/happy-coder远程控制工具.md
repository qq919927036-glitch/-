# Happy Coder - 手机远程控制 Claude Code

**记录时间**: 2026-02-19

## 工具说明
Happy Coder 是一个手机和 Web 客户端，可以远程控制 Claude Code。让你在手机上也能使用 Claude Code 进行编程。

## 基本信息
- **版本**: 0.13.0
- **安装位置**: /usr/local/lib/node_modules/happy-coder/
- **命令路径**: /usr/local/bin/happy
- **GitHub**: https://github.com/slopus/happy-cli
- **Web App**: https://app.happy.engineering
- **服务器**: https://api.cluster-fluster.com

## 使用方法

### 启动服务
```bash
happy
```
这会：
1. 启动 Claude Code 会话
2. 显示二维码供手机扫描连接
3. 实时共享会话

### 常用命令
```bash
happy              # 启动服务（显示二维码）
happy auth         # 管理认证
happy codex        # 启动 Codex 模式
happy connect      # 存储 API 密钥
happy notify       # 发送推送通知到设备
happy daemon       # 管理后台服务
happy doctor       # 系统诊断和故障排除
```

### 环境变量
```bash
HAPPY_SERVER_URL          # 自定义服务器 URL
HAPPY_WEBAPP_URL          # 自定义 Web App URL
HAPPY_HOME_DIR            # 自定义数据目录（默认 ~/.happy）
HAPPY_DISABLE_CAFFEINATE  # 禁用 macOS 防休眠
HAPPY_EXPERIMENTAL        # 启用实验性功能
```

### 选项参数
```bash
-m, --model <model>              # 指定 Claude 模型（默认：sonnet）
-p, --permission-mode <mode>     # 权限模式：auto/default/plan
--claude-env KEY=VALUE           # 设置 Claude 环境变量
--claude-arg ARG                 # 传递额外参数给 Claude CLI
```

## 系统要求
- Node.js >= 20.0.0
- Claude CLI 已安装并登录

## 使用场景
- 在手机上继续电脑上的编程会话
- 远程监控代码执行
- 随时随地使用 Claude Code

## 数据目录
- Happy 数据: ~/.happy/
- Claude 状态: ~/.local/state/claude/

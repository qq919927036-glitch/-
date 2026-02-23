# Gemini 生图方案对比

## 两种方案

### 方案1: gemini-gen（官方API）

**优势**：
- ✅ 稳定可靠
- ✅ 官方支持
- ✅ 适合生产环境

**劣势**：
- ❌ 需要付费
- ❌ 仅支持生图
- ❌ 需要API密钥

**获取API密钥**：https://makersuite.google.com/app/apikey

**使用**：
```bash
/gemini-gen --prompt "一只可爱的猫" --output cat.png
```

---

### 方案2: baoyu-danger-gemini-web（逆向工程）

**优势**：
- ✅ 完全免费
- ✅ 功能更强大（文本+图片+视觉）
- ✅ 支持多轮对话
- ✅ 支持参考图片

**劣势**：
- ⚠️ 非官方API，可能失效
- ⚠️ 需要浏览器认证
- ⚠️ 稳定性无保证

**使用**：
```bash
# 文本生成
/baoyu-danger-gemini-web "你好，介绍一下自己"

# 图片生成
/baoyu-danger-gemini-web --prompt "一只可爱的猫" --image cat.png

# 视觉输入（参考图片）
/baoyu-danger-gemini-web --prompt "描述这张图片" --reference photo.png

# 多轮对话
/baoyu-danger-gemini-web "记住：42" --session-id session-1
/baoyu-danger-gemini-web "什么数字？" --session-id session-1
```

## 选择建议

| 场景 | 推荐方案 | 原因 |
|------|---------|------|
| 个人使用、免费优先 | baoyu-danger-gemini-web | 免费且功能强大 |
| 生产环境、稳定优先 | gemini-gen | 官方API，稳定可靠 |
| 需要视觉理解 | baoyu-danger-gemini-web | 支持参考图片 |
| 批量生成 | gemini-gen | 速率限制更稳定 |
| 多轮对话 | baoyu-danger-gemini-web | 唯一支持 |

## 在工作流中使用

### image-workflow 配置

修改 `~/.baoyu-skills/.env` 或 `.baoyu-skills/.env`：

```bash
# 使用官方API（默认）
GEMINI_GENERATOR=gemini-gen

# 使用免费逆向API
GEMINI_GENERATOR=baoyu-danger-gemini-web
```

### 直接调用

```bash
# 方案1：官方API
/gemini-gen --prompt "产品图" --output product.png

# 方案2：免费逆向
/baoyu-danger-gemini-web --prompt "产品图" --image product.png
```

## 首次使用 baoyu-danger-gemini-web

首次使用会打开浏览器进行 Google 认证：

```bash
/baoyu-danger-gemini-web --login
```

Cookie 会自动缓存，后续无需再次认证。

## 代理配置（中国大陆）

如果需要代理访问 Google：

```bash
HTTP_PROXY=http://127.0.0.1:7890 HTTPS_PROXY=http://127.0.0.1:7890 \
/baoyu-danger-gemini-web --prompt "测试" --image test.png
```

## 免责声明

baoyu-danger-gemini-web 使用非官方的逆向工程 API：
- 使用风险自负
- 不保证稳定性或可用性
- 可能在无预警情况下失效
- 如检测到滥用可能被限制

首次使用需要确认免责声明。

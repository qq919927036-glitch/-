# 图片处理工作流技能集

完整的图片自动化处理系统，从生成到上传一站式解决。

## 技能列表

### 1. `/mj-gen` - Midjourney 生图
- **功能**：使用 Midjourney 生成图片
- **支持**：API 或浏览器自动化
- **参数**：宽高比、质量、风格化等

### 2. `/gemini-gen` - Gemini 生图
- **功能**：使用 Google Gemini 生成图片
- **支持**：Gemini 2.0 Flash API
- **参数**：宽高比、质量（2k）

### 3. `/remove-bg` - 去背景
- **功能**：自动去除图片背景
- **支持**：remove.bg API 或本地脚本
- **格式**：PNG、JPEG、WebP

### 4. `/add-caption` - 加文字
- **功能**：在图片上添加文字说明
- **支持**：固定位置或 AI 布局
- **样式**：多种预设或自定义

### 5. `/upload-image` - 上传图片
- **功能**：上传图片到网站
- **支持**：API 或浏览器自动化
- **平台**：WordPress、Shopify、自定义 API

### 6. `/image-workflow` - 完整工作流
- **功能**：编排上述所有技能
- **流程**：生成 → 去背景 → 加文字 → 上传
- **支持**：批量处理、自定义配置

## 快速开始

### 环境配置

创建 `~/.baoyu-skills/.env` 文件：

```bash
# Gemini 生图
GOOGLE_API_KEY=your_gemini_api_key

# Midjourney（可选）
MJ_API_KEY=your_mj_api_key

# 去背景（可选，有免费额度）
REMOVEBG_API_KEY=your_removebg_api_key

# 上传（可选）
UPLOAD_API_URL=https://api.example.com/upload
UPLOAD_API_KEY=your_upload_api_key
```

### 基础使用

#### 1. 单独使用各个技能

```bash
# Gemini 生图
/gemini-gen --prompt "一只可爱的猫" --output cat.png

# 去背景
/remove-bg photo.png --output photo-no-bg.png

# 加文字
/add-caption image.png --text "标题" --position bottom --output final.png

# 上传
/upload-image final.png --url https://api.example.com/upload
```

#### 2. 使用完整工作流

```bash
# 生成 → 去背景 → 加文字 → 上传
/image-workflow --prompt "产品照片" \
  --caption "新品上市" \
  --upload-url https://api.example.com/upload

# 仅生成和加文字
/image-workflow --prompt "图标" \
  --caption "APP" \
  --steps generate,caption

# 处理现有图片
/image-workflow --input photo.png \
  --caption "热卖中" \
  --steps caption,upload
```

## 典型应用场景

### 场景1：电商产品图

```bash
/image-workflow \
  --prompt "专业产品摄影，白色背景，影棚灯光" \
  --caption "NEW ARRIVAL" \
  --caption-style bold \
  --steps generate,remove-bg,caption \
  --output ./products/product.png
```

### 场景2：社交媒体配图

```bash
/image-workflow \
  --prompt "美丽风景，日落，山脉" \
  --caption "关注我们！#旅行" \
  --generator mj-gen \
  --ar 16:9 \
  --steps generate,caption \
  --output ./social/post.png
```

### 场景3：批量图标生成

```bash
/image-workflow \
  --prompt "简约图标，扁平设计，不同颜色" \
  --count 10 \
  --steps generate,remove-bg \
  --work-dir ./icons/
```

### 场景4：内容创作素材

```bash
# 生图
/gemini-gen --prompt "春季养生概念图，温暖色调" --output spring.png

# 去背景
/remove-bg spring.png --output spring-no-bg.png

# 加文字
/add-caption spring-no-bg.png --text "春季养生指南" --position bottom --output final.png

# 上传
/upload-image final.png --url https://your-api.com/upload
```

## API 密钥获取

### Google Gemini API
1. 访问 https://makersuite.google.com/app/apikey
2. 创建 API 密钥
3. 添加到 `.env` 文件

### Midjourney API
1. 使用第三方服务（推荐）：
   - GoAPI: https://www.goapi.ai/
   - ImagineAPI: https://www.imagineapi.dev/
2. 获取 API 密钥
3. 添加到 `.env` 文件

### remove.bg API
1. 访问 https://www.remove.bg/api
2. 注册账号（免费 50 次/月）
3. 获取 API 密钥
4. 添加到 `.env` 文件

## 工作流定制

### 创建预设配置

创建 `workflow-presets.json`：

```json
{
  "公众号封面": {
    "steps": ["generate", "caption"],
    "generator": "gemini-gen",
    "ar": "16:9",
    "caption-position": "bottom",
    "caption-style": "elegant"
  },
  "产品图": {
    "steps": ["generate", "remove-bg", "caption"],
    "generator": "gemini-gen",
    "ar": "1:1",
    "caption-position": "bottom",
    "caption-style": "bold"
  }
}
```

使用预设：

```bash
/image-workflow --prompt "主题" --config workflow-presets.json --preset 公众号封面
```

## 批量处理

```bash
# 生成多个变体
/image-workflow \
  --prompt "图标，不同颜色" \
  --count 5 \
  --work-dir ./batch-output/

# 处理目录
/image-workflow \
  --input ./raw-photos/ \
  --caption "已处理" \
  --steps caption,upload
```

## 错误处理

每个步骤都有错误处理机制：

- **生图失败**：自动尝试备用生图引擎
- **去背景失败**：跳过或使用本地方法
- **上传失败**：保存到本地，记录到日志
- **继续执行**：`--continue-on-error` 参数

查看日志：

```bash
cat ./image-workflow/workflow.log
```

## 下一步

1. **配置环境变量**：获取所需的 API 密钥
2. **测试单个技能**：先单独测试每个技能
3. **运行完整工作流**：使用 `/image-workflow`
4. **创建预设**：为常见场景创建配置
5. **批量处理**：提高效率

## 技术支持

如有问题或需要帮助，请：
1. 检查 `.env` 文件配置
2. 查看日志文件 `./image-workflow/workflow.log`
3. 确认 API 密钥有效性
4. 测试网络连接

---

**参考 baoyu-skills 模式创建** 🎨

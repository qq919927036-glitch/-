# 微博第三方工具集

收集GitHub上的微博爬虫和API封装库，用于内容提取。

## 工具列表

### 1. 微博爬虫项目

| 项目 | GitHub | 特点 | 推荐度 |
|------|--------|------|--------|
| weibo-scraper | 搜索 "weibo scraper" | 微博内容爬取 | ⭐⭐⭐⭐⭐ |
| sinaweibo | sinaweibo | 新浪微博 Python SDK | ⭐⭐⭐⭐⭐ |
| weibo-bot | 搜索 "weibo bot" | 自动化工具 | ⭐⭐⭐⭐ |
| weibo-api | 搜索 "weibo api wrapper" | API 封装 | ⭐⭐⭐⭐ |

### 2. Python库

```bash
pip install sinaweibo
pip install weibo-scraper
```

### 3. Node.js 库

```bash
npm install weibo-api
npm install weibo-cheerio
```

## 安装建议

### 方案1：sinaweibo（推荐）

**安装**：
```bash
pip install sinaweibo
```

**特点**：
- 官方维护
- 文档完善
- Python SDK
- 支持OAuth

**基础使用**：
```python
from sinaweibo import WeiboAPI

app = WeiboAPI(app_key, app_secret)
# 获取热搜
trends = app.get_trends()
```

### 方案2：直接用爬虫

```bash
# 安装依赖
pip install requests beautifulsoup4 selenium
```

## 实际应用方案

### 简化方案：使用现成工具

#### 工具1：微博网页版（最简单）

**步骤**：
1. 手动打开微博热搜页面
2. 复制内容
3. 让AI分析整理

**时间成本**：5分钟

#### 工具2：微博API + 封装库

**步骤**：
1. 注册微博开放平台
2. 获取API密钥
3. 使用封装库调用

## 推荐方案

对于你的内容工厂，建议使用**手动 + AI整理**：

```bash
# 工作流
1. 手动浏览微博热搜（2分钟）
2. 截图或复制内容
3. 交给我整理和分析
4. 自动生成内容
```

**优势**：
- ✅ 简单可靠
- ✅ 不违反条款
- ✅ 灵活性高
- ✅ 成本最低

## 快速开始

```bash
# 查看微博热搜
手动打开：https://s.weibo.com/top/summary

# 找到相关内容后告诉我：
"微博热搜有 #谷雨祛湿，帮我对标一下"
```

我会：
1. 分析热搜内容
2. 提取关键信息
3. 生成配套内容
4. 制作小红书图

---

**需要我帮你设置吗？**

A. 安装 sinaweibo（Python SDK）
B. 创建手动工作流指南
C. 测试现有爬虫工具
D. 先用手动版试试

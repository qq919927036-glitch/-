---
name: weibo-scrape
description: 提取微博内容、热搜话题、用户动态。支持关键词搜索、热门内容抓取、KOL内容监控。用于热点追踪、素材收集、趋势分析。
---

# 微博内容提取器

从微博提取热点内容、用户动态、热搜话题等，用于内容创作素材收集和热点追踪。

## 使用方法

```bash
# 提取单条微博
/weibo-scrape https://weibo.com/1234567890/status/123456

# 搜索关键词
/weibo-scrape --search "养生" --count 20

# 获取热搜榜
/weibo-scrape --hot-search

# 提取用户微博
/weibo-scrape --user @用户名 --count 50

# 批量监控
/weibo-scrape --monitor keywords.txt --interval hourly
```

## 选项

| 选项 | 说明 | 默认值 |
|------|------|--------|
| `--url` | 微博链接 | - |
| `--search` | 搜索关键词 | - |
| `--count` | 提取数量 | 10 |
| `--hot-search` | 获取热搜榜 | false |
| `--user` | 微博用户（@用户名） | - |
| `--output` | 输出文件 | weibo-scraped.md |
| `--format` | 输出格式 (json/markdown) | markdown |

## 功能模块

### 1. 热搜监控

```bash
/weibo-scrape --hot-search --实时获取微博热搜榜
```

**输出示例**：
```markdown
# 微博热搜榜 2026-02-23 12:00

1. #春季养生
2. #谷雨祛湿
3. #健康饮食
4. #中老年人保健
...
```

### 2. 关键词搜索

```bash
/weibo-scrape --search "养生" --count 20 --output 养生热搜.md
```

**用途**：
- 发现养生热点
- 挖掘爆款话题
- 分析用户需求

### 3. KOL内容提取

```bash
/weibo-scrape --user @健康养生专家 --count 50 --output KOL内容.md
```

**输出格式**：
```markdown
## 微博：@健康养生专家

### 置顶微博
[内容]

### 最新微博
1. [微博1]
2. [微博2]
...
```

### 4. 话题内容抓取

```bash
/weibo-scrape --topic #养生 --pages 5 --output 话题内容.md
```

**用途**：
- 收集话题下的优质内容
- 学习爆款写法
- 提取素材

## 数据处理

### 去重
自动过滤重复内容

### 排序
按互动量（点赞/评论/转发）排序

### 过滤
- 过滤广告
- 过滤低质量内容
- 过滤敏感词

## 输出格式

### Markdown 格式
```markdown
# [微博用户] - [微博内容]

**链接**: [URL]
**发布时间**: [时间]
**互动**: 赞[X] 评[X] 转[X]

[正文内容]
```

### JSON 格式
```json
{
  "user": "用户名",
  "content": "内容",
  "url": "链接",
  "timestamp": "时间戳",
  "engagement": {
    "likes": 1000,
    "comments": 500,
    "reposts": 200
  }
}
```

## 使用场景

### 内容创作
- 挖掘养生热点
- 收集爆款文案
- 学习表达方式

### 趋势分析
- 监控话题热度
- 追踪热点变化
- 发现内容机会

### 素材收集
- 收集真实案例
- 提取用户故事
- 整理专业观点

## 注意事项

- ⚠️ 遵守微博使用条款
- ⚠️ 仅供参考，不侵犯版权
- ⚠️ 尊重原作者，标注来源
- ⚠️ 不过度请求，避免被限制

## 实现方式

### 方式1：官方 API（如有）
如果有微博开放平台 API，优先使用

### 方式2：网页抓取
使用浏览器自动化（Chrome CDP）

### 方式3：第三方服务
使用微博数据抓取服务

## 脚本执行

```bash
# 主脚本
npx -y bun ${SKILL_DIR}/scripts/main.ts [options]

# 各功能模块
npx -y bun ${SKILL_DIR}/scripts/search.ts [keyword]
npx -y bun ${SKILL_DIR}/scripts/hot-search.ts
npx -y bun ${SKILL_DIR}/scripts/user.ts [username]
```

## 扩展功能

### 与内容工厂结合

```bash
# 1. 抓取微博热搜
/weibo-scrape --hot-search

# 2. 分析热点
# 自动识别养生相关热搜

# 3. 生成内容
/content-factory "#春季养生热搜" --use-trends

# 4. 发布小红书
# 自动生成配套内容
```

### 定时监控

```bash
# 每小时抓取一次热搜
/weibo-scrape --monitor --interval hourly --output trends/

# 每天总结
/weibo-scrape --summarize --daily
```

---

**适用场景**：
- 热点追踪
- 素材收集
- 趋势分析
- 内容灵感

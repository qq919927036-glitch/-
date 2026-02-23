---
name: mj-gen
description: Generate images using Midjourney via API or browser automation. Supports prompts, parameters, and batch generation. Use when user asks to "generate with Midjourney", "MJ image" or "使用 Midjourney".
---

# Midjourney Image Generator

Generate images using Midjourney (API or browser automation).

## Usage

```bash
# Basic usage (API)
/mj-gen --prompt "A beautiful sunset over mountains" --output sunset.png

# With parameters (API)
/mj-gen --prompt "Cute cat" --ar 16:9 --stylize 750 --output cat.png

# Browser automation
/mj-gen --prompt "Dragon in forest" --method browser --output dragon.png

# Batch generation
/mj-gen --prompt "Abstract art" --count 4 --output-dir ./generated/
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--prompt`, `-p` | Image prompt (required) | - |
| `--output`, `-o` | Output image path | mj-{timestamp}.png |
| `--output-dir` | Output directory (batch mode) | ./mj-output/ |
| `--method` | api or browser | api |
| `--ar` | Aspect ratio (1:1, 16:9, 4:3, 3:4) | 1:1 |
| `--stylize`, `-s` | Stylize value (0-1000) | 100 |
| `--quality`, `-q` | Quality (.25, .5, 1) | 1 |
| `--chaos`, `-c` | Chaos value (0-100) | 0 |
| `--count` | Number of images (batch mode) | 1 |
| `--wait` | Wait time for generation (browser) | 60 |

## Method Options

### API Method (Recommended)

Fast, reliable, requires Midjourney API access.

Environment variables:

```bash
# Add to ~/.baoyu-skills/.env or .baoyu-skills/.env
MJ_API_KEY=your_api_key_here
MJ_API_SECRET=your_api_secret_here
```

Or use third-party API services:
- GoAPI: https://www.goapi.ai/
- ImagineAPI: https://www.imagineapi.dev/

### Browser Automation

No API needed, uses Chrome CDP to control Midjourney Discord bot.

**Requirements**:
- Google Chrome installed
- Discord logged in to Midjourney server

**First-time setup**:

```bash
# Run setup wizard
npx -y bun ${SKILL_DIR}/scripts/setup-browser.ts
```

## Parameters

### Aspect Ratio (--ar)

| Ratio | Size | Use Case |
|-------|------|----------|
| 1:1 | 1024x1024 | Square (default) |
| 16:9 | 1920x1080 | Landscape |
| 4:3 | 1536x1152 | Standard photo |
| 3:4 | 1152x1536 | Portrait |
| 21:9 | 2048x872 | Ultra-wide |

### Stylize (--stylize)

| Value | Effect | Use Case |
|-------|--------|----------|
| 0-100 | Minimal | Literal interpretation |
| 100-500 | Balanced | Default (100) |
| 500-750 | High | Artistic |
| 750-1000 | Max | Very stylized |

### Quality (--quality)

| Value | Speed | Detail |
|-------|-------|--------|
| .25 | Fast | Less detail |
| .5 | Medium | Moderate detail |
| 1 | Slow | Most detail |

### Chaos (--chaos)

| Value | Effect | Use Case |
|-------|--------|----------|
| 0-25 | Consistent | Variations of same concept |
| 25-50 | Moderate | Some variety |
| 50-100 | High | Very different results |

## Examples

```bash
# Portrait
/mj-gen --prompt "Professional headshot of a doctor, hospital background, natural lighting" \
  --ar 4:3 --quality 1 --output portrait.png

# Landscape
/mj-gen --prompt "Epic mountain landscape, dramatic sky, golden hour" \
  --ar 16:9 --stylize 750 --output landscape.png

# Artistic
/mj-gen --prompt "Abstract cyberpunk city, neon lights, rain, reflection" \
  --chaos 50 --stylize 800 --output cyberpunk.png

# Batch
/mj-gen --prompt "Floral patterns in different colors" --count 4 --output-dir ./flowers/
```

## Browser Automation Workflow

When using browser method:

1. Opens Chrome with Discord profile
2. Navigates to Midjourney channel
3. Sends `/imagine` command
4. Waits for generation (default 60s)
5. Downloads generated image
6. Saves to output path

**Wait times**:
- Fast mode: ~30s
- Quality 1: ~60s
- Stylize high: ~90s

Adjust `--wait` parameter accordingly.

## Error Handling

| Error | Solution |
|-------|----------|
| Missing API credentials | Set MJ_API_KEY or use browser method |
| Browser not found | Install Chrome or set CHROME_PATH |
| Discord not logged in | Manually login first |
| Generation timeout | Increase --wait time |
| Rate limit | Wait a few seconds, retry |

## Script Execution

```bash
# API method
npx -y bun ${SKILL_DIR}/scripts/api.ts [options]

# Browser method
npx -y bun ${SKILL_DIR}/scripts/browser.ts [options]

# Setup wizard
npx -y bun ${SKILL_DIR}/scripts/setup-browser.ts
```

## Tips

1. **Prompt engineering**: Be specific and detailed
2. **Parameters**: Start with defaults, adjust as needed
3. **Batch generation**: Use `--count` for variations
4. **Browser automation**: Slower but works without API
5. **API method**: Faster and more reliable for production

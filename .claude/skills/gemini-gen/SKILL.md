---
name: gemini-gen
description: Generate images using Google Gemini API. Supports text-to-image with custom prompts, aspect ratios, and quality settings. Use when user asks to "generate image with Gemini", "create image", "make picture" or mentions Gemini.
---

# Gemini Image Generator

Generate images using Google Gemini API (Gemini 2.0 Flash).

## Usage

```bash
# Basic usage
/gemini-gen --prompt "一只可爱的猫" --output cat.png

# Specify aspect ratio
/gemini-gen --prompt "风景图" --output landscape.png --ar 16:9

# High quality (2k resolution)
/gemini-gen --prompt "横幅图" --output banner.png --quality 2k

# Read prompt from file
/gemini-gen --promptfile prompt.txt --output output.png

# Multiple prompts
/gemini-gen --prompt "图1" --output img1.png && \
/gemini-gen --prompt "图2" --output img2.png
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--prompt`, `-p` | Text prompt for image generation | Required |
| `--promptfile` | Read prompt from file | - |
| `--output`, `-o` | Output image path (required) | - |
| `--ar` | Aspect ratio (16:9, 4:3, 1:1, 3:4) | 1:1 |
| `--quality` | Image quality (normal, 2k) | normal |
| `--model` | Model name | gemini-2.0-flash-exp |

## Environment Variables

Required environment variable:

```bash
# Add to ~/.baoyu-skills/.env or .baoyu-skills/.env
GOOGLE_API_KEY=your_api_key_here
```

Get API key: https://makersuite.google.com/app/apikey

## Aspect Ratios

| Ratio | Size | Use Case |
|-------|------|----------|
| 16:9 | 1024x576 | Landscape, banner |
| 4:3 | 1024x768 | Standard photo |
| 1:1 | 1024x1024 | Square (default) |
| 3:4 | 768x1024 | Portrait |
| 9:16 | 576x1024 | Mobile portrait |

## Quality Settings

| Quality | Resolution | Description |
|---------|-----------|-------------|
| normal | 1024x1024 | Standard quality (default) |
| 2k | 2048x2048 | High quality |

## Examples

```bash
# Generate a cat
/gemini-gen --prompt "A cute orange cat sitting on a windowsill, warm sunlight, cozy atmosphere" \
  --output cat.png --ar 4:3

# Generate a landscape
/gemini-gen --prompt "Mountain landscape at sunset, dramatic sky, reflection in lake" \
  --output landscape.png --ar 16:9 --quality 2k

# Generate an icon
/gemini-gen --prompt "Minimalist calendar icon, flat design, blue color" \
  --output icon.png --ar 1:1
```

## Error Handling

| Error | Solution |
|-------|----------|
| Missing GOOGLE_API_KEY | Set environment variable in .env file |
| Invalid API key | Check API key at Google AI Studio |
| Rate limit | Wait a few seconds and retry |
| Unsafe content | Modify prompt to comply with policies |

## Script Execution

```bash
# Agent execution
npx -y bun ${SKILL_DIR}/scripts/main.ts [options]
```

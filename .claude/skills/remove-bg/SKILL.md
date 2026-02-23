---
name: remove-bg
description: Remove background from images using remove.bg API or local script. Supports batch processing, multiple formats, and transparent output. Use when user asks to "remove background", "make transparent", "remove bg" or "去背景".
---

# Background Remover

Remove background from images automatically with professional quality.

## Usage

```bash
# Remove background from single image
/remove-bg input.png --output output.png

# Batch process directory
/remove-bg ./images/ --output-dir ./no-bg/

# Process multiple images
/remove-bg img1.png img2.png img3.png --output-dir ./processed/

# Preview without saving
/remove-bg input.png --preview
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `<input>` | Input image path or directory (required) | - |
| `--output`, `-o` | Output image path (single file only) | auto |
| `--output-dir` | Output directory (batch mode) | ./no-bg/ |
| `--method` | api or local | api |
| `--format` | png, webp | png |
| `--preview` | Show preview only, don't save | false |

## Methods

### API Method (remove.bg)

**Recommended**: Best quality, requires API key.

Environment variable:

```bash
# Add to ~/.baoyu-skills/.env or .baoyu-skills/.env
REMOVEBG_API_KEY=your_api_key_here
```

Get free API key: https://www.remove.bg/api

**Limits**: Free tier 50 credits/month, then $0.20 per image.

### Local Method

Free, unlimited, but lower quality.

Uses rembg library:

```bash
pip install rembg
```

## Supported Formats

| Format | Input | Output |
|--------|-------|--------|
| PNG | ✅ | ✅ (transparent) |
| JPEG | ✅ | ✅ (transparent) |
| WebP | ✅ | ✅ (transparent) |
| BMP | ✅ | - |

## Examples

```bash
# Single image
/remove-bg photo.png --output photo-no-bg.png

# Product photography
/remove-bg product-shot.jpg --output product-isolated.png

# Batch process
/remove-bg ./raw-photos/ --output-dir ./processed/

# Preview result
/remove-bg portrait.png --preview
```

## Best Practices

1. **Input quality**: Use high-resolution images for best results
2. **Simple backgrounds**: Solid colors work best
3. **Lighting**: Even lighting improves edge detection
4. **Subject contrast**: Distinct subject from background

## Error Handling

| Error | Solution |
|-------|----------|
| Missing API key | Set REMOVEBG_API_KEY or use --method local |
| Invalid image | Check file format and integrity |
| Rate limit (API) | Upgrade plan or use local method |
| Low quality (local) | Use API method instead |

## Script Execution

```bash
# API method
npx -y bun ${SKILL_DIR}/scripts/api.ts [options]

# Local method
npx -y bun ${SKILL_DIR}/scripts/local.ts [options]
```

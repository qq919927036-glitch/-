---
name: add-caption
description: Add text captions to images with customizable position, style, and effects. Supports fixed positioning and dynamic layout. Use when user asks to "add text", "add caption", "add label" or "加文字".
---

# Image Caption Adder

Add professional text captions and labels to images.

## Usage

```bash
# Add caption at bottom
/add-caption image.png --text "Spring 2024" --output output.png

# Custom position and style
/add-caption image.png --text "标题" --position top --style bold --output out.png

# Multiple captions
/add-caption image.png \
  --text "主标题" --position top --size 48 \
  --text "副标题" --position bottom --size 24 \
  --output final.png

# Dynamic layout with AI
/add-caption image.png --text "智能标题" --layout auto --output result.png
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `<input>` | Input image path (required) | - |
| `--text` | Caption text (required) | - |
| `--output`, `-o` | Output image path | caption-{input} |
| `--position` | top, bottom, center, top-left, top-right, bottom-left, bottom-right | bottom |
| `--style` | simple, bold, elegant, minimal, custom | simple |
| `--size` | Font size (px) | auto (10% of height) |
| `--color` | Text color (hex or name) | white |
| `--bgcolor` | Background color | rgba(0,0,0,0.5) |
| `--padding` | Padding around text (px) | 20 |
| `--method` | script or api | script |

## Position Options

| Position | Description | Use Case |
|----------|-------------|----------|
| `top` | Top center | Headers, titles |
| `bottom` | Bottom center | Captions, credits |
| `center` | Centered | Overlay text |
| `top-left` | Top left corner | Watermarks |
| `top-right` | Top right corner | Badges |
| `bottom-left` | Bottom left corner | Attribution |
| `bottom-right` | Bottom right corner | Timestamps |

## Style Presets

| Style | Font | Background | Shadow | Use Case |
|-------|------|------------|--------|----------|
| `simple` | Arial, sans-serif | Semi-transparent black | None | General purpose |
| `bold` | Impact, bold | Black | White outline | Headlines |
| `elegant` | Georgia, serif | Gradient | Soft | Fashion, luxury |
| `minimal` | Helvetica, thin | None | Text shadow | Clean design |
| `custom` | Custom settings | Custom | Custom | Full control |

## Method Options

### Script Method (Default)

Uses Python PIL/Pillow:

```bash
pip install Pillow
```

**Pros**: Free, fast, offline
**Cons**: Fixed positioning only

### API Method (Nano Bitmap Pro)

Dynamic AI-powered layout:

```bash
# Add to ~/.baoyu-skills/.env or .baoyu-skills/.env
NANOBITMAP_API_KEY=your_api_key_here
```

**Pros**: Smart positioning, professional design
**Cons**: Requires API key, paid service

## Examples

```bash
# Social media post
/add-caption photo.jpg --text "美好的早晨" --position bottom --style elegant \
  --size 36 --color "#ffffff" --bgcolor "rgba(0,0,0,0.3)" --output social.png

# Product label
/add-caption product.png --text "NEW" --position top-right --style bold \
  --size 48 --color "#ff0000" --output labeled.png

# Multi-line caption
/add-caption image.jpg --text "第一行\n第二行" --position center --style minimal \
  --output centered.png

# Watermark
/add-caption photo.png --text "© 2024" --position bottom-right \
  --size 14 --color "rgba(255,255,255,0.5)" --output watermarked.png
```

## Colors

Supports hex codes, RGB, RGBA, and color names:

```bash
# Hex
--color "#ff0000"
--bgcolor "rgba(0,0,0,0.5)"

# Names
--color "white"
--bgcolor "black"

# RGB
--color "rgb(255,0,0)"
--bgcolor "rgba(0,0,0,0.7)"
```

## Multi-Caption Workflow

For multiple captions, chain commands:

```bash
# Add title, subtitle, and watermark
/add-caption base.png --text "主标题" --position top --size 48 --output step1.png && \
/add-caption step1.png --text "副标题" --position center --size 24 --output step2.png && \
/add-caption step2.png --text "© 2024" --position bottom-right --size 12 --output final.png
```

## Script Execution

```bash
# Script method
npx -y bun ${SKILL_DIR}/scripts/script.ts [options]

# API method
npx -y bun ${SKILL_DIR}/scripts/api.ts [options]
```

## Tips

1. **Font sizing**: Auto size is 10% of image height
2. **Contrast**: Use semi-transparent background for readability
3. **Position**: Keep text away from image edges (padding)
4. **Multi-line**: Use `\n` for line breaks in script method

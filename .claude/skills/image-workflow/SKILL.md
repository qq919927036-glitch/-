---
name: image-workflow
description: Complete automated image processing workflow. Orchestrates generation, background removal, caption addition, and upload. Use when user asks to "process image", "complete workflow" or "完整流程".
---

# Image Processing Workflow

Complete automated image processing pipeline from generation to upload.

## Usage

```bash
# Complete workflow (generate → remove bg → add caption → upload)
/image-workflow --prompt "Product on white background" \
  --caption "New Product 2024" \
  --upload-url https://api.example.com/upload

# Skip generation (use existing image)
/image-workflow --input product.png --caption "For Sale" --upload

# Custom workflow steps
/image-workflow --prompt "Cute mascot" --steps generate,caption

# Batch processing
/image-workflow --prompt "Icon set" --count 4 --batch
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--prompt`, `-p` | Image generation prompt | - |
| `--input`, `-i` | Input image (skip generation) | - |
| `--caption`, `-c` | Text caption to add | - |
| `--upload-url` | Upload API URL | - |
| `--steps` | Workflow steps (comma-separated) | all |
| `--output`, `-o` | Final output path | auto |
| `--work-dir` | Working directory | ./image-workflow/ |
| `--count` | Number of images (batch mode) | 1 |
| `--config` | Workflow configuration file | - |

## Workflow Steps

### Available Steps

| Step | Description | Skill Used |
|------|-------------|------------|
| `generate` | Generate image with MJ or Gemini | mj-gen, gemini-gen |
| `remove-bg` | Remove background | remove-bg |
| `caption` | Add text caption | add-caption |
| `upload` | Upload to website | upload-image |
| `all` | Execute all steps | - |

### Default Workflow (all)

```
generate → remove-bg → caption → upload
```

### Example Workflows

```bash
# Full pipeline
/image-workflow --prompt "Product photo" --caption "NEW" --upload-url URL

# Generation and caption only
/image-workflow --prompt "Icon" --caption "APP" --steps generate,caption

# Process existing image
/image-workflow --input photo.png --caption "For Sale" --steps caption,upload

# Generate and upload only
/image-workflow --prompt "Artwork" --upload-url URL --steps generate,upload
```

## Configuration File

Create workflow presets with JSON config:

**workflow-presets.json**:

```json
{
  "product-photo": {
    "steps": ["generate", "remove-bg", "caption", "upload"],
    "generator": "gemini-gen",
    "ar": "1:1",
    "caption-position": "bottom",
    "caption-style": "bold"
  },
  "social-media": {
    "steps": ["generate", "caption"],
    "generator": "mj-gen",
    "ar": "16:9",
    "caption-position": "center",
    "caption-style": "elegant"
  },
  "icon-set": {
    "steps": ["generate", "remove-bg"],
    "generator": "gemini-gen",
    "ar": "1:1",
    "count": 10
  }
}
```

Usage:

```bash
/image-workflow --prompt "Product" --config workflow-presets.json --preset product-photo
```

## Step-by-Step Execution

### Step 1: Generate

```bash
# Uses mj-gen or gemini-gen
npx -y bun ${SKILL_DIR}/scripts/steps/generate.ts \
  --prompt "Product on white background" \
  --generator gemini-gen \
  --ar 1:1 \
  --output ./image-workflow/01-generated.png
```

### Step 2: Remove Background

```bash
# Uses remove-bg
npx -y bun ${SKILL_DIR}/scripts/steps/remove-bg.ts \
  --input ./image-workflow/01-generated.png \
  --output ./image-workflow/02-no-bg.png
```

### Step 3: Add Caption

```bash
# Uses add-caption
npx -y bun ${SKILL_DIR}/scripts/steps/caption.ts \
  --input ./image-workflow/02-no-bg.png \
  --text "NEW PRODUCT 2024" \
  --position bottom \
  --style bold \
  --output ./image-workflow/03-caption.png
```

### Step 4: Upload

```bash
# Uses upload-image
npx -y bun ${SKILL_DIR}/scripts/steps/upload.ts \
  --input ./image-workflow/03-caption.png \
  --url https://api.example.com/upload \
  --save-url ./image-workflow/final-url.txt
```

## Batch Processing

```bash
# Generate multiple images
/image-workflow --prompt "Icon set, different colors" \
  --count 4 \
  --steps generate,remove-bg \
  --work-dir ./icons-batch/

# With custom naming
/image-workflow --prompt "Product variants" \
  --count 3 \
  --naming-pattern "product-{index:02d}-{color}" \
  --work-dir ./products/
```

Output:

```
./icons-batch/
├── 01-generated/
│   ├── icon-01.png
│   ├── icon-02.png
│   ├── icon-03.png
│   └── icon-04.png
├── 02-no-bg/
│   ├── icon-01.png
│   ├── icon-02.png
│   ├── icon-03.png
│   └── icon-04.png
└── final/
    ├── icon-01.png
    ├── icon-02.png
    ├── icon-03.png
    └── icon-04.png
```

## Error Handling

Each step has built-in error handling:

| Step | Error | Action |
|------|-------|--------|
| generate | API failure | Retry with alternative generator |
| remove-bg | Invalid image | Skip or use alternative method |
| caption | Missing text | Use default caption |
| upload | Network error | Save locally, retry later |

**Continue on error**:

```bash
/image-workflow --prompt "Test" --continue-on-error
```

**Log file**:

```
./image-workflow/workflow.log
```

## Environment Variables

Required for all skills:

```bash
# ~/.baoyu-skills/.env or .baoyu-skills/.env

# Generation
GOOGLE_API_KEY=your_gemini_key
MJ_API_KEY=your_mj_key

# Background removal
REMOVEBG_API_KEY=your_removebg_key

# Upload
UPLOAD_API_KEY=your_upload_key
UPLOAD_API_URL=https://api.example.com/upload
```

## Examples

### Product Photo Workflow

```bash
/image-workflow \
  --prompt "Professional product photo, white background, studio lighting" \
  --caption "NEW ARRIVAL" \
  --caption-position bottom \
  --caption-style bold \
  --steps generate,remove-bg,caption \
  --output ./products/new-product.png
```

### Social Media Post

```bash
/image-workflow \
  --prompt "Beautiful landscape, golden hour, mountains" \
  --caption "Visit us today! #travel" \
  --generator mj-gen \
  --ar 16:9 \
  --steps generate,caption \
  --output ./social/post.png
```

### Icon Generation

```bash
/image-workflow \
  --prompt "Minimalist calendar icon, flat design, blue" \
  --count 5 \
  --steps generate,remove-bg \
  --work-dir ./icons/
```

### Complete E-commerce Pipeline

```bash
/image-workflow \
  --prompt "Product photography, professional studio lighting" \
  --caption "NOW ON SALE" \
  --upload-url https://api.mystore.com/upload \
  --steps all \
  --save-url ./products/urls.txt
```

## Script Execution

```bash
# Main workflow
npx -y bun ${SKILL_DIR}/scripts/main.ts [options]

# Individual step
npx -y bun ${SKILL_DIR}/scripts/steps/generate.ts [options]
npx -y bun ${SKILL_DIR}/scripts/steps/remove-bg.ts [options]
npx -y bun ${SKILL_DIR}/scripts/steps/caption.ts [options]
npx -y bun ${SKILL_DIR}/scripts/steps/upload.ts [options]
```

## Best Practices

1. **Start simple**: Test each step individually before running full workflow
2. **Use work-dir**: Keep all intermediate files for debugging
3. **Check logs**: Review workflow.log for errors
4. **Batch processing**: Use --count for multiple images
5. **Configuration**: Create presets for common workflows
6. **Environment**: Set all required API keys in .env file

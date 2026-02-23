---
name: upload-image
description: Upload images to websites via API or browser automation. Supports multiple platforms, batch uploads, and automatic URL extraction. Use when user asks to "upload image", "post to website" or "上传图片".
---

# Image Uploader

Upload images to websites via API or browser automation.

## Usage

```bash
# Upload to custom API
/upload-image image.png --url https://api.example.com/upload --api-key KEY123

# Browser automation
/upload-image photo.jpg --method browser --site https://wordpress.com/

# Batch upload
/upload-image ./images/ --url https://api.example.com/upload

# Extract and save URL
/upload-image img.png --url https://api.example.com/upload --save-url urls.txt
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `<input>` | Input image or directory (required) | - |
| `--url` | API endpoint URL | - |
| `--method` | api or browser | api |
| `--site` | Website URL (browser method) | - |
| `--api-key` | API key or token | - |
| `--api-key-header` | Custom header name | Authorization |
| `--field-name` | Form field name | file |
| `--save-url` | Save uploaded URLs to file | - |
| `--output-dir` | Output directory for batch uploads | ./uploaded/ |
| `--metadata` | JSON file with metadata | - |

## Method Options

### API Method (Recommended)

Fast, reliable, requires API endpoint.

**Custom API**:

```bash
/upload-image photo.png --url https://api.example.com/v1/upload \
  --api-key YOUR_KEY --field-name image
```

**Configuration file** (EXTEND.md):

```yaml
# .baoyu-skills/upload-image/EXTEND.md
default_api_url: https://api.example.com/upload
default_api_key: your_key_here
default_field_name: file
```

### Browser Automation

For websites without API or custom CMS.

**Supported platforms**:
- WordPress (self-hosted)
- Shopify
- Custom CMS (needs configuration)

**First-time setup**:

```bash
# Run setup wizard
npx -y bun ${SKILL_DIR}/scripts/setup-browser.ts
```

**Predefined platforms**:

| Platform | Config File |
|----------|-------------|
| WordPress | references/platforms/wordpress.md |
| Shopify | references/platforms/shopify.md |
| Custom | Create your own config |

## API Authentication

### Bearer Token (Default)

```bash
/upload-image img.png --url https://api.example.com/upload \
  --api-key "Bearer TOKEN123"
```

### Custom Header

```bash
/upload-image img.png --url https://api.example.com/upload \
  --api-key "TOKEN123" --api-key-header "X-API-Key"
```

### Query Parameter

```bash
/upload-image img.png --url https://api.example.com/upload?api_key=TOKEN123
```

## Batch Upload

```bash
# Upload directory
/upload-image ./photos/ --url https://api.example.com/upload \
  --output-dir ./uploaded/

# With URL extraction
/upload-image ./photos/ --url https://api.example.com/upload \
  --save-url uploaded-urls.txt
```

Output format (uploaded-urls.txt):

```
photo1.png -> https://cdn.example.com/abc123.png
photo2.png -> https://cdn.example.com/def456.png
```

## Metadata

Include metadata with upload:

**JSON file** (metadata.json):

```json
{
  "alt": "Description of image",
  "caption": "Image caption",
  "tags": ["tag1", "tag2"],
  "folder": "photos/2024"
}
```

Usage:

```bash
/upload-image photo.png --url https://api.example.com/upload \
  --metadata metadata.json
```

## Browser Automation Workflow

For WordPress example:

1. Opens Chrome
2. Navigates to WordPress admin
3. Goes to Media → Add New
4. Drag & drop or select files
5. Waits for upload completion
6. Extracts file URL
7. Saves to output file

**Configuration** (references/platforms/wordpress.md):

```yaml
login_url: https://yoursite.com/wp-login.php
upload_url: https://yoursite.com/wp-admin/media-new.php
username: your_username
password: your_password
```

## Error Handling

| Error | Solution |
|-------|----------|
| Invalid URL | Check API endpoint URL |
| Authentication failed | Verify API key or credentials |
| File too large | Compress image first |
| Rate limit | Wait and retry |
| Browser automation failed | Check platform config |

## Examples

### WordPress Upload

**API method** (if REST API enabled):

```bash
/upload-image photo.png \
  --url https://yoursite.com/wp-json/wp/v2/media \
  --api-key "Basic BASE64_ENCODED_CREDENTIALS"
```

**Browser method**:

```bash
/upload-image photo.png --method browser --site wordpress \
  --config .baoyu-skills/upload-image/wordpress-config.json
```

### Custom API

```bash
/upload-image product.jpg \
  --url https://api.mysite.com/v1/images/upload \
  --api-key "X-API-KEY: secret123" \
  --field-name "image" \
  --save-url product-urls.txt
```

### Shopify CDN

```bash
/upload-image product.png \
  --url https://shopify.com/admin/api/2024-01/assets.json \
  --api-key "YOUR_SHOPIFY_ADMIN_API_ACCESS_TOKEN"
```

## Script Execution

```bash
# API method
npx -y bun ${SKILL_DIR}/scripts/api.ts [options]

# Browser method
npx -y bun ${SKILL_DIR}/scripts/browser.ts [options]

# Setup wizard
npx -y bun ${SKILL_DIR}/scripts/setup-browser.ts
```

## Best Practices

1. **API first**: Use API method whenever possible
2. **Batch uploads**: Process multiple files in one run
3. **Error handling**: Check return codes and save URLs
4. **Compression**: Compress images before upload for faster uploads
5. **Security**: Don't hardcode API keys, use .env files

---
name: jpocr
description: Japanese OCR via NDLOCR-Lite (National Diet Library). Use when user says '/jpocr', 'OCR this image', '日文OCR', 'recognize Japanese text', or needs to extract text from Japanese documents/screenshots. Best for printed Japanese, experimental handwriting support. Also works for English text.
---

# JPOCR — Japanese OCR (NDLOCR-Lite)

Lightweight Japanese OCR powered by NDLOCR-Lite from Japan's National Diet Library.
Runs locally on CPU (Apple Silicon), no GPU or API key required.

## Strengths

- Printed Japanese (活字): excellent
- Vertical text (縦書き): excellent
- English text: good
- Japanese handwriting (手書き): experimental
- Chinese: not supported (limited charset)

## Commands

| Command | Description |
|---------|-------------|
| `/jpocr <image_path>` | OCR image, return plain text |
| `/jpocr <image_path> --json` | OCR image, return JSON with bounding boxes |
| `/jpocr <dir_path>` | Batch OCR all images in directory |
| `/jpocr <image_path> --viz` | OCR + save visualization with bounding boxes |

## Instructions for Claude Code

### /jpocr <image_path> [flags]

Find `ocr-cli.sh` in the jpocr repo root (wherever this skill is installed from):

```bash
# Default install location — adjust JPOCR_HOME if installed elsewhere
JPOCR_HOME="${JPOCR_HOME:-$HOME/jpocr}"
$JPOCR_HOME/ocr-cli.sh <image_path> [--json] [--viz]
```

Output formats:
- **text** (default): plain text, one line per detected text region
- **json**: structured JSON with `boundingBox`, `text`, `confidence`, `isVertical` per line
- **viz**: saves `viz_<filename>` bounding box overlay to the output directory

### Interpreting JSON output

```json
{
  "contents": [[
    {
      "boundingBox": [[x1,y1],[x1,y2],[x2,y1],[x2,y2]],
      "text": "recognized text",
      "confidence": 0.95,
      "isVertical": "true"
    }
  ]],
  "imginfo": { "img_width": 1920, "img_height": 1080 }
}
```

### Performance

- ~2-3 seconds per image on Apple Silicon (CPU)
- Supported formats: JPG, PNG, TIFF, JP2, BMP

### Tech stack

- Layout detection: DEIMv2 (ONNX)
- Text recognition: PARSeq cascade (30/50/100 char models, ONNX)
- Reading order: xy-cut algorithm
- Charset: ~7000 characters (JIS kanji + kana + ASCII + Greek)

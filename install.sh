#!/usr/bin/env bash
# jpocr installer — sets up venv, dependencies, and Claude Code skill
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$HOME/.claude/skills/jpocr"

echo "=== jpocr installer ==="

# 1. Create venv
if [ ! -d "$SCRIPT_DIR/.venv" ]; then
  echo "[1/4] Creating Python venv..."
  python3 -m venv "$SCRIPT_DIR/.venv"
else
  echo "[1/4] venv already exists, skipping"
fi

# 2. Install dependencies
echo "[2/4] Installing dependencies..."
"$SCRIPT_DIR/.venv/bin/pip" install -q -r "$SCRIPT_DIR/requirements.txt"

# 3. Symlink Claude Code skill
echo "[3/4] Linking Claude Code skill..."
mkdir -p "$SKILL_DIR"
ln -sf "$SCRIPT_DIR/.claude/skills/jpocr/SKILL.md" "$SKILL_DIR/SKILL.md"
echo "  Linked to $SKILL_DIR/SKILL.md"

# 4. Verify
echo "[4/4] Verifying installation..."
if "$SCRIPT_DIR/.venv/bin/python" -c "import onnxruntime; print(f'  onnxruntime {onnxruntime.__version__}')"; then
  echo "=== Installation complete ==="
  echo ""
  echo "Usage:"
  echo "  $SCRIPT_DIR/ocr-cli.sh <image_path>          # plain text"
  echo "  $SCRIPT_DIR/ocr-cli.sh <image_path> --json    # JSON with bounding boxes"
  echo "  $SCRIPT_DIR/ocr-cli.sh <image_path> --viz     # visualization"
  echo ""
  echo "Claude Code: use /jpocr <image_path>"
else
  echo "ERROR: onnxruntime not found. Check requirements.txt"
  exit 1
fi

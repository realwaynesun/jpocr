#!/usr/bin/env bash
# jpocr skill installer
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== jpocr skill installer ==="

# 1. Create venv
if [ ! -d "$SCRIPT_DIR/.venv" ]; then
  echo "[1/3] Creating Python venv..."
  python3 -m venv "$SCRIPT_DIR/.venv"
else
  echo "[1/3] venv already exists, skipping"
fi

# 2. Install dependencies
echo "[2/3] Installing dependencies..."
"$SCRIPT_DIR/.venv/bin/pip" install -q -r "$SCRIPT_DIR/requirements.txt"

# 3. Verify
echo "[3/3] Verifying installation..."
if "$SCRIPT_DIR/.venv/bin/python" -c "import onnxruntime; print(f'  onnxruntime {onnxruntime.__version__}')"; then
  echo ""
  echo "=== Done ==="
  echo ""
  echo "Skill files:"
  echo "  $SCRIPT_DIR/SKILL.md"
  echo "  $SCRIPT_DIR/ocr-cli.sh"
  echo ""
  echo "Point your agent to SKILL.md, or symlink it:"
  echo "  # Claude Code"
  echo "  mkdir -p ~/.claude/skills/jpocr"
  echo "  ln -sf $SCRIPT_DIR/SKILL.md ~/.claude/skills/jpocr/SKILL.md"
  echo ""
  echo "  # Other agents — load SKILL.md however your framework reads skills"
else
  echo "ERROR: onnxruntime not found. Check requirements.txt"
  exit 1
fi

# jpocr — 日本語OCR for Claude Code

[NDLOCR-Lite](https://github.com/ndl-lab/ndlocr-lite)（国立国会図書館）をベースにした日本語OCR CLIツール。
[Claude Code](https://claude.ai/code) スキルとして統合し、ターミナルから直接利用可能。

**GPUは不要** — CPU（Apple Silicon含む）でローカル実行。

> This is a fork of [ndl-lab/ndlocr-lite](https://github.com/ndl-lab/ndlocr-lite) with a CLI wrapper and Claude Code skill integration.

## 特徴

| 対象 | 精度 |
|------|------|
| 活字（印刷日本語） | ◎ |
| 縦書き | ◎ |
| 英語テキスト | ○ |
| 手書き日本語 | △（実験的） |

- 処理速度: Apple Silicon CPUで画像1枚あたり約2〜3秒
- 対応形式: JPG, PNG, TIFF, JP2, BMP
- 文字セット: JIS漢字・かな・ASCII・ギリシャ文字など約7000字

## インストール / Installation

```bash
git clone https://github.com/realwaynesun/jpocr.git
cd jpocr
bash install.sh
```

`install.sh` は以下を実行:
1. Python仮想環境 (`.venv`) を作成
2. 依存パッケージをインストール
3. Claude Codeスキルを `~/.claude/skills/jpocr/` にシンボリックリンク
4. インストールの検証

### 前提条件 / Prerequisites

- Python 3.10+
- macOS / Linux / Windows (WSL)

## 使い方 / Usage

### CLI

```bash
# プレーンテキスト出力
./ocr-cli.sh path/to/image.jpg

# JSON出力（バウンディングボックス付き）
./ocr-cli.sh path/to/image.jpg --json

# ディレクトリ内の全画像を一括処理
./ocr-cli.sh path/to/dir/

# 認識結果の可視化画像を保存
./ocr-cli.sh path/to/image.jpg --viz
```

### Claude Code スキル

Claude Codeのチャットで以下を入力:

```
/jpocr path/to/image.jpg
/jpocr path/to/image.jpg --json
```

## JSON出力フォーマット

```json
{
  "contents": [[
    {
      "boundingBox": [[x1,y1],[x1,y2],[x2,y1],[x2,y2]],
      "text": "認識されたテキスト",
      "confidence": 0.95,
      "isVertical": "true"
    }
  ]],
  "imginfo": { "img_width": 1920, "img_height": 1080 }
}
```

## 技術情報

| モジュール | 手法 |
|-----------|------|
| レイアウト認識 | DEIMv2 (ONNX) |
| 文字列認識 | PARSeq カスケード（30/50/100文字モデル, ONNX） |
| 読み順整序 | xy-cutアルゴリズム |

詳細は[学習及びモデル変換手順](./train/README.md)を参照。

## 環境変数

| 変数 | 説明 | デフォルト |
|------|------|-----------|
| `JPOCR_OUTPUT` | OCR出力先ディレクトリ | `<repo>/output/` |
| `JPOCR_HOME` | jpocrのインストールパス（スキル用） | `$HOME/jpocr` |

## ライセンス / License

本プログラムは国立国会図書館が **CC BY 4.0** ライセンスで公開するものです。

This program is released under the **CC BY 4.0** license by the National Diet Library of Japan.

詳細: [LICENCE](./LICENCE)

## クレジット / Credits

- [NDLOCR-Lite](https://github.com/ndl-lab/ndlocr-lite) — 国立国会図書館 ([NDLラボ](https://lab.ndl.go.jp))
- レイアウト認識: [DEIMv2](https://arxiv.org/abs/2509.20787) (Huang et al., 2025)
- 文字列認識: [PARSeq](https://arxiv.org/abs/2207.06966) (Bautista & Atienza, 2022)

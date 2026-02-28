# jpocr

**AIエージェントに日本語OCR能力を与えるスキル。**

[NDLOCR-Lite](https://github.com/ndl-lab/ndlocr-lite)（国立国会図書館開発）をOCRエンジンとして使用。GPUは不要、CPUのみでローカル実行。

> An AI agent skill that gives your agent Japanese OCR capability. Powered by NDLOCR-Lite from Japan's National Diet Library. Runs locally on CPU — no GPU, no API key.

## スキル導入 / Install the Skill

```bash
git clone https://github.com/realwaynesun/jpocr.git
cd jpocr
bash install.sh
```

`install.sh` はPython venvの作成と依存パッケージのインストールを行います。

### エージェントへの登録

`SKILL.md` をエージェントに読み込ませてください。方法はフレームワークにより異なります:

```bash
# Claude Code — スキルディレクトリにシンボリックリンク
mkdir -p ~/.claude/skills/jpocr
ln -sf "$(pwd)/SKILL.md" ~/.claude/skills/jpocr/SKILL.md

# Cline / Roo Code — .clinerules に追加
cat SKILL.md >> .clinerules

# その他のエージェント — SKILL.md をシステムプロンプトやコンテキストに追加
```

## 仕組み / How it Works

```
ユーザー: 「この画像のテキストを読んで」
    ↓
エージェント: SKILL.md を参照 → ocr-cli.sh を実行
    ↓
ocr-cli.sh: NDLOCR-Lite でOCR処理 → テキスト/JSONを返す
    ↓
エージェント: 結果をユーザーに返す
```

## 対応範囲

| 対象 | 精度 |
|------|------|
| 活字（印刷日本語） | ◎ |
| 縦書き | ◎ |
| 英語テキスト | ○ |
| 手書き日本語 | △（実験的） |

- 処理速度: Apple Silicon CPUで画像1枚あたり約2〜3秒
- 対応形式: JPG, PNG, TIFF, JP2, BMP
- 文字セット: JIS漢字・かな・ASCII・ギリシャ文字など約7000字

## 前提条件

- Python 3.10+
- macOS / Linux / Windows (WSL)

## 技術情報

| モジュール | 手法 |
|-----------|------|
| レイアウト認識 | DEIMv2 (ONNX) |
| 文字列認識 | PARSeq カスケード（30/50/100文字モデル, ONNX） |
| 読み順整序 | xy-cutアルゴリズム |

詳細は[学習及びモデル変換手順](./train/README.md)を参照。

## ライセンス

CC BY 4.0 — 国立国会図書館 ([NDLラボ](https://lab.ndl.go.jp))

詳細: [LICENCE](./LICENCE)

## クレジット

- [NDLOCR-Lite](https://github.com/ndl-lab/ndlocr-lite) — 国立国会図書館
- レイアウト認識: [DEIMv2](https://arxiv.org/abs/2509.20787) (Huang et al., 2025)
- 文字列認識: [PARSeq](https://arxiv.org/abs/2207.06966) (Bautista & Atienza, 2022)

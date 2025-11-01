# OCR PDF Script

A bash script to add searchable text layers to scanned PDFs using OCR (Optical Character Recognition).

## Features

- 🔄 Batch process multiple PDFs in a folder
- 🌍 Multi-language support (Danish, English, German, etc.)
- 🔒 Automatically skips digitally signed PDFs to preserve signatures
- 🗑️ Removes original files after successful OCR (signed files are preserved)
- 📊 Progress tracking and clear error reporting

## Supported Systems

- **Arch Linux**
- **macOS**

## Requirements

- **Tesseract OCR** - The OCR engine
- **ocrmypdf** - Python wrapper for Tesseract
- **Python 3.7+** - Required for ocrmypdf

## Installation

### Arch Linux

```bash
# Install dependencies
sudo pacman -S tesseract tesseract-data-dan python-pipx

# Install ocrmypdf
pipx install ocrmypdf

# Make script executable
chmod +x ocr_pdf.sh
```

### macOS

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install tesseract tesseract-lang

# Install ocrmypdf
pip3 install ocrmypdf

# Make script executable
chmod +x ocr_pdf.sh
```

## Usage

**Process all PDFs in a folder:**
```bash
./ocr_pdf.sh --batch /path/to/your/pdfs/
```

**Process a single PDF:**
```bash
./ocr_pdf.sh input.pdf [output.pdf]
```

## How It Works

1. Scans all PDF files in the specified folder
2. Creates OCR'd versions with "(OCR)" appended to filename
3. Removes original files after successful OCR
4. Skips digitally signed PDFs (preserves signatures)
5. Reports which files were skipped due to signatures

## Output

- **Successfully OCR'd**: `document.pdf` → `document (OCR).pdf` (original removed)
- **Digitally signed**: Original file preserved, no OCR version created
- **Failed processing**: Original file preserved for investigation

## Language Support

The script defaults to **Danish** (`dan`). To use a different language, edit `ocr_pdf.sh` and change `--language dan` to your preferred language:

- English: `eng`
- German: `deu`
- Spanish: `spa`
- French: `fra`
- [See full list](https://tesseract-ocr.github.io/tessdoc/Data-Files-in-different-versions.html)

**Install the corresponding language data:**

```bash
# Arch Linux
sudo pacman -S tesseract-data-<language>

# macOS (included in tesseract-lang package)
```

## Troubleshooting

### "ocrmypdf: command not found"
Make sure `~/.local/bin` is in your PATH:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### "Tesseract not found"
- **Arch Linux**: `sudo pacman -S tesseract`
- **macOS**: `brew install tesseract`

### "Permission denied"
```bash
chmod +x ocr_pdf.sh
```

## Examples

### Batch process financial documents
```bash
./ocr_pdf.sh --batch ~/Documents/finances/
```

### Process a single scanned receipt
```bash
./ocr_pdf.sh receipt.pdf
```

## Technical Details

- Uses **Tesseract OCR** engine for text recognition
- Processes locally on your machine (no internet required after installation)
- OCR layer is added invisibly over original images
- Original image quality is preserved
- Supports deskewing for rotated scans
- Output optimized for file size

## Privacy

All OCR processing happens **100% locally** on your machine. No data is sent to external servers. Your documents remain completely private.

## License

MIT

## Contributing

Issues and pull requests are welcome!

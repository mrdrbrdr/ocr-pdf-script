# OCR PDF Script

So this is a little bash script to add searchable text layers to your PDFs using OCR.
I'm using it at work for financial statements etc. 

## Features

- Batch process multiple PDFs in a folder
- Danish OCR (but has multi-language support for the cosmopolitans out there)
- Re-OCRs PDFs even if they already have text (fixes corrupted text/encoding issues)
- Automatically skips digitally signed PDFs so as to not void signatures
- Removes original files after successful OCR (signed files are preserved)
- Progress tracking in the terminal + clear error reporting

## Supported Systems

- **Arch Linux**
- **macOS**
- **Windows?** You're better than this. Install
  [**Omarchy**](https://github.com/basecamp/omarchy) and when you've joined the promised land we'll pretend this never happened. 
  <iframe src="https://gifer.com/embed/8WK1" width=480 height=261.333 frameBorder="0" allowFullScreen></iframe><p><a href="https://gifer.com">via GIFER</a></p>
  
## Requirements

- **Tesseract OCR** - The OCR engine
- **ocrmypdf** - Python wrapper for Tesseract
- **unpaper** - Image preprocessing tool (for cleaning scans)
- **Python 3.7+** - Required for ocrmypdf

## Installation

### Arch Linux

```bash
# Install dependencies
sudo pacman -S tesseract tesseract-data-dan python-pipx unpaper

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
brew install tesseract tesseract-lang unpaper

# Install ocrmypdf
pip3 install ocrmypdf

# Make script executable
chmod +x ocr_pdf.sh
```

## Usage

**Process all PDFs in a folder:**
```bash
./ocr_pdf.sh --batch "/path/to/your/pdfs/"
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

The script defaults to **Danish** (`dan`). If you wanna use a different language, edit `ocr_pdf.sh` and change `--language dan` to your preferred language. The full list can be found in the link below...
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
- Processes at **300 DPI** for good accuracy on Danish characters (Å, ø, æ)
- **Force re-OCRs all pages** - replaces existing text (even if already present) to fix corrupted text/encoding
- Uses **unpaper** for image cleaning and noise removal
- Processes locally on your machine (no internet required after installation)
- Supports deskewing for rotated scans
- All OCR processing happens **100% locally** on your machine. Your documents remain completely private.

## License

MIT

## Contributing

Issues and pull requests are welcome! <3

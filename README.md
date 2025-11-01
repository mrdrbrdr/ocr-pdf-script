# OCR PDF Script

A simple bash script to add searchable text layers to scanned PDFs using OCR (Optical Character Recognition).

## Features

- Batch process multiple PDFs in a folder
- Danish language support (configurable for other languages)
- Automatically skips digitally signed PDFs to preserve signatures
- Removes original files after successful OCR (signed files are preserved)
- Progress tracking and clear error reporting

## Requirements

- Arch Linux (or any Linux distribution with pacman/pip)
- tesseract-ocr with Danish language data
- ocrmypdf Python package

## Installation

```bash
# Install dependencies
sudo pacman -S tesseract tesseract-data-dan python-pipx

# Install ocrmypdf
pipx install ocrmypdf

# Make script executable
chmod +x ocr_pdf.sh
```

## Usage

### Process all PDFs in a folder:
```bash
./ocr_pdf.sh --batch /path/to/your/pdfs/
```

### Process a single PDF:
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

- Successfully OCR'd: `document.pdf` → `document (OCR).pdf` (original removed)
- Digitally signed: Original file preserved, no OCR version created
- Failed processing: Original file preserved for investigation

## Language Support

To use a different language, modify the `--language` parameter in the script:
- Danish: `dan`
- English: `eng`
- German: `deu`

Install the corresponding tesseract language data package.

## License

MIT

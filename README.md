# OCR PDF Script

A cross-platform script to add searchable text layers to scanned PDFs using OCR (Optical Character Recognition).

## Features

- 🔄 Batch process multiple PDFs in a folder
- 🌍 Multi-language support (Danish, English, German, etc.)
- 🔒 Automatically skips digitally signed PDFs to preserve signatures
- 🗑️ Removes original files after successful OCR (signed files are preserved)
- 📊 Progress tracking and clear error reporting
- 💻 Cross-platform: Linux, macOS, and Windows

## Files

- `ocr_pdf.sh` - Bash script for Linux and macOS
- `ocr_pdf.ps1` - PowerShell script for Windows

## Requirements

### Core Dependencies (All Platforms)
- **Tesseract OCR** - The OCR engine
- **ocrmypdf** - Python wrapper for Tesseract
- **Python 3.7+** - Required for ocrmypdf

## Installation

### Linux (Arch)

```bash
# Install dependencies
sudo pacman -S tesseract tesseract-data-dan python-pipx

# Install ocrmypdf
pipx install ocrmypdf

# Make script executable
chmod +x ocr_pdf.sh
```

### Linux (Ubuntu/Debian)

```bash
# Install dependencies
sudo apt update
sudo apt install tesseract-ocr tesseract-ocr-dan python3-pip

# Install ocrmypdf
pip3 install --user ocrmypdf

# Make script executable
chmod +x ocr_pdf.sh
```

### Linux (Fedora/RHEL)

```bash
# Install dependencies
sudo dnf install tesseract tesseract-langpack-dan python3-pip

# Install ocrmypdf
pip3 install --user ocrmypdf

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

### Windows

1. **Install Python**
   - Download from [python.org](https://www.python.org/downloads/)
   - During installation, check "Add Python to PATH"

2. **Install Tesseract**
   - Download installer from [UB-Mannheim Tesseract](https://github.com/UB-Mannheim/tesseract/wiki)
   - Run installer and note the installation path (e.g., `C:\Program Files\Tesseract-OCR`)
   - Add Tesseract to PATH:
     - Search for "Environment Variables" in Windows
     - Edit "Path" variable
     - Add `C:\Program Files\Tesseract-OCR` (or your installation path)

3. **Install ocrmypdf**
   ```powershell
   pip install ocrmypdf
   ```

## Usage

### Linux/macOS (Bash)

**Process all PDFs in a folder:**
```bash
./ocr_pdf.sh --batch /path/to/your/pdfs/
```

**Process a single PDF:**
```bash
./ocr_pdf.sh input.pdf [output.pdf]
```

### Windows (PowerShell)

**Process all PDFs in a folder:**
```powershell
.\ocr_pdf.ps1 -Mode batch -Directory "C:\path\to\pdfs\"
```

**Process a single PDF:**
```powershell
.\ocr_pdf.ps1 -Mode single -InputFile "input.pdf"
```

**With custom output name:**
```powershell
.\ocr_pdf.ps1 -Mode single -InputFile "input.pdf" -OutputFile "output.pdf"
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

The script defaults to **Danish** (`dan`). To use a different language:

### Linux/macOS
Edit `ocr_pdf.sh` and change `--language dan` to your preferred language:
- English: `eng`
- German: `deu`
- Spanish: `spa`
- French: `fra`
- [See full list](https://tesseract-ocr.github.io/tessdoc/Data-Files-in-different-versions.html)

Install the corresponding language data:
```bash
# Arch Linux
sudo pacman -S tesseract-data-<language>

# Ubuntu/Debian
sudo apt install tesseract-ocr-<language>

# macOS (included in tesseract-lang)
```

### Windows
Edit `ocr_pdf.ps1` and change `--language dan` to your preferred language.

During Tesseract installation, select the languages you need, or download language files manually from [tessdata](https://github.com/tesseract-ocr/tessdata).

## Troubleshooting

### "ocrmypdf: command not found"
- **Linux/macOS**: Make sure `~/.local/bin` is in your PATH
- **Windows**: Reinstall ocrmypdf with `pip install ocrmypdf`

### "Tesseract not found"
- **Linux**: Install tesseract via your package manager
- **macOS**: Install via Homebrew
- **Windows**: Add Tesseract installation directory to PATH

### "Permission denied" (Linux/macOS)
```bash
chmod +x ocr_pdf.sh
```

### Script execution disabled (Windows PowerShell)
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Examples

### Batch process financial documents
```bash
# Linux/macOS
./ocr_pdf.sh --batch ~/Documents/finances/

# Windows
.\ocr_pdf.ps1 -Mode batch -Directory "$HOME\Documents\finances\"
```

### Process a single scanned receipt
```bash
# Linux/macOS
./ocr_pdf.sh receipt.pdf

# Windows
.\ocr_pdf.ps1 -Mode single -InputFile "receipt.pdf"
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

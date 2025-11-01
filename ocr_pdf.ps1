# OCR PDF Script - Windows PowerShell Version
# Adds searchable text layer to scanned PDFs (Danish)
# Created: Oct 31, 2025
# Usage: .\ocr_pdf.ps1 -Mode single -InputFile "input.pdf" [-OutputFile "output.pdf"]
#        .\ocr_pdf.ps1 -Mode batch -Directory "C:\path\to\pdfs\"

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("single", "batch")]
    [string]$Mode = "single",

    [Parameter(Mandatory=$false)]
    [string]$InputFile,

    [Parameter(Mandatory=$false)]
    [string]$OutputFile,

    [Parameter(Mandatory=$false)]
    [string]$Directory
)

# Check if ocrmypdf is installed
$ocrmypdfPath = Get-Command ocrmypdf -ErrorAction SilentlyContinue
if (-not $ocrmypdfPath) {
    Write-Host "Error: ocrmypdf not found!" -ForegroundColor Red
    Write-Host "Please install with: pip install ocrmypdf"
    Write-Host "Also install Tesseract: https://github.com/UB-Mannheim/tesseract/wiki"
    exit 1
}

# Single file processing
if ($Mode -eq "single") {
    if (-not $InputFile) {
        Write-Host "Usage: .\ocr_pdf.ps1 -Mode single -InputFile 'input.pdf' [-OutputFile 'output.pdf']"
        Write-Host "   or: .\ocr_pdf.ps1 -Mode batch -Directory 'C:\path\to\pdfs\'"
        exit 1
    }

    if (-not $OutputFile) {
        $base = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
        $dir = [System.IO.Path]::GetDirectoryName($InputFile)
        $OutputFile = Join-Path $dir "$base (OCR).pdf"
    }

    Write-Host "OCR processing: $InputFile"
    & ocrmypdf --language dan --skip-text --deskew --optimize 1 --invalidate-digital-signatures $InputFile $OutputFile
    Write-Host "✓ Done: $OutputFile" -ForegroundColor Green
}

# Batch processing
elseif ($Mode -eq "batch") {
    if (-not $Directory) {
        $Directory = "."
    }

    Write-Host "Batch OCR processing all PDFs in: $Directory"
    Write-Host ""

    $signedFiles = @()
    $pdfFiles = Get-ChildItem -Path $Directory -Filter "*.pdf"

    foreach ($pdf in $pdfFiles) {
        # Skip files that already have (OCR) in the name
        if ($pdf.Name -match "\(OCR\)") {
            Write-Host "Skipping: $($pdf.Name) (already OCR file)"
            continue
        }

        $base = [System.IO.Path]::GetFileNameWithoutExtension($pdf.FullName)
        $dir = [System.IO.Path]::GetDirectoryName($pdf.FullName)
        $output = Join-Path $dir "$base (OCR).pdf"

        # Remove old OCR file if it exists
        if (Test-Path $output) {
            Write-Host "Removing old OCR version: $(Split-Path $output -Leaf)"
            Remove-Item $output
        }

        Write-Host "Processing: $($pdf.Name)"

        # Try OCR without invalidating signatures
        $errorOutput = & ocrmypdf --language dan --skip-text --deskew --optimize 1 $pdf.FullName $output 2>&1

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Done" -ForegroundColor Green
            # Delete original file after successful OCR
            Remove-Item $pdf.FullName
            Write-Host "  → Removed original file" -ForegroundColor Gray
        }
        else {
            # Check if error is due to digital signature
            if ($errorOutput -match "DigitalSignatureError") {
                Write-Host "⊗ SKIPPED (digitally signed)" -ForegroundColor Yellow
                $signedFiles += $pdf.Name
            }
            else {
                Write-Host "✗ Failed" -ForegroundColor Red
            }
        }
    }

    Write-Host ""
    Write-Host "Batch processing complete!"

    # Display signed files summary if any
    if ($signedFiles.Count -gt 0) {
        Write-Host ""
        Write-Host "=======================================================================" -ForegroundColor Yellow
        Write-Host "  WARNING: The following files were SKIPPED due to digital signatures:" -ForegroundColor Yellow
        Write-Host "=======================================================================" -ForegroundColor Yellow
        foreach ($file in $signedFiles) {
            Write-Host "  • $file" -ForegroundColor Yellow
        }
        Write-Host "=======================================================================" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "These files remain signed and are NOT searchable via OCR."
        Write-Host "Original signed files are preserved without modification."
        Write-Host ""
    }
}

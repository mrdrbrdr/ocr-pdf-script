#!/bin/bash
# OCR PDF Script - Adds searchable text layer to scanned PDFs (Danish)
# Created: Oct 31, 2025
# Usage: ./ocr_pdf.sh input.pdf [output.pdf]
#        ./ocr_pdf.sh --batch /path/to/pdfs/

# Find ocrmypdf location
if command -v ocrmypdf &> /dev/null; then
    OCRMYPDF="ocrmypdf"
elif [ -f "$HOME/.local/bin/ocrmypdf" ]; then
    OCRMYPDF="$HOME/.local/bin/ocrmypdf"
else
    echo "Error: ocrmypdf not found!"
    echo "Please install with: pipx install ocrmypdf"
    exit 1
fi

# Single file processing
if [ "$1" != "--batch" ]; then
    INPUT="$1"
    OUTPUT="${2:-${INPUT%.pdf} (OCR).pdf}"

    if [ -z "$INPUT" ]; then
        echo "Usage: $0 input.pdf [output.pdf]"
        echo "   or: $0 --batch /path/to/pdfs/"
        exit 1
    fi

    echo "OCR processing: $INPUT"
    "$OCRMYPDF" --language dan --image-dpi 600 --clean --skip-text --deskew --invalidate-digital-signatures "$INPUT" "$OUTPUT"
    echo "✓ Done: $OUTPUT"

# Batch processing
else
    DIR="${2:-.}"
    echo "Batch OCR processing all PDFs in: $DIR"
    echo ""

    # Array to track signed files
    SIGNED_FILES=()

    shopt -s nullglob
    for pdf in "$DIR"/*.pdf "$DIR"/*.PDF; do
        if [ -f "$pdf" ]; then
            # Skip files that already have (OCR) in the name
            if [[ "$(basename "$pdf")" == *"(OCR)"* ]]; then
                echo "Skipping: $(basename "$pdf") (already OCR file)"
                continue
            fi

            output="${pdf%.pdf} (OCR).pdf"

            # Remove old OCR file if it exists
            if [ -f "$output" ]; then
                echo "Removing old OCR version: $(basename "$output")"
                rm "$output"
            fi

            echo "Processing: $(basename "$pdf")"

            # Try OCR without invalidating signatures
            ERROR_OUTPUT=$("$OCRMYPDF" --language dan --image-dpi 600 --clean --skip-text --deskew "$pdf" "$output" 2>&1)

            if [ $? -eq 0 ]; then
                echo "✓ Done"
                # Delete original file after successful OCR
                rm "$pdf"
                echo "  → Removed original file"
            else
                # Check if error is due to digital signature
                if echo "$ERROR_OUTPUT" | grep -q "DigitalSignatureError"; then
                    echo "⊗ SKIPPED (digitally signed)"
                    SIGNED_FILES+=("$(basename "$pdf")")
                else
                    echo "✗ Failed"
                fi
            fi
        fi
    done

    echo ""
    echo "Batch processing complete!"

    # Display signed files summary if any
    if [ ${#SIGNED_FILES[@]} -gt 0 ]; then
        echo ""
        echo "======================================================================="
        echo "  WARNING: The following files were SKIPPED due to digital signatures:"
        echo "======================================================================="
        for file in "${SIGNED_FILES[@]}"; do
            echo "  • $file"
        done
        echo "======================================================================="
        echo ""
        echo "These files remain signed and are NOT searchable via OCR."
        echo "Original signed files are preserved without modification."
        echo ""
    fi
fi

# Changelog

All notable changes to this project will be documented in this file.

## [1.3.0] - 2025-11-01

### Changed
- **Reduced DPI from 600 to 300** for faster processing
- **Added visible progress bars** to terminal output showing percentage and time estimates
- Still maintains good accuracy for Danish characters

### Technical Details
- Processing is now approximately 2x faster
- Progress bars show real-time status for each page
- 300 DPI is still sufficient for quality OCR of printed documents

## [1.2.0] - 2025-11-01

### Fixed
- **MAJOR FIX: Danish characters now recognized correctly** (Å, ø, æ)
  - Changed from `--skip-text` to `--force-ocr` to handle PDFs with corrupted embedded text
  - Fixes issue where Å was misread as $, ø as », and æ as {
  - Now properly re-OCRs pages that already contain text

### Technical Details
- Some PDFs have corrupted text already embedded (often from poor initial OCR or encoding issues)
- `--skip-text` was skipping these pages, leaving the corrupted text intact
- `--force-ocr` rasterizes and re-OCRs all pages, replacing corrupted text with accurate OCR
- Requires `unpaper` package for `--clean` flag to work

## [1.1.0] - 2025-10-31

### Changed
- **Improved OCR quality for Danish characters** (Å, ø, æ)
  - Increased image DPI from default to 600 for maximum text recognition accuracy
  - Added `--clean` flag to remove background noise and improve contrast
  - Removed `--optimize` flag to prioritize quality over file size

### Technical Details
- Processing will take longer but produces significantly better results
- Danish special characters should now be recognized correctly instead of being misread as $ or »
- File sizes will be larger due to removal of compression

## [1.0.0] - 2025-10-31

### Added
- Initial release
- Batch PDF OCR processing
- Danish language support
- Digital signature detection and preservation
- Automatic removal of successfully OCR'd original files
- Progress tracking and error reporting
- Support for Arch Linux and macOS

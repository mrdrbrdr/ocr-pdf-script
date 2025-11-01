# Changelog

All notable changes to this project will be documented in this file.

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

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.4] - 2026-03-10

### Added
- `base64ToExtension(String base64Data)` — detect file extension from base64-encoded data using magic bytes
- `base64ToMime(String base64Data)` — detect MIME type from base64-encoded data
- Magic bytes database with 400+ file signatures covering images, audio, video, documents, archives, fonts, executables, and more
- Smart RIFF container detection — differentiates WEBP, AVI, WAV, CDA, QCP, RMI, ANI, CMX, CDR
- Smart ISO BMFF (ftyp) container detection — differentiates MP4, MOV, HEIC, AVIF, M4A, M4V, 3GP, 3G2, HEIF
- Automatic data URI prefix stripping (`data:...;base64,` handled transparently)
- 42 new unit tests for base64 detection (total: 56 tests)
- Missing common file signatures: WASM, JPEG XL, RAR5, ZSTD, LZ4

## [0.0.3] - 2025-11-21

### Changed
- Add example

## [0.0.2] - 2025-11-21

### Changed
- Updated LICENSE to BSD-3-Clause (Flutter Authors)
- Added repository and homepage URLs to pubspec.yaml
- Updated GitHub repository references

## [0.0.1] - 2025-11-21

### Added
- Initial release of mime2extension package
- `extension2Mime(String extension)` function to convert file extensions to MIME types
- `mime2Extension(List<String> mimeTypes)` function to convert MIME types to file extensions
- Wildcard support for MIME type queries (e.g., `application/*` returns all application extensions)
- Comprehensive MIME type database with 6000+ entries from IANA, Apache, and nginx sources
- Support for all major file categories:
  - Application types (836 extensions)
  - Image types (png, jpg, gif, svg, etc.)
  - Audio types (mp3, wav, ogg, etc.)
  - Video types (mp4, avi, mkv, etc.)
  - Text types (txt, html, css, etc.)
  - Font types (ttf, otf, woff, etc.)
- Automatic duplicate removal in results
- Null-safe API with proper error handling
- Comprehensive unit test suite (14 tests)
- Example file demonstrating all features
- Full documentation with usage examples

### Features
- Zero external dependencies (Flutter SDK only)
- Type-safe implementation
- Efficient lookup using Map data structures
- Support for multiple MIME types in a single query
- Combines exact matches and wildcard patterns

[0.0.4]: https://github.com/tidu090/mime2extension/releases/tag/v0.0.4
[0.0.3]: https://github.com/tidu090/mime2extension/releases/tag/v0.0.3
[0.0.2]: https://github.com/tidu090/mime2extension/releases/tag/v0.0.2
[0.0.1]: https://github.com/tidu090/mime2extension/releases/tag/v0.0.1

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[0.0.1]: https://github.com/yourusername/mime2extension/releases/tag/v0.0.1

# mime2extension

A Flutter package for converting between MIME types and file extensions with wildcard support.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features

- 🔄 **Bidirectional conversion** between MIME types and file extensions
- 🌟 **Wildcard support** for querying all extensions of a type (e.g., `application/*`)
- 🔍 **Base64 file detection** — detect file type from base64-encoded data using magic bytes
- 📦 **Comprehensive database** with thousands of MIME type mappings and 400+ file signatures
- 🎯 **Type-safe** with proper null handling
- ✅ **Well-tested** with comprehensive unit tests
- 🚀 **Zero dependencies** (except Flutter SDK)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  mime2extension: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:mime2extension/mime2extension.dart';
```

### Convert extension to MIME type

```dart
// Get MIME type for a known extension
String? mimeType = extension2Mime('pdf');
print(mimeType); // Output: application/pdf

// Handle unknown extensions
String? unknown = extension2Mime('xyz123');
print(unknown); // Output: null
```

### Convert MIME type to extensions

```dart
// Get extensions for a specific MIME type
List<String> pdfExts = mime2Extension(['application/pdf']);
print(pdfExts); // Output: [pdf]

// Get extensions for an image type
List<String> pngExts = mime2Extension(['image/png']);
print(pngExts); // Output: [png]
```

### Use wildcards to get all extensions of a category

```dart
// Get ALL application extensions
List<String> appExts = mime2Extension(['application/*']);
print(appExts.length); // Output: 836 extensions
print(appExts.take(5)); // Output: [ez, appinstaller, aw, appx, appxbundle]

// Get ALL image extensions
List<String> imageExts = mime2Extension(['image/*']);
print(imageExts); // Output: [png, jpg, jpeg, gif, bmp, ...]

// Get ALL audio extensions
List<String> audioExts = mime2Extension(['audio/*']);
print(audioExts); // Output: [mp3, wav, ogg, ...]
```

### Detect file extension from base64 data

```dart
// Detect extension from raw base64 string
String? ext = base64ToExtension('iVBORw0KGgo...');
print(ext); // Output: png

// Also works with data URIs
String? ext2 = base64ToExtension('data:image/png;base64,iVBORw0KGgo...');
print(ext2); // Output: png

// Returns null for unrecognized data
String? unknown = base64ToExtension('AQIDBA==');
print(unknown); // Output: null
```

### Detect MIME type from base64 data

```dart
// Get MIME type directly from base64 data
String? mime = base64ToMime('iVBORw0KGgo...');
print(mime); // Output: image/png

// Works with JPEG
String? jpegMime = base64ToMime('/9j/4AAQ...');
print(jpegMime); // Output: image/jpeg

// Works with data URIs
String? pdfMime = base64ToMime('data:application/octet-stream;base64,JVBERi0...');
print(pdfMime); // Output: application/pdf
```

### Combine multiple MIME types

```dart
// Mix exact MIME types and wildcards
List<String> combined = mime2Extension([
  'application/pdf',
  'image/*',
  'audio/mp3'
]);
// Returns: all image extensions + pdf + mp3
```

## API Reference

### `extension2Mime(String extension)`

Converts a file extension to its corresponding MIME type.

**Parameters:**
- `extension` (String): The file extension without the dot (e.g., `'png'`, `'pdf'`)

**Returns:**
- `String?`: The MIME type, or `null` if not found

**Example:**
```dart
extension2Mime('png');  // Returns: 'image/png'
extension2Mime('pdf');  // Returns: 'application/pdf'
extension2Mime('xyz');  // Returns: null
```

### `base64ToExtension(String base64Data)`

Detects the file extension from base64-encoded binary data by inspecting magic bytes (file signatures).

**Parameters:**
- `base64Data` (String): Raw base64 string or a data URI (e.g., `data:image/png;base64,...`)

**Returns:**
- `String?`: The file extension (without dot), or `null` if not recognized

**Supported container formats with sub-format detection:**
- **RIFF** — differentiates AVI, WAV, WEBP, CDA, QCP, RMI, ANI, CMX, CDR
- **ISO BMFF (ftyp)** — differentiates MP4, MOV, HEIC, AVIF, M4A, M4V, 3GP, 3G2, HEIF

**Example:**
```dart
base64ToExtension('iVBORw0KGgo...');   // Returns: 'png'
base64ToExtension('/9j/4AAQ...');       // Returns: 'jpg'
base64ToExtension('data:...;base64,...'); // Strips data URI prefix automatically
```

### `base64ToMime(String base64Data)`

Detects the MIME type from base64-encoded binary data. Internally calls `base64ToExtension` and then maps the result via the MIME database.

**Parameters:**
- `base64Data` (String): Raw base64 string or a data URI

**Returns:**
- `String?`: The MIME type, or `null` if not recognized

**Example:**
```dart
base64ToMime('iVBORw0KGgo...');  // Returns: 'image/png'
base64ToMime('/9j/4AAQ...');      // Returns: 'image/jpeg'
```

### `mime2Extension(List<String> mimeTypes)`

Converts MIME types to their corresponding file extensions.

**Parameters:**
- `mimeTypes` (List<String>): List of MIME types, supports wildcards (e.g., `'application/*'`)

**Returns:**
- `List<String>`: List of unique file extensions

**Example:**
```dart
mime2Extension(['image/png']);              // Returns: ['png']
mime2Extension(['application/*']);          // Returns: all application extensions
mime2Extension(['image/*', 'audio/mp3']);   // Returns: all image extensions + mp3
```

## Wildcard Patterns

The package supports wildcard patterns in the format `type/*`:

- `application/*` - All application MIME types (836 extensions)
- `image/*` - All image MIME types
- `audio/*` - All audio MIME types
- `video/*` - All video MIME types
- `text/*` - All text MIME types
- And more...

## Examples

### Validate uploaded file type from base64

```dart
bool isImage(String base64Data) {
  final mime = base64ToMime(base64Data);
  return mime?.startsWith('image/') ?? false;
}

Set<String> allowedTypes = {'jpg', 'png', 'gif', 'webp', 'pdf'};

bool isAllowedFile(String base64Data) {
  final ext = base64ToExtension(base64Data);
  return ext != null && allowedTypes.contains(ext);
}
```

### Check if a file is an image

```dart
bool isImageExtension(String ext) {
  final mimeType = extension2Mime(ext);
  return mimeType?.startsWith('image/') ?? false;
}

print(isImageExtension('png'));  // true
print(isImageExtension('pdf'));  // false
```

### Get all supported document extensions

```dart
List<String> documentExts = mime2Extension([
  'application/pdf',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'application/vnd.ms-excel',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
]);
print(documentExts); // [pdf, doc, docx, xls, xlsx]
```

### Filter files by MIME type category

```dart
List<String> getAllowedExtensions() {
  return mime2Extension([
    'image/*',    // All images
    'video/*',    // All videos
    'audio/*',    // All audio
  ]);
}
```

## Database

The package includes two comprehensive databases:

**MIME type database** — sourced from:
- [IANA Media Types](https://www.iana.org/assignments/media-types/media-types.xhtml)
- [Apache mime.types](https://svn.apache.org/repos/asf/httpd/httpd/trunk/docs/conf/mime.types)
- [nginx mime.types](https://github.com/nginx/nginx/blob/master/conf/mime.types)

**Magic bytes database** — 400+ file signatures for detecting file types from binary data, covering:
- Images (PNG, JPEG, GIF, BMP, TIFF, PSD, ICO, WEBP, AVIF, HEIC, and more)
- Audio (MP3, FLAC, OGG, WAV, AAC, M4A, AMR, MIDI, and more)
- Video (MP4, AVI, MKV, WEBM, MOV, FLV, MPG, 3GP, and more)
- Documents (PDF, DOC, RTF, XML, PPT, XLS, and more)
- Archives (ZIP, RAR, 7Z, GZ, BZ2, XZ, TAR, ZSTD, LZ4, and more)
- Fonts (WOFF, WOFF2, TTF, OTF)
- Executables, disk images, database files, and many more

## Testing

The package includes comprehensive unit tests. To run them:

```bash
flutter test
```

All 56 tests cover:
- Extension to MIME conversion
- MIME to extension conversion
- Wildcard pattern matching
- Base64 to extension detection (images, audio, video, documents, archives, fonts)
- Base64 to MIME type detection
- RIFF container sub-format detection (WEBP, AVI, WAV)
- ISO BMFF container brand detection (MP4, HEIC, AVIF, M4A, MOV, 3GP)
- Data URI prefix handling
- Edge cases and error handling
- Integration tests

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.

## Support

If you find this package helpful, please give it a ⭐ on GitHub!

For issues, questions, or suggestions, please [open an issue](https://github.com/tidu090/mime2extension/issues).

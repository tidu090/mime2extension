# mime2extension

A Flutter package for converting between MIME types and file extensions with wildcard support.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features

- 🔄 **Bidirectional conversion** between MIME types and file extensions
- 🌟 **Wildcard support** for querying all extensions of a type (e.g., `application/*`)
- 📦 **Comprehensive database** with thousands of MIME type mappings
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

The package includes a comprehensive database of MIME types sourced from:
- [IANA Media Types](https://www.iana.org/assignments/media-types/media-types.xhtml)
- [Apache mime.types](https://svn.apache.org/repos/asf/httpd/httpd/trunk/docs/conf/mime.types)
- [nginx mime.types](https://github.com/nginx/nginx/blob/master/conf/mime.types)

## Testing

The package includes comprehensive unit tests. To run them:

```bash
flutter test
```

All 14 tests cover:
- Extension to MIME conversion
- MIME to extension conversion
- Wildcard pattern matching
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

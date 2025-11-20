import 'package:flutter/foundation.dart';
import 'package:mime2extension/mime2extension.dart';

void main() {
  // Example 1: Convert extension to MIME type
  final pngMime = extension2Mime('png');
  if (kDebugMode) {
    print('PNG extension -> MIME type: $pngMime');
  }
  // Output: PNG extension -> MIME type: image/png

  final pdfMime = extension2Mime('pdf');
  if (kDebugMode) {
    print('PDF extension -> MIME type: $pdfMime');
  }
  // Output: PDF extension -> MIME type: application/pdf

  // Example 2: Convert MIME type to extensions
  final pngExtensions = mime2Extension(['image/png']);
  if (kDebugMode) {
    print('image/png -> extensions: $pngExtensions');
  }
  // Output: image/png -> extensions: [png]

  // Example 3: Use wildcards to get all extensions for a category
  final imageExtensions = mime2Extension(['image/*']);
  if (kDebugMode) {
    print('image/* -> ${imageExtensions.length} extensions');
    print('First 10 image extensions: ${imageExtensions.take(10).toList()}');
  }
  // Output: image/* -> XX extensions
  // Output: First 10 image extensions: [png, jpg, jpeg, gif, ...]

  // Example 4: Combine multiple MIME types
  final documentExtensions = mime2Extension([
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  ]);
  if (kDebugMode) {
    print('Document extensions: $documentExtensions');
  }
  // Output: Document extensions: [pdf, doc, docx]

  // Example 5: Mix wildcards and specific MIME types
  final mediaExtensions = mime2Extension([
    'image/*',
    'video/*',
    'audio/mp3',
  ]);
  if (kDebugMode) {
    print('Media extensions count: ${mediaExtensions.length}');
  }
  // Output: Media extensions count: XXX

  // Example 6: Handle unknown extensions
  final unknownMime = extension2Mime('xyz123');
  if (kDebugMode) {
    print('Unknown extension -> MIME type: $unknownMime');
  }
  // Output: Unknown extension -> MIME type: null
}

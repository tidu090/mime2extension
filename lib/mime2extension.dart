/// A Flutter package for converting between MIME types and file extensions.
library mime2extension;

import 'src/db.dart';

/// Converts a list of MIME types to their corresponding file extensions.
///
/// Supports wildcard patterns (e.g., 'application/*' returns all application extensions).
/// Returns a list of unique extensions for all matching MIME types.
///
/// Example:
/// ```dart
/// mime2Extension(['image/png']); // Returns ['png']
/// mime2Extension(['application/*']); // Returns all application extensions
/// mime2Extension(['application/*', 'image/png']); // Returns combined list
/// ```
List<String> mime2Extension(List<String> mimeTypes) {
  final Set<String> extensions = {};

  for (final mimeType in mimeTypes) {
    if (mimeType.endsWith('/*')) {
      // Handle wildcard pattern
      final prefix = mimeType.substring(0, mimeType.length - 2);
      
      for (final entry in database.entries) {
        if (entry.key.startsWith(prefix + '/')) {
          final value = entry.value;
          if (value is Map && value.containsKey('extensions')) {
            final exts = value['extensions'];
            if (exts is List) {
              extensions.addAll(exts.cast<String>());
            }
          }
        }
      }
    } else {
      // Handle exact match
      final value = database[mimeType];
      if (value is Map && value.containsKey('extensions')) {
        final exts = value['extensions'];
        if (exts is List) {
          extensions.addAll(exts.cast<String>());
        }
      }
    }
  }

  return extensions.toList();
}

/// Converts a file extension to its corresponding MIME type.
///
/// Returns the MIME type as a String, or null if no match is found.
///
/// Example:
/// ```dart
/// extension2Mime('png'); // Returns 'image/png'
/// extension2Mime('pdf'); // Returns 'application/pdf'
/// extension2Mime('unknown'); // Returns null
/// ```
String? extension2Mime(String extension) {
  for (final entry in database.entries) {
    final value = entry.value;
    if (value is Map && value.containsKey('extensions')) {
      final exts = value['extensions'];
      if (exts is List && exts.contains(extension)) {
        return entry.key;
      }
    }
  }
  return null;
}

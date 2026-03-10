/// A Flutter package for converting between MIME types and file extensions.
library;

import 'dart:convert';
import 'dart:math';

import 'src/db.dart';
import 'src/magic_bytes_db.dart';

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
        if (entry.key.startsWith('$prefix/')) {
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

/// Detects the file extension from base64-encoded data by inspecting magic bytes.
///
/// Accepts raw base64 strings or data URIs (e.g., `data:image/png;base64,...`).
/// Returns the file extension (without dot) or `null` if unrecognized.
///
/// Handles RIFF container formats (AVI, WAV, WEBP) and ISO Base Media File
/// Format containers (MP4, MOV, HEIC, AVIF, M4A) with sub-format detection.
///
/// Example:
/// ```dart
/// base64ToExtension('iVBORw0KGgo...'); // Returns 'png'
/// base64ToExtension('data:image/png;base64,iVBORw0KGgo...'); // Returns 'png'
/// base64ToExtension('/9j/4AAQ...'); // Returns 'jpg'
/// ```
String? base64ToExtension(String base64Data) {
  final bytes = _decodeBase64(base64Data);
  if (bytes == null || bytes.isEmpty) return null;

  // RIFF container: bytes 0-3 = "RIFF", 4-7 = size, 8-11 = sub-format
  if (bytes.length >= 12 && _matchesAt(bytes, 0, _riffHeader)) {
    return _detectRiffFormat(bytes);
  }

  // ISO BMFF container: bytes 0-3 = box size, 4-7 = "ftyp", 8-11 = brand
  if (bytes.length >= 12 && _matchesAt(bytes, 4, _ftypMarker)) {
    return _detectBmffFormat(bytes);
  }

  for (final entry in magicBytesDatabase) {
    if (bytes.length >= entry.signature.length &&
        _matchesAt(bytes, 0, entry.signature)) {
      return entry.ext;
    }
  }

  return null;
}

/// Detects the MIME type from base64-encoded data by inspecting magic bytes.
///
/// Accepts raw base64 strings or data URIs (e.g., `data:image/png;base64,...`).
/// Returns the MIME type string or `null` if unrecognized.
///
/// This first detects the file extension via [base64ToExtension], then looks up
/// the corresponding MIME type using the internal database.
///
/// Example:
/// ```dart
/// base64ToMime('iVBORw0KGgo...'); // Returns 'image/png'
/// base64ToMime('data:image/png;base64,iVBORw0KGgo...'); // Returns 'image/png'
/// base64ToMime('/9j/4AAQ...'); // Returns 'image/jpeg'
/// ```
String? base64ToMime(String base64Data) {
  final ext = base64ToExtension(base64Data);
  if (ext == null) return null;
  return extension2Mime(ext);
}

// ---------------------------------------------------------------------------
// Private helpers for base64 / magic-byte detection
// ---------------------------------------------------------------------------

const _riffHeader = [0x52, 0x49, 0x46, 0x46];
const _ftypMarker = [0x66, 0x74, 0x79, 0x70];

List<int>? _decodeBase64(String input) {
  try {
    var cleaned = input;
    final commaIndex = cleaned.indexOf(',');
    if (commaIndex != -1) {
      cleaned = cleaned.substring(commaIndex + 1);
    }
    cleaned = cleaned.replaceAll(RegExp(r'\s'), '');
    final padLength = (4 - cleaned.length % 4) % 4;
    cleaned += '=' * padLength;
    return base64Decode(cleaned);
  } catch (_) {
    return null;
  }
}

bool _matchesAt(List<int> data, int offset, List<int> pattern) {
  if (data.length < offset + pattern.length) return false;
  for (var i = 0; i < pattern.length; i++) {
    if (data[offset + i] != pattern[i]) return false;
  }
  return true;
}

String _detectRiffFormat(List<int> bytes) {
  // Sub-format identifier sits at offset 8 inside the RIFF container.
  if (_matchesAt(bytes, 8, [0x57, 0x45, 0x42, 0x50])) return 'webp'; // WEBP
  if (_matchesAt(bytes, 8, [0x41, 0x56, 0x49, 0x20])) return 'avi';  // AVI
  if (_matchesAt(bytes, 8, [0x57, 0x41, 0x56, 0x45])) return 'wav';  // WAVE
  if (_matchesAt(bytes, 8, [0x43, 0x44, 0x44, 0x41])) return 'cda';  // CDDA
  if (_matchesAt(bytes, 8, [0x51, 0x4C, 0x43, 0x4D])) return 'qcp';  // QLCM
  if (_matchesAt(bytes, 8, [0x52, 0x4D, 0x49, 0x44])) return 'rmi';  // RMID
  if (_matchesAt(bytes, 8, [0x41, 0x43, 0x4F, 0x4E])) return 'ani';  // ACON
  if (_matchesAt(bytes, 8, [0x43, 0x4D, 0x58, 0x31])) return 'cmx';  // CMX1
  if (_matchesAt(bytes, 8, [0x43, 0x44, 0x52])) return 'cdr';        // CDR
  return 'avi';
}

String _detectBmffFormat(List<int> bytes) {
  if (bytes.length < 12) return 'mp4';
  final brand = String.fromCharCodes(bytes.sublist(8, min(12, bytes.length)));
  switch (brand) {
    case 'avif': return 'avif';
    case 'avis': return 'avif';
    case 'heic': return 'heic';
    case 'heix': return 'heic';
    case 'heim': return 'heic';
    case 'heis': return 'heic';
    case 'hevc': return 'heic';
    case 'mif1': return 'heif';
    case 'msf1': return 'heif';
    case 'M4A ': return 'm4a';
    case 'M4B ': return 'm4a';
    case 'M4V ': return 'm4v';
    case 'qt  ': return 'mov';
    case 'isom': return 'mp4';
    case 'iso2': return 'mp4';
    case 'iso5': return 'mp4';
    case 'iso6': return 'mp4';
    case 'mp41': return 'mp4';
    case 'mp42': return 'mp4';
    case 'mp71': return 'mp4';
    case 'MSNV': return 'mp4';
    case 'dash': return 'mp4';
    case 'NDAS': return 'mp4';
    case '3gp4': return '3gp';
    case '3gp5': return '3gp';
    case '3gp6': return '3gp';
    case '3gp7': return '3gp';
    case '3ge6': return '3gp';
    case '3ge7': return '3gp';
    case '3gg6': return '3gp';
    case '3gs7': return '3gp';
    case '3g2a': return '3g2';
    default: return 'mp4';
  }
}

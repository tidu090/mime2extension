import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mime2extension/mime2extension.dart';

void main() {
  group('extension2Mime', () {
    test('should return correct MIME type for known extensions', () {
      expect(extension2Mime('png'), equals('image/png'));
      expect(extension2Mime('pdf'), equals('application/pdf'));
      expect(extension2Mime('json'), equals('application/json'));
      expect(extension2Mime('xml'), equals('application/xml'));
      expect(extension2Mime('mp4'), equals('application/mp4'));
    });

    test('should return null for unknown extensions', () {
      expect(extension2Mime('unknownext'), isNull);
      expect(extension2Mime('xyz123'), isNull);
      expect(extension2Mime(''), isNull);
    });

    test('should handle various file types', () {
      // Images
      expect(extension2Mime('jpg'), equals('image/jpeg'));
      expect(extension2Mime('gif'), equals('image/gif'));
      
      // Audio
      expect(extension2Mime('mp3'), equals('audio/mp3'));
      expect(extension2Mime('wav'), equals('audio/wav'));
      
      // Video
      expect(extension2Mime('avi'), isNotNull);
      
      // Documents
      expect(extension2Mime('doc'), equals('application/msword'));
      expect(extension2Mime('txt'), isNotNull);
    });
  });

  group('mime2Extension', () {
    test('should return correct extensions for exact MIME types', () {
      final pngExts = mime2Extension(['image/png']);
      expect(pngExts, contains('png'));
      
      final pdfExts = mime2Extension(['application/pdf']);
      expect(pdfExts, contains('pdf'));
      
      final jsonExts = mime2Extension(['application/json']);
      expect(jsonExts, contains('json'));
    });

    test('should return empty list for unknown MIME types', () {
      expect(mime2Extension(['unknown/type']), isEmpty);
      expect(mime2Extension(['fake/mimetype']), isEmpty);
    });

    test('should handle wildcard patterns', () {
      final appExts = mime2Extension(['application/*']);
      expect(appExts, isNotEmpty);
      expect(appExts, contains('pdf'));
      expect(appExts, contains('json'));
      expect(appExts, contains('xml'));
      
      final imageExts = mime2Extension(['image/*']);
      expect(imageExts, isNotEmpty);
      expect(imageExts, contains('png'));
      expect(imageExts, contains('jpg'));
      expect(imageExts, contains('gif'));
      
      final audioExts = mime2Extension(['audio/*']);
      expect(audioExts, isNotEmpty);
      expect(audioExts, contains('mp3'));
    });

    test('should combine results from multiple MIME types', () {
      final combined = mime2Extension(['image/png', 'application/pdf']);
      expect(combined, contains('png'));
      expect(combined, contains('pdf'));
    });

    test('should combine wildcard and exact MIME types', () {
      final combined = mime2Extension(['application/*', 'image/png']);
      expect(combined, isNotEmpty);
      expect(combined, contains('png'));
      expect(combined, contains('pdf'));
      expect(combined, contains('json'));
    });

    test('should remove duplicate extensions', () {
      // Some MIME types might share extensions
      final exts = mime2Extension(['image/png', 'image/png']);
      final uniqueExts = exts.toSet().toList();
      expect(exts.length, equals(uniqueExts.length));
    });

    test('should handle empty input', () {
      expect(mime2Extension([]), isEmpty);
    });

    test('should handle multiple wildcards', () {
      final exts = mime2Extension(['application/*', 'image/*', 'audio/*']);
      expect(exts, isNotEmpty);
      expect(exts.length, greaterThan(10));
    });

    test('should not match partial wildcards incorrectly', () {
      // 'application/*' should not match 'applicationx/something'
      final appExts = mime2Extension(['application/*']);
      // All returned extensions should be from valid application/* MIME types
      expect(appExts, isNotEmpty);
    });
  });

  group('integration tests', () {
    test('should be able to round-trip extension to MIME and back', () {
      final mime = extension2Mime('png');
      expect(mime, isNotNull);
      
      final exts = mime2Extension([mime!]);
      expect(exts, contains('png'));
    });

    test('should handle common file types correctly', () {
      // Test a variety of common extensions
      final commonExtensions = ['pdf', 'jpg', 'png', 'mp3', 'mp4', 'doc', 'txt', 'zip'];
      
      for (final ext in commonExtensions) {
        final mime = extension2Mime(ext);
        expect(mime, isNotNull, reason: 'Extension $ext should have a MIME type');
        
        if (mime != null) {
          final exts = mime2Extension([mime]);
          expect(exts, isNotEmpty, reason: 'MIME type $mime should have extensions');
        }
      }
    });
  });

  group('base64ToExtension', () {
    test('should detect PNG from base64', () {
      final bytes = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('png'));
    });

    test('should detect JPEG from base64', () {
      final bytes = [0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('jpg'));
    });

    test('should detect GIF from base64', () {
      final bytes = [0x47, 0x49, 0x46, 0x38, 0x39, 0x61];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('gif'));
    });

    test('should detect PDF from base64', () {
      final bytes = [0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('pdf'));
    });

    test('should detect ZIP from base64', () {
      final bytes = [0x50, 0x4B, 0x03, 0x04, 0x0A, 0x00, 0x00, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('zip'));
    });

    test('should detect BMP from base64', () {
      final bytes = [0x42, 0x4D, 0x36, 0x00, 0x0C, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('bmp'));
    });

    test('should detect MP3 (ID3) from base64', () {
      final bytes = [0x49, 0x44, 0x33, 0x03, 0x00, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('mp3'));
    });

    test('should detect WOFF2 from base64', () {
      final bytes = [0x77, 0x4F, 0x46, 0x32, 0x00, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('woff2'));
    });

    test('should detect WOFF from base64', () {
      final bytes = [0x77, 0x4F, 0x46, 0x46, 0x00, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('woff'));
    });

    test('should detect RAR from base64', () {
      final bytes = [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('rar'));
    });

    test('should detect 7z from base64', () {
      final bytes = [0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('7z'));
    });

    test('should detect GZIP from base64', () {
      final bytes = [0x1F, 0x8B, 0x08, 0x08, 0x00, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('gz'));
    });

    test('should detect FLAC from base64', () {
      final bytes = [0x66, 0x4C, 0x61, 0x43, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('flac'));
    });

    test('should detect OGG from base64', () {
      final bytes = [0x4F, 0x67, 0x67, 0x53, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('ogg'));
    });

    test('should detect PSD from base64', () {
      final bytes = [0x38, 0x42, 0x50, 0x53, 0x00, 0x01];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('psd'));
    });

    test('should detect TIFF (little-endian) from base64', () {
      final bytes = [0x49, 0x49, 0x2A, 0x00, 0x08, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('tiff'));
    });

    test('should detect TIFF (big-endian) from base64', () {
      final bytes = [0x4D, 0x4D, 0x00, 0x2A, 0x00, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('tiff'));
    });

    test('should detect ICO from base64', () {
      final bytes = [0x00, 0x00, 0x01, 0x00, 0x01, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('ico'));
    });

    test('should handle data URI with prefix', () {
      final bytes = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00];
      final b64 = 'data:image/png;base64,${base64Encode(bytes)}';
      expect(base64ToExtension(b64), equals('png'));
    });

    test('should return null for empty string', () {
      expect(base64ToExtension(''), isNull);
    });

    test('should return null for invalid base64', () {
      expect(base64ToExtension('!!!invalid!!!'), isNull);
    });

    test('should return null for unrecognized data', () {
      final bytes = [0x01, 0x02, 0x03, 0x04, 0x05];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), isNull);
    });

    test('should detect EPUB (specific ZIP variant)', () {
      final bytes = [0x50, 0x4B, 0x03, 0x04, 0x0A, 0x00, 0x02, 0x00, 0x00, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('epub'));
    });

    test('should detect DOCX (specific ZIP variant)', () {
      final bytes = [0x50, 0x4B, 0x03, 0x04, 0x14, 0x00, 0x06, 0x00, 0x00, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('docx'));
    });
  });

  group('base64ToExtension - RIFF container', () {
    test('should detect WEBP inside RIFF', () {
      // RIFF + 4-byte size + WEBP
      final bytes = [
        0x52, 0x49, 0x46, 0x46, // RIFF
        0x00, 0x00, 0x00, 0x00, // size
        0x57, 0x45, 0x42, 0x50, // WEBP
        0x00, 0x00,
      ];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('webp'));
    });

    test('should detect AVI inside RIFF', () {
      final bytes = [
        0x52, 0x49, 0x46, 0x46,
        0x00, 0x00, 0x00, 0x00,
        0x41, 0x56, 0x49, 0x20, // AVI
        0x00, 0x00,
      ];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('avi'));
    });

    test('should detect WAV inside RIFF', () {
      final bytes = [
        0x52, 0x49, 0x46, 0x46,
        0x00, 0x00, 0x00, 0x00,
        0x57, 0x41, 0x56, 0x45, // WAVE
        0x00, 0x00,
      ];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('wav'));
    });
  });

  group('base64ToExtension - ISO BMFF container', () {
    test('should detect MP4 (isom brand)', () {
      final bytes = [
        0x00, 0x00, 0x00, 0x1C, // size
        0x66, 0x74, 0x79, 0x70, // ftyp
        0x69, 0x73, 0x6F, 0x6D, // isom
        0x00, 0x00,
      ];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('mp4'));
    });

    test('should detect HEIC', () {
      final bytes = [
        0x00, 0x00, 0x00, 0x20,
        0x66, 0x74, 0x79, 0x70,
        0x68, 0x65, 0x69, 0x63, // heic
        0x00, 0x00,
      ];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('heic'));
    });

    test('should detect AVIF', () {
      final bytes = [
        0x00, 0x00, 0x00, 0x20,
        0x66, 0x74, 0x79, 0x70,
        0x61, 0x76, 0x69, 0x66, // avif
        0x00, 0x00,
      ];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('avif'));
    });

    test('should detect M4A', () {
      final bytes = [
        0x00, 0x00, 0x00, 0x20,
        0x66, 0x74, 0x79, 0x70,
        0x4D, 0x34, 0x41, 0x20, // M4A
        0x00, 0x00,
      ];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('m4a'));
    });

    test('should detect MOV (qt brand)', () {
      final bytes = [
        0x00, 0x00, 0x00, 0x14,
        0x66, 0x74, 0x79, 0x70,
        0x71, 0x74, 0x20, 0x20, // qt
        0x00, 0x00,
      ];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('mov'));
    });

    test('should detect 3GP', () {
      final bytes = [
        0x00, 0x00, 0x00, 0x14,
        0x66, 0x74, 0x79, 0x70,
        0x33, 0x67, 0x70, 0x35, // 3gp5
        0x00, 0x00,
      ];
      final b64 = base64Encode(bytes);
      expect(base64ToExtension(b64), equals('3gp'));
    });
  });

  group('base64ToMime', () {
    test('should return MIME type for PNG', () {
      final bytes = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00];
      final b64 = base64Encode(bytes);
      expect(base64ToMime(b64), equals('image/png'));
    });

    test('should return MIME type for JPEG', () {
      final bytes = [0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10];
      final b64 = base64Encode(bytes);
      expect(base64ToMime(b64), equals('image/jpeg'));
    });

    test('should return MIME type for GIF', () {
      final bytes = [0x47, 0x49, 0x46, 0x38, 0x39, 0x61];
      final b64 = base64Encode(bytes);
      expect(base64ToMime(b64), equals('image/gif'));
    });

    test('should return MIME type for PDF', () {
      final bytes = [0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E];
      final b64 = base64Encode(bytes);
      expect(base64ToMime(b64), equals('application/pdf'));
    });

    test('should return MIME type for WEBP via RIFF', () {
      final bytes = [
        0x52, 0x49, 0x46, 0x46,
        0x00, 0x00, 0x00, 0x00,
        0x57, 0x45, 0x42, 0x50,
        0x00, 0x00,
      ];
      final b64 = base64Encode(bytes);
      expect(base64ToMime(b64), equals('image/webp'));
    });

    test('should return MIME type for MP4', () {
      final bytes = [
        0x00, 0x00, 0x00, 0x1C,
        0x66, 0x74, 0x79, 0x70,
        0x69, 0x73, 0x6F, 0x6D,
        0x00, 0x00,
      ];
      final b64 = base64Encode(bytes);
      expect(base64ToMime(b64), equals('application/mp4'));
    });

    test('should handle data URI prefix', () {
      final bytes = [0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E];
      final b64 = 'data:application/octet-stream;base64,${base64Encode(bytes)}';
      expect(base64ToMime(b64), equals('application/pdf'));
    });

    test('should return null for unrecognized data', () {
      final bytes = [0x01, 0x02, 0x03, 0x04, 0x05];
      final b64 = base64Encode(bytes);
      expect(base64ToMime(b64), isNull);
    });

    test('should return null for empty string', () {
      expect(base64ToMime(''), isNull);
    });
  });
}

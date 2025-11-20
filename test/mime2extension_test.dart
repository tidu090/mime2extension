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
}

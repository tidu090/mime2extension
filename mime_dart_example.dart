import 'package:mime2extension/mime2extension.dart';

void main() {
  // Test extension to MIME conversion
  print('Extension to MIME:');
  print('png -> ${extension2Mime('png')}');
  print('pdf -> ${extension2Mime('pdf')}');
  print('unknown -> ${extension2Mime('unknown')}');
  print('');
  
  // Test MIME to extension conversion with wildcards
  print('MIME to Extensions:');
  final extensions = mime2Extension(['application/*', 'image/png']);
  print('application/* and image/png -> ${extensions.length} extensions');
  print('First 10: ${extensions.take(10).toList()}');
  print('');
  
  // Test exact MIME type
  print('Exact MIME type:');
  print('image/png -> ${mime2Extension(['image/png'])}');
}

# mime2extension Example

This example demonstrates how to use the `mime2extension` package to convert between MIME types and file extensions.

## Running the Example

```bash
dart run example/example.dart
```

## Features Demonstrated

1. **Extension to MIME Type Conversion**
   - Convert file extensions like 'png', 'pdf' to their MIME types

2. **MIME Type to Extensions Conversion**
   - Get file extensions for specific MIME types

3. **Wildcard Support**
   - Use patterns like `image/*` to get all image extensions
   - Use patterns like `application/*` to get all application extensions

4. **Combining Multiple MIME Types**
   - Query multiple MIME types at once
   - Mix specific MIME types with wildcards

5. **Error Handling**
   - Handle unknown extensions gracefully (returns `null`)
   - Handle unknown MIME types (returns empty list)

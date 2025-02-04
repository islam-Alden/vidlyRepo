  
// helpers/validators.dart

String? extractVideoId(String url) {
  final pattern = RegExp(
    r'(?:youtube\.com(?:/[^/]+)?(?:\?v=|\/)([^"&?\/\s]+)|youtu\.be\/([^"&?\/\s]+))',
  );
  final match = pattern.firstMatch(url);
  final id = match != null ? (match.group(1) ?? match.group(2)) : null;

  // Check if the ID is exactly 11 characters long
  if (id != null && id.length == 11) {
    return id;
  } else {
    return null; // Return null if the ID is not 11 characters
  }
}


String? youtubeUrlValidator(String value) {
  if (value.isEmpty) return null; // No error on empty input

  final RegExp youtubeRegex = RegExp(
    r'^(https?:\/\/)?(www\.)?(youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})(\S*)$',
  );

  if (!youtubeRegex.hasMatch(value)) {
    return "This is not a valid YouTube URL"; // Show error if invalid
  }

  return null; // Valid URL, no error
}
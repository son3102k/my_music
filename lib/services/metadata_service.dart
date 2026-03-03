// Metadata Service to extract song information from files
// For simplicity, we'll extract from filename pattern
// In a production app, use packages like audio_metadata or id3

class MetadataService {
  static final MetadataService _instance = MetadataService._internal();

  factory MetadataService() {
    return _instance;
  }

  MetadataService._internal();

  // Get metadata from audio file
  // Returns {title, artist, duration, ...}
  Future<Map<String, dynamic>?> getMetadata(String filePath) async {
    try {
      final fileName = _getFileName(filePath);
      final metadata = _parseMetadataFromFilename(fileName);
      return metadata;
    } catch (e) {
      print('Error getting metadata: $e');
      return null;
    }
  }

  // Try to parse title and artist from filename
  // Supports formats like:
  // - "Artist - Title.mp3"
  // - "Title.mp3"
  Map<String, dynamic> _parseMetadataFromFilename(String filename) {
    final withoutExtension = filename.replaceAll(RegExp(r'\.[^/.]+$'), '');
    
    if (withoutExtension.contains('-')) {
      final parts = withoutExtension.split('-').map((s) => s.trim()).toList();
      if (parts.length >= 2) {
        return {
          'title': parts[1],
          'artist': parts[0],
        };
      }
    }

    return {
      'title': withoutExtension,
      'artist': 'Unknown Artist',
    };
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }
}

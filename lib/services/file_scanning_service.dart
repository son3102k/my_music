import 'dart:io';
import '../models/song.dart';
import 'database_service.dart';
import 'metadata_service.dart';
import 'permission_service.dart';

class FileScanningService {
  static final FileScanningService _instance = FileScanningService._internal();

  factory FileScanningService() {
    return _instance;
  }

  FileScanningService._internal();

  final _databaseService = DatabaseService();
  final _metadataService = MetadataService();
  final _permissionService = PermissionService();

  // Request file permissions
  Future<bool> requestPermissions() async {
    final hasStoragePermission = await _permissionService.requestStoragePermission();
    final hasAudioPermission = await _permissionService.requestMediaAudioPermission();
    return hasStoragePermission || hasAudioPermission;
  }

  // Check if permission is granted
  Future<bool> hasPermission() async {
    final hasStoragePermission = await _permissionService.hasStoragePermission();
    final hasAudioPermission = await _permissionService.requestMediaAudioPermission();
    return hasStoragePermission || hasAudioPermission;
  }

  // Scan a directory for MP3 files
  Future<List<Song>> scanDirectory(String directoryPath) async {
    final songs = <Song>[];
    try {
      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        print('Directory does not exist: $directoryPath');
        return songs;
      }

      final files = directory.listSync(recursive: false, followLinks: false);
      for (var file in files) {
        try {
          if (file is File && _isMp3File(file.path)) {
            print('Found file: ${file.path}');
            final song = await _createSongFromFile(file.path);
            if (song != null) {
              songs.add(song);
            }
          } else if (file is Directory) {
            // Recursively scan subdirectories
            final subSongs = await scanDirectory(file.path);
            songs.addAll(subSongs);
          }
        } catch (e) {
          print('Error processing entry $file: $e');
        }
      }
    } catch (e) {
      print('Error scanning directory $directoryPath: $e');
    }
    return songs;
  }

  // Scan default music directories
  Future<List<Song>> scanDefaultMusicDirectories() async {
    final songs = <Song>[];
    
    // Common music directories on Android
    final musicDirs = [
      '/storage/emulated/0/Music',
      '/storage/emulated/0/Download',
      '/storage/emulated/0/DCIM',
      '/storage/emulated/0/Documents',
    ];

    for (var dir in musicDirs) {
      try {
        if (await Directory(dir).exists()) {
          final dirSongs = await scanDirectory(dir);
          songs.addAll(dirSongs);
        }
      } catch (e) {
        print('Error scanning directory $dir: $e');
      }
    }

    return songs;
  }

  // Create a Song object from a file
  Future<Song?> _createSongFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      final fileName = file.path.split('/').last;
      final metadata = await _metadataService.getMetadata(filePath);

      return Song(
        title: metadata?['title'] ?? _stripExtension(fileName),
        artist: metadata?['artist'] ?? 'Unknown Artist',
        filePath: filePath,
        albumArt: 'assets/album_placeholder.png',
        duration: (metadata?['duration'] as num?)?.toDouble() ?? 180.0,
        dateAdded: DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      print('Error creating song from file: $e');
      return null;
    }
  }

  // Add songs to library
  Future<void> addSongsToLibrary(List<Song> songs) async {
    await _databaseService.insertSongs(songs);
  }

  // Check if file is MP3
  bool _isMp3File(String path) {
    return path.toLowerCase().endsWith('.mp3') ||
        path.toLowerCase().endsWith('.wav') ||
        path.toLowerCase().endsWith('.flac') ||
        path.toLowerCase().endsWith('.m4a') ||
        path.toLowerCase().endsWith('.aac') ||
        path.toLowerCase().endsWith('.ogg');
  }

  // Helper to strip file extension
  String _stripExtension(String fileName) {
    final lastDot = fileName.lastIndexOf('.');
    if (lastDot == -1) return fileName;
    return fileName.substring(0, lastDot);
  }
}

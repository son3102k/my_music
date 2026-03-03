class Song {
  final int? id; // database id
  final String title;
  final String artist;
  final String? filePath; // path to mp3 file
  final String albumArt; // asset path or url
  final double duration; // in seconds
  final int dateAdded; // timestamp when added

  const Song({
    this.id,
    required this.title,
    required this.artist,
    this.filePath,
    required this.albumArt,
    this.duration = 180.0,
    this.dateAdded = 0,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'artist': artist,
      'filePath': filePath,
      'albumArt': albumArt,
      'duration': duration,
      'dateAdded': dateAdded,
    };
  }

  // Create Song from database map
  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      filePath: map['filePath'],
      albumArt: map['albumArt'],
      duration: (map['duration'] as num).toDouble(),
      dateAdded: map['dateAdded'] ?? 0,
    );
  }

  // Create a copy with modified fields
  Song copyWith({
    int? id,
    String? title,
    String? artist,
    String? filePath,
    String? albumArt,
    double? duration,
    int? dateAdded,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      filePath: filePath ?? this.filePath,
      albumArt: albumArt ?? this.albumArt,
      duration: duration ?? this.duration,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}

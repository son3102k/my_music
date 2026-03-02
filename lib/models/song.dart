class Song {
  final String title;
  final String artist;
  final String albumArt; // asset path or url
  final double duration; // in seconds

  const Song({
    required this.title,
    required this.artist,
    required this.albumArt,
    this.duration = 180.0,
  });
}

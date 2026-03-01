import 'package:flutter/material.dart';

/// Displays album art in a circular frame, similar to Spotify's player.
class AlbumArt extends StatelessWidget {
  final ImageProvider image;
  final double size;

  const AlbumArt({Key? key, required this.image, this.size = 250}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipOval(
        child: Image(
          image: image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[800],
              child: Icon(Icons.music_note, size: size * 0.5, color: Colors.white24),
            );
          },
        ),
      ),
    );
  }
}

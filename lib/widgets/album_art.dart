import 'package:flutter/material.dart';

/// Displays album art in a circular frame, similar to Spotify's player.
class AlbumArt extends StatefulWidget {
  final ImageProvider image;
  final double size;
  final bool spin;

  const AlbumArt({
    Key? key,
    required this.image,
    this.size = 250,
    this.spin = false,
  }) : super(key: key);

  @override
  State<AlbumArt> createState() => _AlbumArtState();
}

class _AlbumArtState extends State<AlbumArt> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    if (!widget.spin) _controller.stop();
  }

  @override
  void didUpdateWidget(AlbumArt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spin && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.spin && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.spin ? Colors.grey[800] : null,
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
            image: widget.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[800],
                child: Icon(Icons.music_note, size: size * 0.5, color: Colors.white24),
              );
            },
          ),
        ),
      ),
    );
  }
}

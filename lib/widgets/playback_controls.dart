import 'package:flutter/material.dart';

/// A row of playback controls mimicking Spotify layout (previous/play/pause/next).
class PlaybackControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const PlaybackControls({
    Key? key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onBackground;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          iconSize: 36,
          icon: Icon(Icons.skip_previous, color: color),
          onPressed: onPrevious,
        ),
        IconButton(
          iconSize: 56,
          icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: color),
          onPressed: onPlayPause,
        ),
        IconButton(
          iconSize: 36,
          icon: Icon(Icons.skip_next, color: color),
          onPressed: onNext,
        ),
      ],
    );
  }
}

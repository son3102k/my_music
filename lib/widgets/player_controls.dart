import 'package:flutter/material.dart';

enum RepeatMode { off, all, one }

class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isShuffled;
  final RepeatMode repeatMode;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onShuffle;
  final VoidCallback onRepeat;

  const PlayerControls({
    Key? key,
    required this.isPlaying,
    this.isShuffled = false,
    this.repeatMode = RepeatMode.off,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onShuffle,
    required this.onRepeat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Shuffle button
        GestureDetector(
          onTap: onShuffle,
          child: Icon(
            Icons.shuffle,
            color: isShuffled ? colors.primary : colors.onSurface,
            size: 24,
          ),
        ),
        // Previous button
        GestureDetector(
          onTap: onPrevious,
          child: Icon(
            Icons.skip_previous,
            color: colors.onSurface,
            size: 32,
          ),
        ),
        // Play/Pause button
        GestureDetector(
          onTap: onPlayPause,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.onSurface,
              boxShadow: [
                BoxShadow(
                  color: colors.onSurface.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: colors.background,
              size: 28,
            ),
          ),
        ),
        // Next button
        GestureDetector(
          onTap: onNext,
          child: Icon(
            Icons.skip_next,
            color: colors.onSurface,
            size: 32,
          ),
        ),
        // Repeat button
        GestureDetector(
          onTap: onRepeat,
          child: Stack(
            children: [
              Icon(
                Icons.repeat,
                color: repeatMode != RepeatMode.off ? colors.primary : colors.onSurface,
                size: 24,
              ),
              if (repeatMode == RepeatMode.one)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary,
                    ),
                    child: const Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

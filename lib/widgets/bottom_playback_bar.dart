import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../providers/playback_notifier.dart';

/// Spotify‑style mini player bar with thumbnail, title, artist, progress,
/// and a play/pause button. Tapping the bar routes to full player.
class BottomPlaybackBar extends StatelessWidget {
  final VoidCallback onTap;

  const BottomPlaybackBar({Key? key, required this.onTap}) : super(key: key);

  Widget _buildAlbumImage(String url) {
    final errBuilder = (BuildContext context, Object error, StackTrace? stackTrace) {
      return Container(
        width: 48,
        height: 48,
        color: Theme.of(context).colorScheme.surface,
        child: Icon(Icons.music_note,
            color: Theme.of(context).colorScheme.primary),
      );
    };

    if (url.startsWith('http')) {
      return Image(
        image: CachedNetworkImageProvider(url),
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => errBuilder(context, error, stackTrace),
      );
    } else {
      return Image.asset(
        url,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: errBuilder,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaybackNotifier>(
      builder: (context, playback, _) {
        final song = playback.currentSong;
        if (song == null) return const SizedBox.shrink();

        return Material(
          color: Theme.of(context).colorScheme.surface,
          elevation: 12,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final local = box.globalToLocal(details.globalPosition);
                  final pct = (local.dx / box.size.width).clamp(0.0, 1.0);
                  playback.seek(pct);
                },
                child: LinearProgressIndicator(
                  value: playback.position,
                  backgroundColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).colorScheme.primary),
                  minHeight: 2,
                ),
              ),
              InkWell(
                onTap: onTap,
                child: SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: _buildAlbumImage(song.albumArt),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              song.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          playback.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: playback.togglePlayPause,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

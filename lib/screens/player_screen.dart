import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_notifier.dart';
import '../models/song.dart';
import '../providers/playback_notifier.dart';
import '../widgets/album_art.dart';
import '../widgets/track_info.dart';
import '../widgets/player_controls.dart';
import '../widgets/progress_bar.dart';
import '../widgets/volume_control.dart';

/// A simple "Spotify-like" player screen.
///
/// For demo purposes this screen uses hardcoded data and controls a single
/// boolean to simulate playback. In a real application you'd connect these
/// controls to your audio engine or business logic.
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  void _onSeek(double value, PlaybackNotifier playback) {
    playback.seek(value);
  }

  @override
  Widget build(BuildContext context) {
    final playback = context.watch<PlaybackNotifier>();
    final song = playback.currentSong ??
        const Song(title: 'Unknown', artist: 'Unknown', albumArt: 'assets/album_placeholder.png');

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Now Playing'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () {
              context.read<ThemeNotifier>().nextTheme();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // gradient background using primary color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity == null) return;
              if (details.primaryVelocity! < 0) {
                // swipe left = next
              } else if (details.primaryVelocity! > 0) {
                // swipe right = previous
              }
            },
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 8),
                      AlbumArt(image: AssetImage(song.albumArt), size: MediaQuery.of(context).size.width * 0.8),
                      const SizedBox(height: 24),
                      TrackInfo(title: song.title, artist: song.artist),
                      const SizedBox(height: 16),
                      // progress bar with time
                      ProgressBar(
                        value: playback.position,
                        max: 1.0,
                        onChanged: (v) => _onSeek(v, playback),
                      ),
                      const SizedBox(height: 24),
                      PlayerControls(
                        isPlaying: playback.isPlaying,
                        onPlayPause: playback.togglePlayPause,
                        onNext: () {},
                        onPrevious: () {},
                        onShuffle: () {},
                        onRepeat: () {},
                      ),
                      const SizedBox(height: 24),
                      VolumeControl(
                        value: 50,
                        onChanged: (v) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

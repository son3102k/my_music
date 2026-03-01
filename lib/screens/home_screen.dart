import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../models/song.dart';
import '../models/playlist.dart';
import '../providers/playback_notifier.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';
import '../widgets/bottom_playback_bar.dart';
import '../widgets/media_card.dart';
import '../widgets/track_list_item.dart';
import 'player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  List<Song> get _songs => const [
        Song(title: 'Track One', artist: 'Artist A', albumArt: 'assets/album_placeholder.png'),
        Song(title: 'Track Two', artist: 'Artist B', albumArt: 'assets/album_placeholder.png'),
        Song(title: 'Track Three', artist: 'Artist C', albumArt: 'assets/album_placeholder.png'),
        Song(title: 'Track Four', artist: 'Artist D', albumArt: 'assets/album_placeholder.png'),
        Song(title: 'Track Five', artist: 'Artist E', albumArt: 'assets/album_placeholder.png'),
      ];

  List<Playlist> get _playlists => [
        Playlist(name: 'Daily Mix 1', songs: _songs),
        Playlist(name: 'Daily Mix 2', songs: _songs),
        Playlist(name: 'Daily Mix 3', songs: _songs),
      ];

  @override
  Widget build(BuildContext context) {
    final playback = context.watch<PlaybackNotifier>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(
              top: 0,
              left: 16,
              right: 16,
              bottom: 140,
            ),
            children: [
              // Header with greeting and theme switcher
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    // Theme switcher
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _themeButton(context, ThemeVariant.spotify, 'Spotify'),
                        _themeButton(context, ThemeVariant.purple, 'Purple'),
                        _themeButton(context, ThemeVariant.blue, 'Blue'),
                        _themeButton(context, ThemeVariant.orange, 'Orange'),
                      ],
                    ),
                  ],
                ),
              ),
              // Recently Played
              Text('Recently Played', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _songs.take(4).length,
                itemBuilder: (context, index) {
                  final song = _songs[index];
                  return MediaCard(
                    title: song.title,
                    subtitle: song.artist,
                    imageUrl: song.albumArt,
                    variant: MediaCardVariant.album,
                    imageSize: 120,
                    onTap: () => playback.playSong(song),
                    onPlayPressed: () => playback.playSong(song),
                  );
                },
              ),
              const SizedBox(height: 32),
              // Your Top Songs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your Top Songs', style: Theme.of(context).textTheme.titleLarge),
                  Text('Show all', style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
              const SizedBox(height: 12),
              ..._songs.asMap().entries.map((entry) {
                final index = entry.key;
                final song = entry.value;
                return TrackListItem(
                  number: index + 1,
                  title: song.title,
                  artist: song.artist,
                  duration: '${Random().nextInt(5)}:${Random().nextInt(60).toString().padLeft(2, '0')}',
                  imageUrl: song.albumArt,
                  onTap: () => playback.playSong(song),
                  onLikePressed: () {},
                );
              }),
              const SizedBox(height: 32),
              // Made For You
              Text('Made For You', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _playlists.length,
                itemBuilder: (context, index) {
                  final playlist = _playlists[index];
                  return MediaCard(
                    title: playlist.name,
                    subtitle: '${playlist.songs.length} songs',
                    imageUrl: 'assets/album_placeholder.png',
                    variant: MediaCardVariant.playlist,
                    imageSize: 120,
                    onTap: () {
                      if (playlist.songs.isNotEmpty) {
                        playback.playSong(playlist.songs.first);
                      }
                    },
                    onPlayPressed: () {
                      if (playlist.songs.isNotEmpty) {
                        playback.playSong(playlist.songs.first);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 8),
              // Popular Artists
              Text('Popular Artists', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 140,
                        child: MediaCard(
                          title: 'Artist ${index + 1}',
                          imageUrl: 'assets/album_placeholder.png',
                          variant: MediaCardVariant.artist,
                          imageSize: 120,
                          onTap: () {},
                          onPlayPressed: () {},
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Bottom playback bar
          if (playback.currentSong != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomPlaybackBar(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const PlayerScreen(),
                      transitionsBuilder: (context, anim, sec, child) {
                        final offset = Tween(begin: const Offset(0, 1), end: Offset.zero).animate(anim);
                        return SlideTransition(position: offset, child: child);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _themeButton(BuildContext context, ThemeVariant variant, String label) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final isSelected = themeNotifier.currentVariant == variant;

    Color color;
    switch (variant) {
      case ThemeVariant.spotify:
        color = AppColors.spotifyPrimary;
        break;
      case ThemeVariant.purple:
        color = AppColors.purplePrimary;
        break;
      case ThemeVariant.blue:
        color = AppColors.bluePrimary;
        break;
      case ThemeVariant.orange:
        color = AppColors.orangePrimary;
        break;
    }

    return GestureDetector(
      onTap: () {
        // Will update once we fix the consumer issue
        context.read<ThemeNotifier>().setTheme(variant);
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 8,
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

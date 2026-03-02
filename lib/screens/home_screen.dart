import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../models/song.dart';
import '../models/playlist.dart';
import '../data/sample_songs.dart';
import '../providers/playback_notifier.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';
import '../widgets/bottom_playback_bar.dart';
import '../widgets/media_card.dart';
import '../widgets/track_list_item.dart';
import 'player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // pre-cache the recently played songs (first 4) so they don't flash
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final songs = _songs.take(4);
      for (var song in songs) {
        if (song.albumArt.startsWith('http')) {
          precacheImage(CachedNetworkImageProvider(song.albumArt), context);
        } else {
          precacheImage(AssetImage(song.albumArt), context);
        }
      }
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  List<Song> get _songs => sampleSongs;

  List<Playlist> get _playlists => [
        Playlist(name: 'Daily Mix 1', songs: _songs),
        Playlist(name: 'Daily Mix 2', songs: _songs),
        Playlist(name: 'Daily Mix 3', songs: _songs),
      ];

  void _playAndCache(BuildContext context, PlaybackNotifier playback, Song song) {
    // send the full list so user can skip tracks
    playback.playSong(song, queue: _songs);
    // pre-cache the image right away so it appears instantly later
    if (song.albumArt.startsWith('http')) {
      precacheImage(CachedNetworkImageProvider(song.albumArt), context);
    } else {
      precacheImage(AssetImage(song.albumArt), context);
    }
  }

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
              // Header with greeting and theme switcher on same row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                          _getGreeting(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    // Smaller theme buttons aligned right
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _themeButton(context, ThemeVariant.spotify, 'S'),
                        const SizedBox(width: 8),
                        _themeButton(context, ThemeVariant.purple, 'P'),
                        const SizedBox(width: 8),
                        _themeButton(context, ThemeVariant.blue, 'B'),
                        const SizedBox(width: 8),
                        _themeButton(context, ThemeVariant.orange, 'O'),
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
                    onTap: () => _playAndCache(context, playback, song),
                    onPlayPressed: () => _playAndCache(context, playback, song),
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
                  onTap: () => _playAndCache(context, playback, song),
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
                        _playAndCache(context, playback, playlist.songs.first);
                      }
                    },
                    onPlayPressed: () {
                      if (playlist.songs.isNotEmpty) {
                        _playAndCache(context, playback, playlist.songs.first);
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/playback_notifier.dart';
import '../services/file_scanning_service.dart';
import '../widgets/track_list_item.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _fileScanningService = FileScanningService();
  bool _isScanning = false;
  String _scanStatus = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Thêm nhạc',
            onPressed: _isScanning ? null : _showAddMusicMenu,
          )
        ],
      ),
      body: Consumer<PlaybackNotifier>(
        builder: (context, playback, _) {
          final songs = playback.allSongs;

          if (_isScanning) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(_scanStatus),
                ],
              ),
            );
          }

          if (songs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không có bài hát',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nhấn + để thêm nhạc',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showAddMusicMenu,
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm nhạc'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              final isPlaying = playback.currentSong?.id == song.id &&
                  playback.isPlaying;
              
              // Convert duration from seconds to mm:ss format
              final minutes = (song.duration / 60).toStringAsFixed(0);
              final seconds =
                  (song.duration % 60).toStringAsFixed(0).padLeft(2, '0');
              final durationStr = '$minutes:$seconds';
              
              return TrackListItem(
                number: index + 1,
                title: song.title,
                artist: song.artist,
                duration: durationStr,
                imageUrl: song.albumArt,
                isPlaying: isPlaying,
                onTap: () {
                  playback.playSong(song, queue: songs);
                },
                onLikePressed: () {
                  // Implement like functionality
                },
                onMorePressed: () {
                  _showSongOptions(context, song);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showAddMusicMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Quét thư mục Nhạc'),
              subtitle: const Text('Quét thư mục Music, Download, DCIM...'),
              onTap: () {
                Navigator.pop(context);
                _scanMusicDirectory();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanMusicDirectory() async {
    // ensure permissions before scanning
    final granted = await _fileScanningService.requestPermissions();
    if (!granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cần cấp quyền truy cập bộ nhớ để quét nhạc')),
        );
      }
      return;
    }

    if (!mounted) return;
    setState(() => _isScanning = true);

    try {
      _updateStatus('Quét nhạc...');
      final songs = await _fileScanningService.scanDefaultMusicDirectories();
      print('scanMusicDirectory found ${songs.length} songs');

      if (!mounted) return;

      if (songs.isNotEmpty) {
        _updateStatus('Thêm vào thư viện...');
        await _fileScanningService.addSongsToLibrary(songs);

        final playback = context.read<PlaybackNotifier>();
        await playback.initialize();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thêm ${songs.length} bài hát')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không tìm thấy bài hát nào trong thư mục nhạc')), 
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
      print('Error scanning music directory: $e');
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }


  void _updateStatus(String status) {
    if (mounted) {
      setState(() => _scanStatus = status);
    }
  }

  void _showSongOptions(BuildContext context, Song song) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Xóa khỏi thư viện'),
              onTap: () {
                Navigator.pop(context);
                // Delete functionality would go here
              },
            ),
          ],
        ),
      ),
    );
  }
}

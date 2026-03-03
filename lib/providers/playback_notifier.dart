import 'package:flutter/material.dart' hide RepeatMode;
import '../models/song.dart';
import '../models/repeat_mode.dart';
import '../data/sample_songs.dart';
import '../services/database_service.dart';
import '../services/persistence_service.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

/// Playback controller that manages currently playing song and playback state.
/// Persists state to local storage so playback can be resumed.
class PlaybackNotifier extends ChangeNotifier {
  // Services
  final _databaseService = DatabaseService();
  final _persistenceService = PersistenceService();

  // playback queue machinery
  List<Song> _queue = [];
  List<Song> _allSongs = [];
  int _currentIndex = 0;
  bool _isShuffled = false;
  RepeatMode _repeatMode = RepeatMode.off;

  // Current playback state
  Song? _currentSong;
  bool _isPlaying = false;
  double _position = 0.0; // 0.0 - 1.0
  double _buffer = 1.0; // amount buffered
  double _trackDuration = 180.0; // seconds

  // audio engine
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  // Library state
  bool _isLibraryLoaded = false;

  // expose some state
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  double get position => _position;
  double get buffer => _buffer;
  double get trackDuration => _trackDuration;
  bool get isShuffled => _isShuffled;
  RepeatMode get repeatMode => _repeatMode;
  List<Song> get queue => _queue;
  List<Song> get allSongs => _allSongs;
  bool get isLibraryLoaded => _isLibraryLoaded;

  // Initialize playback with saved state
  Future<void> initialize() async {
    await _persistenceService.init();
    await _loadLibrary();
    await _restoreSavedState();
  }

  // Load library from database
  Future<void> _loadLibrary() async {
    _allSongs = await _databaseService.getAllSongs();
    if (_allSongs.isEmpty) {
      // If no songs in database, use sample songs
      _allSongs = sampleSongs;
      await _databaseService.insertSongs(_allSongs);
    }
    _queue = _allSongs;
    _isLibraryLoaded = true;
    notifyListeners();
  }

  // Restore saved playback state
  Future<void> _restoreSavedState() async {
    final songId = _persistenceService.getCurrentSongId();
    final position = _persistenceService.getPlaybackPosition();
    final repeatName = _persistenceService.getRepeatMode();
    final shuffled = _persistenceService.getIsShuffled();

    _repeatMode = RepeatMode.values.firstWhere(
      (r) => r.name == repeatName,
      orElse: () => RepeatMode.off,
    );
    _isShuffled = shuffled;

    if (songId != null) {
      final song = _allSongs.firstWhere(
        (s) => s.id == songId,
        orElse: () => _allSongs.first,
      );
      _currentSong = song;
      _currentIndex = _queue.indexOf(song);
      _position = position;
      _trackDuration = song.duration;

      // prepare audio engine with the file path but do not auto play
      try {
        if (song.filePath != null) {
          await _audioPlayer.setFilePath(song.filePath!);
          final seekDuration = Duration(milliseconds: (position * _trackDuration * 1000).toInt());
          await _audioPlayer.seek(seekDuration);
        }
      } catch (e) {
        print('Error restoring audio source: $e');
      }

      _startAudioListeners();
      // keep paused; user can press play manually
      _isPlaying = false;
    }
    notifyListeners();
  }

  // Save current state
  void _saveState() {
    _persistenceService.saveCurrentSongId(_currentSong?.id);
    _persistenceService.savePlaybackPosition(_position);
    _persistenceService.saveIsPlaying(_isPlaying);
    _persistenceService.saveRepeatMode(_repeatMode.name);
    _persistenceService.saveIsShuffled(_isShuffled);
  }

  void _startAudioListeners() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();

    _positionSub = _audioPlayer.positionStream.listen((pos) {
      if (_trackDuration > 0) {
        _position = pos.inMilliseconds / (_trackDuration * 1000);
      }
      notifyListeners();
    });

    _durationSub = _audioPlayer.durationStream.listen((dur) {
      if (dur != null) {
        _trackDuration = dur.inSeconds.toDouble();
      }
    });

    _playerStateSub = _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        if (_repeatMode == RepeatMode.one) {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.play();
        } else {
          next();
        }
      }
      notifyListeners();
    });
  }

  /// Start playing [song]. Optionally pass a [queue] which will be used
  /// for next/previous operations.
  Future<void> playSong(Song song, {List<Song>? queue}) async {
    _queue = queue ?? _allSongs;
    _currentIndex = _queue.indexOf(song);
    if (_currentIndex == -1) {
      _queue.add(song);
      _currentIndex = _queue.length - 1;
    }

    _currentSong = song;
    _trackDuration = song.duration;
    _position = 0.0;

    // prepare audio source
    try {
      if (song.filePath != null) {
        await _audioPlayer.setFilePath(song.filePath!);
      } else {
        // fallback to asset or url; not implemented
        _audioPlayer.setAsset('assets/album_placeholder.png');
      }
      _audioPlayer.play();
    } catch (e) {
      print('Error loading audio source: $e');
    }

    _startAudioListeners();
    _saveState();
    notifyListeners();
  }

  void togglePlayPause() {
    if (_currentSong == null) return;
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    _saveState();
  }

  void seek(double value) {
    if (_currentSong == null) return;
    final positionMs = (value.clamp(0.0, 1.0) * _trackDuration * 1000).toInt();
    _audioPlayer.seek(Duration(milliseconds: positionMs));
    _saveState();
  }

  void stop() {
    _audioPlayer.stop();
    _isPlaying = false;
    _saveState();
    notifyListeners();
  }

  /// Move to the next track in the queue
  void next() {
    if (_queue.isEmpty) return;
    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
    } else if (_repeatMode == RepeatMode.all) {
      _currentIndex = 0;
    } else {
      _isPlaying = false;
      _saveState();
      notifyListeners();
      return;
    }
    playSong(_queue[_currentIndex], queue: _queue);
  }

  /// Move to the previous track or restart
  void previous() {
    if (_queue.isEmpty) return;
    if (_position > 0.1) {
      _position = 0.0;
      _saveState();
      notifyListeners();
      return;
    }
    if (_currentIndex > 0) {
      _currentIndex--;
    } else if (_repeatMode == RepeatMode.all) {
      _currentIndex = _queue.length - 1;
    } else {
      _position = 0.0;
      _isPlaying = true;
      _saveState();
      notifyListeners();
      return;
    }
    playSong(_queue[_currentIndex], queue: _queue);
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    if (_isShuffled) {
      _queue = List.from(_queue)..shuffle();
      _currentIndex = _queue.indexOf(_currentSong!);
    } else {
      _queue = List.from(_allSongs);
      _currentIndex = _queue.indexOf(_currentSong!);
    }
    _saveState();
    notifyListeners();
  }

  void toggleRepeat() {
    switch (_repeatMode) {
      case RepeatMode.off:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.off;
        break;
    }
    _saveState();
    notifyListeners();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    _audioPlayer.dispose();
    _saveState();
    super.dispose();
  }
}

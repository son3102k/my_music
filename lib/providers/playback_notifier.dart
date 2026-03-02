import 'package:flutter/material.dart' hide RepeatMode;
import '../models/song.dart';
import '../models/repeat_mode.dart';
import '../data/sample_songs.dart';

/// Simple playback controller that holds the currently playing song and
/// playback state. In a real app this would talk to an audio engine.
import 'dart:async';

class PlaybackNotifier extends ChangeNotifier {
  // playback queue machinery
  List<Song> _queue = [];
  int _currentIndex = 0;
  bool _isShuffled = false;
  RepeatMode _repeatMode = RepeatMode.off;

  Song? _currentSong;
  bool _isPlaying = false;
  double _position = 0.0; // 0.0 - 1.0
  double _buffer = 1.0; // amount buffered/downloaded
  double _trackDuration = 180.0; // seconds
  Timer? _ticker;

  // expose some state
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  double get position => _position;
  double get buffer => _buffer;
  double get trackDuration => _trackDuration;
  bool get isShuffled => _isShuffled;
  RepeatMode get repeatMode => _repeatMode;

  // a fallback list of songs to build a queue when none is provided
  static const List<Song> _allSongs = sampleSongs;

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isPlaying) return;
      if (_trackDuration > 0) {
        final increment = 0.5 / _trackDuration;
        _position += increment;
      } else {
        _position += 0.01;
      }
      if (_position >= 1.0) {
        if (_repeatMode == RepeatMode.one) {
          // restart same track
          _position = 0.0;
        } else {
          timer.cancel();
          if (_repeatMode == RepeatMode.all) {
            next();
          } else {
            _isPlaying = false;
          }
        }
      }
      notifyListeners();
    });
  }

  /// Start playing [song]. Optionally pass a [queue] which will be used
  /// for next/previous operations. If no queue is provided we fall back to
  /// a built-in sample list.
  void playSong(Song song, {List<Song>? queue}) {
    _queue = queue ?? _allSongs;
    _currentIndex = _queue.indexOf(song);
    if (_currentIndex == -1) {
      // if not found, append to end
      _queue.add(song);
      _currentIndex = _queue.length - 1;
    }

    _currentSong = song;
    _trackDuration = song.duration;
    _isPlaying = true;
    _position = 0.0;
    notifyListeners();
    _startTicker();
  }

  void togglePlayPause() {
    if (_currentSong == null) return;
    if (_isPlaying) {
      _isPlaying = false;
    } else {
      // if already finished, restart from beginning
      if (_position >= 1.0) {
        _position = 0.0;
      }
      _isPlaying = true;
      _startTicker();
    }
    notifyListeners();
  }

  void seek(double value) {
    if (_currentSong == null) return;
    _position = value.clamp(0.0, 1.0);
    // optionally adjust buffer to at least position
    if (_buffer < _position) _buffer = _position;
    notifyListeners();
  }

  void stop() {
    _isPlaying = false;
    _ticker?.cancel();
    notifyListeners();
  }

  /// Move to the next track in the queue (or wrap/stop depending on settings).
  void next() {
    if (_queue.isEmpty) return;
    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
    } else if (_repeatMode == RepeatMode.all) {
      _currentIndex = 0;
    } else {
      // reached the end and no repeat
      _isPlaying = false;
      notifyListeners();
      return;
    }
    playSong(_queue[_currentIndex], queue: _queue);
  }

  /// Move to the previous track or restart the current one if playback has
  /// progressed past a reasonable threshold.
  void previous() {
    if (_queue.isEmpty) return;
    if (_position > 0.1) {
      _position = 0.0;
      notifyListeners();
      return;
    }
    if (_currentIndex > 0) {
      _currentIndex--;
    } else if (_repeatMode == RepeatMode.all) {
      _currentIndex = _queue.length - 1;
    } else {
      // at the start, just restart
      _position = 0.0;
      _isPlaying = true;
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
    notifyListeners();
  }
}

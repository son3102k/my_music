import 'package:flutter/material.dart';
import '../models/song.dart';

/// Simple playback controller that holds the currently playing song and
/// playback state. In a real app this would talk to an audio engine.
import 'dart:async';

class PlaybackNotifier extends ChangeNotifier {
  Song? _currentSong;
  bool _isPlaying = false;
  double _position = 0.0; // 0.0 - 1.0
  Timer? _ticker;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  double get position => _position;

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isPlaying) return;
      _position += 0.01;
      if (_position >= 1.0) {
        _position = 1.0;
        _isPlaying = false;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  void playSong(Song song) {
    _currentSong = song;
    _isPlaying = true;
    _position = 0.0;
    notifyListeners();
    _startTicker();
  }

  void togglePlayPause() {
    if (_currentSong == null) return;
    _isPlaying = !_isPlaying;
    notifyListeners();
    if (_isPlaying) {
      _startTicker();
    }
  }

  void seek(double value) {
    if (_currentSong == null) return;
    _position = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void stop() {
    _isPlaying = false;
    _ticker?.cancel();
    notifyListeners();
  }
}

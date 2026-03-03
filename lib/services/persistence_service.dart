import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  static final PersistenceService _instance = PersistenceService._internal();
  static SharedPreferences? _prefs;

  factory PersistenceService() {
    return _instance;
  }

  PersistenceService._internal();

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Save currently playing song ID
  Future<void> saveCurrentSongId(int? songId) async {
    if (songId == null) {
      await _prefs?.remove('current_song_id');
    } else {
      await _prefs?.setInt('current_song_id', songId);
    }
  }

  // Get currently playing song ID
  int? getCurrentSongId() {
    return _prefs?.getInt('current_song_id');
  }

  // Save playback position (0.0 - 1.0)
  Future<void> savePlaybackPosition(double position) async {
    await _prefs?.setDouble('playback_position', position);
  }

  // Get playback position
  double getPlaybackPosition() {
    return _prefs?.getDouble('playback_position') ?? 0.0;
  }

  // Save is playing state
  Future<void> saveIsPlaying(bool isPlaying) async {
    await _prefs?.setBool('is_playing', isPlaying);
  }

  // Get is playing state
  bool getIsPlaying() {
    return _prefs?.getBool('is_playing') ?? false;
  }

  // Save repeat mode
  Future<void> saveRepeatMode(String mode) async {
    await _prefs?.setString('repeat_mode', mode);
  }

  // Get repeat mode
  String getRepeatMode() {
    return _prefs?.getString('repeat_mode') ?? 'off';
  }

  // Save shuffle state
  Future<void> saveIsShuffled(bool isShuffled) async {
    await _prefs?.setBool('is_shuffled', isShuffled);
  }

  // Get shuffle state
  bool getIsShuffled() {
    return _prefs?.getBool('is_shuffled') ?? false;
  }

  // Save queue (list of song IDs)
  Future<void> saveQueue(List<int> songIds) async {
    await _prefs?.setStringList(
      'queue',
      songIds.map((id) => id.toString()).toList(),
    );
  }

  // Get queue
  List<int> getQueue() {
    final queue = _prefs?.getStringList('queue') ?? [];
    return queue.map((id) => int.parse(id)).toList();
  }

  // Save volume level
  Future<void> saveVolume(double volume) async {
    await _prefs?.setDouble('volume', volume);
  }

  // Get volume level
  double getVolume() {
    return _prefs?.getDouble('volume') ?? 1.0;
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}

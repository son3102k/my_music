import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/song.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_music.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        filePath TEXT UNIQUE NOT NULL,
        albumArt TEXT NOT NULL,
        duration REAL NOT NULL,
        dateAdded INTEGER NOT NULL
      )
    ''');
  }

  // Insert or replace a song
  Future<int> insertSong(Song song) async {
    final db = await database;
    return db.insert(
      'songs',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert multiple songs
  Future<void> insertSongs(List<Song> songs) async {
    final db = await database;
    final batch = db.batch();
    for (var song in songs) {
      batch.insert(
        'songs',
        song.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  // Get all songs
  Future<List<Song>> getAllSongs() async {
    final db = await database;
    final maps = await db.query('songs', orderBy: 'dateAdded DESC');
    return List.generate(maps.length, (i) => Song.fromMap(maps[i]));
  }

  // Get song by id
  Future<Song?> getSongById(int id) async {
    final db = await database;
    final maps = await db.query(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Song.fromMap(maps.first);
  }

  // Delete song
  Future<int> deleteSong(int id) async {
    final db = await database;
    return db.delete(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all songs
  Future<int> deleteAllSongs() async {
    final db = await database;
    return db.delete('songs');
  }

  // Search songs by title or artist
  Future<List<Song>> searchSongs(String query) async {
    final db = await database;
    final maps = await db.query(
      'songs',
      where: 'title LIKE ? OR artist LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'dateAdded DESC',
    );
    return List.generate(maps.length, (i) => Song.fromMap(maps[i]));
  }

  // Close database
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

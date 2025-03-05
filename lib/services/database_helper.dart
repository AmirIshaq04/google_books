import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:book_finder_flutter/models/book_data.dart'; 

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorite_books.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        id TEXT PRIMARY KEY,
        title TEXT,
        authors TEXT,
        thumbnail TEXT
      )
    ''');
  }

  // Add a book to favorites
  Future<void> addFavorite(Item book) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'id': book.id,
        'title': book.volumeInfo?.title,
        'authors': book.volumeInfo?.authors?.join(', '),
        'thumbnail': book.volumeInfo?.imageLinks?.thumbnail,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Remove a book from favorites
  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get all favorite books
  Future<List<Item>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        volumeInfo: VolumeInfo(
          title: maps[i]['title'],
          authors: maps[i]['authors']?.split(', '),
          imageLinks: ImageLinks(
            thumbnail: maps[i]['thumbnail'],
          ),
        ),
      );
    });
  }

  // Check if a book is in favorites
  Future<bool> isFavorite(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}
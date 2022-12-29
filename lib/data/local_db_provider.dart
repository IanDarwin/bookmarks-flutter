// Data Access for Bookmarks Data

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/bookmark.dart';

const bookmarkTableName = 'bookmarks';
const columnId = 'id';
const columnTopic = 'topic';
const columnUrl = ' url';
const columnText = 'text';
const allColumns = [columnId, columnTopic, columnUrl, columnText];

const topicTableName = 'topics';
const topicColumnId = 'id';
const topicColumnDetails = 'text';

/// Bookmark provider.
class LocalDbProvider {
  String path;
  LocalDbProvider(this.path) {
    open(path);
  }

  /// The database when opened.
  late Database _db;

  /// Open the database.
  Future<void> open(String path) async {
    debugPrint("LocalDbProvider.open($path)");
    _db = await openDatabase(path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database database, int version) async {
    debugPrint("In onCreate");
    await database.execute('''
create table $bookmarkTableName ( 
  $columnId integer primary key autoincrement, 
  $columnTopic text not null,
  $columnUrl text not null,
  $columnText text not null)
''');
    debugPrint("base = $database; db = $_db");
    for (Bookmark b in _demoList) {
      await database.execute('''
        insert into $bookmarkTableName($columnTopic,$columnUrl,$columnText)
        values('${b.topic}, ${b.url}, ${b.text}');
        ''');
    }
  }

  Future<void> _onUpgrade(Database base, int oldVersion, int newVersion) async {
    throw(Exception("onUpgrade not needed yet"));
  }

  // Initial demo list of bookmarks
  final List<Bookmark> _demoList = [
    Bookmark('banking', 'https://www.alrajhibank.com.sa/en', 'al-Rajhi Bank'),
    Bookmark('tech', 'https://darwinsys.com/', 'DarwinSys.com'),
    Bookmark('evs', 'https://IanOnEVs.com/', 'Ian On EVs'),
    Bookmark('photog', 'https://IanDarwinPhoto.com', 'Ian Darwin Photo'),
    Bookmark('education', 'https://learningtree.com', 'Learning Tree International'),
  ];

  // CRUD operations:

  /// "Create": Insert a Bookmark.
  Future<Bookmark> insert(Bookmark bookmark) async {
    debugPrint("LocalDbProvider::insert$bookmark");
    bookmark.id = await _db.insert(bookmarkTableName, bookmark.toMap());
    return bookmark;
  }

  /// "Read": Get a Bookmark.
  Future<Bookmark?> getBookmark(int id) async {
    final List<Map> maps = await _db.query(bookmarkTableName,
        columns: allColumns,
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Bookmark.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Bookmark>> getAllBookmarks() async {
    List<Bookmark> result = [];
    final List<Map> maps = await _db.query(bookmarkTableName);
    if (maps.isNotEmpty) {
      for (Map m in maps) {
        result.add(Bookmark.fromMap(m));
      } return result;
    } else {
      throw Exception("No records found");
    }
  }

  /// "Update" a Bookmark.
  Future<int?> update(Bookmark bookmark) async {
    return await _db.update(bookmarkTableName, bookmark.toMap(),
        where: '$columnId = ?', whereArgs: [bookmark.id!]);
  }

  /// "Delete" a Bookmark.
  Future<int?> delete(int id) async {
    return await _db.delete(bookmarkTableName, where: '$columnId = ?', whereArgs: [id]);
  }

  // CATEGORIES
  // Fake for now
  static final List<String> _categories = [
    "News",
    "Bookmark",
    "Reading",
    "Writing",
  ];

  List<String> get categories => _categories;

  /// Close database.
  Future close() async => _db.close();
}
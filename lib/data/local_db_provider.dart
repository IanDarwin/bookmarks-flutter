// Data Access for Bookmarks Data

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../model/bookmark.dart';
import '../model/topic.dart';

const bookmarkTableName = 'bookmarks';
const columnId = 'id';
const columnTopic = 'topic';
const columnUrl = ' url';
const columnText = 'text';
const columnRemoteId = "remoteId";
const allColumns = [columnId, columnTopic, columnUrl, columnText, columnRemoteId];

const topicTableName = 'topics';
const topicColumnId = 'id';
const topicColumnName = 'name';

/// Bookmark provider.
class LocalDbProvider {

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
    debugPrint("In onCreate; base = $database");
    await database.execute('''
create table $bookmarkTableName ( 
  $columnId integer primary key autoincrement, 
  $columnTopic text not null,
  $columnUrl text not null,
  $columnText text not null,
  $columnRemoteId text)
''');
    // Insert starter bookmark records
    for (Bookmark b in _demoList) {
      await database.execute('''
        insert into $bookmarkTableName($columnTopic,$columnUrl,$columnText)
        values('${b.topic_id}', '${b.url}', '${b.text}');
        ''');
    }

    await database.execute('''
create table $topicTableName ( 
$topicColumnId text not null,
$topicColumnName text not null)
''');
    for (Topic t in _demoTopicList) {
    await database.execute('''
        insert into $topicTableName($topicColumnId,$topicColumnName)
        values('${t.id}', '${t.name}');
        ''');
    }
  }

  Future<void> _onUpgrade(Database base, int oldVersion, int newVersion) async {
    throw(Exception("onUpgrade not needed yet"));
  }

  // Initial start list of Topic
  final List<Topic> _demoTopicList = [
    Topic('news', 'News'),
    Topic('res', 'Research'),
    Topic('read', 'To Read'),
    Topic('wri', 'Writing'),
  ];

  // Initial starter list of Bookmark
  final List<Bookmark> _demoList = [
    Bookmark('tech', 'https://darwinsys.com/', "DarwinSys.com - Ian''s site"),
    Bookmark('evs', 'https://IanOnEVs.com/', 'Ian On EVs'),
    Bookmark('education', 'https://learningtree.com', 'Learning Tree International'),
    Bookmark('news', 'https://TheGuardian.co.uk', 'The Guardian News'),
  ];

  // CATEGORIES
  // Hard-coded for now
  static final List<String> _categories = [
    "News",
    "Research",
    "To Read",
    "Writing",
  ];

  // CRUD operations:

  /// "Create": Insert a Bookmark.
  Future<Bookmark> insert(Bookmark bookmark) async {
    debugPrint("LocalDbProvider::insert$bookmark");
    var map = bookmark.toMap();
    map.remove("id");
    bookmark.id = await _db.insert(bookmarkTableName, map);
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
    final List<Map> maps = await _db.query(bookmarkTableName,
        orderBy: 'lower($columnText)');
    if (maps.isNotEmpty) {
      for (Map m in maps) {
        result.add(Bookmark.fromMap(m));
      }
    } else {
      result.add(Bookmark(null, null, "No bookmarks found - add some!"));
    }
    return result;
  }

  /// "Update" a Bookmark.
  Future<int?> update(Bookmark bookmark) async {
    return await _db.update(bookmarkTableName, bookmark.toMap(),
        where: '$columnId = ?', whereArgs: [bookmark.id]);
  }

  /// "Delete" a Bookmark.
  Future<int?> delete(int id) async {
    return await _db.delete(bookmarkTableName, where: '$columnId = ?', whereArgs: [id]);
  }

  List<String> get categories => _categories;

  /// Close database.
  Future close() async => _db.close();
}

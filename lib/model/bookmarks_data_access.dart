// Data Access for Bookmarks Data
// A placeholder for now.
import 'package:http/http.dart' as http;

import 'bookmark.dart';
import '../converters/bookmark_json.dart';

class BookmarksDataAccess {

  static final List<String> _categories = [
    "News",
    "ToDo",
    "Reading",
    "Writing",
  ];

  static List<String> get categories => _categories;

  static Future<int> addBookmark(Bookmark bookmark) async {

    var url = Uri.http('127.0.0.1:8080', 'bookmark');
    var request = http.Request('POST', url);
    request.body = BookmarkJson.toJson(bookmark);
    request.headers.addAll( {
      'content-type': 'application/json',
      'accept' : 'application/json',
    } );
    var response = await request.send();
    // print('Response status: ${response.statusCode}');
    if (response.statusCode != 200) {
      return -1;
    }
    int newId = int.parse(await response.stream.bytesToString());
    return newId;
  }
}

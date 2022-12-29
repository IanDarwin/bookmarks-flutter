import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'bookmark.dart';
import 'local_db_provider.dart';

class BookmarksHttpLoader {
  BookmarksHttpLoader(this.localdb);
  LocalDbProvider localdb;

  Future<int> addBookmark(Bookmark bookmark) async {

    // 1) Upload it
    try {
      var url = Uri.http('10.0.2.2:8080', 'bookmark');
      var request = http.Request('POST', url);
      request.body = bookmark.toJsonString();
      request.headers.addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
      });
      var response = await request.send();
      if (response.statusCode != 200) {
        print('Response status: ${response.statusCode}');
        return -1;
      }
      bookmark.id = int.parse(await response.stream.bytesToString());
    } catch (exception) {
      print("Upload didn't work: ${exception}");
      bookmark.id = -1;
    }
    //2 Save it locally with same ID
    await localdb.insert(bookmark);

    // 3) Return the new ID
    return bookmark.id!;
  }
}
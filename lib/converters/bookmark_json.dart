import 'dart:convert';

import '../model/bookmark.dart';

/// Converters between Bookmarks and JSON
class BookmarkJson {

  /// Convert a Bookmark to JSON for use on the back-end.
  /// Simple enough that we don't need an API for this step.
  /// The existing server implementation uses 'topic' instead of
  /// 'category' so we respect that in the JSON format.
  static String toJson(Bookmark b) {
    // edit with care - no trailing "," on last n-v pair in JSON, meh
    return """
\t{"bookmark":{
\t\t"id":${b.id!},
\t\t"topic":"${b.topic!}",
\t\t"url":"${b.url!}",
\t\t"text":"${b.text!}"
\t}}
""";
  }

  static Bookmark fromJson(String sb) {
    var json = jsonDecode(sb)["bookmark"];
    return Bookmark(json['topic'], json['url'], json['text'], id: json['id']);
  }
}

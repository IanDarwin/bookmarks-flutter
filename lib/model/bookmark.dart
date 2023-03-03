import 'dart:convert';

class Bookmark {
  int id;
  int remoteId = 0;
  String? topic_id;
  String? url;
  String? text;

  Bookmark(this.topic_id, this.url, this.text, {this.id = 0, this.remoteId = 0});

  factory Bookmark.empty() {
    return Bookmark(null, null, null);
  }

  factory Bookmark.fromJsonString(String sb) {
    var json = jsonDecode(sb)["bookmark"];
    return Bookmark.fromMap(json);
  }

  factory Bookmark.fromMap(Map m) {
    return Bookmark(m['topic'], m['url'], m['text'], id: m['id']);
  }

  toMap() {
    return {
      'id': id,
      'remoteId': remoteId,
      'topic': topic_id,
      'url' : url,
      'text' : text,
    };
  }

  /// Convert a Bookmark to JSON for use on the back-end.
  /// Simple enough that we don't need an API for this step.
  /// The existing server implementation uses 'topic' instead of
  /// 'category' so we respect that in the JSON format.
  String toJsonString() {
    // edit with care - no trailing "," on last n-v pair in JSON, meh
    return """
\t{"bookmark":{
\t\t"id":${id},
\t\t"topic":"${topic_id!}",
\t\t"url":"${url!}",
\t\t"text":"${text!}"
\t}}
""";
  }

  @override
  String toString() {
    return 'Bookmark[#$id $topic_id $url, "$text"]';
  }

  @override
  // hashCode intentionally left blank, for now
  bool operator==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    var spare = other as Bookmark;
    return spare.id==id &&
      spare.topic_id!.compareTo(spare.topic_id!) == 0 &&
      spare.url!.compareTo(spare.url!) == 0 &&
      spare.text!.compareTo(spare.text!) == 0;
  }
}

import 'dart:convert';

/// Represents one topic.
/// The id is a short form for the name, e.g., 'wri' and 'Writing'
class Topic {
  String id;
  String name;

  Topic(this.id, this.name);

  @override
  String toString() {
    return "Topic($id, $name)";
  }

  factory Topic.fromJsonString(String sb) {
    var json = jsonDecode(sb)["bookmark"];
    return Topic.fromMap(json);
  }

  factory Topic.fromMap(Map m) {
    return Topic(m['id'], m['name']);
  }

  toMap() {
    return {
      'topic_id': id,
      'name': name,
    };
  }
}
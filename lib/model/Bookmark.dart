class Bookmark {
  int? id;
  String? topic;
  String? url;
  String? text;

  Bookmark(this.topic, this.url, this.text, {this.id = 0});

  factory Bookmark.empty() {
    return Bookmark(null, null, null);
  }

  @override
  String toString() {
    return 'Bookmark[#$id $topic $url, "$text"]';
  }

  @override
  bool operator==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    var spare = other as Bookmark;
    return spare.id==id &&
      spare.topic!.compareTo(spare.topic!) == 0 &&
      spare.url!.compareTo(spare.url!) == 0 &&
      spare.text!.compareTo(spare.text!) == 0;
  }
}

class Bookmark {
  int? id;
  String? category;
  String? url;
  String? text;

  Bookmark(this.category, this.url, this.text, {this.id = 0});

  factory Bookmark.empty() {
    return Bookmark(null, null, null);
  }
  @override
  String toString() {
    return 'Bookmark[$category $url, "$text"';
  }
}
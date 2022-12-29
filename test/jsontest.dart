import 'package:bookmarks/model/bookmark.dart';
import 'package:test/test.dart';

void main() {
  // Individual test
  group("JSON Conversions", () {
  test('toJson', () {
    Bookmark bookmark = Bookmark('test', 'https://a.b.c', 'Marvelous new invention!');
    var expected = """
\t{"bookmark":{
\t\t"id":0,
\t\t"topic":"test",
\t\t"url":"https://a.b.c",
\t\t"text":"Marvelous new invention!"
\t}}
""";
    var actual = bookmark.toJsonString();
    expect(expected, actual);
  });

  test('FromJson', () {
    String json = '{"bookmark":{"id":42,"topic":"test","url":"https://a.b.c","text":"Grokkit!"}}';
    Bookmark expected = Bookmark("test", "https://a.b.c", "Grokkit!", id:42);
    var fromJson = Bookmark.fromJsonString(json);
    expect(fromJson, expected);
  });
});
}
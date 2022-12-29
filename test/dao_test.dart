import 'package:bookmarks/model/bookmark.dart';
import 'package:bookmarks/data/http_access.dart';
import 'package:bookmarks/data/local_db_provider.dart';
import 'package:test/test.dart';

void main() {
  BookmarksHttpLoader dao = BookmarksHttpLoader(LocalDbProvider(":memory:"));

  test("web service upload", () async {
    Bookmark b = Bookmark('econ', 'https://TEST.TEST', 'TEST TEST TEST');
    await dao.addBookmark(b);
  });
}
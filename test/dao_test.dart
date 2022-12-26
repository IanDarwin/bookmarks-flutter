import 'package:bookmarks/model/bookmark.dart';
import 'package:bookmarks/model/bookmarks_data_access.dart';
import 'package:test/test.dart';

void main() {
  test("web service upload", () async {
    Bookmark b = Bookmark('econ', 'https://TEST.TEST', 'TEST TEST TEST');
    await BookmarksDataAccess.addBookmark(b);
  });
}
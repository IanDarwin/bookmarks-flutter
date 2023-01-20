import 'package:bookmarks/main.dart';
import 'package:flutter/foundation.dart';

/// In order to ensure reliable operation in the face
/// of Bookmarks being created both on-device and on-server,
/// neither side can be "in charge of" assigning pkeys,
/// so, as long as we're using relational DBMS, we have
/// to keep two primary keys. These are identified
/// in the Bookmark class as id for local, and
/// remoteId for, well, remote.
/// The SyncService is in charge of reconciling them.
/// For now, this version only uploads new ones from here.
/// This should be run from a "cron" or similar mechanism
/// periodically, say, hourly.
class SyncService {
  static void run() async {
    debugPrint("In SyncService::run");
    List all = await localDbProvider.getAllBookmarks();
    for (var bookmark in all) {
      if (bookmark.remoteId == 0) {
        debugPrint("We should Upload $bookmark");
      }
    }}
}
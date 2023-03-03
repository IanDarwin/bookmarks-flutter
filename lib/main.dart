import 'package:bookmarks/data/local_db_provider.dart';
import 'package:bookmarks/ui/nav_drawer.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/sync_service.dart';
import 'edit_page.dart';
import 'intent_receiver.dart';
import 'model/bookmark.dart';

late LocalDbProvider localDbProvider ;

void main() async {
  // Set up local database
  WidgetsFlutterBinding.ensureInitialized();
  localDbProvider = LocalDbProvider();
  await localDbProvider.open('bookmarks.db');

  // Init Settings_Screens
  Settings.init();

  // Set up background job to synch with server
  final cron = Cron();
  cron.schedule(Schedule.parse('01 * * * *'), () async {
    debugPrint('hourly task running now');
    SyncService.run();
  });

  // Finally, run the app
  runApp(const MaterialApp(
    home: ListPage(title: "Browser-independent Bookmarks"),
  ));
}

/// A ListView-based StatefulWidget here,
/// with the FAB set to + to open an EditPage.
class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});
  final String title;
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  late Future<List<Bookmark>> _all;

  @override
  void initState() {
    IntentReceiver(localDbProvider).setupReceiving(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _pos;
    debugPrint("In _ListPageState.build()");
    _all = localDbProvider.getAllBookmarks();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const NavDrawer(),
      body:  ListView(
          children: <Widget>[
            FutureBuilder<List<Bookmark>>(
                future: _all,
                builder: (BuildContext context, AsyncSnapshot<List<Bookmark>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: snapshot.data!.map((bookmark) =>
                        GestureDetector(
                            onTapDown: (pos) {_pos = _getTapPosition(pos);},
                            onLongPress: () async {
                              final RenderObject? overlay =
                              Overlay.of(context).context.findRenderObject();
                              await showMenu(
                                context: context,
                                position: RelativeRect.fromRect(
                                    Rect.fromLTWH(_pos.dx, _pos.dy, 50, 50),
                                    Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                                        overlay.paintBounds.size.height)),
                                items: <PopupMenuEntry>[
                                  PopupMenuItem(
                                    onTap: () async {
                                      _edit(context, bookmark);
                                      setState( () => { });
                                    },
                                    child: Row(
                                      children: const <Widget>[
                                        Icon(Icons.edit),
                                        Text("Edit"),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () async {
                                      _delete(context, bookmark);
                                      setState( () => { });
                                    },
                                    child: Row(
                                      children: const <Widget>[
                                        Icon(Icons.delete),
                                        Text("Delete"),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                        child: ListTile(
                          leading: const Icon(Icons.open_in_browser_outlined),
                          title: Text(bookmark.text!),
                          subtitle: Text(bookmark.url!),
                          onTap: () => _launchUrl(bookmark.url),
                        )
                        )
                    ).toList());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong! See logs"));
                  }
                  // Still here, so must be still in progress...
                  return const CircularProgressIndicator();
                }
            )
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => (EditPage(localDbProvider, Bookmark.empty()))));
          // BuildContext used from a StatefulWidget, 'mounted'
          // MUST be checked after an asynchronous gap.
          if (!mounted) {
            return;
          }
          setState( () {} );
        },
        tooltip: 'Add bookmark',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _launchUrl(urlStr) async {
    var url = Uri.parse(urlStr);
    if (!await launchUrl(url)) {
      throw 'Could not launch $urlStr';
    }
  }

  Offset _getTapPosition(TapDownDetails tapPosition) {
    debugPrint("Tapped!");
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    return referenceBox.globalToLocal(tapPosition.globalPosition);
  }

  _edit(BuildContext context, Bookmark bookmark) async {
    debugPrint("Edit");
    Future.delayed(
        const Duration(seconds: 0),
            () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => (EditPage(localDbProvider, bookmark)))));
  }

  _delete(BuildContext context, Bookmark bookmark) async {
    debugPrint("In _delete");
    await localDbProvider.delete(bookmark.id);
  }
}

alert(BuildContext context, String message, {title = 'Error', actions}) async {
  debugPrint("alert('$message')");
  showDialog<void>(
      context: context,
      barrierDismissible: true, // must tap a button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: actions ?? <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      }
  );
}


import 'package:bookmarks/data/local_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'edit_page.dart';
import 'intent_receiver.dart';
import 'model/bookmark.dart';

late LocalDbProvider localDbProvider ;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  localDbProvider = LocalDbProvider();
  await localDbProvider.open('bookmarks.db');
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
      body:  ListView(
          children: <Widget>[
            FutureBuilder<List<Bookmark>>(
                future: _all,
                builder: (BuildContext context, AsyncSnapshot<List<Bookmark>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: snapshot.data!.map((bookmark) =>
                        GestureDetector(
                            onTapDown: (pos) {_pos = _getTapPosition(pos);},
                            //onTap: () => alert(context, bookmark.url!, title: bookmark.text!),
                            onLongPress: () async {
                              final RenderObject? overlay =
                              Overlay.of(context)?.context.findRenderObject();
                              await showMenu(
                                context: context,
                                position: RelativeRect.fromRect(
                                    Rect.fromLTWH(_pos.dx, _pos.dy, 50, 50),
                                    Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                                        overlay.paintBounds.size.height)),
                                items: <PopupMenuEntry>[
                                  PopupMenuItem(
                                    onTap: () async => setState( () => _edit(context, bookmark)),
                                    child: Row(
                                      children: const <Widget>[
                                        Icon(Icons.edit),
                                        Text("Edit"),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () async => setState( () => _delete(context, bookmark)),
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
          Bookmark results = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => (EditPage(localDbProvider))));
          // BuildContext used from a StatefulWidget, 'mounted'
          // MUST be checked after an asynchronous gap.
          if (!mounted) {
            return;
          }
          // Value of -1 here indicates Cancel was pressed, so no item
          // saved, and thus don't need to rebuild.
          if (results.id == -1) {
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
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    return referenceBox.globalToLocal(tapPosition.globalPosition);
  }

  _edit(BuildContext context, Bookmark bookmark) {
    debugPrint("Edit code not written yet, Sorry");
  }

  _delete(BuildContext context, Bookmark bookmark) {
    debugPrint("In _delete");
    localDbProvider.delete(bookmark.id!);
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


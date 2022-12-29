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
    debugPrint("In _ListPageState.build()");
    _all = localDbProvider.getAllBookmarks();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:  ListView(
          children:  <Widget>[
      FutureBuilder<List<Bookmark>>(
        future: _all,
        builder: (BuildContext context, AsyncSnapshot<List<Bookmark>> snapshot) {
          if (snapshot.hasData) {
            return Column(children: snapshot.data!.map((bookmark) =>
                ListTile(
                  leading: const Icon(Icons.open_in_browser_outlined),
                  title: Text(bookmark.text!),
                  subtitle: Text(bookmark.url!),
                  onTap: () => _launchUrl(bookmark.url),
                )).toList());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong! See logs"));
          }
          // Still here, so must be still in progress...
          return const Center(child: Text('Loading...'));
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
}

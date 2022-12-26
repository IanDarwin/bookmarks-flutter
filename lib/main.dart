import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'edit_page.dart';
import 'intent_receiver.dart';
import 'model/bookmark.dart';

void main() => runApp(
    MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const ListPage(title: "Browser-indie Bookmarks")));

List<Bookmark> listData = [
  Bookmark('banking', 'https://www.alrajhibank.com.sa/en', 'al-Rajhi Bank'),
  Bookmark('tech', 'https://darwinsys.com/', 'DarwinSys.com'),
  Bookmark('evs', 'https://IanOnEVs.com/', 'Ian On EVs'),
  Bookmark('photog', 'https://IanDarwinPhoto.com', 'Ian Darwin Photo'),
  Bookmark('education', 'https://learningtree.com', 'Learning Tree International'),
];

/// A ListView-based StatefulWidget here,
/// with the FAB set to + to open an EditPage.
class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});
  final String title;
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  @override
  void initState() {
    IntentReceiver().setupReceiving(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    debugPrint("In _ListPageState.build()");
    listData.sort((b1, b2) => b1.text!.toLowerCase().compareTo(b2.text!.toLowerCase()));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:  ListView(
          children: listData.map((bookmark) =>
            ListTile(
              leading: const Icon(Icons.open_in_browser_outlined),
              title: Text(bookmark.text!),
              subtitle: Text(bookmark.url!),
              onTap: () => _launchUrl(bookmark.url),
            ),
          ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Bookmark results = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => (const EditPage())));
          // BuildContext used from a StatefulWidget, 'mounted'
          // MUST be checked after an asynchronous gap.
          if (!mounted) {
            return;
          }
          if (results.id == -1) {
            return;
          }
          setState( () => listData.add(results) );
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
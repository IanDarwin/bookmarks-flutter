import 'package:flutter/material.dart';

import 'edit_page.dart';
import 'model/Bookmark.dart';

/// This version of the app only provides an Edit/View page.
/// The next version will likely have a ListView here.
void main() => runApp(
    MaterialApp(home: const ListPage(title: "Browser-indie Bookmarks")));

List<Bookmark> listData = [
  Bookmark('tech', 'https://darwinsys.com/', 'DarwinSys.com'),
  Bookmark('evs', 'https://IanOnEVs.com/', 'Ian On EVs'),
  Bookmark('photog', 'https://IanDarwinPhoto.com', 'Ian Darwin Photo'),
];

/// A ListView-based StatefulWidget here,
/// with the FAB set to + to open an EditPage.
// XXX NB Move the Intent registration stuff here, and
// launch an EditPage as needed.
class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});
  final String title;
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  @override
  Widget build(BuildContext context) {
    debugPrint("In _ListPageState.build()");
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
            ),
          ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => (const EditPage()))),
        tooltip: 'Add bookmark',
        child: const Icon(Icons.add),
      ),
    );
  }
}
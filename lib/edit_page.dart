import 'package:bookmarks/data/local_db_provider.dart';
import 'package:flutter/material.dart';

import 'model/bookmark.dart';

// Called with a URL when launched from an intent,
// called without a URL when launched from the + button.
class EditPage extends StatefulWidget {
  final String? url;
  final LocalDbProvider localDbProvider;
  final Bookmark bookmark;
  const EditPage(this.localDbProvider, this.bookmark, {this.url, super.key});

  @override
  EditPageState createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _focusNode;
  late Bookmark _bookmark;

  @override
  void initState() {
    debugPrint("EditPageState.initState()");
    _bookmark = widget.bookmark;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("EditPageState.build()");
    // Stash value here b/c onChanged isn't triggered when 'share' used
	  // But don't overwrite if we're editing.
    _bookmark.url ??= widget.url;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarks app'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(children: [
                Expanded(child:TextFormField(maxLength: 1024,
                    //focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "URL",
                    ),
                    keyboardType: TextInputType.url,
                    initialValue: _bookmark.url ?? "https://",
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (s) => s!.startsWith("https://") && s!.length > 8 ?
                      null :
                      "An 'HTTPS:' URL please",
                    onChanged: (s) => _bookmark.url = s,
                    onSaved: (s) => _bookmark.url = s,
                    )
                ),
              ]),
              Row(children: [
                Expanded(child:TextFormField(maxLength: 128,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Description",
                    ),
                    initialValue: _bookmark.text,
                    textCapitalization: TextCapitalization.sentences,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (s) => s!.isEmpty ? 'Title required' : null,
                    onChanged: (s) => _bookmark.text = s,
                    onSaved: (s) => _bookmark.text = s,
                    ),
                ),
              ]),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Category",
                ),
                // value: _bookmark.topic,
                isExpanded: true,
                items: widget.localDbProvider.categories.map((String cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value) => { _bookmark.topic = value! },
                validator: (s) => s == null || s == 'Required' ? "Category required" : null,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      debugPrint("'Cancel command accepted.'");
                      _bookmark.id = -1;  // poison, can't pass null
                      Navigator.pop(context, _bookmark);
                    }),
                ElevatedButton(
                    child: const Text("Save/Update"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        debugPrint("Save/Update($_bookmark)");
                        if (_bookmark.id == 0) {
                          widget.localDbProvider.insert(_bookmark);
                        } else {
                          widget.localDbProvider.update(_bookmark);
                        }
                        Navigator.pop(context, _bookmark);
                      } else {
                        FocusScope.of(context).requestFocus(_focusNode);
                      }
                    }),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

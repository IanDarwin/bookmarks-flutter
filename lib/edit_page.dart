import 'package:bookmarks/model/bookmarks_data_access.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'model/bookmark.dart';

class EditPage extends StatefulWidget {
  final String? url;
  const EditPage({super.key, this.url});

  @override
  EditPageState createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _focusNode;
  final Bookmark _bookmark = Bookmark.empty();

  @override
  Widget build(BuildContext context) {

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
                    initialValue: widget.url ?? "",
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (s) => s!.startsWith("https://") ? null : "An 'HTTPS:' URL please",
                    onChanged: (s) => _bookmark.url = s,
                    onSaved: (s) => _bookmark.url = s,
                    )
                ),
              ]),
              Row(children: [
                Expanded(child:TextFormField(maxLength: 128,
                    //focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Description",
                    ),
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
                // value: _selectedCategory,
                isExpanded: true,
                items: BookmarksDataAccess.categories.map((String cat) {
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

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'model/Bookmark.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  EditPageState createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  final Bookmark _bookmark = Bookmark.empty();
  late StreamSubscription _intentDataStreamSubscription;
  // This will become dynamic
  final List<String> _categories = [
    "ToDo",
    "Reading",
    "Writing",
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // For sharing or opening urls/text coming from outside the app while the app is in memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
          setState(() {
            _bookmark.url = value;
            debugPrint("Received Share: ${_bookmark.url}");
          });
        }, onError: (err) {
          debugPrint("getLinkStream error: $err");
        });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        _bookmark.url = value;
        if (_bookmark.url != null) {
          debugPrint("Received Share: $_bookmark.url");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var urlController = TextEditingController(text: _bookmark.url);
    var titleController = TextEditingController(text: _bookmark.text);

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
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (s) => s!.startsWith("https://") ? null : "An 'HTTPS:' URL please",
                    controller: urlController)),
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
                    controller: titleController),
                ),
              ]),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Category",
                ),
                // value: _selectedCategory,
                isExpanded: true,
                items: _categories.map((String cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value) => { _bookmark.category = value! },
                validator: (s) => s == null || s == 'Required' ? "Category required" : null,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      debugPrint("'Cancel command accepted.'");
                    }),
                ElevatedButton(
                    child: const Text("Save/Update"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        debugPrint("Save/Update($_bookmark)");
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

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }
}

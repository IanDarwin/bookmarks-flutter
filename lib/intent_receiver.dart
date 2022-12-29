import 'package:bookmarks/model/local_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'edit_page.dart';

class IntentReceiver {
  LocalDbProvider localDbProvider;

  IntentReceiver(this.localDbProvider);

  void setupReceiving(BuildContext context) {
    // For sharing or opening urls/text coming from outside the app while the app is in memory
    ReceiveSharingIntent.getTextStream().listen((String value) {
      debugPrint("Received TextStream Share: $value");
      _launchEditor(context, value);
    }, onError: (err) {
      debugPrint("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      debugPrint("Received initialText Share: $value");
      _launchEditor(context, value);
    });
  }

  void _launchEditor(context, value) {
    if (value == null) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditPage(localDbProvider, url: value)));
  }
}

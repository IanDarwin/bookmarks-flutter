

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../constants.dart';

/// Activity for Settings.
///
class SettingsPage extends StatefulWidget {

  @override
  SettingsState createState() => new SettingsState();

}

class SettingsState extends State<SettingsPage> {

  SettingsState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SettingsScreen(title: "Bookmark Settings",
        children: [
          SettingsGroup(title: "Connection",
              children: [
                TextInputSettingsTile(
                  title: "Backend URL",
                  settingKey: Constants.keyUrl,
                  keyboardType: TextInputType.url,
                  validator: (instrName) {
                    if (instrName != null && instrName.startsWith("https://"))
                      return null;
                    return "Valid https backend is required";
                  },
                  errorColor: Colors.redAccent,
                ),
                TextInputSettingsTile(
                  title: "Username",
                  settingKey: Constants.keyUserName,
                  keyboardType: TextInputType.name,
                  validator: (name) {
                    if (name != null && name.isNotEmpty) {
                      return null;
                    };
                    return "Username on server is required";
                  },
                  errorColor: Colors.redAccent,
                ),
                TextInputSettingsTile(
                  title: "Password",
                  settingKey: Constants.keyPass,
                  keyboardType: TextInputType.text,

                  validator: (pw) {
                    if (pw != null && pw.isNotEmpty)
                      return null;
                    return "Password required";
                  },
                  errorColor: Colors.redAccent,
                ),
              ]),

          SettingsGroup(
            title: "Personalization",
            children: [
              SwitchSettingsTile(
                title: "Dark mode",
                  leading: Icon(Icons.dark_mode),
                  settingKey: Constants.keyDarkMode,
                  onChange: (val) {
                    // XXX MAKE IT SO!!!!!
                  })
              ],
        )
      ]
    );
  }

  @override
  void dispose() {
	  // Do we need anything here?
	  super.dispose();
  }
}



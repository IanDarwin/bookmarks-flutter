import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:icheckin/config/ops_units.dart';
import 'package:icheckin/constants.dart';
import 'package:icheckin/main.dart' show prefs, storage;
import 'package:icheckin/ui/ui_utils.dart';

int defaultCourseLength = 3;
bool defaultSaveToCal = true;

Future<String> getInstrCode() async {
  return await storage.read(key: Constants.KEY_CODE);
}

/// Activity for Settings.
///
class SettingsPage extends StatefulWidget {

  @override
  SettingsState createState() => new SettingsState();

}

class SettingsState extends State<SettingsPage> {

  OpsUnit defaultOpsUnit;
  final Map<int,String> opsUnitMap = Map();

  SettingsState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SettingsScreen(title: "Bookmark Settings",
        children: <Widget>[
          SettingsGroup(title: "Connection",
              children: [
                TextInputSettingsTile(
                  title: "Backend URL",
                  settingKey: Constants.KEY_NAME,
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
                  settingKey: Constants.KEY_PHONE,
                  keyboardType: TextInputType.name,
                  validator: (name) {
                    if (name != null && name.isNotEmpty)
                      return null;
                    return "Username on server is required";
                  },
                  errorColor: Colors.redAccent,
                ),
                TextInputSettingsTile(
                  title: "Password",
                  settingKey: Constants.KEY_CODE,
                  keyboardType: TextInputType.text),
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
                  settingKey: Constants.KEY_DARK_MODE,
                  onChange: (val) {
                    alert(context, "Change will take effect on app restart",
                        title:'Dark Mode ${val?'on':'off'}');
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



import 'package:flutter/material.dart';

import 'settings_page.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  build(context) {
    return Drawer(
      child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.none,
                      image: AssetImage('images/logo.png'))
              ),
              child: Text(
                'Bookmarks Menu',
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.input),
              title: const Text('Bookmarks Intro/Help'),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SettingsPage()))
              },
            ),
            const AboutListTile(
              icon: Icon(Icons.info),
              applicationName:  'Bookmarks',
              aboutBoxChildren: [
               Text("Bookmarks for Flutter"),
              ],
            ),
          ]),
    );
  }
}

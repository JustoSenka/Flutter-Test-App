import 'package:aibstract_app/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settingsPageTitle),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Column(children: <Widget>[
            RaisedButton(
              child: Text("Reset Logon State"),
              onPressed: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setBool(Keys.loggedIn, false);
                });
              },
            ),
          ]),
        ),
      )),
    );
  }
}

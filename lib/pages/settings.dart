import 'package:aibstract_app/services/analytics.dart';
import 'package:aibstract_app/services/authentication.dart';
import 'package:aibstract_app/utils/strings.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {

  SettingsPage(this.auth, this.analytics) {}
  final BaseAuth auth;
  final BaseAnalytics analytics;

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
                print("Setting logged in as false.");
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setBool(Keys.loggedIn, false);
                });
              },
            ),
            RaisedButton(
              child: Text("Send Analytics Event"),
              onPressed: () {
                print("Sending analytics.");
                analytics.logEvent('test_analytics_event');
              },
            ),
            RaisedButton(
              child: Text("Crash"),
              onPressed: () {
                throw Exception("Test Crash Happened");
              },
            ),
          ]),
        ),
      )),
    );
  }
}

import 'dart:io';

import 'package:aibstract_app/pages/login.dart';
import 'package:aibstract_app/services/analytics.dart';
import 'package:aibstract_app/services/authentication.dart';
import 'package:aibstract_app/utils/common_widgets.dart';
import 'package:aibstract_app/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';

class HomePage extends StatefulWidget {
  HomePage(this.auth, this.analytics, {this.user}) {}
  final BaseAuth auth;
  final BaseAnalytics analytics;
  final FirebaseUser user;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    print('Home Init');

    _isSignedIn = widget.user != null;
    print('Home, is signed in: $_isSignedIn');

    /*
    widget.auth.getCurrentUser().then((user) {
      _user = user;

      if (_user != null) {
        print('User got from firebase');
        setState(() {
          _isSignedIn = true;
        });
      } else {
        print('User not logged in in firebase');
        Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
            builder: (ctx) => LoginPage(widget.auth, widget.analytics)));
      }
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showDrawer(),
      appBar: AppBar(
        title: Text(Strings.homePageTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (ctx) =>
                      SettingsPage(widget.auth, widget.analytics)));
            },
          ),
        ],
      ),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    if (!_isSignedIn) return CommonWidgets.circularLoadingProgress(true);

    return Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              showLogoBox(),
            ],
          ),
        ),
      ),
    );
  }

  Drawer showDrawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                Text('User data: '),
                Text(widget.user.displayName),
                Text(widget.user.email),
                Text(widget.user.uid),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Sign out'),
            onTap: () {
              Navigator.of(context).pop();
              widget.auth.signOut().then((_){
                Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (ctx) => LoginPage(widget.auth, widget.analytics)));
              });

              SharedPreferences.getInstance().then((prefs) {
                prefs.setBool(Keys.loggedIn, false);
              });
            },
          ),
        ],
      ),
    );
  }

  Image showLogoBox() {
    return Image.asset(
      "assets/logo.png",
      fit: BoxFit.contain,
    );
  }
}

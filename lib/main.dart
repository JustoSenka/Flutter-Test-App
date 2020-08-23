import 'dart:io';

import 'package:aibstract_app/services/analytics.dart';
import 'package:aibstract_app/services/authentication.dart';
import 'package:aibstract_app/utils/common_widgets.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home.dart';
import 'pages/login.dart';
import 'utils/strings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final analytics = new Analytics(FirebaseAnalytics());
  final auth = new Auth();

  analytics.logAppOpen();

  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runApp(MyApp(analytics: analytics, auth: auth));
}

class MyApp extends StatelessWidget {
  MyApp({this.analytics, this.auth}) {}
  final BaseAnalytics analytics;
  final BaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.materialAppTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(auth, analytics),
      initialRoute: '/StartupPage',
      routes: {'/StartupPage': (ctx) => StartupPage(auth, analytics)},
    );
  }
}

class StartupPage extends StatelessWidget {
  StartupPage(this.auth, this.analytics) {}
  final BaseAuth auth;
  final BaseAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    print('Startup page');
    auth.getCurrentUser().then((user) {
      final isLoggedIn = user != null;
      print('User logged in: $isLoggedIn');

      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
            builder: (ctx) => HomePage(auth, analytics, user: user)));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
            builder: (ctx) => LoginPage(auth, analytics)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.homePageTitle),
      ),
      body: CommonWidgets.circularLoadingProgress(true),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = List<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  // #enddocregion RWS-var

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(WordPair pair) {
    final isSaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        isSaved ? Icons.favorite : Icons.favorite_border,
        color: isSaved ? Colors.red : Colors.grey,
      ),
      onTap: () {
        setState(() {
          if (!isSaved)
            _saved.add(pair);
          else
            _saved.remove(pair);
        });
      },
    );
  }

  // #enddocregion _buildRow

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

// #enddocregion RWS-build
// #docregion RWS-var

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }
}

// #enddocregion RWS-var

[1mdiff --git a/lib/main.dart b/lib/main.dart[m
[1mindex fe894b2..0a8c7dd 100644[m
[1m--- a/lib/main.dart[m
[1m+++ b/lib/main.dart[m
[36m@@ -1,125 +1,94 @@[m
 import 'package:flutter/material.dart';[m
[32m+[m[32mimport 'package:english_words/english_words.dart';[m
 [m
[31m-void main() {[m
[31m-  runApp(MyApp());[m
[31m-}[m
[32m+[m[32mvoid main() => runApp(MyApp());[m
 [m
[32m+[m[32m// #docregion MyApp[m
 class MyApp extends StatelessWidget {[m
[31m-  // This widget is the root of your application.[m
[32m+[m[32m  // #docregion build[m
   @override[m
   Widget build(BuildContext context) {[m
     return MaterialApp([m
[31m-      title: 'Flutter Demo',[m
[31m-      theme: ThemeData([m
[31m-        // This is the theme of your application.[m
[31m-        //[m
[31m-        // Try running your application with "flutter run". You'll see the[m
[31m-        // application has a blue toolbar. Then, without quitting the app, try[m
[31m-        // changing the primarySwatch below to Colors.green and then invoke[m
[31m-        // "hot reload" (press "r" in the console where you ran "flutter run",[m
[31m-        // or simply save your changes to "hot reload" in a Flutter IDE).[m
[31m-        // Notice that the counter didn't reset back to zero; the application[m
[31m-        // is not restarted.[m
[31m-        primarySwatch: Colors.blue,[m
[31m-        // This makes the visual density adapt to the platform that you run[m
[31m-        // the app on. For desktop platforms, the controls will be smaller and[m
[31m-        // closer together (more dense) than on mobile platforms.[m
[31m-        visualDensity: VisualDensity.adaptivePlatformDensity,[m
[31m-      ),[m
[31m-      home: MyHomePage(title: 'Aibstract Demo'),[m
[31m-[m
[32m+[m[32m      title: 'Startup Name Generator',[m
[32m+[m[32m      home: RandomWords(),[m
     );[m
   }[m
[32m+[m[32m// #enddocregion build[m
 }[m
[32m+[m[32m// #enddocregion MyApp[m
 [m
[31m-class MyHomePage extends StatefulWidget {[m
[31m-  MyHomePage({Key key, this.title}) : super(key: key);[m
 [m
[31m-  // This widget is the home page of your application. It is stateful, meaning[m
[31m-  // that it has a State object (defined below) that contains fields that affect[m
[31m-  // how it looks.[m
[32m+[m[32mclass RandomWords extends StatefulWidget {[m
[32m+[m[32m  @override[m
[32m+[m[32m  RandomWordsState createState() => new RandomWordsState();[m
[32m+[m[32m}[m
 [m
[31m-  // This class is the configuration for the state. It holds the values (in this[m
[31m-  // case the title) provided by the parent (in this case the App widget) and[m
[31m-  // used by the build method of the State. Fields in a Widget subclass are[m
[31m-  // always marked "final".[m
[32m+[m[32mclass RandomWordsState extends State<RandomWords> {[m
[32m+[m[32m  final _suggestions = <WordPair>[];[m
[32m+[m[32m  final _saved = List<WordPair>();[m
[32m+[m[32m  final _biggerFont = const TextStyle(fontSize: 18.0);[m
[32m+[m[32m  // #enddocregion RWS-var[m
 [m
[31m-  final String title;[m
[32m+[m[32m  // #docregion _buildSuggestions[m
[32m+[m[32m  Widget _buildSuggestions() {[m
[32m+[m[32m    return ListView.builder([m
[32m+[m[32m        padding: const EdgeInsets.all(16.0),[m
[32m+[m[32m        itemBuilder: /*1*/ (context, i) {[m
[32m+[m[32m          if (i.isOdd) return Divider(); /*2*/[m
 [m
[31m-  @override[m
[31m-  _MyHomePageState createState() => _MyHomePageState();[m
[31m-}[m
[32m+[m[32m          final index = i ~/ 2; /*3*/[m
[32m+[m[32m          if (index >= _suggestions.length) {[m
[32m+[m[32m            _suggestions.addAll(generateWordPairs().take(10)); /*4*/[m
[32m+[m[32m          }[m
[32m+[m[32m          return _buildRow(_suggestions[index]);[m
[32m+[m[32m        });[m
[32m+[m[32m  }[m
[32m+[m[32m  // #enddocregion _buildSuggestions[m
 [m
[31m-class _MyHomePageState extends State<MyHomePage> {[m
[31m-  int _counter = 0;[m
[32m+[m[32m  // #docregion _buildRow[m
[32m+[m[32m  Widget _buildRow(WordPair pair) {[m
[32m+[m[32m    final isSaved = _saved.contains(pair);[m
 [m
[31m-  void _incrementCounter() {[m
[31m-    setState(() {[m
[31m-      // This call to setState tells the Flutter framework that something has[m
[31m-      // changed in this State, which causes it to rerun the build method below[m
[31m-      // so that the display can reflect the updated values. If we changed[m
[31m-      // _counter without calling setState(), then the build method would not be[m
[31m-      // called again, and so nothing would appear to happen.[m
[31m-      _counter++;[m
[31m-    });[m
[32m+[m[32m    return ListTile([m
[32m+[m[32m      title: Text([m
[32m+[m[32m        pair.asPascalCase,[m
[32m+[m[32m        style: _biggerFont,[m
[32m+[m[32m      ),[m
[32m+[m[32m      trailing: Icon([m
[32m+[m[32m        isSaved ? Icons.favorite : Icons.favorite_border,[m
[32m+[m[32m        color:  isSaved ? Colors.red : Colors.grey,[m
[32m+[m[32m      ),[m
[32m+[m[32m      onTap: () {[m
[32m+[m[32m        setState(() {[m
[32m+[m[32m          if (!isSaved)[m
[32m+[m[32m            _saved.add(pair);[m
[32m+[m[32m          else[m
[32m+[m[32m            _saved.remove(pair);[m
[32m+[m[32m        });[m
[32m+[m[32m      },[m
[32m+[m[32m    );[m
   }[m
[32m+[m[32m  // #enddocregion _buildRow[m
 [m
[32m+[m[32m  // #docregion RWS-build[m
   @override[m
   Widget build(BuildContext context) {[m
[31m-    // This method is rerun every time setState is called, for instance as done[m
[31m-    // by the _incrementCounter method above.[m
[31m-    //[m
[31m-    // The Flutter framework has been optimized to make rerunning build methods[m
[31m-    // fast, so that you can just rebuild anything that needs updating rather[m
[31m-    // than having to individually change instances of widgets.[m
     return Scaffold([m
       appBar: AppBar([m
[31m-        // Here we take the value from the MyHomePage object that was created by[m
[31m-        // the App.build method, and use it to set our appbar title.[m
[31m-        title: Text(widget.title),[m
[31m-      ),[m
[31m-      body: Center([m
[31m-        // Center is a layout widget. It takes a single child and positions it[m
[31m-        // in the middle of the parent.[m
[31m-        child: Column([m
[31m-          // Column is also a layout widget. It takes a list of children and[m
[31m-          // arranges them vertically. By default, it sizes itself to fit its[m
[31m-          // children horizontally, and tries to be as tall as its parent.[m
[31m-          //[m
[31m-          // Invoke "debug painting" (press "p" in the console, choose the[m
[31m-          // "Toggle Debug Paint" action from the Flutter Inspector in Android[m
[31m-          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)[m
[31m-          // to see the wireframe for each widget.[m
[31m-          //[m
[31m-          // Column has various properties to control how it sizes itself and[m
[31m-          // how it positions its children. Here we use mainAxisAlignment to[m
[31m-          // center the children vertically; the main axis here is the vertical[m
[31m-          // axis because Columns are vertical (the cross axis would be[m
[31m-          // horizontal).[m
[31m-          mainAxisAlignment: MainAxisAlignment.center,[m
[31m-          children: <Widget>[[m
[31m-            ButtonBar([m
[31m-              children: <Widget>[[m
[31m-                  Text([m
[31m-                    'text'[m
[31m-                  )[m
[31m-              ],[m
[31m-            ),[m
[31m-            Text([m
[31m-              'You have pushed the button this many times:',[m
[31m-            ),[m
[31m-            Text([m
[31m-              '$_counter',[m
[31m-              style: Theme.of(context).textTheme.headline4,[m
[31m-            ),[m
[31m-          ],[m
[31m-        ),[m
[32m+[m[32m        title: Text('Startup Name Generator'),[m
[32m+[m[32m        actions: [[m
[32m+[m[32m          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),[m
[32m+[m[32m        ],[m
       ),[m
[31m-      floatingActionButton: FloatingActionButton([m
[31m-        onPressed: _incrementCounter,[m
[31m-        tooltip: 'Increment',[m
[31m-        child: Icon(Icons.add),[m
[31m-      ), // This trailing comma makes auto-formatting nicer for build methods.[m
[32m+[m[32m      body: _buildSuggestions(),[m
     );[m
   }[m
[32m+[m[32m// #enddocregion RWS-build[m
[32m+[m[32m// #docregion RWS-var[m
[32m+[m
[32m+[m[32m  void _pushSaved() {[m
[32m+[m
[32m+[m[32m  }[m
 }[m
[32m+[m[32m// #enddocregion RWS-var[m
[41m+[m
[1mdiff --git a/pubspec.lock b/pubspec.lock[m
[1mindex ea61056..8feac17 100644[m
[1m--- a/pubspec.lock[m
[1m+++ b/pubspec.lock[m
[36m@@ -50,6 +50,13 @@[m [mpackages:[m
       url: "https://pub.dartlang.org"[m
     source: hosted[m
     version: "0.1.3"[m
[32m+[m[32m  english_words:[m
[32m+[m[32m    dependency: "direct main"[m
[32m+[m[32m    description:[m
[32m+[m[32m      name: english_words[m
[32m+[m[32m      url: "https://pub.dartlang.org"[m
[32m+[m[32m    source: hosted[m
[32m+[m[32m    version: "3.1.5"[m
   fake_async:[m
     dependency: transitive[m
     description:[m
[1mdiff --git a/pubspec.yaml b/pubspec.yaml[m
[1mindex efc8969..48623e2 100644[m
[1m--- a/pubspec.yaml[m
[1m+++ b/pubspec.yaml[m
[36m@@ -24,10 +24,10 @@[m [mdependencies:[m
   flutter:[m
     sdk: flutter[m
 [m
[31m-[m
   # The following adds the Cupertino Icons font to your application.[m
   # Use with the CupertinoIcons class for iOS style icons.[m
   cupertino_icons: ^0.1.3[m
[32m+[m[32m  english_words: ^3.1.5[m
 [m
 dev_dependencies:[m
   flutter_test:[m

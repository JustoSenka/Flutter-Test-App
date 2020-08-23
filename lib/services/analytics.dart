import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';

abstract class BaseAnalytics {
  Future<void> logAppOpen();
  Future<void> logEvent(String name);
}

class Analytics implements BaseAnalytics {
  Analytics(this.firebase) {}

  final FirebaseAnalytics firebase;

  Future<void> logAppOpen() async => firebase.logAppOpen();

  Future<void> logEvent(String name) async => firebase.logEvent(name: name);
}

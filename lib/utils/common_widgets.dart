import 'package:flutter/material.dart';

class CommonWidgets {
  static Widget circularLoadingProgress(bool isLoading) {
    if (isLoading) {
      return Center(
        child: Column(
          children: [
            Center(child: Text('Loading..')),
            CircularProgressIndicator(),
          ],
        ),
      );

      //return Center(child: CircularProgressIndicator());
    }
    return empty();
  }

  static Container empty() {
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}

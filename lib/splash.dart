import 'dart:async';

import 'package:banking/main.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  Future checkAuthentication(BuildContext context) async {
    // Check if user is logged in
    // Push login screen once build is complete
    await Future.delayed(Duration(seconds: 4));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebViewExample(),
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: checkAuthentication(context),
          builder: (_, snapshot) {
            return Container(
              child: Image.asset('lib/splash.jpg'),
            );
          },
        ),
      ),
    );
  }
}

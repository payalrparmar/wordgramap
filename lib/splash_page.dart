import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wordgramapp/home_page.dart';

class SplashPage extends StatefulWidget {
  static var tag = 'splash-page';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isLogin = false;
  late Timer _startTimer;

  @override
  void initState() {
    startTime();
    super.initState();
  }

  @override
  void dispose() {
    _startTimer.cancel();
    super.dispose();
  }

  void startTime() async {
    var _duration = Duration(milliseconds: 5000);
    _startTimer = Timer(_duration, navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/progress.gif",
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "WORDGRAM APP",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.lightBlue),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(HomePage.tag);
  }
}

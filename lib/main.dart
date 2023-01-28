import 'package:flutter/material.dart';
import 'package:wordgramapp/splash_page.dart';

import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    HomePage.tag: (context) => HomePage(),
    SplashPage.tag: (context) => SplashPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobigic test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      routes: routes,
    );
  }
}

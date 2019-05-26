import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

import 'package:weather_sc/pages/home_page.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintLayerBordersEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appName = 'SC Weather';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: true,
      // showPerformanceOverlay: true,

      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // brightness: Brightness.light,
        // accentColor: Colors.,
        // buttonColor: Colors.,
      ),
      home: HomePage(appName),
    );
  }
}

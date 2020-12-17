import 'package:flutter/material.dart';
import 'package:akitasummer_flutter_trip/navigator/tab_navigator.dart';


void main() {
  runApp(MyApp());
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         // fontFamily: 'RubikMonoOne', // 全局字体
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       routes: <String, WidgetBuilder>{
//         // 'main': (BuildContext context) => ();
//       },
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // fontFamily: 'RubikMonoOne', // 全局字体
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TabNavigator(),
      routes: <String, WidgetBuilder>{
        'main': (BuildContext context) => TabNavigator()
      },
    );
  }
}

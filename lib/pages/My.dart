import 'package:akitasummer_flutter_trip/widget/webview.dart';
import 'package:flutter/material.dart';

class My extends StatefulWidget {
  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<My> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
          url: 'https://m.ctrip.com/webapp/myctrip/',
          hideAppBar: true,
          backForbid: true,
          statusBarColor: '4c5bca',
        )
    );
  }
}

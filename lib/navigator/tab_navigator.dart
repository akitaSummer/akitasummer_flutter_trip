import 'package:flutter/material.dart';
import 'package:akitasummer_flutter_trip/pages/Home.dart';
import 'package:akitasummer_flutter_trip/pages/My.dart';
import 'package:akitasummer_flutter_trip/pages/Search.dart';
import 'package:akitasummer_flutter_trip/pages/Travel.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {

  final _defaultColor = Colors.grey;

  final _activeColor = Colors.blue;

  int _currentIndex = 0;

  final PageController _controller = PageController(
    initialPage: 0
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        // 禁止左右滑动
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          Search(hideLeft: true,),
          Travel(),
          My(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        selectedLabelStyle: TextStyle(color: _activeColor),
        unselectedLabelStyle: TextStyle(color: _defaultColor),
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomItem('Home', Icons.home),
          _bottomItem('Search', Icons.search),
          _bottomItem('Travel', Icons.camera_alt),
          _bottomItem('My', Icons.circle),
        ],
      ),
    );
  }
  
  _bottomItem(String label, IconData icon) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: _defaultColor),
      activeIcon: Icon(icon, color: _activeColor),
      label: label,
    );
  }
}

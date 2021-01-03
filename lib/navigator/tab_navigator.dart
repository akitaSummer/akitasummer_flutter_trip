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
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _defaultColor),
            activeIcon: Icon(Icons.home, color: _activeColor),
              // title: Text('Home', style: TextStyle(color: _currentIndex != 1 ? _defaultColor : _activeColor)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: _defaultColor),
              activeIcon: Icon(Icons.search, color: _activeColor),
              label: 'Search'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt, color: _defaultColor),
              activeIcon: Icon(Icons.camera_alt, color: _activeColor),
              label: 'Travel'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: _defaultColor),
              activeIcon: Icon(Icons.account_circle, color: _activeColor),
              label: 'My'
          ),
        ],
      ),
    );
  }
}

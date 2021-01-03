import 'dart:convert';

import 'package:akitasummer_flutter_trip/dao/home_dart.dart';
import 'package:akitasummer_flutter_trip/model/common_model.dart';
import 'package:akitasummer_flutter_trip/model/grid_nav_model.dart';
import 'package:akitasummer_flutter_trip/model/home_model.dart';
import 'package:akitasummer_flutter_trip/model/sales_box_model.dart';
import 'package:akitasummer_flutter_trip/widget/grid_nav.dart';
import 'package:akitasummer_flutter_trip/widget/local_nav.dart';
import 'package:akitasummer_flutter_trip/widget/row_grid_nav.dart';
import 'package:akitasummer_flutter_trip/widget/sales_box.dart';
import 'package:akitasummer_flutter_trip/widget/search_bar.dart';
import 'package:akitasummer_flutter_trip/widget/sub_nav.dart';
import 'package:akitasummer_flutter_trip/widget/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {

  double appBarAlpha = 0;
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  List<CommonModel> bannerList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
        body: Stack(
          children: [
            MediaQuery.removePadding( // 用于去除组件内置padding
                context: context,
                removeTop: true,
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: NotificationListener( // 用于监听滚动
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) { // 滚动且是列表滚动时
                        _onScroll(scrollNotification.metrics.pixels);
                      }
                    },
                    child: _listView
                  ),
                )
            ),
            _appBar
          ],
        )
    );
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  Widget get _listView {
    return ListView(
      children: [
        Container(
            height: 160,
            child: _banner
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: GridNav(gridNavModel: gridNavModel),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SubNav(subNavList: subNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SalesBox(salesBox: salesBoxModel),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: RowGridNav(gridNavModel: gridNavModel),
        ),
      ],
    );
  }

  Widget get _banner {
    return Swiper(
      itemCount: bannerList.length,
      autoplay: true,
      itemBuilder: (BuildContext context, int index){
        return GestureDetector(
          onTap: (){
            CommonModel model = bannerList[index];
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WebView(url: model.url, title: model.title, hideAppBar: model.hideAppbar,))
            );
          },
          child: Image.network(
              bannerList[index].icon,
              fit: BoxFit.fill
          ),
        );
      },
      pagination: SwiperPagination(),
    );
  }

  Widget get _appBar {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
                color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2 ? SearchBarType.homeLight : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 0.5)
            ]
          ),
        )
      ],
    );
  }

  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
        bannerList = model.bannerList;
        _loading = false;
      });
    } catch(e) {
      _loading = false;
      print(e);
    }
    return null;
  }

  _jumpToSearch() {}

  _jumpToSpeak() {}
}

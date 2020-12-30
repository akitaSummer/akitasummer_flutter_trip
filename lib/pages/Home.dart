import 'dart:convert';

import 'package:akitasummer_flutter_trip/dao/home_dart.dart';
import 'package:akitasummer_flutter_trip/model/common_model.dart';
import 'package:akitasummer_flutter_trip/model/home_model.dart';
import 'package:akitasummer_flutter_trip/widget/grid_nav.dart';
import 'package:akitasummer_flutter_trip/widget/local_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {

  double appBarAlpha = 0;
  List<CommonModel> localNavList = [];

  List<String> _imageUrls = [
    'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg',
  ];

  @override
  void initState() {
    super.initState();
    loadData();
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
                child: NotificationListener( // 用于监听滚动
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) { // 滚动且是列表滚动时
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                  },
                  child: ListView(
                    children: [
                      Container(
                          height: 160,
                          child: Swiper(
                            itemCount: _imageUrls.length,
                            autoplay: true,
                            itemBuilder: (BuildContext context, int index){
                              return Image.network(
                                  _imageUrls[index],
                                  fit: BoxFit.fill
                              );
                            },
                            pagination: SwiperPagination(),
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                        child: LocalNav(localNavList: localNavList),
                      ),
                      Container(
                          height: 800,
                          child: ListTile(title: Text('test'),)
                      )
                    ],
                  ),
                )
            ),
            Opacity(
              opacity: appBarAlpha,
              child: Container(
                height: 80,
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('home')
                  )
                ),
              ),
            )
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

  loadData() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
      });
    } catch(e) {
      print(e);
    }
  }
}

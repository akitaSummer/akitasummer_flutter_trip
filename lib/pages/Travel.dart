import 'package:akitasummer_flutter_trip/dao/travel_tab_dao.dart';
import 'package:akitasummer_flutter_trip/model/travel-tab-model.dart';
import 'package:akitasummer_flutter_trip/pages/travel_tab.dart';
import 'package:flutter/material.dart';

class Travel extends StatefulWidget {
  @override
  _TravelState createState() => _TravelState();
}

class _TravelState extends State<Travel> with TickerProviderStateMixin {
  TabController _controller;
  List<TravelTab> tabs = [];
  TravelTabModel travelTabModel;

  @override
  void initState() {
    _controller = TabController(length: 0, vsync: this);
    TravelTabDao.fetch().then((TravelTabModel model) {
      // fix tab label 未重新渲染
      _controller = TabController(length: model.tabs.length, vsync: this);
      setState(() {
        tabs = model.tabs;
        travelTabModel = model;
      });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 30),
              child: TabBar(
                controller: _controller,
                isScrollable: true,
                tabs: tabs.map<Tab>((TravelTab tab) {
                  return Tab(text: tab.labelName,);
                }).toList(),
                labelColor: Colors.black,
                labelPadding: EdgeInsets.fromLTRB(20, 0, 10, 5),
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Color(0Xff2fcfbb), width: 3),
                    insets: EdgeInsets.only(bottom: 10)
                ),
              ),
            ),
            // TabBarView 会丢失宽高数据
            Flexible(
              child: TabBarView(
                controller: _controller,
                children: tabs.map((TravelTab tab) {
                  return TravelTabPage(
                    travelUrl: travelTabModel.url,
                    params: travelTabModel.params,
                    groupChannelCode: tab.groupChannelCode,
                  );
                }).toList(),
              ),
            )
          ],
        )
    );
  }
}

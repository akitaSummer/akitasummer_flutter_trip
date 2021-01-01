import 'package:akitasummer_flutter_trip/model/common_model.dart';
import 'package:akitasummer_flutter_trip/model/grid_nav_model.dart';
import 'package:akitasummer_flutter_trip/widget/webview.dart';
import 'package:flutter/material.dart';

class RowGridNav extends StatelessWidget {

  final GridNavModel gridNavModel;

  const RowGridNav({ Key key, @required this.gridNavModel }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(6)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _row(context, gridNavModel.hotel, first: true),
          _row(context, gridNavModel.flight),
          _row(context, gridNavModel.travel)
        ],
      ),
    );
  }

  Widget _row(BuildContext context, GridNavItem items,{ bool first = false }) {
    Color startColor = Color(int.parse('0xff' + items.startColor));
    Color endColor = Color(int.parse('0xff' + items.endColor));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
        )
      ),
      height: 88,
      margin: first ? null : EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: _wrapGesture(context,
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Image.network(items.mainItem.icon, fit: BoxFit.contain, height: 88, width: 121, alignment: AlignmentDirectional.bottomEnd),
                    Container(
                      margin: EdgeInsets.only(top: 11),
                      child: Text(items.mainItem.title, style: TextStyle(fontSize: 14, color: Colors.white),),
                    )
                  ],
                ), items.mainItem),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(flex: 1,child: Row(children: [_smallItem(context, items.item1), _smallItem(context, items.item2, left: false, right: false)])),
                Expanded(flex: 1,child: Row(children: [_smallItem(context, items.item3, bottom: false), _smallItem(context, items.item4, left:false, bottom: false, right: false)])),
              ],
            ),
          )
        ],
      ),
    );
  }



  Widget _smallItem(BuildContext context, CommonModel model, { bool left = true, bool bottom = true, bool right = true}) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return Expanded(
      flex: 1,
      child: _wrapGesture(context,
          Container(
            decoration: BoxDecoration(
                border: Border(
                  left: left ? borderSide : BorderSide.none,
                  bottom: bottom ? borderSide : BorderSide.none,
                  right: right ? borderSide : BorderSide.none,
                )
            ),
            child: Center(
              child: Text(
                  model.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white)
              ),
            ),
          ), model),
    );
  }

  Widget _wrapGesture(BuildContext context, Widget child, CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WebView(
            url: model.url,
            statusBarColor: model.statusBarColor,
            title: model.title,
            hideAppBar: model.hideAppbar,
          ))
        );
      },
      child: child,
    );
  }
}

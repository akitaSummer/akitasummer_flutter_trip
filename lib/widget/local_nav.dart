import 'package:akitasummer_flutter_trip/model/common_model.dart';
import 'package:akitasummer_flutter_trip/widget/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocalNav extends StatelessWidget {

  final List<CommonModel> localNavList;

  const LocalNav({ Key key, @required this.localNavList }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(6)
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  Widget _items(BuildContext context) {
    if (localNavList == null) {
      return null;
    }
    List<Widget> items = localNavList.map((model) => _item(context, model)).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            WebView(
              url: model.url,
              statusBarColor: model.statusBarColor,
              hideAppBar: model.hideAppbar,
            )
        ));
      },
      child: Column(
        children: [
          Image.network(
            model.icon,
            width: 32,
            height: 32,
          ),
          Text(
            model.title,
            style: TextStyle(fontSize: 12)
          )
        ],
      ),
    );
  }
}

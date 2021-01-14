import 'package:akitasummer_flutter_trip/dao/travel_dao.dart';
import 'package:akitasummer_flutter_trip/model/travel-model.dart';
import 'package:akitasummer_flutter_trip/widget/loading_container.dart';
import 'package:akitasummer_flutter_trip/widget/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const _TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

const PAGE_SIZE = 10;

class TravelTabPage extends StatefulWidget {
  final String travelUrl;
  final Map params;
  final String groupChannelCode;

  TravelTabPage({Key key, this.travelUrl, this.params, this.groupChannelCode}): super(key: key);

  @override
  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage> with AutomaticKeepAliveClientMixin {

  List<TravelItem> travelItems;
  int pageIndex = 1;
  bool _loading = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _loadData();
    _scrollController.addListener(() { // 上拉加载更多
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
    super.initState();
  }

  // 防止tab切换页面重绘
  @override
  bool get wantKeepAlive => true;

  Future<Null> _handleRefresh () async {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingContainer( // 页面loading加载
        isLoading: _loading,
        child: RefreshIndicator( // 下拉刷新
          onRefresh: _handleRefresh,
          child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: StaggeredGridView.countBuilder(
                controller: _scrollController,
                // 每行几列
                crossAxisCount: 4,
                // 所有item数量
                itemCount: travelItems?.length ?? 0,
                // item具体的渲染方法
                itemBuilder: (BuildContext context, int index) => _TravelItem(index: index, item: travelItems[index]),
                // 控制每个item占几列
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
              )
          ),
        ),
      ),
    );
  }

  _loadData({loadMore = false}) {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    TravelDao.fetch(widget.travelUrl ?? _TRAVEL_URL , widget.params, widget.groupChannelCode, pageIndex, PAGE_SIZE)
        .then((TravelItemModel model) => {
          setState(() {
            List<TravelItem> items = _filterItems(model.resultList);
            if (travelItems != null) {
              travelItems.addAll(items);
            } else {
              travelItems = items;
            }
            _loading = false;
          })
        }).catchError((e) {
          print(e);
          setState(() {
            _loading = false;
          });
        });
  }

  List<TravelItem> _filterItems(List<TravelItem> resultList) {
    if (resultList == null) {
      return [];
    }
    List<TravelItem> filterItems = [];
    resultList.forEach((item) {
      if (item.article != null) {
        filterItems.add(item);
      }
    });
    return filterItems;
  }
}

class _TravelItem extends StatelessWidget {

  final TravelItem item;
  final int index;

  const _TravelItem({Key key, this.item, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.article.urls != null && item.article.urls.length > 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebView(
                    url: item.article.urls[0].h5Url,
                    title: '详情',
                  )));
        }
      },
      // card
      child: Card(
        // 裁切组件
        child: PhysicalModel(
          color: Colors.transparent,
          // 设置裁切
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _itemImage(),
              Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  item.article.articleTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              _infoText()
            ],
          ),
        ),
      ),
    );
  }

  _itemImage() {
    return Stack(
      children: [
        Image.network(item.article.images[0]?.dynamicUrl),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Icon(Icons.location_on, color: Colors.white,size: 12,),
                ),
                // 用于限制内部文字省略号
                LimitedBox(
                  maxWidth: 130,
                  child: Text(
                    _poiName(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  String _poiName() {
    return item.article.pois == null || item.article.pois.length == 0 ? '未知' : item.article.pois[0]?.poiName?? '未知';
  }

  _infoText() {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.network(item.article.author?.coverImage?.dynamicUrl, width: 24, height: 24,),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(
                  item.article.author?.nickName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.thumb_up,
                size: 14,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: Text(item.article.likeCount.toString(), style: TextStyle(fontSize: 10),),
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'package:akitasummer_flutter_trip/model/common_model.dart';
import 'package:akitasummer_flutter_trip/model/config_model.dart';
import 'package:akitasummer_flutter_trip/model/grid_nav_model.dart';
import 'package:akitasummer_flutter_trip/model/sales_box_model.dart';

class HomeModel {
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final GridNavModel gridNav;
  final List<CommonModel> subNavList;
  final SalesBoxModel salesBox;

  HomeModel({
    this.bannerList,
    this.localNavList,
    this.gridNav,
    this.subNavList,
    this.salesBox,
    this.config
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    List localNavListJson = json['localNavList'] as List;
    List bannerListJson = json['bannerList'] as List;
    List subNavListJson = json['subNavList'] as List;
    List<CommonModel> localNavList = localNavListJson.map((i) => CommonModel.fromJson(i)).toList();
    List<CommonModel> bannerList = bannerListJson.map((i) => CommonModel.fromJson(i)).toList();
    List<CommonModel> subNavList = subNavListJson.map((i) => CommonModel.fromJson(i)).toList();

    return HomeModel(
      localNavList: localNavList,
      bannerList: bannerList,
      subNavList: subNavList,
      config: ConfigModel.fromJson(json['config']),
      gridNav: GridNavModel.fromJson(json['gridNav']),
      salesBox: SalesBoxModel.fromJson(json['salesBox']),
    );
  }
}

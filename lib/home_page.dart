import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bean/he_weather.dart';
import 'package:flutter_app/service/api_service.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:async';

import 'page_index.dart';

class HomePage extends StatefulWidget {
  @override
  createState() => HomeStatePage();
}

class HomeStatePage extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 上次点击时间
  DateTime _lastPressedAt;

  HeWeather weather;
  String city;

  @override
  void initState() {
    super.initState();
    city = '北京';
    // 获取当前位置的天气数据
    getWeatherData(city);
  }

  @override
  Widget build(BuildContext context) {
    /**
     * 实现原理，使用WillPopScope组件，它会检测到子组件的Navigation的pop事件，并拦截下来。
     * 我们需要在它的onWillPop属性中返回一个新的组件（一般是一个Dialog）处理是否真的pop该页面。
     */
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          key: _scaffoldKey,
          appBar: AppBar(
            // Title
            title: GestureDetector(
              onTap: () => pushNewPage(context, CityPage(currentCity: city)),
              child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text(city, style: TextStyle(fontSize: 17.0)),
                      Icon(Icons.keyboard_arrow_down)
                    ], mainAxisSize: MainAxisSize.min),
                    Text(
                        '${weather?.now?.cond_txt ?? ''} ${weather?.now?.tmp ?? ''}',
                        style: TextStyle(fontSize: 13.0))
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center),
            ),
            elevation: 4.0,
            leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState.openDrawer()),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.tune, semanticLabel: "tune"),
                  onPressed: () => getTestData(),
                  tooltip: "Tune")
            ],
          ),
          drawer: HomeDrawable(),
          body: ListView(physics: BouncingScrollPhysics(), children: <Widget>[
            Container(
                height: Utils.width * 72 / 108,
                child: Swiper(
                    itemBuilder: (context, index) =>
                        ImageLoadView(banner_images[index]),
                    itemCount: banner_images.length,
                    pagination: SwiperPagination(
                        builder: SwiperPagination.fraction,
                        alignment: Alignment.bottomRight),
                    autoplay: true)),
            ExpansionTile(
                title: Text('${ExpandStateBean.expandStateList[0].title}'),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: _buildListBody(ExpandStateBean.expandStateList[0]),
                onExpansionChanged: (bool value) {},
                leading: Icon(ExpandStateBean.expandStateList[0].leading)),
            ExpansionTile(
                title: Text('${ExpandStateBean.expandStateList[1].title}'),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: _buildListBody(ExpandStateBean.expandStateList[1]),
                onExpansionChanged: (bool value) {},
                leading: Icon(ExpandStateBean.expandStateList[1].leading)),
            ExpansionTile(
                title: Text('${ExpandStateBean.expandStateList[2].title}'),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: _buildListBody(ExpandStateBean.expandStateList[2]),
                onExpansionChanged: (bool value) {},
                leading: Icon(ExpandStateBean.expandStateList[2].leading)),
            ExpansionTile(
                title: Text('${ExpandStateBean.expandStateList[3].title}'),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: _buildListBody(ExpandStateBean.expandStateList[3]),
                onExpansionChanged: (bool value) {},
                leading: Icon(ExpandStateBean.expandStateList[3].leading))
          ])),
    );
  }

  List<Widget> _buildListBody(ExpandStateBean bean) {
    List<Widget> widgets = [];
    for (int i = 0; i < bean.children.length; i++) {
      widgets
        ..add(ListTile(
            contentPadding: EdgeInsets.only(left: 30, right: 20),
            title: Text(bean.children[i].title),
            onTap: () => pushNewPage(context, bean.children[i].page),
            trailing: Icon(Icons.keyboard_arrow_right)))
        ..add(Container(height: 0.5, color: Colors.grey[200]));
    }
    return widgets;
  }

  /// 监听返回键，点击两下退出程序
  Future<bool> _onBackPressed() async {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      print("菜单打开着");
    } else if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt) > Duration(seconds: 2)) {
      print("点击时间");
      //两次点击间隔超过2秒则重新计时
      _lastPressedAt = DateTime.now();
      Toast.show("再按一次退出", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return false;
    }
    return true;
  }

  void getWeatherData(String city) async {
    weather = await ApiService.getHeWeatherNow(city);
    setState(() {});
  }

  void getTestData() async {}
}

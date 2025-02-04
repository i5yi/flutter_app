import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bean/news.dart';
import 'package:flutter_app/global/config.dart';
import 'package:flutter_app/bean/movie.dart';
import 'package:flutter_app/movie/page/movie_classify_page.dart';
import 'package:flutter_app/movie/page/movie_hot.dart';
import 'package:flutter_app/movie/page/movie_soon.dart';
import 'package:flutter_app/movie/ui/ranking_banner.dart';
import 'package:flutter_app/service/api_service.dart';
import 'package:flutter_app/movie/ui/banner_view.dart';
import 'package:flutter_app/movie/ui/classify_section_home.dart';
import 'package:flutter_app/movie/ui/home_section_view.dart';
import 'package:flutter_app/movie/ui/item_grid_view.dart';
import 'package:flutter_app/movie/ui/movie_grid_view.dart';
import 'package:flutter_app/utils/loading_util.dart';
import 'package:flutter_app/utils/route_util.dart';

class MovieHomePage extends StatefulWidget {
  @override
  _MovieHomePageState createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  /// 分类浏览每个大类分别随机一个小分类
  List<String> tags = [];

  /// 头部banner新闻
  List<News> banner = [];

  /// 影院热映
  List<Movie> hotMovies = [];

  /// 即将上映
  List<Movie> soonMovies = [];

  /// Top250
  List<Movie> top250 = [];

  /// 北美票房排行榜
  List<Movie> us = [];

  /// 一周口碑排行榜
  List<Movie> weekly = [];

  /// 一周最新电影排行榜
  List<Movie> news = [];

  List<List<Movie>> movies = [];

  @override
  void initState() {
    super.initState();

    tags
      ..add(
          '${Config.GenreList[Random().nextInt(Config.GenreList.length - 1)]}')
      ..add(
          '${Config.RegionList[Random().nextInt(Config.RegionList.length - 1)]}')
      ..add(
          '${Config.FeatureList[Random().nextInt(Config.FeatureList.length - 1)]}')
      ..add('${Config.YearList[Random().nextInt(Config.YearList.length - 1)]}');

    getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('豆瓣电影'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: bodyView(),
      backgroundColor: Colors.white,
    );
  }

  Future<void> getHomeData() async {
    banner = await ApiService.getNewsList();
    hotMovies =
        await ApiService.getNowPlayingList(city: "北京", start: 0, count: 6);
    soonMovies = await ApiService.getComingList(start: 0, count: 6);

    top250 = await ApiService.getTop250List(start: 0, count: 10);
    news = await ApiService.getNewMoviesList();
    us = await ApiService.getUsBoxList();
    weekly = await ApiService.getWeeklyList();

    setState(() {
      movies..add(weekly)..add(top250)..add(news)..add(us);
    });
  }

  Widget bodyView() {
    if (movies.isEmpty) {
      return getLoadingWidget();
    } else {
      return ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          BannerView(banner: banner),
          HomeSectionView("影院热映",
              onPressed: () => pushNewPage(context, MovieHotPage())),
          Container(
            padding: EdgeInsets.all(6.0),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: hotMovies.map((movie) => MovieGridView(movie)).toList(),
            ),
          ),
          HomeSectionView("即将上映",
              onPressed: () => pushNewPage(context, MovieSoonPage())),
          ItemGridView(movies: soonMovies),
          HomeSectionView("电影榜单", hiddenMore: true),
          RankingBanner(movies),
          HomeSectionView("分类浏览",
              onPressed: () => pushNewPage(context, MovieClassifyPage())),
          ClassifySection(tags[0]),
          ClassifySection(tags[1]),
          ClassifySection(tags[2]),
          ClassifySection(tags[3]),
        ],
      );
    }
  }
}

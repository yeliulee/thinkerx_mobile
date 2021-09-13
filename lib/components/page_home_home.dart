import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thinkerx/core/resource_helper.dart';
import 'package:thinkerx/core/tools_config.dart';
import 'package:thinkerx/models/app_news_entity.dart';
import 'package:thinkerx/router/app_router.gr.dart';
import 'package:thinkerx/store/app.dart';
import 'package:thinkerx/store/page_home.dart';

class PageHomeHome extends StatelessWidget {
  static const String API_URL =
      "http://service.thinker-x.com:8848/user/news/list";

  Future<List<AppNewsEntity>> fetchNewsList() async {
    try {
      Response response = await Dio().get(API_URL,
          options: Options(sendTimeout: 5000, receiveTimeout: 5000));
      List<AppNewsEntity> tempList = [];
      List<dynamic> resData = jsonDecode(response.data);
      resData.forEach((jsonNews) {
        tempList.add(AppNewsEntity.fromJson(jsonNews));
      });
      return tempList;
    } catch (e) {
      throw HttpStatus.serviceUnavailable;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final List<String> favorites = context.watch<AppViewModel>().appFavorites;
    final List<ToolConfig> favoriteTools = AppToolsConfig()
        .tools
        .where((tool) => favorites.contains(tool.routeName))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("ThinkerX"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => ExtendedNavigator.root.push(AppRoutes.pageSearch),
          ),
        ],
      ),
      backgroundColor: Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSlideShow(context),
//            _buildNewsList(context),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              margin: EdgeInsets.only(top: 12),
              child: Card(
                shadowColor: primaryColor.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _buildCardHeader(
                        context,
                        title: "应用收藏",
                        icon: Icon(
                          Icons.collections_bookmark,
                          color: Colors.black54,
                        ),
                        trainingTitle: "管理收藏",
                        trainingIcon: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black54,
                        ),
                        onPress: () => ExtendedNavigator.root
                            .push(AppRoutes.pageFavoritesManager),
                      ),
                      favoriteTools.length != 0
                          ? _buildFavoriteList(context, favoriteTools)
                          : _buildEmptyTip(context),
                    ],
                  ),
                ),
              ),
            ),
            _buildRandomRecommend(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideShow(BuildContext context) {
    List<String> imagePathList = [
      ResourceHelper.image_home_banner_1,
      ResourceHelper.image_home_banner_2
    ];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      constraints: BoxConstraints(
        maxHeight: 568 / MediaQuery.of(context).devicePixelRatio,
        minHeight: 0,
      ),
      child: Swiper(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  imagePathList[index],
                ),
              ),
            ),
          );
        },
        pagination: SwiperPagination(),
        scale: 0.9,
      ),
    );
  }

  /// [_buildCardHeader] , 构建卡片头部
  Widget _buildCardHeader(
    BuildContext context, {
    @required Widget icon,
    @required String title,
    @required String trainingTitle,
    @required Icon trainingIcon,
    @required VoidCallback onPress,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 8),
                child: icon),
            Container(
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onPress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  trainingTitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 4),
                child: trainingIcon,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewsList(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildCardHeader(
                context,
                icon: Icon(
                  FontAwesomeIcons.rss,
                  color: Colors.black54,
                ),
                title: "应用动态",
                trainingTitle: "应用公告",
                trainingIcon: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black54,
                ),
                onPress: () {},
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 8),
                constraints: BoxConstraints(
                  minHeight: 64,
                  maxHeight: 256,
                ),
                child: FutureBuilder<List<AppNewsEntity>>(
                  future: fetchNewsList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<AppNewsEntity>> snapshot) {
                    if (snapshot.hasData) {
                      final newsList = snapshot.data;
                      return Scrollbar(
                        child: ListView.builder(
                            itemCount: newsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final AppNewsEntity appNews = newsList[index];
                              final bool isLast = index == newsList.length - 1;
                              final double marginBottom = isLast ? 0.0 : 8;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: marginBottom, top: 8),
                                    alignment: Alignment.centerLeft,
                                    constraints: BoxConstraints(
                                      minHeight: 64,
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(4),
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Text(
                                                          appNews.title,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 4),
                                                        child: Text(
                                                          appNews.summary,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (appNews.image != null)
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 16),
                                                    constraints: BoxConstraints(
                                                      minWidth: 76,
                                                      minHeight: 76,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            appNews.image),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 4),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    child: CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          "https://www.yeliulee.com/usr/uploads/yeliulee.png"),
                                                      radius: 12,
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                  ),
                                                  Text(
                                                    appNews.author,
                                                    style: TextStyle(
                                                      color: Colors.black87
                                                          .withOpacity(0.75),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    Divider(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      thickness: 0.3,
                                      height: 4,
                                    ),
                                ],
                              );
                            }),
                      );
                    } else if (snapshot.hasError) {
                      return Container();
                    } else {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteList(
      BuildContext context, List<ToolConfig> favoriteTools) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(0),
      constraints: BoxConstraints(maxHeight: 150),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4.0,
            children: favoriteTools
                .map(
                  (favoriteTool) => ActionChip(
                    label: Text(
                      favoriteTool.name,
                      style: TextStyle(color: Colors.black87),
                    ),
                    onPressed: () =>
                        ExtendedNavigator.root.push(favoriteTool.routeName),
                    backgroundColor: Color(0xFFF4F4F4),
                    elevation: 0.5,
                    pressElevation: 2,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyTip(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 128),
      alignment: Alignment.center,
      child: Text(
        "目前尚无收藏,快去增加收藏吧!",
        style: TextStyle(color: Colors.black54),
        softWrap: true,
      ),
    );
  }

  Widget _buildRandomRecommend(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(),
      child: Card(
        shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildCardHeader(
                context,
                title: "随机推荐",
                icon: Icon(
                  FontAwesomeIcons.random,
                  color: Colors.black54,
                ),
                trainingTitle: "刷新",
                trainingIcon: Icon(
                  Icons.refresh,
                  color: Colors.black54,
                ),
                onPress: () =>
                    context.read<PageHomeViewModel>().changeRandomTools(),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 16),
                child: Consumer(
                    builder: (_, PageHomeViewModel pageHomeViewModel, __) {
                  return Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4.0,
                    children: pageHomeViewModel.randomTools
                        .map(
                          (favoriteTool) => ActionChip(
                            label: Text(
                              favoriteTool.name,
                              style: TextStyle(color: Colors.black87),
                            ),
                            onPressed: () => ExtendedNavigator.root
                                .push(favoriteTool.routeName),
                            backgroundColor: Color(0xFFF4F4F4),
                            elevation: 0.5,
                            pressElevation: 2,
                          ),
                        )
                        .toList(),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

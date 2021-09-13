import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thinkerx/constants/tool_category.dart';
import 'package:thinkerx/constants/tool_platform.dart';
import 'package:thinkerx/core/tools_config.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/store/app.dart';

class PageHomeGallery extends StatefulWidget {
  @override
  _PageHomeGalleryState createState() => _PageHomeGalleryState();
}

class _PageHomeGalleryState extends State<PageHomeGallery> with SingleTickerProviderStateMixin {
  Map<ToolCategory, Tab> appCategoryTabs = {
    ToolCategory.CATE_UNIVERSAL: Tab(
      icon: Icon(Icons.wb_sunny),
      text: AppLocale.current.toolCategoryUniversal,
    ),
    ToolCategory.CATE_FUN: Tab(
      icon: Icon(Icons.sentiment_very_satisfied),
      text: AppLocale.current.toolCategoryFun,
    ),
    ToolCategory.CATE_PROGRAMMING: Tab(
      icon: Icon(Icons.code),
      text: AppLocale.current.toolCategoryProgramming,
    ),
    ToolCategory.CATE_IMAGE: Tab(
      icon: Icon(Icons.photo_library),
      text: AppLocale.current.toolCategoryImage,
    ),
    ToolCategory.CATE_TEXT: Tab(
      icon: Icon(Icons.text_rotation_none),
      text: AppLocale.current.toolCategoryText,
    ),
    ToolCategory.CATE_DEVICE: Tab(
      icon: Icon(Icons.phonelink_setup),
      text: AppLocale.current.toolCategoryDevice,
    ),
    ToolCategory.CATE_OTHERS: Tab(
      icon: Icon(Icons.category),
      text: AppLocale.current.toolCategoryOthers,
    ),
  };
  AppToolsConfig _appToolsConfig;
  TabController _tabController;
  ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    _appToolsConfig = AppToolsConfig();
    _tabController = TabController(vsync: this, length: appCategoryTabs.values.length + 1);
    _scrollViewController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  void _handleFunBtnPress(ToolConfig tool) {
    ExtendedNavigator.root.push(tool.routeName);
  }

  void _handleFuncBtnLongPress(BuildContext context, ToolConfig tool) async {
    AppViewModel appViewModel = context.read<AppViewModel>();
    bool addToFavorites = await showDialog(
      context: context,
      builder: (BuildContext context) {
        final List<Widget> actions = [
          FlatButton(onPressed: () => Navigator.of(context).pop(false), child: Text(AppLocale.current.titleNO)),
          FlatButton(onPressed: () => Navigator.of(context).pop(true), child: Text(AppLocale.current.titleYES)),
        ];
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(AppLocale.current.titleInformation),
                content: Text(AppLocale.current.askAddThisToFavorites),
                actions: actions,
              )
            : AlertDialog(
                title: Text(AppLocale.current.titleInformation),
                content: Text(AppLocale.current.askAddThisToFavorites),
                actions: actions,
              );
      },
    );
    if (addToFavorites == true) {
      if (appViewModel.appFavorites.contains(tool.routeName)) {
        Fluttertoast.showToast(msg: AppLocale.current.tipAppAddedToFavorites, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);
      } else {
        try {
          List<String> tempFavorites = appViewModel.appFavorites;
          tempFavorites.add(tool.routeName);
          appViewModel.handleSetFavorites(tempFavorites);
          Fluttertoast.showToast(msg: AppLocale.current.tipAppAddToFavoritesSuccessfully, gravity: ToastGravity.CENTER);
        } catch (error) {
          Fluttertoast.showToast(msg: error.toString(), gravity: ToastGravity.BOTTOM);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ToolPlatform currentPlatform = Platform.isAndroid ? ToolPlatform.ANDROID : ToolPlatform.IOS;

    final double funcBtnWidth = (MediaQuery.of(context).size.width < 600
            ? ((MediaQuery.of(context).size.width - 6 * 8) / 2)
            : ((MediaQuery.of(context).size.width - 8 * 8) / 3)) -
        0.1;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              title: Text(AppLocale.current.appGallery),
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: Icon(Icons.apps),
                    text: AppLocale.current.toolCategoryAll,
                  ),
                  ...appCategoryTabs.values.toList()
                ],
                isScrollable: true,
                indicatorColor: Theme.of(context).primaryColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(4),
                ),
              ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(0),
              child: SingleChildScrollView(
                child: Wrap(
                  direction: Axis.horizontal,
                  children: _appToolsConfig
                      .getTools(platform: currentPlatform)
                      .map(
                        (tool) => _buildToolButton(funcBtnWidth, tool, context),
                      )
                      .toList(),
                ),
              ),
            ),
            ...appCategoryTabs.entries
                .map((appCategoryTab) => Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: _appToolsConfig
                              .getTools(category: appCategoryTab.key, platform: currentPlatform)
                              .map((tool) => _buildToolButton(funcBtnWidth, tool, context))
                              .toList(),
                        ),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButton(double funcBtnWidth, ToolConfig tool, BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: funcBtnWidth, maxWidth: funcBtnWidth),
      margin: EdgeInsets.all(8),
      child: FlatButton(
        color: Color(0xFFF8F8F8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.all(12),
        onPressed: () => _handleFunBtnPress(tool),
        onLongPress: () => _handleFuncBtnLongPress(context, tool),
        child: Text(
          tool.name,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

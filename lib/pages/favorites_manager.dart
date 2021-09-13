import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:thinkerx/core/resource_helper.dart';
import 'package:thinkerx/core/storage_util.dart';
import 'package:thinkerx/core/tools_config.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/store/app.dart';

class PageFavoritesManager extends StatefulWidget {
  final bool isManageMode;

  PageFavoritesManager({this.isManageMode = false});

  @override
  _PageFavoritesManagerState createState() => _PageFavoritesManagerState();
}

class _PageFavoritesManagerState extends State<PageFavoritesManager> {
  static const String FAV_CONFIG_NAME = "name";
  static const String FAV_CONFIG_ROUTE = "route";
  static const String FAV_CONFIG_CHECKED = "checked";

  bool isManageMode;
  List<Map<String, dynamic>> favoriteToolConfigs;
  bool isSelectedAll = false;

  void checkIsSelectedAll() {
    List<Map<String, dynamic>> selectedTools = favoriteToolConfigs.where((favoriteToolConfig) => favoriteToolConfig[FAV_CONFIG_CHECKED]).toList();
    setState(() {
      isSelectedAll = selectedTools.length == favoriteToolConfigs.length;
    });
  }

  onPressCheck() {
    var tempFavoriteToolConfigs = favoriteToolConfigs;
    bool formatValue = !isSelectedAll;
    tempFavoriteToolConfigs.forEach((tempFavoriteToolConfig) {
      tempFavoriteToolConfig[FAV_CONFIG_CHECKED] = formatValue;
    });
    setState(() {
      favoriteToolConfigs = tempFavoriteToolConfigs;
      isSelectedAll = !isSelectedAll;
    });
  }

  void onLongPress() {
    if (!isManageMode) {
      setState(() {
        isManageMode = !isManageMode;
      });
    }
  }

  void onChange(bool checked, Map<String, dynamic> favoriteToolConfig) {
    setState(() {
      favoriteToolConfigs[favoriteToolConfigs.indexOf(favoriteToolConfig)][FAV_CONFIG_CHECKED] = checked;
      checkIsSelectedAll();
    });
  }

  void onPress(Map<String, dynamic> favoriteToolConfig) {
    if (isManageMode) {
      checkIsSelectedAll();
      int configIndex = favoriteToolConfigs.indexOf(favoriteToolConfig);
      setState(() {
        favoriteToolConfigs[configIndex][FAV_CONFIG_CHECKED] = !favoriteToolConfigs[configIndex][FAV_CONFIG_CHECKED];
      });
    } else {
      ExtendedNavigator.root.push(favoriteToolConfig[FAV_CONFIG_ROUTE]);
    }
  }

  void handleConfirm(BuildContext context) {
    List<String> tempToolsRoutes = [];
    favoriteToolConfigs.forEach((favoriteToolConfig) {
      if (favoriteToolConfig[FAV_CONFIG_CHECKED]) {
        tempToolsRoutes.add(favoriteToolConfig[FAV_CONFIG_ROUTE]);
      }
    });
    context.read<AppViewModel>().handleSetFavorites(tempToolsRoutes);
    setState(() {
      isManageMode = false;
    });
  }

  @override
  void initState() {
    isManageMode = widget.isManageMode;
    favoriteToolConfigs = AppToolsConfig()
        .tools
        .map((tool) => {
              FAV_CONFIG_NAME: tool.name,
              FAV_CONFIG_ROUTE: tool.routeName,
              FAV_CONFIG_CHECKED: StorageUtil.getStringList('app_favorites', defaultValue: []).contains(tool.routeName)
            })
        .toList();
    checkIsSelectedAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final funcBtnWidth = MediaQuery.of(context).size.width < 600
        ? ((MediaQuery.of(context).size.width - 6 * 8) / 2)
        : ((MediaQuery.of(context).size.width - 8 * 8) / 3) - 0.1;
    return Scaffold(
      appBar: AppBar(
        title: Text(isManageMode ? AppLocale.current.favoritesManagerSuper : AppLocale.current.favoritesManager),
        actions: <Widget>[
          if (isManageMode)
            IconButton(
              icon: Icon(isSelectedAll ? Icons.check_box : Icons.check_box_outline_blank),
              onPressed: () => onPressCheck(),
            )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(8),
            child: ListTileTheme(
              style: ListTileStyle.drawer,
              child: Wrap(
                direction: Axis.horizontal,
                children: (isManageMode
                        ? favoriteToolConfigs
                        : favoriteToolConfigs.where((favoriteToolConfig) => favoriteToolConfig[FAV_CONFIG_CHECKED]).toList())
                    .map((favoriteToolConfig) => Container(
                          constraints: BoxConstraints(minWidth: funcBtnWidth, maxWidth: funcBtnWidth, maxHeight: 48),
                          margin: EdgeInsets.all(8),
                          child: FlatButton(
                            color: Color(0xFFF8F8F8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            padding: EdgeInsets.only(left: 12, right: 4, top: 12, bottom: 12),
                            onPressed: () => onPress(favoriteToolConfig),
                            onLongPress: () => onLongPress(),
                            child: Row(
                              mainAxisAlignment: isManageMode ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                              children: <Widget>[
                                Text(favoriteToolConfig[FAV_CONFIG_NAME]),
                                if (isManageMode)
                                  Checkbox(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    value: favoriteToolConfig[FAV_CONFIG_CHECKED],
                                    onChanged: (checked) => onChange(checked, favoriteToolConfig),
                                  ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          if (!isManageMode && favoriteToolConfigs.where((favoriteToolConfig) => favoriteToolConfig[FAV_CONFIG_CHECKED]).toList().length != 0)
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                AppLocale.current.favoritesTipLongPress,
                style: TextStyle(color: Theme.of(context).primaryColorLight),
              ),
            ),
          if (!isManageMode && favoriteToolConfigs.where((favoriteToolConfig) => favoriteToolConfig[FAV_CONFIG_CHECKED]).toList().length == 0)
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 5,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 32),
                      child: SvgPicture.asset(
                        ResourceHelper.icon_empty_box,
                        color: Theme.of(context).primaryColorLight,
                        width: 128,
                        height: 128,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(22),
                      splashColor: Theme.of(context).primaryColor,
                      onTap: () {
                        Future.delayed(Duration(milliseconds: 150), () {
                          setState(() {
                            isManageMode = true;
                          });
                        });
                      },
                      child: Container(
                        width: 176,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withAlpha(144),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Text(
                              AppLocale.current.favoritesTextAdd,
                              style: TextStyle(color: Colors.white.withOpacity(1)),
                            ),
                            Positioned(
                              right: 4,
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.75),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
      floatingActionButton: isManageMode
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.75),
              splashColor: Theme.of(context).primaryColor,
              child: Icon(Icons.check),
              onPressed: () => handleConfirm(context),
            )
          : null,
    );
  }
}

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:thinkerx/constants/tool_platform.dart';
import 'package:thinkerx/core/storage_util.dart';
import 'package:thinkerx/core/tools_config.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageSearch extends StatefulWidget {
  @override
  _PageSearchState createState() => _PageSearchState();
}

class _PageSearchState extends State<PageSearch> {
  AppToolsConfig _appToolsConfig;
  List<String> _searchHistory;
  TextEditingController _controller;
  String _filterText = "";

  void _setHistoryData(List<String> historyList) {
    StorageUtil.instance.setStringList('history_search_list', historyList);
  }

  void _clearAll() {
    setState(() {
      _setHistoryData([]);
      _searchHistory = [];
    });
  }

  List<ToolConfig> _fetchHistoryTools(List<String> historyList) {
    List<ToolConfig> _tools = [];
    historyList.forEach((routeName) {
      _tools.add(_appToolsConfig.tools.firstWhere((tool) => tool.routeName == routeName));
    });
    return _tools;
  }

  void _navigateToolPage(ToolConfig tool) {
    ExtendedNavigator.root.push(tool.routeName);
  }

  void _handlePressResultItem(ToolConfig tool) {
    List<String> tempHistoryList = _searchHistory;
    // 已存在，先删除
    if (tempHistoryList.contains(tool.routeName)) {
      tempHistoryList.removeWhere((routeName) => routeName == tool.routeName);
    }
    // 插入到最前面
    tempHistoryList.insert(0, tool.routeName);

    // 长度超过 10，移除最后一个item
    if (tempHistoryList.length > 10) {
      tempHistoryList.removeLast();
    }

    // 存储到本地
    _setHistoryData(tempHistoryList);

    setState(() {
      _searchHistory = tempHistoryList;
    });

    // 前往工具页面
    _navigateToolPage(tool);
  }

  void _handleInputChange(String text) {
    setState(() {
      _filterText = text;
    });
  }

  List<ToolConfig> _findTools(String keyword) {
    final ToolPlatform currentPlatform = Platform.isAndroid ? ToolPlatform.ANDROID : ToolPlatform.IOS;
    return keyword.length != 0
        ? _appToolsConfig
            .getTools(platform: currentPlatform)
            .where((tool) => tool.keywords.toLowerCase().contains(keyword.toLowerCase()) || tool.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList()
        : [];
  }

  @override
  void initState() {
    _appToolsConfig = AppToolsConfig();
    _searchHistory = StorageUtil.getStringList('history_search_list', defaultValue: []);
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double funcBtnWidth = MediaQuery.of(context).size.width < 600
        ? ((MediaQuery.of(context).size.width - 6 * 8) / 2)
        : ((MediaQuery.of(context).size.width - 8 * 8) / 3);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppLocale.current.searchTools,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          onChanged: (text) => _handleInputChange(text),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: (_searchHistory.length > 0 && _filterText.length == 0)
              // 无输入且有搜索历史则展示搜索历史
              ? Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.history),
                              Padding(padding: EdgeInsets.only(left: 8), child: Text("历史搜索", style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_sweep),
                            onPressed: () => _clearAll(),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: Wrap(
                          spacing: 12,
                          children: _fetchHistoryTools(_searchHistory)
                              .map(
                                (tool) => FlatButton(
                                  color: Color(0xFFF5F5F5),
                                  textColor: Color(0xFF545454),
                                  shape: StadiumBorder(),
                                  onPressed: () => _navigateToolPage(tool),
                                  child: Text(tool.name),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    ],
                  ),
                )
              :
              // 展示搜索结果
              Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: _findTools(_filterText)
                        .map(
                          (tool) => Container(
                            constraints: BoxConstraints(minWidth: funcBtnWidth, maxWidth: funcBtnWidth),
                            margin: EdgeInsets.all(8),
                            child: FlatButton(
                              color: Color(0xFFF8F8F8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: EdgeInsets.all(12),
                              onPressed: () => _handlePressResultItem(tool),
                              child: Text(tool.name),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
        ),
      ),
    );
  }
}

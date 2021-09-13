import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thinkerx/constants/tool_platform.dart';
import 'package:thinkerx/core/tools_config.dart';

class PageHomeViewModel with ChangeNotifier {
  int _tabIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  List<ToolConfig> _randomTools = [];

  int get tabIndex => _tabIndex;
  PageController get pageController => _pageController;
  List<ToolConfig> get randomTools => _randomTools;

  void handleSwitchTab(int tabIndex) {
    this._tabIndex = tabIndex;
    notifyListeners();
  }

  List<ToolConfig> generateRandomTools() {
    final List<ToolConfig> tools = AppToolsConfig().getTools(platform: Platform.isAndroid ? ToolPlatform.ANDROID : ToolPlatform.IOS)..shuffle();
    return tools.sublist(0, 5);
  }

  void changeRandomTools() {
    _randomTools = generateRandomTools();
    notifyListeners();
  }

  PageHomeViewModel() {
    _randomTools = generateRandomTools();
  }
}

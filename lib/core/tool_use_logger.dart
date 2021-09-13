import 'package:flutter/material.dart';
import 'package:thinkerx/core/db_helper.dart';
import 'package:thinkerx/database/entity/history.dart';

/// [ToolUseLogger] , 功能使用记录监测
class ToolUseLogger extends NavigatorObserver {
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null && route.settings.name.startsWith('/tool/')) {
      // 记录入库
      DbHelper.historyRecordDao.add(HistoryRecord(path: route.settings.name, time: DateTime.now().millisecondsSinceEpoch));
    }
  }
}

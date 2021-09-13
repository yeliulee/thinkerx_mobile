import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thinkerx/app.dart';
import 'package:thinkerx/core/db_helper.dart';
import 'package:thinkerx/core/runtime_env.dart';
import 'package:thinkerx/core/storage_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 生产模式
  RuntimeEnv.setEnv(false);

  /// 初始化数据库实例
  await DbHelper.init();

  /// 初始化Shared preferences 实例
  await StorageUtil.getInstance();

  /// 设置系统层界面相关
  handleSetSystemOverlay();

  /// 运行应用
  runApp(ApplicationManager());
}

handleSetSystemOverlay() {
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
}

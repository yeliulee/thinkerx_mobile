import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolSystemInfo extends StatefulWidget {
  @override
  _PageToolSystemInfoState createState() => _PageToolSystemInfoState();
}

class _PageToolSystemInfoState extends State<PageToolSystemInfo> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'Android 版本': build.version.release,
      '安全更新': build.version.securityPatch,
      '系统 API': build.version.sdkInt,
//      'version.previewSdkInt': build.version.previewSdkInt,
      '版本标识': build.version.incremental,
      '系统代码': build.version.codename,
      '系统基座': build.version.baseOS,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      '系统名称:': data.utsname.sysname,
      '网络名称:': data.utsname.nodename,
      '版本名称:': data.utsname.release,
      '系统版本:': data.utsname.version,
      '设备标识:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameSystemInfo),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          children: _deviceData.length == 0
              ? <Widget>[]
              : <Widget>[
                  ..._deviceData.entries
                      .map(
                        (e) => ListTile(
                          leading: Text(
                            e.key,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          title: Text(
                            e.value.toString(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                          onTap: () {},
                        ),
                      )
                      .toList(),
                ],
        ),
      ),
    );
  }
}

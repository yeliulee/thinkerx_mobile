import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolDeviceInfo extends StatefulWidget {
  @override
  _PageToolDeviceInfoState createState() => _PageToolDeviceInfoState();
}

class _PageToolDeviceInfoState extends State<PageToolDeviceInfo> {
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
      '设备品牌': build.brand,
      '制造商': build.manufacturer,
      '设备名称': build.model,
      '设备设计': build.device,
      '版本指纹': build.fingerprint,
      '处理器 ID': build.hardware,
      '主机名': build.host,
      '设备 ID': build.id,
      '产品设计': build.product,
//      '支持接口': build.supportedAbis,
      '设备类型': build.isPhysicalDevice ? '物理设备' : '虚拟设备',
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      '设备名称': data.name,
      '系统名称': data.systemName,
      '系统版本': data.systemVersion,
      '设备模型': data.model,
      '设备 ID': data.identifierForVendor,
      '设备类型': data.isPhysicalDevice ? '物理设备' : '虚拟设备',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameDeviceInfo),
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

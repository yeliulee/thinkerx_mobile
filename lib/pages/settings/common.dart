import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/router/app_router.gr.dart';
import 'package:thinkerx/store/app.dart';

class PageSettingCommon extends StatelessWidget {
  final Map<String, String> languages = {
    "zh_CN": "简体中文",
    "en_US": "English",
    "ja": "日本語",
    "ru": "русский язык",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.settingCommon),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(AppLocale.current.multipleLang),
            subtitle: Text(context.watch<AppViewModel>().followDeviceLocale
                ? "${AppLocale.current.followDeviceLocale}(${languages[AppLocale.current.localeKey]})"
                : languages[Provider.of<AppViewModel>(context).currentAppLocale.toString()]),
            leading: Icon(Icons.translate),
            trailing: Icon(Icons.keyboard_arrow_right),
//            onTap: () => _handleChangeLanguage(context),
            onTap: () => Fluttertoast.showToast(msg: "即将支持",gravity: ToastGravity.CENTER),
          ),
          ListTile(
            title: Text(AppLocale.current.themeManager),
            subtitle: Text(AppLocale.current.themeManagerDetail),
            leading: Icon(Icons.color_lens),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => ExtendedNavigator.root.pushPageSettingThemes(),
          ),
          ListTile(
            title: Text(AppLocale.current.cacheClear),
            subtitle: Text(AppLocale.current.cacheClearDetail),
            leading: Icon(Icons.delete),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _handleCacheClear(context),
          ),
          ListTile(
            title: Text(AppLocale.current.about),
            leading: Icon(Icons.info_outline),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => ExtendedNavigator.root.pushPageAbout(),
          ),
        ],
      ),
    );
  }

  void _handleChangeLanguage(BuildContext context) async {
    bool isLocaleInUse(String localeString) {
      return context.read<AppViewModel>().currentAppLocale.toString() == localeString && !context.read<AppViewModel>().followDeviceLocale;
    }

    List<Map<String, dynamic>> locales = [
      {
        "key": "follow_device_locale",
        "title": AppLocale.current.followDeviceLocale,
        "checked": Provider.of<AppViewModel>(context, listen: false).followDeviceLocale,
      },
      {
        "key": "zh_CN",
        "title": "简体中文(中国)",
        "checked": isLocaleInUse("zh_CN"),
        "locale": Locale('zh', 'CN'),
      },
      {
        "key": "en_US",
        "title": "English(United States)",
        "checked": isLocaleInUse("en_US"),
        "locale": Locale('en', 'US'),
      },
      {
        "key": "ja",
        "title": "日本語",
        "checked": isLocaleInUse("ja"),
        "locale": Locale('ja'),
      },
      {
        "key": "ru",
        "title": "русский язык",
        "checked": isLocaleInUse("ru"),
        "locale": Locale('ru'),
      },
    ];
    Map<String, dynamic> langInfo = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocale.current.chooseLanguage),
          children: locales
              .map(
                (locale) => SimpleDialogOption(
                  padding: EdgeInsets.all(0),
                  child: CheckboxListTile(
                    value: locale['checked'],
                    title: Text(locale['title']),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool value) {
                      Navigator.of(context).pop(locale);
                    },
                  ),
                ),
              )
              .toList(),
        );
      },
    );
    if (langInfo != null) {
      if (langInfo['key'] == 'follow_device_locale') {
        if (!context.read<AppViewModel>().followDeviceLocale) {
          context.read<AppViewModel>().handleChangeIsFollowDeviceLocale(true);
          // 清除当前 locale，跟随系统
          context.read<AppViewModel>().handleChangeCurrentAppLocale(null);
        }
      } else {
        context.read<AppViewModel>().handleChangeIsFollowDeviceLocale(false);
        context.read<AppViewModel>().handleChangeCurrentAppLocale(langInfo['locale']);
        AppLocale.load(langInfo['locale']);
      }
    }
  }

  void _handleCacheClear(BuildContext context) async {
    Future<void> delDir(FileSystemEntity file) async {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    }

    bool cacheClearConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        final List<Widget> actions = [
          FlatButton(onPressed: () => Navigator.of(context).pop(false), child: Text("NO")),
          FlatButton(onPressed: () => Navigator.of(context).pop(true), child: Text("YES")),
        ];
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(AppLocale.current.cacheClear),
                content: Text(AppLocale.current.cacheClearConfirm),
                actions: actions,
              )
            : AlertDialog(
                title: Text(AppLocale.current.cacheClear),
                content: Text(AppLocale.current.cacheClearConfirm),
                actions: actions,
              );
      },
    );

    // 执行清除缓存
    if (cacheClearConfirmed == true) {
      try {
        Directory tempDir = await getTemporaryDirectory();
        await delDir(tempDir);
        Fluttertoast.showToast(msg: "✔ success", gravity: ToastGravity.CENTER);
      } on Exception catch (e) {
        Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.BOTTOM);
      }
    }
  }
}

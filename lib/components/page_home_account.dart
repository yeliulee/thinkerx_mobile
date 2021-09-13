import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/pages/about.dart';
import 'package:thinkerx/router/app_router.gr.dart';

class PageHomeAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.accountManager),
        actions: <Widget>[],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(FontAwesomeIcons.userCircle),
            title: Text("账户信息"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => Fluttertoast.showToast(msg: "尚未开放", gravity: ToastGravity.CENTER),
//            onTap: () => ExtendedNavigator.root.push(AppRoutes.pageUserProfile),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.history),
            title: Text("使用记录"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => ExtendedNavigator.root.push(AppRoutes.pageHistory),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(AppLocale.current.favoritesManager),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => ExtendedNavigator.root.push(AppRoutes.pageFavoritesManager),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(AppLocale.current.settingCommon),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => ExtendedNavigator.root.pushPageSettingCommon(),
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text(AppLocale.current.helpAndFeedBack),
            trailing: Icon(Icons.keyboard_arrow_right),
//            onTap: () => ExtendedNavigator.root.push(AppRoutes.pageFeedback),
            onTap: () => PageAbout.handleJoinGroup(),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(AppLocale.current.quitApp),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _handleQuitApp(),
          ),
        ],
      ),
    );
  }

  void _handleQuitApp() async {
    await SystemChannels.platform.invokeMethod("SystemNavigator.pop");
  }
}

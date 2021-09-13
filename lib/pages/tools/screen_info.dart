import 'package:flutter/material.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolScreenInfo extends StatefulWidget {
  @override
  _PageToolScreenInfoState createState() => _PageToolScreenInfoState();
}

class _PageToolScreenInfoState extends State<PageToolScreenInfo> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double pixRatio = mediaQuery.devicePixelRatio;
    final double deviceWidth = mediaQuery.size.width * pixRatio;
    final double deviceHeight = mediaQuery.size.height * pixRatio;
    final double statusBarHeight = mediaQuery.padding.top * pixRatio;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameScreenInfo),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Text("像素密度"),
              title: Text(
                "$pixRatio",
                textAlign: TextAlign.right,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Text("设备宽度"),
              title: Text(
                "$deviceWidth px",
                textAlign: TextAlign.right,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Text("设备高度"),
              title: Text(
                "$deviceHeight px",
                textAlign: TextAlign.right,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Text("状态栏高度"),
              title: Text(
                "$statusBarHeight px",
                textAlign: TextAlign.right,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

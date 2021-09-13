import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:thinkerx/core/resource_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class PageAbout extends StatelessWidget {
  static void handleJoinGroup() async {
    String groupNumber = "384300653";
    String url =
        'mqqapi://card/show_pslcard?src_type=internal&version=1&uin=$groupNumber&card_type=group&source=qrcode';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "QQ 未安装");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: AssetImage(ResourceHelper.image_about_background),
          ),
        ),
        child: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              PackageInfo packageInfo = snapshot.data;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32)
                    .copyWith(top: MediaQuery.of(context).padding.top),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 32,
                      ),
                      child: Text(
                        "ThinkerX",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      child: Text(
                        "ThinkerX, extremely think what you think!",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Share.share(
                                  "ThinkerX,官网: https://www.yeliulee.com/");
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.share),
                                  Container(
                                    margin: EdgeInsets.only(left: 12),
                                    child: Text(
                                      "分享 ThinkerX",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => launch("https://www.yeliulee.com/"),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.update),
                                  Container(
                                    margin: EdgeInsets.only(left: 12),
                                    child: Text(
                                      "检查版本更新",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => handleJoinGroup(),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.group_add),
                                  Container(
                                    margin: EdgeInsets.only(left: 12),
                                    child: Text(
                                      "加入 QQ 群",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => showLicensePage(
                              context: context,
                              applicationName: "ThinkerX",
                              applicationVersion: '${packageInfo.version}',
                              applicationLegalese:
                                  "Copyright yeliulee@github.com 2020 ~ present All rights reserved.",
                              applicationIcon: Image.asset(
                                ResourceHelper.image_app_logo,
                                width: 48,
                                height: 48,
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.githubAlt),
                                  Container(
                                    margin: EdgeInsets.only(left: 12),
                                    child: Text(
                                      "开源许可",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

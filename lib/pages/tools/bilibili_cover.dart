import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolBilibiliCover extends StatefulWidget {
  @override
  _PageToolBilibiliCoverState createState() => _PageToolBilibiliCoverState();
}

class _PageToolBilibiliCoverState extends State<PageToolBilibiliCover> {
  TextEditingController _controller;
  String title;
  String imageURL;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  handleSearch() async {
    if (_controller.text.trim().length == 0) {
      await Fluttertoast.showToast(msg: "请输入 B 站视频 ID 或链接...");
      return false;
    }
    final ProgressDialog progressDialog = ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal);
    progressDialog.style(
      message: "正在获取, 请稍后...",
      progressWidget: Container(
          padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
    );
    try {
      await progressDialog.show();

      /// api is now unavailable, please refactor this method to use alapi v2
      Response<Map> response = await Dio().post(
        "https://v1.alapi.cn/api/bbcover",
        data: FormData.fromMap(
          {"c": _controller.text},
        ),
        options: Options(
          receiveTimeout: 5000,
          sendTimeout: 5000,
        ),
      );
      if (response.data['code'].toString() == '200') {
        setState(() {
          title = response.data['data']['title'];
          if (response.data['data']['cover'] != null &&
              response.data['data']['cover'].toString().length > 0) {
            imageURL = response.data['data']['cover'];
          }
        });
      }
      await progressDialog.hide();
    } catch (e) {
      await progressDialog.hide();
      Fluttertoast.showToast(msg: e.error.toString());
    }
  }

  handleSaveImage() async {
    final ProgressDialog progressDialog = ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal);
    progressDialog.style(
      message: "正在保存, 请稍后...",
      progressWidget: Container(
          padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
    );
    try {
      await progressDialog.show();
      final Directory tempDir = await getTemporaryDirectory();
      final String savedFilePath =
          '${tempDir.path}/image_download_cache_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Response res = await Dio().download(imageURL, savedFilePath);
      if (res.statusCode == 200) {
        if ((await Permission.storage.request()).isGranted) {
          await ImageGallerySaver.saveFile(savedFilePath);
        } else {
          throw Exception(FormatException("permission denied!"));
        }
      }
      await progressDialog.hide();
      Fluttertoast.showToast(msg: "已保存到相册");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      await progressDialog.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocale.current.toolNameBilibiliCover),
        bottom: _buildSearchBox(context),
      ),
      body: _buildContent(context),
      floatingActionButton: imageURL == null
          ? null
          : FloatingActionButton(
              child: Icon(FontAwesomeIcons.solidSave),
              onPressed: () => handleSaveImage(),
            ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: (title != null)
              ? <Widget>[
                  ListTile(
                    leading: Text("标题"),
                    title: Text(
                      title,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (imageURL != null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: Image.network(
                        imageURL,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                ]
              : <Widget>[],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(96),
      child: Container(
        height: 96,
        padding: EdgeInsets.all(16),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TextField(
              controller: _controller,
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                hintText: "请输入 B 站视频 ID 或链接...",
                suffixIcon: IconButton(
                  enableFeedback: true,
                  icon: Icon(Icons.search),
                  onPressed: () => handleSearch(),
                ),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onSubmitted: (String value) => handleSearch(),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PageToolWhatAnime extends StatefulWidget {
  @override
  _PageToolWhatAnimeState createState() => _PageToolWhatAnimeState();
}

class _PageToolWhatAnimeState extends State<PageToolWhatAnime> {
  File imageFile;
  String imageFilename;
  final ImagePicker imagePicker = ImagePicker();
  List animeList = [];
  @override
  void initState() {
    imageFilename = '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handlePickImage(BuildContext context) async {
    try {
      PickedFile pickedFile =
          await imagePicker.getImage(source: ImageSource.gallery);
      if (pickedFile.path.length > 0) {
        File tempFile = File(pickedFile.path);
        if (tempFile.lengthSync() / (1000 * 1000) > 10) {
          Fluttertoast.showToast(
              msg: "图片不能大于10MB",
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
        } else {
          setState(() {
            imageFile = tempFile;
            imageFilename = imageFile.path
                .substring(imageFile.path.lastIndexOf('/') + 1)
                .replaceFirst('image_picker', 'temp_');
            fetchData(context);
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  fetchData(BuildContext context) async {
    FormData formData = new FormData.fromMap({
      'image': base64Encode(imageFile.readAsBytesSync()),
    });
    final ProgressDialog progressDialog = ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal);
    progressDialog.style(
      message: "搜索中, 请稍后...",
      progressWidget: Container(
          padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
    );
    try {
      await progressDialog.show();

      /// api is now unavailable, please refactor this method
      Response response = await Dio().request(
        'https://trace.moe/api/search',
        options: Options(
          method: 'POST',
          sendTimeout: 10000,
          receiveTimeout: 10000,
        ),
        data: formData,
      );
      final resData = response.data;
      await progressDialog.hide();
      if (resData["docs"] != null && resData["docs"].length > 0) {
        List tempAnimeList = resData['docs'];
        setState(() {
          animeList = [];
          tempAnimeList.forEach((anime) {
            if (!anime['is_adult']) {
              animeList.add(anime);
            }
          });
        });
      } else {
        Fluttertoast.showToast(
            msg: "搜索失败...",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e) {
      await progressDialog.hide();
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("以图搜番"),
        bottom: _buildSearchBox(context),
      ),
      body: animeList.length > 0 ? _buildContent(context) : _buildNotice(),
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
            child: Container(
              height: 48,
              color: Colors.white,
              padding: EdgeInsets.only(left: 8),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        imageFilename.length > 0 ? imageFilename : '点击按钮选择图片',
                        style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        if (imageFile != null)
                          IconButton(
                            constraints:
                                BoxConstraints(maxWidth: 48, maxHeight: 48),
                            color: Colors.grey,
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                animeList = [];
                                imageFile = null;
                                imageFilename = "";
                              });
                            },
                          ),
                        IconButton(
                          constraints:
                              BoxConstraints(maxWidth: 48, maxHeight: 48),
                          icon: Icon(Icons.cloud_upload),
                          onPressed: () => handlePickImage(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 16),
      itemCount: animeList.length,
      itemBuilder: (BuildContext context, int index) => _buildAnimeCard(
        context,
        Map.from(animeList[index]),
        index,
      ),
    );
  }

  /// api is now unavailable, please refactor this method
  Widget _buildAnimeCard(BuildContext context, Map anime, int index) {
    final double imageContainerWidth = MediaQuery.of(context).size.width - 48;
    return Container(
      padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: Card(
        elevation: 2,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                anime['title_native'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0),
                leading: Text("匹配位置",
                    overflow: TextOverflow.ellipsis, softWrap: false),
                title: Text(
                  Duration(
                          seconds:
                              double.parse(anime['from'].toString()).floor())
                      .toString()
                      .split('.')
                      .first
                      .padLeft(8, "0"),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0),
                leading: Text("中文名称",
                    overflow: TextOverflow.ellipsis, softWrap: false),
                title: Text(anime['title_chinese'],
                    overflow: TextOverflow.ellipsis, softWrap: false),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0),
                leading: Text("英文名称",
                    overflow: TextOverflow.ellipsis, softWrap: false),
                title: Text(anime['title_english'],
                    overflow: TextOverflow.ellipsis, softWrap: false),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0),
                leading: Text("相似指数",
                    overflow: TextOverflow.ellipsis, softWrap: false),
                title: Text(
                  double.parse(anime['similarity'].toString())
                      .toStringAsFixed(2),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              Container(
                width: imageContainerWidth,
                margin: EdgeInsets.only(top: 8),
                child: Image.network(
                  "https://trace.moe/thumbnail.php?anilist_id=${anime['anilist_id']}&file=${Uri.encodeComponent(anime['filename'])}&t=${anime['at']}&token=${anime['tokenthumb']}",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotice() {
    return Container(
      width: MediaQuery.of(context).size.width * (2 / 3),
      padding: EdgeInsets.all(16),
      alignment: Alignment.topLeft,
      child: Text(
        "使用须知:\n1.数据来源于 trace.moe\n2.图片不经过 ThinkerX 服务器\n3.识别成功率取决于上传的截图",
        style: TextStyle(
          color: Theme.of(context).primaryColor.withOpacity(0.75),
        ),
      ),
    );
  }
}

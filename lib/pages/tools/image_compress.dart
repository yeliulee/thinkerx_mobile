import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart' as imageD;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolImageCompress extends StatefulWidget {
  @override
  _PageToolImageCompressState createState() => _PageToolImageCompressState();
}

class _PageToolImageCompressState extends State<PageToolImageCompress> {
  Map<String, String> selectedImages = {};
  bool isProcessing = false;

  @override
  void dispose() async {
    super.dispose();
    await FilePicker.clearTemporaryFiles();
  }

  handleSelectImages() async {
    if ((await Permission.storage.request()).isGranted) {
      Map<String, String> images;
      try {
        images = await FilePicker.getMultiFilePath(type: FileType.image);
      } catch (e) {
        return false;
      }
      if (images != null && images.length > 20) {
        await Fluttertoast.showToast(msg: "最多选择 20 张图片");
      }
      if (images != null && images.length > 0) {
        setState(() {
          selectedImages = images;
        });
      }
    }
  }

  handleProcess() async {
    Map<String, Uint8List> compressedImages = {};
    int total = selectedImages.length;
    int current = 0;
    ProgressDialog progressDialog = ProgressDialog(context, isDismissible: true, type: ProgressDialogType.Normal);
    progressDialog.style(
      message: "正在压缩 $current/$total 张...",
      progressWidget: Container(
        padding: EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      ),
    );
    await progressDialog.show();
    try {
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      selectedImages.forEach((key, value) {
        progressDialog.update(
          message: "正在压缩 ${current + 1}/$total 张...",
        );
        Uint8List tempImageData = imageD.encodeJpg(imageD.decodeImage(File(value).readAsBytesSync()), quality: 50);
        compressedImages.putIfAbsent('thinkerx_compressed_image_${timestamp}_${current + 1}', () => tempImageData);
        current += 1;
      });
      compressedImages.forEach((key, value) async {
        await ImageGallerySaver.saveImage(value, name: key, quality: 50);
      });
      await progressDialog.hide();
      await Fluttertoast.showToast(msg: "处理完毕,已保存至相册", gravity: ToastGravity.CENTER);
    } catch (e) {
      await progressDialog.hide();
      await Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
    }
  }

  handleDeleteItem(String imageName) {
    setState(() {
      selectedImages.removeWhere((key, value) => key == imageName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameImageCompressor),
      ),
      body: selectedImages.length == 0 ? _buildPickerView(context) : _buildProcessView(context),
      floatingActionButton: selectedImages.length == 0
          ? null
          : FloatingActionButton(
              onPressed: () => handleSelectImages(),
              child: Icon(Icons.cloud_upload),
            ),
    );
  }

  Widget _buildProcessView(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            children: selectedImages.entries
                .map(
                  (image) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    constraints: BoxConstraints(
                      maxWidth: 128,
                    ),
                    child: Chip(
                      backgroundColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
                      label: Text(
                        image.key,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onDeleted: () => isProcessing ? null : handleDeleteItem(image.key),
                      deleteIconColor: Colors.black45,
                    ),
                  ),
                )
                .toList(),
          ),
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top: 24),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        selectedImages = {};
                      });
                    },
                    child: Text(
                      "清空列表",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    color: Theme.of(context).primaryColor.withOpacity(0.75),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 6,
                  child: FlatButton(
                    onPressed: () => handleProcess(),
                    child: Text(
                      "开始压缩",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    color: Theme.of(context).primaryColor.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerView(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: IconButton(
        iconSize: 48,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        icon: Icon(
          FontAwesomeIcons.image,
          color: Theme.of(context).primaryColorLight,
        ),
        splashColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
        onPressed: () => handleSelectImages(),
      ),
    );
  }
}

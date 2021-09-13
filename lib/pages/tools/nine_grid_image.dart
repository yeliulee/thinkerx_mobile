import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PageToolNineGridImage extends StatefulWidget {
  @override
  _PageToolNineGridImageState createState() => _PageToolNineGridImageState();
}

class _PageToolNineGridImageState extends State<PageToolNineGridImage> {
  File croppedImageFile;

  ProgressDialog createLoadingDialog() {
    final ProgressDialog progressDialog = ProgressDialog(context, isDismissible: false, type: ProgressDialogType.Normal);
    progressDialog.style(
      message: "处理中...",
      progressWidget: Container(padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
    );
    return progressDialog;
  }

  handlePickImage(BuildContext context) async {
    Color primaryColor = Theme.of(context).primaryColor;
    String imagePath = await FilePicker.getFilePath(type: FileType.image);
    if (imagePath != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: imagePath,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
          toolbarColor: primaryColor,
          toolbarWidgetColor: primaryColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
        ),
      );
      if (croppedFile != null) {
        setState(() {
          croppedImageFile = croppedFile;
        });
      }
    }
  }

  handleCrop() async {
    ProgressDialog loading = createLoadingDialog();
    await loading.show();
    try {
      List<img.Image> images = [];
      img.Image image = img.decodeImage(croppedImageFile.readAsBytesSync());
      int cropSize = image.width ~/ 3;
      images.add(img.copyCrop(image, 0, 0, cropSize, cropSize)); // 1,1
      await Future.delayed(Duration(milliseconds: 50));
      images.add(img.copyCrop(image, cropSize, 0, cropSize, cropSize)); // 1,2
      await Future.delayed(Duration(milliseconds: 50));
      images.add(img.copyCrop(image, cropSize * 2, 0, cropSize, cropSize)); // 1,3
      await Future.delayed(Duration(milliseconds: 50));
      images.add(img.copyCrop(image, 0, cropSize, cropSize, cropSize)); // 2,1
      await Future.delayed(Duration(milliseconds: 50));
      images.add(img.copyCrop(image, cropSize, cropSize, cropSize, cropSize)); // 2,2
      await Future.delayed(Duration(milliseconds: 50));
      images.add(img.copyCrop(image, cropSize * 2, cropSize, cropSize, cropSize)); // 2,3
      await Future.delayed(Duration(milliseconds: 50));
      images.add(img.copyCrop(image, 0, cropSize * 2, cropSize, cropSize)); // 3,1
      await Future.delayed(Duration(milliseconds: 50));
      images.add(img.copyCrop(image, cropSize, cropSize * 2, cropSize, cropSize)); // 3,2
      await Future.delayed(Duration(milliseconds: 50));
      images.add(img.copyCrop(image, cropSize * 2, cropSize * 2, cropSize, cropSize)); // 3,3
      int counter = 1;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      images.forEach((img.Image tempImage) {
        String filename = "nine_grid_image_${timestamp}_$counter";
        ImageGallerySaver.saveImage(img.encodeJpg(tempImage), quality: 100, name: filename);
        counter++;
      });
      await loading.hide();
      await Fluttertoast.showToast(msg: "已保存到相册", gravity: ToastGravity.CENTER);
    } catch (e) {
      await loading.hide();
      await Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("九宫格切图"),
      ),
      body: _buildProcessor(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => handleCrop(),
        child: Icon(Icons.content_cut),
      ),
    );
  }

  Widget _buildProcessor(BuildContext context) {
    final double viewSize = MediaQuery.of(context).size.width - 24;
    return Container(
      margin: EdgeInsets.all(12),
      child: Center(
        child: GestureDetector(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: viewSize,
              maxHeight: viewSize,
            ),
            color: Colors.grey[100],
            child: Stack(
              children: <Widget>[
                if (croppedImageFile == null)
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "点击选择图片",
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                if (croppedImageFile != null)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: viewSize,
                      height: viewSize,
                      child: Image.file(
                        croppedImageFile,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                CustomPaint(
                  size: Size(
                    viewSize,
                    viewSize,
                  ),
                  painter: NineGridImageView(),
                ),
              ],
            ),
          ),
          onTap: () => handlePickImage(context),
        ),
      ),
    );
  }
}

class NineGridImageView extends CustomPainter {
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 1
      ..isAntiAlias = true
      ..color = Colors.grey;

    double startX = 0;
    double startY = 0;
    double max = size.width;
    double space = 10;

    // 画横线
    while (startX < max) {
      canvas.drawLine(Offset(startX, size.width / 3), Offset(startX + 5, size.width / 3), paint);
      canvas.drawLine(Offset(startX, (size.width / 3) * 2), Offset(startX + 5, (size.width / 3) * 2), paint);
      startX += space;
    }

    // 画竖线
    while (startY < max) {
      canvas.drawLine(Offset(size.height / 3, startY), Offset(size.height / 3, startY + 5), paint);
      canvas.drawLine(Offset((size.height / 3) * 2, startY), Offset((size.height / 3) * 2, startY + 5), paint);
      startY += space;
    }
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:progress_dialog/progress_dialog.dart';

class PageToolColorPicker extends StatefulWidget {
  @override
  _PageToolColorPickerState createState() => _PageToolColorPickerState();
}

class _PageToolColorPickerState extends State<PageToolColorPicker> with SingleTickerProviderStateMixin {
  TabController _tabController;
  Color _imagePickedColor;
  Color _palettePickedColor;
  String _imagePath;
  GlobalKey _indicatorViewKey, _imageViewKey;
  double _indicatorDx, _indicatorDy;
  img.Image photo;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _indicatorViewKey = GlobalKey<_PageToolColorPickerState>();
    _imageViewKey = GlobalKey<_PageToolColorPickerState>();
    _indicatorDx = _indicatorDy = 0;
    _palettePickedColor = Colors.blueAccent;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  ProgressDialog createLoadingDialog() {
    final ProgressDialog progressDialog = ProgressDialog(context, isDismissible: false, type: ProgressDialogType.Normal);
    progressDialog.style(
      message: "加载中...",
      progressWidget: Container(padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
    );
    return progressDialog;
  }

  handlePickImage() async {
    final tempPath = await FilePicker.getFilePath(type: FileType.image);
    if (tempPath != null) {
      setState(() {
        _imagePath = tempPath;
      });
      ProgressDialog loading = createLoadingDialog();
      await loading.show();
      try {
        await Future.delayed(Duration(milliseconds: 1000));
        RenderRepaintBoundary boundary = _imageViewKey.currentContext.findRenderObject();
        ui.Image image = await boundary.toImage();
        ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        setState(() {
          photo = img.decodeImage(byteData.buffer.asUint8List());
          handlePickImageColor();
        });
        await loading.hide();
      } catch (e) {
        await loading.hide();
        await Fluttertoast.showToast(msg: "加载失败, 请重试");
      }
    }
  }

  handleDrag(Offset offset) async {
    if (photo == null) {
      await Fluttertoast.showToast(msg: "请先选取图片");
      return false;
    }
    Size imageViewSize = _imageViewKey.currentContext.size;
    setState(() {
      if (_indicatorDx.abs() * 2 < imageViewSize.width) {
        double tempDx = _indicatorDx + offset.dx;
        if (tempDx.abs() * 2 > imageViewSize.width) {
          _indicatorDx = (_indicatorDx > 0 ? imageViewSize.width : -imageViewSize.width) / 2 + (_indicatorDx > 0 ? -0.1 : 0.1);
        } else {
          _indicatorDx = tempDx;
        }
      }
      if (_indicatorDy.abs() * 2 < imageViewSize.height) {
        double tempDy = _indicatorDy + offset.dy;
        if (tempDy.abs() * 2 > imageViewSize.height) {
          _indicatorDy = (_indicatorDy > 0 ? imageViewSize.height : -imageViewSize.height) / 2 + (_indicatorDy > 0 ? -0.1 : 0.1);
        } else {
          _indicatorDy = tempDy;
        }
      }
      handlePickImageColor();
    });
  }

  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  handlePickImageColor() async {
    Size imageViewSize = _imageViewKey.currentContext.size;
    double px = imageViewSize.width / 2 + _indicatorDx;
    double py = imageViewSize.height / 2 + _indicatorDy;
    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);
    setState(() {
      _imagePickedColor = Color(hex);
    });
  }

  handleMoveIndicator(MoveDirection moveDirection) {
    switch (moveDirection) {
      case MoveDirection.up:
        handleDrag(Offset(0, -0.5));
        break;
      case MoveDirection.down:
        handleDrag(Offset(0, 0.5));
        break;
      case MoveDirection.right:
        handleDrag(Offset(0.5, 0));
        break;
      case MoveDirection.left:
        handleDrag(Offset(-0.5, 0));
        break;
    }
  }

  handleCopy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    await Fluttertoast.showToast(msg: "已复制", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("拾色器"),
        bottom: _buildTabBar(context),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildPickerView(context),
          _buildPaletteView(context),
        ],
      ),
    );
  }

  /// [_buildTabBar] 构造 TabBar
  Widget _buildTabBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.all(8).copyWith(left: 16),
          alignment: Alignment.centerLeft,
          constraints: BoxConstraints(
            maxHeight: 32,
          ),
          child: Theme(
            data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              indicator: BoxDecoration(
                color: Theme.of(context).primaryColorLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              tabs: [
                Tab(
                  text: "图片取色",
                ),
                Tab(
                  text: "调色板",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildPickerView] 构造图片拾色视图
  Widget _buildPickerView(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 24),
                child: RaisedButton(
                  onPressed: _imagePickedColor != null ? () => handleCopy(_imagePickedColor.value.toRadixString(16).toUpperCase()) : () {},
                  color: _imagePickedColor ?? primaryColor,
                  child: Text(
                    "#${_imagePickedColor != null ? _imagePickedColor.value.toRadixString(16).toUpperCase() : '0'}",
                    style: TextStyle(
                      color: _imagePickedColor != null ? (_imagePickedColor.computeLuminance() >= 0.5 ? Colors.black : Colors.white) : Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              RaisedButton(
                onPressed: handlePickImage,
                color: primaryColor,
                child: Text(
                  "选择图片",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_imagePath != null)
                    RepaintBoundary(
                      key: _imageViewKey,
                      child: Container(
                        width: double.infinity,
                        child: Image.file(
                          File(_imagePath),
                        ),
                      ),
                    ),
                  GestureDetector(
                    onPanUpdate: (DragUpdateDetails details) => handleDrag(details.delta),
                    child: Align(
                      child: Transform.translate(
                        offset: Offset(_indicatorDx, _indicatorDy),
                        child: Container(
                          key: _indicatorViewKey,
                          child: Icon(
                            FontAwesomeIcons.crosshairs,
                            color: Colors.redAccent,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () => handleMoveIndicator(MoveDirection.left),
                child: Icon(Icons.keyboard_arrow_left),
                color: Colors.grey[300],
              ),
              FlatButton(
                onPressed: () => handleMoveIndicator(MoveDirection.right),
                child: Icon(Icons.keyboard_arrow_right),
                color: Colors.grey[300],
              ),
              FlatButton(
                onPressed: () => handleMoveIndicator(MoveDirection.up),
                child: Icon(Icons.keyboard_arrow_up),
                color: Colors.grey[300],
              ),
              FlatButton(
                onPressed: () => handleMoveIndicator(MoveDirection.down),
                child: Icon(Icons.keyboard_arrow_down),
                color: Colors.grey[300],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// [_buildPaletteView] 构造调色盘视图
  Widget _buildPaletteView(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ColorPicker(
            pickerColor: _palettePickedColor,
            showLabel: false,
            colorPickerWidth: MediaQuery.of(context).size.width - 24,
            pickerAreaBorderRadius: BorderRadius.circular((MediaQuery.of(context).size.width - 24) / 2),
            onColorChanged: (Color value) {
              setState(() {
                _palettePickedColor = value;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            width: double.infinity,
            child: RaisedButton(
              onPressed: _palettePickedColor != null ? () => handleCopy("#${_palettePickedColor.value.toRadixString(16).toUpperCase()}") : () {},
              color: _palettePickedColor ?? primaryColor,
              child: Text(
                "#${_palettePickedColor != null ? _palettePickedColor.value.toRadixString(16).toUpperCase() : '0'}",
                style: TextStyle(
                  color: _palettePickedColor.computeLuminance() >= 0.5 ? Colors.black : Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum MoveDirection {
  up,
  right,
  down,
  left,
}

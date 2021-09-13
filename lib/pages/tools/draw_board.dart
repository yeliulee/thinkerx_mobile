import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thinkerx/components/painter.dart';

class PageToolDrawBoard extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<PageToolDrawBoard> {
  PainterController _controller;
  double _thickness;
  Color _bgColor;
  Color _foreColor;
  GlobalKey _globalKey;

  @override
  void initState() {
    super.initState();
    _globalKey = GlobalKey();
    _thickness = 5.0;
    _bgColor = Colors.white;
    _foreColor = Colors.black;
    _controller = _newController();
  }

  PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = _thickness;
    controller.backgroundColor = _bgColor;
    controller.drawColor = _foreColor;
    return controller;
  }

  _pickColor(BuildContext context, [bool isBgColor = false]) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: isBgColor ? _bgColor : _foreColor,
              onColorChanged: (Color color) {
                setState(() {
                  if (isBgColor) {
                    _controller.backgroundColor = _bgColor = color;
                  } else {
                    _controller.drawColor = _foreColor = color;
                  }
                });
              },
              colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: true,
              displayThumbColor: true,
              showLabel: true,
              paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(2.0),
                topRight: const Radius.circular(2.0),
              ),
            ),
          ),
        );
      },
    );
  }

  ProgressDialog createLoadingDialog(BuildContext context) {
    final ProgressDialog progressDialog = ProgressDialog(context, isDismissible: false, type: ProgressDialogType.Normal);
    progressDialog.style(
      message: "正在保存...",
      progressWidget: Container(padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
    );
    return progressDialog;
  }

  void _save(BuildContext context) async {
    ProgressDialog progressDialog = createLoadingDialog(context);
    try {
      await progressDialog.show();
      RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
      Image targetImage = await boundary.toImage(pixelRatio: MediaQuery.of(context).devicePixelRatio);
      ByteData byteData = await targetImage.toByteData(format: ImageByteFormat.png);
      Uint8List imageBytes = byteData.buffer.asUint8List();
      String imageSavedFilename = 'thinkerx_painted_image_${DateTime.now().millisecondsSinceEpoch}';
      if ((await Permission.storage.request()).isGranted) {
        final result = await ImageGallerySaver.saveImage(imageBytes, name: imageSavedFilename);
        await progressDialog.hide();
        if (result != null) {
          Fluttertoast.showToast(msg: "保存成功", gravity: ToastGravity.CENTER);
        }
      }
    } catch (e) {
      await progressDialog.hide();
      await Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('绘画板'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.undo,
                ),
                onPressed: () {
                  if (!_controller.isEmpty) {
                    _controller.undo();
                  }
                }),
            IconButton(icon: Icon(Icons.delete_sweep), onPressed: _controller.clear),
            IconButton(icon: Icon(Icons.save), onPressed: () => _save(context)),
          ],
          bottom: PreferredSize(
            child: _buildSettingBar(context),
            preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
          )),
      body: RepaintBoundary(
        key: _globalKey,
        child: Painter(_controller),
      ),
    );
  }

  Widget _buildSettingBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Container(
              child: Slider(
            value: _controller.thickness,
            onChanged: (double value) => setState(() {
              _controller.thickness = _thickness = value;
            }),
            min: 1.0,
            max: 20.0,
            activeColor: Colors.white,
          ));
        })),
        IconButton(
            icon: Icon(
              _controller.eraseMode ? Icons.create : FontAwesomeIcons.eraser,
              color: Colors.black87,
            ),
            onPressed: () {
              setState(() {
                _controller.eraseMode = !_controller.eraseMode;
              });
            }),
        IconButton(
          icon: Icon(
            Icons.brush,
            color: _foreColor,
          ),
          onPressed: () => _pickColor(context),
        ),
        IconButton(
          icon: Icon(
            Icons.format_color_fill,
            color: _bgColor,
          ),
          onPressed: () => _pickColor(context, true),
        ),
      ],
    );
  }
}

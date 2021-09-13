import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:thinkerx/core/resource_helper.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolQrcode extends StatefulWidget {
  @override
  _PageToolQrcodeState createState() => _PageToolQrcodeState();
}

class _PageToolQrcodeState extends State<PageToolQrcode> with SingleTickerProviderStateMixin {
  static const String QR_LEVEL = "level";
  static const String QR_LEVEL_LABEL = "level_label";
  TabController _tabController;
  Color foreColor;
  Color bgColor;
  double qrSize;
  double qrPadding;
  String currentText;
  File logoImageFile;
  String logoImageFilename;
  int correctLevel;
  List<Map> correctLevels = [
    {
      QR_LEVEL: QrErrorCorrectLevel.L,
      QR_LEVEL_LABEL: "低",
    },
    {
      QR_LEVEL: QrErrorCorrectLevel.M,
      QR_LEVEL_LABEL: "中",
    },
    {
      QR_LEVEL: QrErrorCorrectLevel.Q,
      QR_LEVEL_LABEL: "正常",
    },
    {
      QR_LEVEL: QrErrorCorrectLevel.H,
      QR_LEVEL_LABEL: "高",
    },
  ];
  GlobalKey _globalKey = GlobalKey();
  FocusNode _focusNode = FocusNode();
  String scanResultText;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    foreColor = Colors.black;
    bgColor = Colors.white;
    qrSize = 200;
    qrPadding = 0;
    currentText = 'empty data';
    correctLevel = QrErrorCorrectLevel.Q;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  handleChangeColor(BuildContext context, {bool isBgColor = false}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: isBgColor ? bgColor : foreColor,
              onColorChanged: (Color color) {
                setState(() {
                  if (isBgColor) {
                    bgColor = color;
                  } else {
                    foreColor = color;
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

  handlePickImage(BuildContext context) async {
    try {
      PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile.path.length > 0) {
        File tempFile = File(pickedFile.path);
        setState(() {
          logoImageFile = tempFile;
          logoImageFilename = logoImageFile.path.substring(logoImageFile.path.lastIndexOf('/') + 1).replaceFirst('image_picker', 'temp_');
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  handleSaveImage(BuildContext context, double qrContainerSize) async {
    final ProgressDialog progressDialog = ProgressDialog(context, isDismissible: false, type: ProgressDialogType.Normal);
    progressDialog.style(
      message: "正在保存, 请稍后...",
      progressWidget: Container(padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
    );
    try {
      await progressDialog.show();
      RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
      ui.Image targetImage = await boundary.toImage(pixelRatio: qrSize / qrContainerSize);
      ByteData byteData = await targetImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List imageBytes = byteData.buffer.asUint8List();
      String imageSavedFilename = 'thinkerx_qrcode_image_${DateTime.now().millisecondsSinceEpoch}';
      if ((await Permission.storage.request()).isGranted) {
        final result = await ImageGallerySaver.saveImage(imageBytes, name: imageSavedFilename);
        await progressDialog.hide();
        if (result != null) {
          Fluttertoast.showToast(msg: "保存成功", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);
        }
      }
    } catch (e) {
      await progressDialog.hide();
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    }
  }

  handleScanQrCode(BuildContext context) async {
    if ((await Permission.camera.request()).isGranted && (await Permission.storage.request()).isGranted) {
      String result = await scanner.scan();
      setState(() {
        scanResultText = result;
      });
    }
  }

  handleCopyResult() async {
    await Clipboard.setData(ClipboardData(text: scanResultText));
    Fluttertoast.showToast(msg: '已复制到剪贴板');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocale.current.toolNameQrCode),
          bottom: _buildTabBar(context),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _buildEncoder(context),
            _buildDecoder(context),
          ],
        ),
      ),
    );
  }

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
                  text: "生成",
                ),
                Tab(
                  text: "解析",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEncoder(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final qrContainerSize = MediaQuery.of(context).size.width - 32;
    double qrPdd = (qrPadding / qrContainerSize) * qrPadding;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: "请输入二维码内容,如网址...",
            ),
            onChanged: (String value) {
              setState(() {
                currentText = value;
              });
            },
            focusNode: _focusNode,
          ),
          Container(
            alignment: Alignment.center,
            margin: MediaQuery.of(context).padding,
            padding: EdgeInsets.only(bottom: 4),
            width: qrContainerSize,
            height: qrContainerSize,
            constraints: BoxConstraints(maxWidth: qrContainerSize, maxHeight: qrSize > qrContainerSize ? qrContainerSize : qrSize),
            child: RepaintBoundary(
              key: _globalKey,
              child: QrImage(
                data: currentText,
                size: qrSize,
                padding: EdgeInsets.all(qrPdd),
                backgroundColor: bgColor,
                foregroundColor: foreColor,
                errorCorrectionLevel: correctLevel,
                embeddedImage: logoImageFile == null ? null : FileImage(logoImageFile),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(48, 48),
                ),
              ),
            ),
          ),
          Container(
            margin: MediaQuery.of(context).padding,
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: QrColorIndicator(
                    title: "前景色",
                    color: foreColor,
                    onPress: () => handleChangeColor(context),
                  ),
                ),
                Container(
                  width: 2,
                  height: 24,
                  color: Theme.of(context).primaryColor,
                ),
                Flexible(
                  flex: 1,
                  child: QrColorIndicator(
                    title: "背景色",
                    color: bgColor,
                    onPress: () => handleChangeColor(context, isBgColor: true),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: MediaQuery.of(context).padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 12),
                  child: Text("二维码容错率："),
                ),
                DropdownButton<String>(
                  isDense: true,
                  value: correctLevels.firstWhere((e) => e[QR_LEVEL] == correctLevel)[QR_LEVEL_LABEL],
                  onChanged: (String value) {},
                  items: correctLevels
                      .map<DropdownMenuItem<String>>(
                        (tempCorrectLevel) => DropdownMenuItem(
                          value: tempCorrectLevel[QR_LEVEL_LABEL],
                          onTap: () {
                            setState(() {
                              correctLevel = tempCorrectLevel[QR_LEVEL];
                            });
                          },
                          child: Text(tempCorrectLevel[QR_LEVEL_LABEL]),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          Container(
            margin: MediaQuery.of(context).padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("二维码 LOGO"),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  constraints: BoxConstraints(maxHeight: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          logoImageFilename == null ? '点击图标选择 LOGO' : logoImageFilename,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          if (logoImageFile != null)
                            IconButton(
                              constraints: BoxConstraints(maxWidth: 48, maxHeight: 48),
                              color: Colors.grey,
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  logoImageFile = null;
                                  logoImageFilename = null;
                                });
                              },
                            ),
                          IconButton(
                            icon: Icon(Icons.cloud_upload),
                            onPressed: () => handlePickImage(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: MediaQuery.of(context).padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("二维码尺寸"),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 12),
                        child: Text("192"),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            inactiveTrackColor: Colors.grey,
                            activeTrackColor: primaryColor,
                            thumbColor: primaryColor,
                            overlayColor: primaryColor.withOpacity(0.5),
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                            valueIndicatorColor: primaryColor.withOpacity(0.5),
                          ),
                          child: Slider(
                            min: 192,
                            max: 1024,
                            divisions: 831,
                            value: qrSize,
                            label: "${qrSize.round()}",
                            onChanged: (double value) {
                              setState(() {
                                qrSize = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12),
                        child: Text("1024"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: MediaQuery.of(context).padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("二维码边距"),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 12),
                        child: Text("0"),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            inactiveTrackColor: Colors.grey,
                            activeTrackColor: primaryColor,
                            thumbColor: primaryColor,
                            overlayColor: primaryColor.withOpacity(0.5),
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                            valueIndicatorColor: primaryColor.withOpacity(0.5),
                          ),
                          child: Slider(
                            min: 0,
                            max: 100,
                            divisions: 99,
                            value: qrPadding,
                            label: "${qrPadding.round()}",
                            onChanged: (double value) {
                              setState(() {
                                qrPadding = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12),
                        child: Text("100"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: MediaQuery.of(context).padding.copyWith(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(minWidth: 128),
                  child: FlatButton(
                    color: primaryColor,
                    child: Text("保存", style: TextStyle(color: Colors.white)),
                    onPressed: () => handleSaveImage(context, qrContainerSize),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecoder(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(16),
      child: Stack(
        children: scanResultText != null
            ? <Widget>[
                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        scanResultText,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    onTap: () => handleCopyResult(),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () => handleScanQrCode(context),
                    child: SvgPicture.asset(
                      ResourceHelper.icon_scan_qr_code,
                      color: Colors.white,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ]
            : <Widget>[
                Center(
                  child: FlatButton(
                    padding: EdgeInsets.all(16),
                    child: SvgPicture.asset(
                      ResourceHelper.icon_scan_qr_code,
                      width: width / 4,
                      height: width / 4,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    highlightColor: Colors.transparent,
                    onPressed: () => handleScanQrCode(context),
                  ),
                ),
              ],
      ),
    );
  }
}

/// [QrColorIndicator] 二维码颜色指示器
class QrColorIndicator extends StatelessWidget {
  final String title;

  final GestureTapCallback onPress;

  final Color color;

  QrColorIndicator({this.title, this.color, this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            margin: EdgeInsets.all(8).copyWith(right: 12),
            padding: MediaQuery.of(context).padding,
          ),
          Text(title),
        ],
      ),
      onTap: onPress,
    );
  }
}

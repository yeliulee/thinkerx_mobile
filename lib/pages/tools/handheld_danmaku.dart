import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';

class PageToolHandheldDanmaku extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<PageToolHandheldDanmaku> {
  TextEditingController _controller;
  FocusNode _focusNode;
  double textSize = 32;
  double scrollSpeed = 15;
  Color foreColor = Colors.black;
  Color bgColor = Colors.white;
  bool scrollable = false;
  bool displayMode = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
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

  enterDisplayMode(BuildContext context) {
    if (_controller.text.trim().length == 0) {
      Fluttertoast.showToast(msg: "请输入文本");
      return false;
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    setState(() {
      displayMode = true;
    });
  }

  Future<bool> quitDisplayMode() async {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    setState(() {
      displayMode = false;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return displayMode ? _buildDisplayModule(context) : _buildSettingModule(context, primaryColor);
  }

  Widget _buildSettingModule(BuildContext context, Color primaryColor) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("手持弹幕"),
        ),
        body: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "请输入文字,如:一起爬山?",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "文字大小",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("4"),
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
                                min: 4,
                                max: 128,
                                divisions: 123,
                                value: textSize,
                                label: "${textSize.floor()}",
                                onChanged: (double value) {
                                  setState(() {
                                    textSize = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            child: Text("128"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "滚动速度",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("5"),
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
                                min: 5,
                                max: 256,
                                divisions: 251,
                                value: scrollSpeed,
                                label: "${scrollSpeed.floor()}",
                                onChanged: (double value) {
                                  setState(() {
                                    scrollSpeed = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 12),
                            child: Text("256"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "颜色选择",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: ColorIndicator(
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
                              child: ColorIndicator(
                                title: "背景色",
                                color: bgColor,
                                onPress: () => handleChangeColor(context, isBgColor: true),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "弹幕类型",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Checkbox(
                                value: !scrollable,
                                onChanged: (bool value) {
                                  setState(() {
                                    scrollable = !scrollable;
                                  });
                                },
                              ),
                              Text(
                                "静止弹幕",
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 5),
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: scrollable,
                                  onChanged: (bool value) {
                                    setState(() {
                                      scrollable = !scrollable;
                                    });
                                  },
                                ),
                                Text(
                                  "滚动弹幕",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32, bottom: 12),
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 128,
                    child: RaisedButton(
                      color: primaryColor,
                      onPressed: () => enterDisplayMode(context),
                      child: Text(
                        "显示弹幕",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayModule(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: bgColor,
        body: scrollable
            ? Container(
                alignment: Alignment.center,
                child: Marquee(
                  text: _controller.text,
                  style: TextStyle(
                    fontSize: textSize,
                    color: foreColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                  velocity: scrollSpeed,
                  blankSpace: MediaQuery.of(context).size.width,
                  accelerationCurve: Curves.ease,
                  decelerationCurve: Curves.ease,
                ),
              )
            : Container(
                child: Center(
                  child: Text(
                    _controller.text,
                    style: TextStyle(
                      fontSize: textSize,
                      color: foreColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                    softWrap: true,
                  ),
                ),
              ),
      ),
      onWillPop: () => quitDisplayMode(),
    );
  }
}

/// [ColorIndicator] 颜色指示器
class ColorIndicator extends StatelessWidget {
  final String title;

  final GestureTapCallback onPress;

  final Color color;

  ColorIndicator({this.title, this.color, this.onPress});

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

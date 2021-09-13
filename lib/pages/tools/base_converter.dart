import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolBaseConverter extends StatefulWidget {
  @override
  _PageToolBaseConverterState createState() => _PageToolBaseConverterState();
}

class _PageToolBaseConverterState extends State<PageToolBaseConverter> {
  TextEditingController _controllerBin; // 二进制
  TextEditingController _controllerOct; // 八进制
  TextEditingController _controllerDec; // 十进制
  TextEditingController _controllerHex; // 十六进制
  TextEditingController _controllerThirtyBin; // 三十二进制
  List<TextEditingController> controllers;

  @override
  initState() {
    super.initState();
    _controllerBin = TextEditingController();
    _controllerOct = TextEditingController();
    _controllerDec = TextEditingController();
    _controllerHex = TextEditingController();
    _controllerThirtyBin = TextEditingController();
    controllers = [_controllerBin, _controllerOct, _controllerDec, _controllerHex, _controllerThirtyBin];
  }

  @override
  dispose() {
    super.dispose();
    controllers.forEach((controller) {
      controller.dispose();
    });
  }

  handleOnChange(String value, {BaseNotation notation = BaseNotation.binary}) {
    if (value.length == 0) {
      controllers.forEach((controller) {
        controller.text = '';
      });
      return false;
    }
    switch (notation) {
      case BaseNotation.binary:
        _controllerOct.text = int.parse(value, radix: 2).toRadixString(8);
        _controllerDec.text = int.parse(value, radix: 2).toRadixString(10);
        _controllerHex.text = int.parse(value, radix: 2).toRadixString(16);
        _controllerThirtyBin.text = int.parse(value, radix: 2).toRadixString(32);
        break;

      case BaseNotation.octal:
        _controllerBin.text = int.parse(value, radix: 8).toRadixString(2);
        _controllerDec.text = int.parse(value, radix: 8).toRadixString(10);
        _controllerHex.text = int.parse(value, radix: 8).toRadixString(16);
        _controllerThirtyBin.text = int.parse(value, radix: 8).toRadixString(32);
        break;

      case BaseNotation.decimal:
        _controllerBin.text = int.parse(value, radix: 10).toRadixString(2);
        _controllerOct.text = int.parse(value, radix: 10).toRadixString(8);
        _controllerHex.text = int.parse(value, radix: 10).toRadixString(16);
        _controllerThirtyBin.text = int.parse(value, radix: 10).toRadixString(32);
        break;

      case BaseNotation.hex:
        _controllerBin.text = int.parse(value, radix: 16).toRadixString(2);
        _controllerOct.text = int.parse(value, radix: 16).toRadixString(8);
        _controllerDec.text = int.parse(value, radix: 16).toRadixString(10);
        _controllerThirtyBin.text = int.parse(value, radix: 16).toRadixString(32);
        break;

      case BaseNotation.thirtyBin:
        _controllerBin.text = int.parse(value, radix: 32).toRadixString(2);
        _controllerOct.text = int.parse(value, radix: 32).toRadixString(8);
        _controllerDec.text = int.parse(value, radix: 32).toRadixString(10);
        _controllerHex.text = int.parse(value, radix: 32).toRadixString(16);
        break;
    }
  }

  handleClearAll() {
    controllers.forEach((controller) {
      controller.clear();
    });
    Fluttertoast.showToast(msg: '清除完毕');
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameBaseConverter),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            BaseConverterTextField(
              title: "二进制",
              hintText: "100100011101",
              controller: _controllerBin,
              onChange: (value) => handleOnChange(value),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^0$)|^[10]*$')),
              ],
            ),
            BaseConverterTextField(
              title: "八进制",
              hintText: "4435",
              controller: _controllerOct,
              onChange: (value) => handleOnChange(value, notation: BaseNotation.octal),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^0$)|^[1-7][0-7]*$')),
              ],
            ),
            BaseConverterTextField(
              title: "十进制",
              hintText: "2333",
              controller: _controllerDec,
              onChange: (value) => handleOnChange(value, notation: BaseNotation.decimal),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^0$)|^[1-9][0-9]*$')),
              ],
            ),
            BaseConverterTextField(
              title: "十六进制",
              hintText: "91d",
              controller: _controllerHex,
              onChange: (value) => handleOnChange(value, notation: BaseNotation.hex),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^0$)|^[1-9a-f][0-9a-f]*$')),
              ],
            ),
            BaseConverterTextField(
              title: "三十二进制",
              hintText: "28t",
              controller: _controllerThirtyBin,
              onChange: (value) => handleOnChange(value, notation: BaseNotation.thirtyBin),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^0$)|^[1-9a-v][0-9a-v]*$')),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.topRight,
              child: Container(
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(maxWidth: 360),
                child: FlatButton(
                  onPressed: () => handleClearAll(),
                  child: Text(
                    "清除全部",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum BaseNotation {
  binary,
  octal,
  decimal,
  hex,
  thirtyBin,
}

class BaseConverterTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChange;
  final List<TextInputFormatter> inputFormatters;

  BaseConverterTextField(
      {@required this.title, @required this.hintText, @required this.controller, @required this.onChange, @required this.inputFormatters});

  handleCopy() async {
    if (controller.text.trim().length > 0) {
      await Clipboard.setData(ClipboardData(text: controller.text));
      await Fluttertoast.showToast(msg: "内容已复制");
    } else {
      await Fluttertoast.showToast(msg: "内容为空", textColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextField(
            controller: controller,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              suffixIcon: IconButton(
                icon: Icon(Icons.content_copy),
                onPressed: () => handleCopy(),
              ),
              suffixIconConstraints: BoxConstraints(
                maxHeight: 48,
              ),
              border: OutlineInputBorder(),
            ),
            onChanged: onChange,
            inputFormatters: inputFormatters,
          ),
        ],
      ),
    );
  }
}

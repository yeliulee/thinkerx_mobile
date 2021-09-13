import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/utils/morse_code.dart';

class PageToolMorseCode extends StatefulWidget {
  @override
  _PageToolMorseCodeState createState() => _PageToolMorseCodeState();
}

class _PageToolMorseCodeState extends State<PageToolMorseCode> {
  TextEditingController _controllerForSource;
  TextEditingController _controllerForTarget;

  @override
  void initState() {
    super.initState();
    _controllerForSource = TextEditingController();
    _controllerForTarget = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerForTarget.dispose();
    _controllerForSource.dispose();
  }

  handleDecode() {
    String tempText = MorseCode().decode(_controllerForTarget.text);
    setState(() {
      _controllerForSource.text = tempText == '⍰' ? '' : tempText;
    });
  }

  handleEncode() {
    String tempText = MorseCode().encode(_controllerForSource.text);
    setState(() {
      _controllerForTarget.text = tempText.trim().length == 0 ? '' : tempText;
    });
  }

  handleCopy(String content) async {
    await Clipboard.setData(ClipboardData(text: content));
    Fluttertoast.showToast(msg: "内容已复制");
  }

  @override
  Widget build(BuildContext context) {
    final Size currentSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;
    final inputContainerPadding = EdgeInsets.all(16).copyWith(top: 0);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameMorseCode),
      ),
      body: Container(
        constraints: BoxConstraints(
          maxHeight: currentSize.height,
          maxWidth: currentSize.width,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: inputContainerPadding,
                child: Stack(
                  children: <Widget>[
                    TextField(
                      controller: _controllerForSource,
                      cursorColor: primaryColor,
                      maxLines: 10000,
                      decoration: InputDecoration(
                        hintText: "请输入待转换为摩斯电码的文本(不支持超出摩斯电码可编码范围的字符)",
                        border: InputBorder.none,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: Icon(Icons.content_copy),
                        onPressed: () => handleCopy(_controllerForSource.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 96,
              constraints: BoxConstraints(
                maxWidth: currentSize.width,
                maxHeight: 96,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: currentSize.width / 3,
                    constraints: BoxConstraints(maxWidth: 200),
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      color: primaryColor,
                      onPressed: () => handleDecode(),
                      child: Text(
                        "还原为明文",
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                  Container(
                    width: currentSize.width / 3,
                    constraints: BoxConstraints(maxWidth: 200),
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      color: primaryColor,
                      onPressed: () => handleEncode(),
                      child: Text(
                        "转换为密文",
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: inputContainerPadding,
                child: Stack(
                  children: <Widget>[
                    TextField(
                      controller: _controllerForTarget,
                      maxLines: 10000,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                        hintText: "转换结果(或可直接输入待解密的密文)",
                        border: InputBorder.none,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: Icon(Icons.content_copy),
                        onPressed: () => handleCopy(_controllerForTarget.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}

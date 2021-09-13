import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolUrlEncoder extends StatefulWidget {
  @override
  _PageToolUrlEncoderState createState() => _PageToolUrlEncoderState();
}

class _PageToolUrlEncoderState extends State<PageToolUrlEncoder> {
  TextEditingController _controller;

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

  handleProcess({bool isDecode = false}) {
    _controller.text = isDecode ? Uri.decodeComponent(_controller.text) : Uri.encodeComponent(_controller.text);
  }

  handleCopy() async {
    if (_controller.text.trim().length > 0) {
      await Clipboard.setData(ClipboardData(text: _controller.text));
      await Fluttertoast.showToast(msg: "内容已复制");
    } else {
      await Fluttertoast.showToast(msg: "内容为空", textColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final double btnWidth = (MediaQuery.of(context).size.width - 32 - 16) / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameUrlEncoder),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              constraints: BoxConstraints(
                minHeight: 256,
                maxHeight: 256,
              ),
              child: Stack(
                children: <Widget>[
                  TextField(
                    cursorColor: primaryColor,
                    controller: _controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      hintText: '请输入待编码或解码的 URL 或 URL 部分',
                      border: OutlineInputBorder(),
                      isDense: true,
                      counterText: "",
                    ),
                    maxLength: -1,
                    maxLines: 100000,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: InkWell(
                      child: Container(
                        height: 36,
                        width: 36,
                        child: Icon(Icons.content_copy),
                      ),
                      onTap: () => handleCopy(),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: btnWidth,
                  child: FlatButton(
                    color: primaryColor,
                    onPressed: () => handleProcess(),
                    child: Text(
                      "编码",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Container(
                  width: btnWidth,
                  child: FlatButton(
                    color: primaryColor,
                    onPressed: () => handleProcess(isDecode: true),
                    child: Text(
                      "解码",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

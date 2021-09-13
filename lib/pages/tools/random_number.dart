import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolRandomNumber extends StatefulWidget {
  @override
  _PageToolRandomNumberState createState() => _PageToolRandomNumberState();
}

class _PageToolRandomNumberState extends State<PageToolRandomNumber> {
  TextEditingController _controllerForMin;
  TextEditingController _controllerForMax;
  double amount = 1;
  List<int> results = [];

  @override
  void initState() {
    super.initState();
    _controllerForMin = TextEditingController();
    _controllerForMax = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerForMin.dispose();
    _controllerForMax.dispose();
  }

  handleGenerate() async {
    String minText = _controllerForMin.text.trim();
    String maxText = _controllerForMax.text.trim();
    if (minText.length > 0 && maxText.length > 0) {
      final min = int.parse(minText);
      final max = int.parse(maxText);
      if (min >= max) {
        await Fluttertoast.showToast(msg: "最小值需小于最大值");
        return false;
      }
      List<int> tempResults = [];
      for (int i = 0; i < amount; i++) {
        int tempNumber = Random().nextInt(max - min + 1) + min;
        tempResults.add(tempNumber);
      }
      setState(() {
        results = tempResults;
      });
    }
  }

  handleCopy(int number) async {
    await Clipboard.setData(ClipboardData(text: "$number"));
    await Fluttertoast.showToast(msg: "已复制到剪贴板", gravity: ToastGravity.CENTER);
  }

  handleCopyAll() async {
    await Clipboard.setData(ClipboardData(text: "${results.join(',')}"));
    await Fluttertoast.showToast(msg: "已复制到剪贴板", gravity: ToastGravity.CENTER);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameRandomNumber),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20).copyWith(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.black12.withAlpha(22),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                      child: TextField(
                        controller: _controllerForMin,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "最小值...",
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 48,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.hdr_weak),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: TextField(
                        controller: _controllerForMax,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "最大值...",
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "生成数量",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        inactiveTrackColor: Colors.grey,
                        thumbColor: primaryColor,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                        valueIndicatorColor: primaryColor.withOpacity(0.5),
                        activeTickMarkColor: primaryColor,
                        inactiveTickMarkColor: Colors.grey,
                      ),
                      child: Slider(
                        min: 1,
                        max: 20,
                        divisions: 19,
                        value: amount,
                        label: "${amount.round()}",
                        onChanged: (double value) {
                          setState(() {
                            amount = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Text(
                    "${amount.floor()}个",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (results.length > 0)
                    Container(
                      constraints: BoxConstraints(
                        minWidth: 100,
                      ),
                      child: RaisedButton(
                        highlightElevation: 1,
                        color: primaryColor.withAlpha(0xdd),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onPressed: () => handleCopyAll(),
                        child: Text(
                          "复制所有",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    constraints: BoxConstraints(
                      minWidth: 100,
                    ),
                    child: RaisedButton(
                      highlightElevation: 1,
                      color: primaryColor.withAlpha(0xdd),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onPressed: () => handleGenerate(),
                      child: Text(
                        "生成",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: results
                    .map(
                      (result) => ActionChip(
                        label: Text("$result"),
                        backgroundColor: Color(0xFFF4F4F4),
                        onPressed: () => handleCopy(result),
                        pressElevation: 2,
                        elevation: 0.5,
                        shadowColor: Theme.of(context).primaryColorLight,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

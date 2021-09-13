import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thinkerx/core/resource_helper.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolRelationshipCalculator extends StatefulWidget {
  @override
  _PageToolRelationshipCalculatorState createState() => _PageToolRelationshipCalculatorState();
}

class _PageToolRelationshipCalculatorState extends State<PageToolRelationshipCalculator> {
  JSContext _jsContext;
  bool bundledFuncExecuted = false;
  String defaultText = '';
  String defaultResultText = '';
  String chainText = '';
  String chainResultText = '';
  int myGender = 1; // 1 男性, 0 女性
  int currentGender = 1; // 1 男性, 0 女性
  String calcType = 'default'; // chain 算关系; default 算称谓
  bool reverse = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _jsContext = JSContext.create();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _jsContext.release();
  }

  loadJavaScript() async {
    if (bundledFuncExecuted) {
      return true;
    }
    try {
      String jsContent = await rootBundle.loadString(ResourceHelper.js_bundle_relationship);
      _jsContext.evaluate(jsContent);
    } catch (e) {
      return false;
    }
    bundledFuncExecuted = true;
    return bundledFuncExecuted;
  }

  Future<String> handleCalc() async {
    String result = await execute();
    result = result.toString().replaceAll('[', '').replaceAll(']', '').replaceAll("\"", "");
    return result;
  }

  queryData(String name) async {
    print(name);
    if (defaultText == '') {
      setState(() {
        defaultText = name;
      });
    } else {
      setState(() {
        defaultText = "$defaultText的$name";
      });
    }
    if (defaultText.length > 56) {
      handleClr();
    }
    String tempName = defaultText.split('的').last;
    toggleGender('爸爸,老公,儿子,哥哥,弟弟'.indexOf(tempName) > -1);
    String result = await handleCalc();
    setState(() {
      defaultResultText = result;
    });
  }

  handleGenderChange() async {
    String result = await handleCalc();
    setState(() {
      defaultResultText = result;
    });
  }

  handleReverseChange() async {
    String result = await handleCalc();
    setState(() {
      defaultResultText = result;
    });
  }

  handleChainChange(String text) async {
    if (!bundledFuncExecuted) {
      bool isExecuted = await loadJavaScript();
      if (!isExecuted) {
        await Fluttertoast.showToast(msg: "计算出错");
        return '';
      }
    }
    String result = '';
    try {
      result = _jsContext.evaluate('relationship({text:"$text",sex:$myGender,type:"$calcType",reverse:$reverse})').string;
      result = result.toString().replaceAll('[', '').replaceAll(']', '').replaceAll("\"", "");
      setState(() {
        chainResultText = result;
      });
    } catch (e) {
      await Fluttertoast.showToast(msg: "计算出错");
    }
  }

  toggleGender(isMale) {
    setState(() {
      currentGender = isMale ? 1 : 0;
    });
  }

  handleDel() async {
    String source = defaultText.trim();
    defaultText = source.substring(0, max(0, source.lastIndexOf('的')));
    String name = defaultText.split('的').last;
    if (name.length > 0) {
      toggleGender('爸爸,老公,儿子,哥哥,弟弟'.indexOf(name) > -1);
      String result = await execute();
      result = result.toString().replaceAll('[', '').replaceAll(']', '');
      setState(() {
        defaultResultText = result;
      });
    } else {
      toggleGender(myGender == 1);
      setState(() {
        defaultText = '';
        defaultResultText = '';
      });
    }
  }

  handleClr() {
    setState(() {
      defaultText = '';
      defaultResultText = '';
      currentGender = myGender;
    });
  }

  execute() async {
    if (!bundledFuncExecuted) {
      bool isExecuted = await loadJavaScript();
      if (!isExecuted) {
        await Fluttertoast.showToast(msg: "计算出错");
        return '';
      }
    }
    String execResult = '';
    try {
      execResult = _jsContext.evaluate('relationship({text:"$defaultText",sex:$myGender,type:"$calcType",reverse:$reverse})').string;
    } catch (e) {
      await Fluttertoast.showToast(msg: "计算出错");
    }
    return execResult;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameRelationshipCalculator),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (calcType == 'default')
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: Text(
                              "我的性别:",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          DropdownButton<int>(
                            value: myGender,
                            items: [
                              DropdownMenuItem<int>(
                                value: 0,
                                child: Text(
                                  "女性",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              DropdownMenuItem<int>(
                                value: 1,
                                child: Text(
                                  "男性",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                            onChanged: (int value) {
                              setState(() {
                                myGender = value;
                                handleGenderChange();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          child: Text(
                            "计算类型:",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        DropdownButton<String>(
                          value: calcType,
                          items: [
                            DropdownMenuItem<String>(
                              value: 'default',
                              child: Text(
                                "称谓计算",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: 'chain',
                              child: Text(
                                "关系计算",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              calcType = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (calcType == 'default')
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: Text(
                              "称呼方式:",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          DropdownButton<bool>(
                            value: reverse,
                            items: [
                              DropdownMenuItem<bool>(
                                value: false,
                                child: Text(
                                  "我称呼对方",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              DropdownMenuItem<bool>(
                                value: true,
                                child: Text(
                                  "对方称呼我",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                            onChanged: (bool value) {
                              setState(() {
                                reverse = value;
                                handleReverseChange();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  if (calcType == 'default' && defaultText != '')
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(top: 32),
                      child: Container(
                        alignment: Alignment.centerRight,
                        constraints: BoxConstraints(
                          maxWidth: (size.width * 0.75),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "我的$defaultText",
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              softWrap: true,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 24,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                defaultResultText,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              border: calcType == 'default'
                  ? Border(
                      top: BorderSide(
                        color: Theme.of(context).primaryColorLight.withOpacity(0.2),
                        width: 1.25,
                      ),
                    )
                  : null,
            ),
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  if (calcType == 'default') ..._buildCalcBtnList(context),
                  if (calcType == 'chain') _buildChainContainer(size, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildChainContainer(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 48),
      padding: EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 48),
            alignment: Alignment.centerRight,
            child: Container(
              alignment: Alignment.centerRight,
              constraints: BoxConstraints(
                maxWidth: (size.width * 0.75),
              ),
              child: Text(
                chainResultText,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                softWrap: true,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          TextField(
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              labelText: "请输入称谓,如外曾外祖母",
            ),
            onChanged: (String value) {
              handleChainChange(value);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCalcBtnList(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color splashColor = Theme.of(context).primaryColorLight;
    double btnWidth = double.parse((MediaQuery.of(context).size.width / 4).toStringAsFixed(4));
    List<Map<String, dynamic>> buttons = [
      {
        "icon": Text("爸爸"),
        "action": () => queryData("爸爸"),
      },
      {
        "icon": Text("妈妈"),
        "action": () => queryData("妈妈"),
      },
      {
        "icon": Text("DEL", style: TextStyle(color: primaryColor)),
        "action": () => handleClr(),
      },
      {
        "icon": Text("CLR", style: TextStyle(color: primaryColor)),
        "action": () => handleClr(),
      },
      {
        "icon": Text("老公"),
        "action": () => currentGender == 1 ? () {} : queryData("老公"),
      },
      {
        "icon": Text("老婆"),
        "action": () => currentGender == 0 ? () {} : queryData("老婆"),
      },
      {
        "icon": Text("儿子"),
        "action": () => queryData("儿子"),
      },
      {
        "icon": Text("女儿"),
        "action": () => queryData("女儿"),
      },
      {
        "icon": Text("哥哥"),
        "action": () => queryData("哥哥"),
      },
      {
        "icon": Text("弟弟"),
        "action": () => queryData("弟弟"),
      },
      {
        "icon": Text("姐姐"),
        "action": () => queryData("姐姐"),
      },
      {
        "icon": Text("妹妹"),
        "action": () => queryData("妹妹"),
      },
    ];
    return buttons
        .map(
          (button) => Container(
            alignment: Alignment.center,
            height: 80,
            constraints: BoxConstraints(
              maxWidth: btnWidth,
            ),
            child: IconButton(
              splashColor: splashColor,
              icon: button['icon'],
              onPressed: button['action'],
            ),
          ),
        )
        .toList();
  }
}

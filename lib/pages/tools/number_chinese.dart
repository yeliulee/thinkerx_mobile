import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thinkerx/components/content_copy_view.dart';
import 'package:thinkerx/core/resource_helper.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolNumberChinese extends StatefulWidget {
  @override
  _PageToolNumberChineseState createState() => _PageToolNumberChineseState();
}

class _PageToolNumberChineseState extends State<PageToolNumberChinese> with TickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _controllerEncode;
  TextEditingController _controllerDecode;
  FocusNode _focusNodeEncode;
  FocusNode _focusNodeDecode;
  JSContext _jsContext;
  bool bundledFuncExecuted = false;
  List<Map<String, String>> results = [
    {
      "name": "小写",
      "text": "",
    },
    {
      "name": "大写",
      "text": "",
    },
    {
      "name": "金额(简写)",
      "text": "",
    },
    {
      "name": "金额(完整)",
      "text": "",
    },
  ];
  String decodeResultText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _controllerEncode = TextEditingController();
    _controllerDecode = TextEditingController();
    _jsContext = JSContext.create();
    _focusNodeEncode = FocusNode();
    _focusNodeDecode = FocusNode();
    loadJavaScript();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _jsContext.release();
    _controllerEncode.dispose();
    _controllerDecode.dispose();
    _focusNodeEncode.dispose();
    _focusNodeDecode.dispose();
  }

  loadJavaScript() async {
    if (bundledFuncExecuted) {
      return true;
    }
    try {
      String jsContent = await rootBundle.loadString(ResourceHelper.js_bundle_nzh);
      _jsContext.evaluate(jsContent);
    } catch (e) {
      return false;
    }
    bundledFuncExecuted = true;
    return bundledFuncExecuted;
  }

  handleEncode(String value) async {
    if (!bundledFuncExecuted) {
      bool isExecuted = await loadJavaScript();
      if (!isExecuted) {
        await Fluttertoast.showToast(msg: "转换出错");
        return false;
      }
    }

    List<Map<String, String>> tempResult = results;
    try {
      tempResult[0]['text'] = _jsContext.evaluate('Nzh.cn.encodeS("${_controllerEncode.text}")').string;
      tempResult[1]['text'] = _jsContext.evaluate('Nzh.cn.encodeB("${_controllerEncode.text}")').string;
      tempResult[2]['text'] = _jsContext.evaluate('Nzh.cn.toMoney("${_controllerEncode.text}",{ outSymbol: false })').string;
      tempResult[3]['text'] = _jsContext.evaluate('Nzh.cn.toMoney("${_controllerEncode.text}",{complete: true, outSymbol: false})').string;
    } catch (e) {
      await Fluttertoast.showToast(msg: "转换出错");
      return false;
    }
    setState(() {
      results = tempResult;
    });
  }

  handleDecode(String value) async {
    if (value.trim().length == 0) {
      setState(() {
        decodeResultText = '';
      });
      return false;
    }
    if (!bundledFuncExecuted) {
      bool isExecuted = await loadJavaScript();
      if (!isExecuted) {
        await Fluttertoast.showToast(msg: "转换出错");
        return false;
      }
    }
    String handler = '';
    if (RegExp(r'^负?[零一二三四五六七八九十百千万亿]*点?[零一二三四五六七八九]*$').hasMatch(value)) {
      handler = 'Nzh.cn.decodeS';
    } else if (RegExp(r'负?[零壹贰叁肆伍陆柒捌玖拾佰仟万亿]*点?[零壹贰叁肆伍陆柒捌玖]*$').hasMatch(value)) {
      handler = 'Nzh.cn.decodeB';
    } else {
      return false;
    }
    String tempResult = decodeResultText;
    try {
      tempResult = _jsContext.evaluate('$handler("$value").toString()').string;
    } catch (e) {
      await Fluttertoast.showToast(msg: "转换出错");
      return false;
    }
    setState(() {
      decodeResultText = tempResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameNumberToChinese),
        bottom: _buildTabBar(context),
      ),
      body: GestureDetector(
        onTap: () {
          _focusNodeEncode.unfocus();
          _focusNodeDecode.unfocus();
        },
        child: Container(
          width: size.width,
          constraints: BoxConstraints(
            minHeight: size.height,
            maxHeight: size.height,
          ),
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              _buildEncoder(),
              _buildDecoder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEncoder() {
    final primaryColor = Theme.of(context).primaryColor;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Container(
            child: TextField(
              focusNode: _focusNodeEncode,
              controller: _controllerEncode,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
                hintText: "请输入数字(支持科学计数法)...",
                counterText: "",
              ),
              cursorColor: primaryColor,
              maxLength: 100,
              onChanged: (value) => handleEncode(value),
              keyboardType: TextInputType.numberWithOptions(signed: true),
            ),
          ),
          ..._buildResults(),
        ],
      ),
    );
  }

  List<Widget> _buildResults() {
    return results[0]['text'].length > 0
        ? results
            .map(
              (e) => Container(
                margin: EdgeInsets.only(top: 16),
                child: ContentCopyView(
                  title: e['name'],
                  content: e['text'],
                ),
              ),
            )
            .toList()
        : [];
  }

  Widget _buildDecoder() {
    final primaryColor = Theme.of(context).primaryColor;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Container(
            child: TextField(
              focusNode: _focusNodeDecode,
              controller: _controllerDecode,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
                hintText: "请输入中文数字...",
                counterText: "",
              ),
              cursorColor: primaryColor,
              maxLength: 100,
              onChanged: (value) => handleDecode(value),
            ),
          ),
          if (decodeResultText.length > 0)
            Container(
              margin: EdgeInsets.only(top: 24),
              child: ContentCopyView(
                title: "转换结果",
                content: decodeResultText,
              ),
            ),
        ],
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
                  text: "数字转中文",
                ),
                Tab(
                  text: "中文转数字",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

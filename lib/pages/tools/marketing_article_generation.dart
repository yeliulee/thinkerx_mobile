import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolMarketingArticleGeneration extends StatefulWidget {
  @override
  _PageToolMarketingArticleGenerationState createState() => _PageToolMarketingArticleGenerationState();
}

class _PageToolMarketingArticleGenerationState extends State<PageToolMarketingArticleGeneration> {
  TextEditingController _controllerForSubject;
  TextEditingController _controllerForEvent;
  TextEditingController _controllerForDetail;
  TextEditingController _controllerForResult;

  @override
  initState() {
    super.initState();
    _controllerForSubject = TextEditingController();
    _controllerForEvent = TextEditingController();
    _controllerForDetail = TextEditingController();
    _controllerForResult = TextEditingController();
  }

  @override
  dispose() {
    super.dispose();
    _controllerForResult.dispose();
    _controllerForEvent.dispose();
    _controllerForSubject.dispose();
    _controllerForDetail.dispose();
  }

  handleOnChange() {
    _controllerForResult.text =
        '       ${_controllerForSubject.text}${_controllerForEvent.text}是怎么回事呢？${_controllerForSubject.text}相信大家都很熟悉，但是${_controllerForSubject.text}${_controllerForEvent.text}是怎么回事呢，下面就让小编带大家一起了解吧。\n       ${_controllerForSubject.text}${_controllerForEvent.text}，其实就是${_controllerForDetail.text}，大家可能会很惊讶${_controllerForSubject.text}怎么会${_controllerForEvent.text}呢？但事实就是这样，小编也感到非常惊讶。\n       这就是关于${_controllerForSubject.text}${_controllerForEvent.text}的事情了，大家有什么想法呢，欢迎在评论区告诉小编一起讨论哦！';
  }

  handleCopy() async {
    if (_controllerForResult.text.trim().length > 0) {
      await Clipboard.setData(ClipboardData(text: _controllerForResult.text));
      await Fluttertoast.showToast(msg: "内容已复制");
    } else {
      await Fluttertoast.showToast(msg: "内容为空", textColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameMarketingArticle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildInputField(
              context,
              onChange: (value) => handleOnChange(),
              title: "主体",
              controller: _controllerForSubject,
              hintText: "酒",
            ),
            _buildInputField(
              context,
              onChange: (value) => handleOnChange(),
              title: "事件",
              controller: _controllerForEvent,
              hintText: "不能喝太多",
            ),
            _buildInputField(
              context,
              onChange: (value) => handleOnChange(),
              title: "替换说法",
              controller: _controllerForDetail,
              hintText: "酒喝太多了会吐",
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Text("生成结果"),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 200,
                    ),
                    child: Stack(
                      children: <Widget>[
                        TextField(
                          controller: _controllerForResult,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            hintText:
                                """       酒不能喝太多是怎么回事呢？酒相信大家都很熟悉，但是酒不能喝太多是怎么回事呢，下面就让小编带大家一起了解吧。\n       酒不能喝太多，其实就是酒喝太多了会吐，大家可能会很惊讶酒怎么会不能喝太多呢？但事实就是这样，小编也感到非常惊讶。\n        这就是关于酒不能喝太多的事情了，大家有什么想法呢，欢迎在评论区告诉小编一起讨论哦！""",
                            contentPadding: EdgeInsets.all(12),
                            counterText: "",
                            hintMaxLines: 6,
                          ),
                          maxLines: 1000,
                          maxLength: -1,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context,
      {@required ValueChanged<String> onChange, @required String title, @required TextEditingController controller, @required String hintText}) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(title),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 48),
            child: TextField(
              controller: controller,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                hintText: hintText,
                contentPadding: EdgeInsets.all(12),
              ),
              onChanged: onChange,
            ),
          ),
        ],
      ),
    );
  }
}

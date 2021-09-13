import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PageToolViewSource extends StatefulWidget {
  @override
  _PageToolViewSourceState createState() => _PageToolViewSourceState();
}

class _PageToolViewSourceState extends State<PageToolViewSource> {
  String urlPattern;
  TextEditingController _controller;
  String htmlContext;
  FocusNode _focusNode;
  JSContext _jsContext;
  String javaScriptContent = r"""function formatHTML(html) {
    var indent = '\n';
    var tab = '\t';
    var i = 0;
    var pre = [];

    html = html
        .replace(new RegExp('<pre>((.|\\t|\\n|\\r)+)?</pre>'), function (x) {
            pre.push({ indent: '', tag: x });
            return '<--TEMPPRE' + i++ + '/-->'
        })
        .replace(new RegExp('<[^<>]+>[^<]?', 'g'), function (x) {
            var ret;
            var tag = /<\/?([^\s/>]+)/.exec(x)[1];
            var p = new RegExp('<--TEMPPRE(\\d+)/-->').exec(x);

            if (p) 
                pre[p[1]].indent = indent;

            if (['area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'input', 'keygen', 'link', 'menuitem', 'meta', 'param', 'source', 'track', 'wbr'].indexOf(tag) >= 0) // self closing tag
                ret = indent + x;
            else {
                if (x.indexOf('</') < 0) { //open tag
                    if (x.charAt(x.length - 1) !== '>')
                        ret = indent + x.substr(0, x.length - 1) + indent + tab + x.substr(x.length - 1, x.length);
                    else 
                        ret = indent + x;
                    !p && (indent += tab);
                }
                else {//close tag
                    indent = indent.substr(0, indent.length - 1);
                    if (x.charAt(x.length - 1) !== '>')
                        ret =  indent + x.substr(0, x.length - 1) + indent + x.substr(x.length - 1, x.length);
                    else
                        ret = indent + x;
                }
            }
            return ret;
        });

    for (i = pre.length; i--;) {
        html = html.replace('<--TEMPPRE' + i + '/-->', pre[i].tag.replace('<pre>', '<pre>\n').replace('</pre>', pre[i].indent + '</pre>'));
    }

    return html.charAt(0) === '\n' ? html.substr(1, html.length - 1) : html;
}""";

  @override
  void initState() {
    super.initState();
    urlPattern = r"^[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$";
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _jsContext = JSContext.create();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _jsContext.release();
  }

  handleViewSource(BuildContext context, String url) async {
    if (url.trim().isNotEmpty && RegExp(urlPattern).hasMatch(url)) {
      ProgressDialog loading = ProgressDialog(context, isDismissible: false);
      await loading.show();
      try {
        Dio dio = Dio();
        dio.options.headers["User-Agent"] =
            "Mozilla/5.0 (Linux; Android 5.1.1; Android SDK built for x86 Build/LMY48X) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/39.0.0.0 Mobile Safari/537.36";
        dio.interceptors.add(InterceptorsWrapper(
          onResponse: (Response response) async {
            if (!response.headers[Headers.contentTypeHeader].toString().contains("text/html")) {
              dio.close();
              await loading.hide();
              throw Exception("该链接非网页地址");
            }
          },
        ));
        Response response = await dio.get(url, options: Options(responseType: ResponseType.plain));
        setState(() {
          htmlContext = _jsContext.evaluate('$javaScriptContent formatHTML(decodeURIComponent("${Uri.encodeComponent(response.data)}"));').string;
        });
        await loading.hide();
      } catch (e) {
        await loading.hide();
        Fluttertoast.showToast(msg: e.message);
      }
    } else {
      Fluttertoast.showToast(msg: "请输入正确的网页地址");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("网页源码查看"),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(72),
            child: Container(
              height: 72,
              padding: EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 8),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "请输入网页地址...",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () => handleViewSource(context, _controller.text),
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (String value) => handleViewSource(context, value),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: htmlContext != null
            ? Container(
                height: double.maxFinite,
                child: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        child: SelectableText(
                          htmlContext,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "长度：${htmlContext.length}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(4)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

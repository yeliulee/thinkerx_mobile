import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:thinkerx/components/content_copy_view.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolChinesePinyin extends StatefulWidget {
  @override
  _PageToolChinesePinyinState createState() => _PageToolChinesePinyinState();
}

class _PageToolChinesePinyinState extends State<PageToolChinesePinyin> {
  TextEditingController _textEditingController;
  String resultText = '';
  bool withTone = false;
  bool firstLetterMode = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  handleConvert() async {
    if (_textEditingController.text.trim().length > 0) {
      if (firstLetterMode) {
        String tempText = PinyinHelper.getPinyinE(_textEditingController.text, format: PinyinFormat.WITHOUT_TONE, separator: "#", defPinyin: '*');
        List<String> pinyinList = tempText.split("#");
        List<String> tempResults = [];
        pinyinList.forEach((pinyin) {
          tempResults.add(pinyin.substring(0, 1));
        });
        setState(() {
          resultText = tempResults.join(" ");
        });
      } else {
        PinyinFormat pinyinFormat = withTone ? PinyinFormat.WITH_TONE_MARK : PinyinFormat.WITHOUT_TONE;
        String tempText = PinyinHelper.getPinyinE(_textEditingController.text, format: pinyinFormat);
        setState(() {
          resultText = tempText;
        });
      }
    } else {
      setState(() {
        resultText = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameChineseToPinyin),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16).copyWith(bottom: 0),
              child: TextField(
                controller: _textEditingController,
                cursorColor: primaryColor,
                decoration: InputDecoration(
                  labelText: "请输入汉字, 如: 汉字",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => handleConvert(),
                  ),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (String value) => handleConvert(),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(right: 8),
              child: Wrap(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                        value: withTone,
                        onChanged: firstLetterMode
                            ? null
                            : (bool value) {
                                setState(() {
                                  withTone = value;
                                });
                              },
                      ),
                      Text(
                        "标注声调",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                        value: firstLetterMode,
                        onChanged: (bool value) {
                          setState(() {
                            firstLetterMode = value;
                          });
                        },
                      ),
                      Text(
                        "首字母",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (resultText.trim().length > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                margin: EdgeInsets.only(top: 16),
                child: ContentCopyView(
                  title: "转换结果",
                  content: resultText,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

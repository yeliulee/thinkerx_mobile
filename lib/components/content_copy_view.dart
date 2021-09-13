import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContentCopyView extends StatelessWidget {
  final String title;
  final String content;

  ContentCopyView({@required this.title, @required this.content});

  handleCopy() async {
    if (content != null) {
      await Clipboard.setData(ClipboardData(text: content));
      await Fluttertoast.showToast(msg: "内容已复制");
    } else {
      await Fluttertoast.showToast(msg: "内容为空");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 4),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          height: 48,
          padding: EdgeInsets.only(left: 8),
          constraints: BoxConstraints(maxHeight: 48),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  content,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.content_copy),
                onPressed: () => handleCopy(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

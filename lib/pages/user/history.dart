import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thinkerx/core/db_helper.dart';
import 'package:thinkerx/core/tools_config.dart';
import 'package:thinkerx/database/entity/history.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageHistory extends StatefulWidget {
  @override
  _PageHistoryState createState() => _PageHistoryState();
}

class _PageHistoryState extends State<PageHistory> {
  List<HistoryRecord> records = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    final tempRecords = await DbHelper.historyRecordDao.readAll();
    setState(() {
      records = tempRecords;
    });
  }

  handleClearAll(BuildContext context) async {
    final bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        final List<Widget> actions = [
          FlatButton(onPressed: () => Navigator.of(context).pop(false), child: Text(AppLocale.current.titleCancel)),
          FlatButton(onPressed: () => Navigator.of(context).pop(true), child: Text(AppLocale.current.titleConfirm)),
        ];
        final Widget title = Text("清除历史");
        final Widget content = Text("确认清除所有使用记录?");
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: title,
                content: content,
                actions: actions,
              )
            : AlertDialog(
                title: title,
                content: content,
                actions: actions,
              );
      },
    );
    if (confirmed) {
      await DbHelper.historyRecordDao.deleteAll();
      await Fluttertoast.showToast(msg: "清除成功", gravity: ToastGravity.CENTER);
      setState(() {
        records = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double funcBtnWidth = (MediaQuery.of(context).size.width < 600
            ? ((MediaQuery.of(context).size.width - 6 * 8) / 2)
            : ((MediaQuery.of(context).size.width - 8 * 8) / 3)) -
        0.1;

    final Widget contentView = records.length == 0
        ? Container(
            child: Center(
              child: Text(
                "当前还未使用如何工具",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          )
        : SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Wrap(
                direction: Axis.horizontal,
                children: records.reversed.toList().map((record) {
                  final tool = AppToolsConfig().tools.firstWhere((tool) => tool.routeName == record.path);
                  return Container(
                    constraints: BoxConstraints(minWidth: funcBtnWidth, maxWidth: funcBtnWidth),
                    margin: EdgeInsets.all(8),
                    child: FlatButton(
                      color: Color(0xFFF4F4F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: EdgeInsets.all(12),
                      onPressed: () => ExtendedNavigator.of(context).push(tool.routeName),
                      child: Text(tool.name),
                    ),
                  );
                }).toList(),
              ),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text("使用记录"),
        actions: <Widget>[
          if (records.length > 0)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () => handleClearAll(context),
            ),
        ],
      ),
      body: contentView,
    );
  }
}

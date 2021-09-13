import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/models/express_data_entity.dart';

class PageToolExpressInquiry extends StatefulWidget {
  @override
  _PageToolExpressInquiryState createState() => _PageToolExpressInquiryState();
}

/// api is now unavailable, please refactor this method to use alapi v2
class _PageToolExpressInquiryState extends State<PageToolExpressInquiry> {
  static const String API_URL = 'https://v1.alapi.cn/api/kd?number=';
  TextEditingController _controller;
  ExpressDataEntity expressData;

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

  ProgressDialog createLoadingDialog() {
    final ProgressDialog progressDialog = ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal);
    progressDialog.style(
      message: "正在查询, 请稍后...",
      progressWidget: Container(
          padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
    );
    return progressDialog;
  }

  handleQuery() async {
    final String numberTicket = _controller.text.trim();
    if (numberTicket.length == 0) {
      await Fluttertoast.showToast(msg: "请输入快递单号");
      return false;
    } else if (numberTicket.length < 8) {
      await Fluttertoast.showToast(msg: "快递单号至少 8 位");
      return false;
    }
    ExpressDataEntity expressDataEntity;
    ProgressDialog progressDialog = createLoadingDialog();
    await progressDialog.show();
    try {
      Response response = await Dio().get(
          "$API_URL${Uri.encodeComponent(numberTicket)}",
          options: Options(receiveTimeout: 5, sendTimeout: 5));
      dynamic resData = response.data;
      print(response.data);
      if (resData['code'] == 200 && resData['data']['status'] == 1) {
        expressDataEntity = ExpressDataEntity.fromJson(resData['data']);
        if (expressDataEntity.info.first.content == '查无结果') {
          await progressDialog.hide();
          Fluttertoast.showToast(msg: "未查询到订单");
          return false;
        }
      } else {
        Fluttertoast.showToast(msg: "未查询到订单");
        return false;
      }
    } catch (e) {
      await progressDialog.hide();
      await Fluttertoast.showToast(msg: "查询失败");
      return false;
    }
    await progressDialog.hide();
    await Fluttertoast.showToast(msg: "查询成功");
    setState(() {
      expressData = expressDataEntity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameExpressInquiry),
        bottom: _buildSearchField(),
      ),
      body: expressData != null
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...expressData.info
                      .map(
                          (expressInfo) => _buildListItem(context, expressInfo))
                      .toList()
                      .reversed,
                ],
              ),
            )
          : null,
    );
  }

  _buildListItem(BuildContext context, ExpressInfo info) {
    final primaryColor = Theme.of(context).primaryColor.withOpacity(0.8);
    final bool isLast = info == expressData.info.first;
    List<Widget> items;
    if (expressData.info.indexOf(info) == expressData.info.length - 1) {
      items = <Widget>[
        Text(
          info.content,
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              expressData.state == "3"
                  ? Text(
                      "已签收",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Spacer(),
              Text(
                info.time,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ];
    } else {
      items = <Widget>[
        Text(
          info.content,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text(
                info.time,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ];
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  width: 0.2,
                  color: Colors.grey,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildSearchField() {
    return PreferredSize(
      preferredSize: Size.fromHeight(96),
      child: Container(
        height: 96,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 48,
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    hintText: "请输入快递单号...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 8),
                  ),
                  onSubmitted: (String value) => handleQuery(),
                  textInputAction: TextInputAction.search,
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => handleQuery(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

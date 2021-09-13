import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/models/ip_information_entity.dart';

class PageToolIpQuery extends StatefulWidget {
  @override
  _PageToolIpQueryState createState() => _PageToolIpQueryState();
}

class _PageToolIpQueryState extends State<PageToolIpQuery> {
  TextEditingController _controller;
  FocusNode _focusNode;
  Data ipData;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
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
    if (RegExp(
            r'^(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$')
        .hasMatch(_controller.text)) {
      ProgressDialog loading = createLoadingDialog();
      await loading.show();
      try {
        /// api is now unavailable, please refactor this method to use alapi v2
        Response response = await Dio().post("https://v1.alapi.cn/api/ip",
            data: FormData.fromMap({'ip': _controller.text.trim()}),
            options: Options(
              sendTimeout: 5000,
              receiveTimeout: 5000,
            ));

        final resData = response.data;
        if (response.data['data']['location'] == '' ||
            response.data['data']['ad_info'] == '') {
          resData['data']['location'] = Map<String, dynamic>();
          resData['data']['ad_info'] = Map<String, dynamic>();
        }
        IpInformationEntity ipInformationEntity =
            IpInformationEntity.fromJson(resData);
        await loading.hide();
        if (ipInformationEntity.code == 200) {
          setState(() {
            ipData = ipInformationEntity.data;
          });
        } else {
          Fluttertoast.showToast(msg: 'IP 查询出错');
        }
      } catch (e) {
        await loading.hide();
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      Fluttertoast.showToast(msg: "IP 格式不正确");
    }
  }

  /// api is now unavailable, please refactor this method to use alapi v2
  handleQueryDeviceIp() async {
    ProgressDialog loading = createLoadingDialog();
    await loading.show();
    try {
      Response response = await Dio().post("https://v1.alapi.cn/api/ip",
          options: Options(sendTimeout: 5000, receiveTimeout: 5000));
      IpInformationEntity ipInformationEntity =
          IpInformationEntity.fromJson(response.data);
      await loading.hide();
      if (ipInformationEntity.code == 200) {
        setState(() {
          ipData = ipInformationEntity.data;
          _controller.text = ipData.ip;
        });
      } else {
        Fluttertoast.showToast(msg: 'IP 查询出错');
      }
    } catch (e) {
      await loading.hide();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameIpInformationQuery),
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: size.height,
          maxHeight: size.height,
        ),
        child: GestureDetector(
          onTap: () => _focusNode.unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "请输入待查 IP 地址",
                    filled: true,
                    fillColor: Color(0xFFF4F4F4),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => handleQuery(),
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (String value) => handleQuery(),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "使用本机 IP 查询",
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor.withOpacity(0.8),
                        ),
                      ),
                    ),
                    onTap: () => handleQueryDeviceIp(),
                  ),
                ),
                if (ipData != null)
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (ipData.ip != null)
                          ListTile(
                            leading: Text(
                              "当前 IP:",
                              style: TextStyle(fontSize: 16),
                            ),
                            title: Text(ipData.ip),
                            onTap: () {},
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 0),
                          ),
                        if (ipData.isp != null && ipData.isp != '')
                          ListTile(
                            leading: Text(
                              "运营商:",
                              style: TextStyle(fontSize: 16),
                            ),
                            title: Text(ipData.isp),
                            onTap: () {},
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 0),
                          ),
                        if (ipData.pos != null && ipData.pos != '')
                          ListTile(
                            leading: Text(
                              "位    置:",
                              style: TextStyle(fontSize: 16),
                            ),
                            title: Text(ipData.pos),
                            onTap: () {},
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 0),
                          ),
                        if (ipData.location != null &&
                            ipData.location.lat != null)
                          ListTile(
                            leading: Text(
                              "维    度:",
                              style: TextStyle(fontSize: 16),
                            ),
                            title: Text(ipData.location.lat.toString()),
                            onTap: () {},
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 0),
                          ),
                        if (ipData.adInfo != null &&
                            ipData.adInfo.adcode != null)
                          ListTile(
                            leading: Text(
                              "地区码:",
                              style: TextStyle(fontSize: 16),
                            ),
                            title: Text(ipData.adInfo.adcode.toString()),
                            onTap: () {},
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 0),
                          ),
                        if (ipData.location != null &&
                            ipData.location.lng != null)
                          ListTile(
                            leading: Text(
                              "经    度:",
                              style: TextStyle(fontSize: 16),
                            ),
                            title: Text(ipData.location.lng.toString()),
                            onTap: () {},
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 0),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

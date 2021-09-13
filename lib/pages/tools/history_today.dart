import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/models/history_today_data_entity.dart';

class PageToolHistoryToday extends StatefulWidget {
  @override
  _PageToolHistoryTodayState createState() => _PageToolHistoryTodayState();
}

class _PageToolHistoryTodayState extends State<PageToolHistoryToday> {
  String filename;
  DateTime dateTime;
  List<HistoryTodayDataEntity> historyDataList;
  bool loadFailed = false;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    this.loadInitialData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  queryData(filename) async {
    JSContext jsContext = JSContext.create(); // 创建 js 执行环境
    List<HistoryTodayDataEntity> tempHistoryDataList = [];
    String url = 'http://code.lssdjt.com/codedata/$filename';
    String javascriptContent;
    try {
      Response<String> response = await Dio().get<String>(url, options: Options(responseType: ResponseType.plain));
      String tempJSContent = response.data.replaceAll('Toh.get(callback)', '');
      javascriptContent = tempJSContent + "function getDataList(){return JSON.stringify(datalist);}getDataList();";
      String dataJsonString = jsContext.evaluate(javascriptContent).string;
      jsContext.release(); // 释放 js 执行环境
      List<dynamic> dataJson = jsonDecode(dataJsonString);
      dataJson.forEach((data) {
        tempHistoryDataList.add(HistoryTodayDataEntity.fromJson(data));
      });
    } catch (e) {
      await Fluttertoast.showToast(msg: "获取失败,检查网络\n或点击按钮重试...");
      setState(() {
        loadFailed = true;
      });
      return false;
    }
    setState(() {
      historyDataList = tempHistoryDataList;
      loadFailed = false;
    });
  }

  loadInitialData() {
    filename = "history.${dateTime.month}.${dateTime.day}.js";
    queryData(filename);
  }

  handleChangeDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(dateTime.year, 1),
      lastDate: DateTime(dateTime.year, 12),
    );
    if (picked != null) {
      setState(() {
        dateTime = picked;
        filename = "history.${dateTime.month}.${dateTime.day}.js";
        queryData(filename);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameHistoryToday),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.event),
            onPressed: () => handleChangeDate(context),
          ),
        ],
      ),
      body: _buildContentView(context),
    );
  }

  Widget _buildContentView(BuildContext context) {
    if (historyDataList != null && loadFailed != true) {
      final historyTodayDataList = historyDataList.reversed.toList();
      return Container(
        child: ListView.builder(
          itemCount: historyTodayDataList.length,
          itemBuilder: (BuildContext context, int index) {
            HistoryTodayDataEntity historyData = historyTodayDataList[index];
            if (historyData.pic != null && historyData.pic.toString().trim().length > 0) {
              return Container(
                margin: EdgeInsets.only(bottom: 24),
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        historyData.year.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 48,
                              child: Image.network(
                                historyData.pic,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            width: MediaQuery.of(context).size.width - 48,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                              child: Text(
                                historyData.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.only(bottom: 24),
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        historyData.year.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      width: MediaQuery.of(context).size.width - 48,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          historyData.title,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      );
    } else {
      if (loadFailed) {
        return Container(
          child: Center(
            child: IconButton(
              iconSize: 48,
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.refresh),
              splashColor: Theme.of(context).primaryColorLight,
              onPressed: () => loadInitialData(),
            ),
          ),
        );
      } else {
        return null;
      }
    }
  }
}

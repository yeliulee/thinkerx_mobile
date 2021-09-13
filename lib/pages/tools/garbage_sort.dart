import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thinkerx/core/resource_helper.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/utils/servers_helper.dart';

class PageToolGarbageSort extends StatefulWidget {
  @override
  _PageToolGarbageSortState createState() => _PageToolGarbageSortState();
}

class _PageToolGarbageSortState extends State<PageToolGarbageSort> {
  TextEditingController _controller;
  bool isLoading = false;
  static const String INPUT_HINT_TEXT = "请输入垃圾名称...";
  static const String EMPTY_ALERT_TEXT = "内容为空, 请输入关键字";
  static const String QUERY_FAILED_TEXT = "查询失败";
  static const String QUERY_EMPTY_TEXT = "查询结果为空";
  static const String LABEL_ICON = "icon";
  static const String LABEL_NAME = "name";
  static const String LABEL_CATEGORY = "category";
  static const String LABEL_EXPLAIN = "explain";
  static const String LABEL_CONTAINS = "contains";
  static const String LABEL_TIPS = "tips";
  List<Map<String, String>> garbageInfoList = [
    {
      LABEL_ICON: ResourceHelper.icon_garbage_type_0,
      LABEL_NAME: "可回收垃圾",
      LABEL_EXPLAIN: "可回收垃圾是指，适宜回收利用和资源化利用的生活废弃物，如废纸张、废塑料、废玻璃制品、废金属、废织物等",
      LABEL_CONTAINS: "报纸、纸箱、书本、广告单、塑料瓶、塑料玩具、油桶、酒瓶、玻璃杯、易拉罐、旧铁锅、旧衣服、包、旧玩偶、旧数码产品、旧家电等",
      LABEL_TIPS: "1.轻投轻放 2.清洁干燥、避免污染，废纸尽量平整 3.立体包装请清空内容物，清洁后压扁投放 4.有尖锐边角的，应包裹后投放",
    },
    {
      LABEL_ICON: ResourceHelper.icon_garbage_type_1,
      LABEL_NAME: "有毒垃圾",
      LABEL_EXPLAIN: "有害垃圾是指，对人体健康或者自然环境造成直接或潜在危害的废弃物",
      LABEL_CONTAINS: "废电池（充电电池、铅酸电池、镍镉电池、纽扣电池等）、废油漆、消毒剂、荧光灯管、含贡温度计、废药品及其包装物等",
      LABEL_TIPS: "1.投放时请注意轻放 2.易破损的请连带包装或包裹后轻放 3.如易挥发，请密封后投放",
    },
    {
      LABEL_ICON: ResourceHelper.icon_garbage_type_2,
      LABEL_NAME: "湿(厨余)垃圾",
      LABEL_EXPLAIN: "湿垃圾即厨余垃圾，是指日常生活垃圾产生的容易腐烂的生物质废弃物或居民日常生活及食品加工、饮食服务、单位供餐等活动中产生的垃圾。",
      LABEL_CONTAINS: "食材废料、剩饭剩菜、过期食品、蔬菜水果、瓜皮果核、花卉绿植、中药残渣等",
      LABEL_TIPS: "1.纯流质的食物垃圾，如牛奶等，应直接倒进下水口 2.有包装物的湿垃圾应将包装物去除后分类投放，包装物请投放到对应的可回收垃圾或干垃圾容器",
    },
    {
      LABEL_ICON: ResourceHelper.icon_garbage_type_3,
      LABEL_NAME: "干(其他)垃圾",
      LABEL_EXPLAIN: "干垃圾即其他垃圾，是指除可回收垃圾、有害垃圾、湿垃圾以外的其它生活废弃物",
      LABEL_CONTAINS: "餐盒、餐巾纸、湿纸巾、卫生间用纸、塑料袋、食品包装袋、污染严重的纸、烟蒂、纸尿裤、一次性杯子、大骨头、贝壳、花盆等",
      LABEL_TIPS: "1.尽量沥干水分 2.难以辨识类别的生活垃圾投入干垃圾容器内",
    },
  ];

  List<dynamic> garbageList = [];

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

  handleQuery() async {
    final garbageName = _controller.text.trim();
    if (garbageName.length == 0) {
      Fluttertoast.showToast(msg: EMPTY_ALERT_TEXT);
    } else {
      try {
        setState(() {
          isLoading = true;
          garbageList = [];
        });
        Response response = await Dio().get(ServersHelper.apiURL + "/v_app/waste_classify", queryParameters: {"name": garbageName});
        if (response.data["data"].length == 0) {
          await Fluttertoast.showToast(msg: QUERY_EMPTY_TEXT);
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            garbageList = response.data["data"];
            isLoading = false;
          });
        }
      } catch (e) {
        print(e);
        await Fluttertoast.showToast(msg: QUERY_FAILED_TEXT);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  handleShowInfo(BuildContext context, Map<String, String> garbageInfo) async {
    showModalBottomSheet<void>(
      enableDrag: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          constraints: BoxConstraints(
            minHeight: 50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.help,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              "${garbageInfo[LABEL_NAME]}是什么?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        garbageInfo[LABEL_EXPLAIN],
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "有什么常见的${garbageInfo[LABEL_NAME]}?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        garbageInfo[LABEL_CONTAINS],
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                color: Color(0xFFF4F4F4),
                child: Text(
                  garbageInfo[LABEL_TIPS],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameGarbageSortQuery),
        bottom: _buildSearchField(context),
      ),
      body: Container(
        child: isLoading ? Center(child: CircularProgressIndicator()) : _buildContentView(context),
      ),
    );
  }

  Widget _buildContentView(BuildContext context) {
    return Container(
      color: Color(0xFFF8F8F8),
      child: ListView.builder(
        itemCount: garbageList.length,
        itemBuilder: (BuildContext ctx, int index) {
          Map<String, dynamic> garbage = garbageList[index];
          Map<String, String> garbageInfo = garbageInfoList[garbage[LABEL_CATEGORY]];
          return Container(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 4),
            child: ListTile(
              leading: Container(
                width: 28,
                height: 28,
                child: Image.asset(garbageInfo[LABEL_ICON]),
              ),
              title: Text(
                garbage[LABEL_NAME],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                garbageInfo[LABEL_NAME],
                style: TextStyle(
                  color: Colors.black38,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => handleShowInfo(context, garbageInfo),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: Container(
        height: 80,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 48,
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
                    hintText: INPUT_HINT_TEXT,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 8),
                  ),
                  onSubmitted: (String value) => handleQuery(),
                  textInputAction: TextInputAction.search,
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                splashColor: Theme.of(context).primaryColorLight,
                onPressed: () => handleQuery(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

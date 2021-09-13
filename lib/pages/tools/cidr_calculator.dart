import 'package:flutter/material.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/utils/cidr_calculator.dart';

class PageToolCidrCalculator extends StatefulWidget {
  @override
  _PageToolCidrCalculatorState createState() => _PageToolCidrCalculatorState();
}

class _PageToolCidrCalculatorState extends State<PageToolCidrCalculator> {
  TextEditingController controller;
  int available;
  CidrCalculator currentCalculator;
  String currentText;
  String errorText;

  @override
  void initState() {
    controller = TextEditingController();
    currentText = controller.text;
    super.initState();
  }

  void parseCidr(String cidrText) {
    setState(() {
      currentText = cidrText;
    });
    String pattern =
        r'^(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\/([1-9]|[1-2]\d|3[0-2])$';
    if (cidrText.length > 0 && RegExp(pattern).hasMatch(cidrText)) {
      setState(() {
        errorText = null;
        try {
          currentCalculator = CidrCalculator(cidr: cidrText);
        } catch (e) {
          print(e);
        }
      });
    } else if (cidrText.length > 0 && !RegExp(pattern).hasMatch(cidrText)) {
      setState(() {
        errorText = 'CIDR 格式有误';
      });
    } else {
      setState(() {
        errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocale.current.toolNameCidrCalculator),
        bottom: _buildInputBox(context),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return currentCalculator == null
        ? null
        : ListView(
            children: <Widget>[
              ListTile(
                dense: true,
                leading: Text("可用地址："),
                title: Text(currentCalculator.available.toString()),
                onTap: () {},
              ),
              ListTile(
                dense: true,
                leading: Text("起始地址："),
                title: Text(currentCalculator.firstHost),
                onTap: () {},
              ),
              ListTile(
                dense: true,
                leading: Text("结束地址："),
                title: Text(currentCalculator.lastHost),
                onTap: () {},
              ),
              ListTile(
                dense: true,
                leading: Text("子网掩码："),
                title: Text(currentCalculator.maskCode),
                onTap: () {},
              ),
              ListTile(
                dense: true,
                leading: Text("网络地址："),
                title: Text(currentCalculator.networkID),
                onTap: () {},
              ),
              ListTile(
                dense: true,
                leading: Text("广播地址："),
                title: Text(currentCalculator.networkBroadcast),
                onTap: () {},
              ),
            ],
          );
  }

  Widget _buildInputBox(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(108),
      child: Container(
        height: 108,
        padding: EdgeInsets.all(16),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TextField(
              controller: controller,
              autofocus: true,
              cursorColor: Theme.of(context).primaryColor,
              enableSuggestions: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                errorText: errorText,
                errorStyle: TextStyle(color: Colors.white),
                hintText: "示例: 192.168.0.1/24",
                filled: true,
                fillColor: Colors.white,
                suffixIcon: currentText.length == 0
                    ? null
                    : IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          currentCalculator = null;
                          controller.clear();
                          this.parseCidr('');
                        },
                      ),
              ),
              onChanged: (String text) => parseCidr(text),
            ),
          ),
        ),
      ),
    );
  }
}

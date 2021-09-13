import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thinkerx/components/content_copy_view.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageToolMd5Summary extends StatefulWidget {
  @override
  _PageToolMd5SummaryState createState() => _PageToolMd5SummaryState();
}

class _PageToolMd5SummaryState extends State<PageToolMd5Summary> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _inputController;
  TextEditingController _inputControllerForFile;
  FocusNode _focusNodeForText = FocusNode();
  FocusNode _focusNodeForFile = FocusNode();
  String textSummary = '';
  String fileSummary = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _inputController = TextEditingController();
    _inputControllerForFile = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _inputController.dispose();
    _inputControllerForFile.dispose();
  }

  handleTextChange(String value) {
    setState(() {
      Uint8List bytes = utf8.encode(_inputController.text);
      Digest digest = md5.convert(bytes);
      textSummary = digest.toString();
    });
  }

  handlePickFile() async {
    final ProgressDialog progressDialog = ProgressDialog(context, isDismissible: false, type: ProgressDialogType.Normal);
    progressDialog.style(
      message: "正在处理,请稍后...",
      progressWidget: Container(padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
    );
    if ((await Permission.storage.request()).isGranted) {
      try {
        String filePath = await FilePicker.getFilePath(allowCompression: false);
        if (filePath == null) {
          return false;
        }
        File file = File(filePath);
        await progressDialog.show();
        String filename = file.path.substring(file.path.lastIndexOf('/') + 1);
        Uint8List bytes = file.readAsBytesSync();
        Digest digest = md5.convert(bytes);
        await progressDialog.hide();
        setState(() {
          _inputControllerForFile.text = filename;
          fileSummary = digest.toString();
        });
      } catch (e) {
        await progressDialog.hide();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameMd5Summary),
        bottom: _buildTabBar(context),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildTextEncoder(context),
          _buildFileEncoder(context),
        ],
      ),
    );
  }

  Widget _buildTextEncoder(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () => _focusNodeForText.unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: TextField(
                focusNode: _focusNodeForText,
                controller: _inputController,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                  hintText: "请输入文本...",
                  counterText: "",
                ),
                cursorColor: primaryColor,
                maxLength: 10000,
                onChanged: (value) => handleTextChange(value),
              ),
            ),
            if (textSummary != null && textSummary.trim().length > 0)
              Container(
                child: ContentCopyView(
                  title: "摘要结果",
                  content: textSummary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileEncoder(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () => _focusNodeForFile.unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: TextField(
                focusNode: _focusNodeForFile,
                readOnly: true,
                controller: _inputControllerForFile,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                  hintText: "点击选择文件...",
                  counterText: "",
                  suffixIcon: Icon(Icons.file_upload),
                ),
                cursorColor: primaryColor,
                maxLength: 10000,
                onTap: () => handlePickFile(),
              ),
            ),
            if (fileSummary != null && fileSummary.trim().length > 0)
              Container(
                child: ContentCopyView(
                  title: "摘要结果",
                  content: fileSummary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.all(8).copyWith(left: 16),
          alignment: Alignment.centerLeft,
          constraints: BoxConstraints(
            maxHeight: 32,
          ),
          child: Theme(
            data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              indicator: BoxDecoration(
                color: Theme.of(context).primaryColorLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              tabs: [
                Tab(
                  text: "文本",
                ),
                Tab(
                  text: "文件",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

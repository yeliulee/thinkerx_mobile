import 'package:flutter/material.dart';
import 'package:thinkerx/generated/l10n.dart';

class PageFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.helpAndFeedBack),
      ),
    );
  }
}

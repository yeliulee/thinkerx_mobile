import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/store/app.dart';
import 'package:thinkerx/themes.dart';

class PageSettingThemes extends StatelessWidget {
  final Map<String, ThemeData> themes = AppThemes.all;
  final Map<String, String> themesTitle = {
    "blue": AppLocale.current.themeBlue,
    "pink": AppLocale.current.themePink,
    "orange": AppLocale.current.themeOrange,
    "red": AppLocale.current.themeRed,
    "cyan": AppLocale.current.themeCyan,
    "green": AppLocale.current.themeGreen,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.themeManager),
      ),
      body: ListView(
        children: themes.entries
            .map((theme) => CheckboxListTile(
                  title: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 48),
                          color: theme.value.primaryColor,
                          height: 24,
                        ),
                      ),
                      Icon(
                        Icons.invert_colors,
                        color: theme.value.primaryColor,
                      ),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: theme.key == context.watch<AppViewModel>().appTheme,
                  onChanged: (bool checked) => _handleSetTheme(context, theme.key),
                ))
            .toList(),
      ),
    );
  }

  void _handleSetTheme(BuildContext context, String themeName) {
    if (themes.containsKey(themeName)) {
      context.read<AppViewModel>().handleSetTheme(themeName);
    }
  }
}

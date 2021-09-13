import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:thinkerx/core/tool_use_logger.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/router/app_router.gr.dart';
import 'package:thinkerx/store/app.dart';
import 'package:thinkerx/themes.dart';

class ApplicationManager extends StatefulWidget {
  ApplicationManager({Key key}) : super(key: key);

  static restartApp(BuildContext context) {
    final _ApplicationManagerState state = context.findAncestorStateOfType<_ApplicationManagerState>();
    state.restartApp();
  }

  @override
  _ApplicationManagerState createState() => _ApplicationManagerState();
}

class _ApplicationManagerState extends State<ApplicationManager> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      key: _key,
      providers: [
        ChangeNotifierProvider<AppViewModel>(create: (context) => AppViewModel()),
      ],
      child: Application(),
    );
  }
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ThinkerX",
      theme: AppThemes.getTheme(themeName: Provider.of<AppViewModel>(context).appTheme),
      locale: !Provider.of<AppViewModel>(context).followDeviceLocale ? Provider.of<AppViewModel>(context).currentAppLocale : null,
      localizationsDelegates: [
        AppLocale.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: AppLocale.delegate.supportedLocales,
      localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
        Locale localeToUse = supportedLocales.first;

        // 不完全匹配
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            localeToUse = supportedLocale;
          }
        }

        // 完全匹配
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode) {
            localeToUse = supportedLocale;
          }
        }

        return localeToUse;
      },
      builder: (ctx, _) {
        return ExtendedNavigator<AppRouter>(
          observers: [
            ToolUseLogger(),
          ],
          router: AppRouter(),
        );
      },
    );
  }
}

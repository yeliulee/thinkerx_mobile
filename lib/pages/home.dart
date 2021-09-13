import 'package:auto_route/auto_route.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:thinkerx/components/page_home_account.dart';
import 'package:thinkerx/components/page_home_gallery.dart';
import 'package:thinkerx/components/page_home_home.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/router/app_router.gr.dart';
import 'package:thinkerx/store/page_home.dart';

DateTime lastPopTime;

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  QuickActions quickActions = QuickActions();

  @override
  void initState() {
    super.initState();
    setupQuickActions();
  }

  void setupQuickActions() {
    quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
        type: 'action_search',
        localizedTitle: "搜索工具",
        icon: 'ic_action_search',
      ),
      ShortcutItem(
        type: 'action_favorites',
        localizedTitle: "收藏管理",
        icon: 'ic_action_favorites',
      ),
      ShortcutItem(
        type: 'action_history',
        localizedTitle: "最近使用",
        icon: 'ic_action_history',
      ),
    ]);

    quickActions.initialize((type) {
      if (type == 'action_search') {
        ExtendedNavigator.root.push(AppRoutes.pageSearch);
      } else if (type == 'action_favorites') {
        ExtendedNavigator.root.push(AppRoutes.pageFavoritesManager);
      } else if (type == 'action_history') {
        ExtendedNavigator.root.push(AppRoutes.pageHistory);
      }
    });
  }

  handleWillPop() async {
    // 点击返回键的操作
    if (lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
      lastPopTime = DateTime.now();
      await Fluttertoast.showToast(
        msg: '再按一次退出',
        backgroundColor: Colors.black45.withOpacity(0.5),
        textColor: Colors.white,
        gravity: ToastGravity.CENTER,
      );
    } else {
      lastPopTime = DateTime.now();
      // 退出app
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: ChangeNotifierProvider(
        create: (ctx) => PageHomeViewModel(),
        builder: (ctx, _) => _buildScaffold(ctx),
      ),
      onWillPop: () => handleWillPop(),
    );
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(AppLocale.current.pageHomeTabHome),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            title: Text(AppLocale.current.pageHomeTabGallery),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text(AppLocale.current.pageHomeTabAccount),
          ),
        ],
        currentIndex: context.watch<PageHomeViewModel>().tabIndex,
        onTap: (tabIndex) {
          Provider.of<PageHomeViewModel>(context, listen: false).handleSwitchTab(tabIndex);
          Provider.of<PageHomeViewModel>(context, listen: false)
              .pageController
              .animateToPage(tabIndex, duration: Duration(milliseconds: 150), curve: Curves.easeInOut);
        },
      ),
      body: PageView(
        controller: Provider.of<PageHomeViewModel>(context, listen: false).pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          PageHomeHome(),
          PageHomeGallery(),
          PageHomeAccount(),
        ],
        onPageChanged: (pageIndex) => Provider.of<PageHomeViewModel>(context, listen: false).handleSwitchTab(pageIndex),
      ),
    );
  }
}

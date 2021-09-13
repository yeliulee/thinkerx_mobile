import 'package:auto_route/auto_route_annotations.dart';
import 'package:thinkerx/pages/about.dart';
import 'package:thinkerx/pages/favorites_manager.dart';
import 'package:thinkerx/pages/feedback.dart';
import 'package:thinkerx/pages/home.dart';
import 'package:thinkerx/pages/search.dart';
import 'package:thinkerx/pages/settings/common.dart';
import 'package:thinkerx/pages/settings/themes.dart';
import 'package:thinkerx/pages/tools/base_converter.dart';
import 'package:thinkerx/pages/tools/bilibili_cover.dart';
import 'package:thinkerx/pages/tools/bmi_calculator.dart';
import 'package:thinkerx/pages/tools/chinese_pinyin.dart';
import 'package:thinkerx/pages/tools/cidr_calculator.dart';
import 'package:thinkerx/pages/tools/color_picker.dart';
import 'package:thinkerx/pages/tools/device_info.dart';
import 'package:thinkerx/pages/tools/draw_board.dart';
import 'package:thinkerx/pages/tools/express_inquiry.dart';
import 'package:thinkerx/pages/tools/garbage_sort.dart';
import 'package:thinkerx/pages/tools/handheld_danmaku.dart';
import 'package:thinkerx/pages/tools/history_today.dart';
import 'package:thinkerx/pages/tools/image_compress.dart';
import 'package:thinkerx/pages/tools/ip_query.dart';
import 'package:thinkerx/pages/tools/marketing_article_generation.dart';
import 'package:thinkerx/pages/tools/md5_summary.dart';
import 'package:thinkerx/pages/tools/morse_code.dart';
import 'package:thinkerx/pages/tools/nine_grid_image.dart';
import 'package:thinkerx/pages/tools/number_chinese.dart';
import 'package:thinkerx/pages/tools/qrcode.dart';
import 'package:thinkerx/pages/tools/random_number.dart';
import 'package:thinkerx/pages/tools/relationship_calculator.dart';
import 'package:thinkerx/pages/tools/screen_info.dart';
import 'package:thinkerx/pages/tools/system_info.dart';
import 'package:thinkerx/pages/tools/time_screen.dart';
import 'package:thinkerx/pages/tools/url_encoder.dart';
import 'package:thinkerx/pages/tools/video_to_gif.dart';
import 'package:thinkerx/pages/tools/view_source.dart';
import 'package:thinkerx/pages/tools/what_anime.dart';
import 'package:thinkerx/pages/user/history.dart';
import 'package:thinkerx/pages/user/profile.dart';

@MaterialAutoRouter(
  generateNavigationHelperExtension: true,
  routesClassName: 'AppRoutes',
  routes: [
    MaterialRoute(path: '/', page: PageHome),
    MaterialRoute(path: '/search', page: PageSearch),
    MaterialRoute(path: '/setting/common', page: PageSettingCommon),
    MaterialRoute(path: '/setting/themes', page: PageSettingThemes),
    MaterialRoute(path: '/feedback', page: PageFeedback),
    MaterialRoute(path: '/about', page: PageAbout),
    MaterialRoute(path: '/favorites', page: PageFavoritesManager),

    /// 用户相关路由
    MaterialRoute(path: '/user/profile', page: PageUserProfile),
    MaterialRoute(path: '/user/history', page: PageHistory),

    /// 工具页面路由
    MaterialRoute(path: '/tool/bmi_calculator', page: PageToolBmiCalculator),
    MaterialRoute(path: '/tool/base_converter', page: PageToolBaseConverter),
    MaterialRoute(path: '/tool/bilibili_cover', page: PageToolBilibiliCover),
    MaterialRoute(path: '/tool/chinese_pinyin', page: PageToolChinesePinyin),
    MaterialRoute(path: '/tool/cidr_calculator', page: PageToolCidrCalculator),
    MaterialRoute(path: '/tool/device_info', page: PageToolDeviceInfo),
    MaterialRoute(path: '/tool/express_inquiry', page: PageToolExpressInquiry),
    MaterialRoute(path: '/tool/garbage_sort', page: PageToolGarbageSort),
    MaterialRoute(path: '/tool/history_today', page: PageToolHistoryToday),
    MaterialRoute(path: '/tool/image_compress', page: PageToolImageCompress),
    MaterialRoute(path: '/tool/ip_query', page: PageToolIpQuery),
    MaterialRoute(path: '/tool/marketing_article_generation', page: PageToolMarketingArticleGeneration),
    MaterialRoute(path: '/tool/md5_summary', page: PageToolMd5Summary),
    MaterialRoute(path: '/tool/morse_code', page: PageToolMorseCode),
    MaterialRoute(path: '/tool/number_chinese', page: PageToolNumberChinese),
    MaterialRoute(path: '/tool/qrcode', page: PageToolQrcode),
    MaterialRoute(path: '/tool/relationship_calculator', page: PageToolRelationshipCalculator),
    MaterialRoute(path: '/tool/screen_info', page: PageToolScreenInfo),
    MaterialRoute(path: '/tool/system_info', page: PageToolSystemInfo),
    MaterialRoute(path: '/tool/url_encoder', page: PageToolUrlEncoder),
    MaterialRoute(path: '/tool/video_to_gif', page: PageToolVideoToGif),
    MaterialRoute(path: '/tool/what_anime', page: PageToolWhatAnime),
    MaterialRoute(path: '/tool/random_number', page: PageToolRandomNumber),
    MaterialRoute(path: '/tool/time_screen', page: PageToolTimeScreen),
    MaterialRoute(path: '/tool/handheld_danmaku', page: PageToolHandheldDanmaku),
    MaterialRoute(path: '/tool/draw_board', page: PageToolDrawBoard),
    MaterialRoute(path: '/tool/color_picker', page: PageToolColorPicker),
    MaterialRoute(path: '/tool/nine_grid_image', page: PageToolNineGridImage),
    MaterialRoute(path: '/tool/view_source', page: PageToolViewSource),
  ],
)
class $AppRouter {}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../pages/about.dart';
import '../pages/favorites_manager.dart';
import '../pages/feedback.dart';
import '../pages/home.dart';
import '../pages/search.dart';
import '../pages/settings/common.dart';
import '../pages/settings/themes.dart';
import '../pages/tools/base_converter.dart';
import '../pages/tools/bilibili_cover.dart';
import '../pages/tools/bmi_calculator.dart';
import '../pages/tools/chinese_pinyin.dart';
import '../pages/tools/cidr_calculator.dart';
import '../pages/tools/color_picker.dart';
import '../pages/tools/device_info.dart';
import '../pages/tools/draw_board.dart';
import '../pages/tools/express_inquiry.dart';
import '../pages/tools/garbage_sort.dart';
import '../pages/tools/handheld_danmaku.dart';
import '../pages/tools/history_today.dart';
import '../pages/tools/image_compress.dart';
import '../pages/tools/ip_query.dart';
import '../pages/tools/marketing_article_generation.dart';
import '../pages/tools/md5_summary.dart';
import '../pages/tools/morse_code.dart';
import '../pages/tools/nine_grid_image.dart';
import '../pages/tools/number_chinese.dart';
import '../pages/tools/qrcode.dart';
import '../pages/tools/random_number.dart';
import '../pages/tools/relationship_calculator.dart';
import '../pages/tools/screen_info.dart';
import '../pages/tools/system_info.dart';
import '../pages/tools/time_screen.dart';
import '../pages/tools/url_encoder.dart';
import '../pages/tools/video_to_gif.dart';
import '../pages/tools/view_source.dart';
import '../pages/tools/what_anime.dart';
import '../pages/user/history.dart';
import '../pages/user/profile.dart';

class AppRoutes {
  static const String pageHome = '/';
  static const String pageSearch = '/search';
  static const String pageSettingCommon = '/setting/common';
  static const String pageSettingThemes = '/setting/themes';
  static const String pageFeedback = '/feedback';
  static const String pageAbout = '/about';
  static const String pageFavoritesManager = '/favorites';
  static const String pageUserProfile = '/user/profile';
  static const String pageHistory = '/user/history';
  static const String pageToolBmiCalculator = '/tool/bmi_calculator';
  static const String pageToolBaseConverter = '/tool/base_converter';
  static const String pageToolBilibiliCover = '/tool/bilibili_cover';
  static const String pageToolChinesePinyin = '/tool/chinese_pinyin';
  static const String pageToolCidrCalculator = '/tool/cidr_calculator';
  static const String pageToolDeviceInfo = '/tool/device_info';
  static const String pageToolExpressInquiry = '/tool/express_inquiry';
  static const String pageToolGarbageSort = '/tool/garbage_sort';
  static const String pageToolHistoryToday = '/tool/history_today';
  static const String pageToolImageCompress = '/tool/image_compress';
  static const String pageToolIpQuery = '/tool/ip_query';
  static const String pageToolMarketingArticleGeneration =
      '/tool/marketing_article_generation';
  static const String pageToolMd5Summary = '/tool/md5_summary';
  static const String pageToolMorseCode = '/tool/morse_code';
  static const String pageToolNumberChinese = '/tool/number_chinese';
  static const String pageToolQrcode = '/tool/qrcode';
  static const String pageToolRelationshipCalculator =
      '/tool/relationship_calculator';
  static const String pageToolScreenInfo = '/tool/screen_info';
  static const String pageToolSystemInfo = '/tool/system_info';
  static const String pageToolUrlEncoder = '/tool/url_encoder';
  static const String pageToolVideoToGif = '/tool/video_to_gif';
  static const String pageToolWhatAnime = '/tool/what_anime';
  static const String pageToolRandomNumber = '/tool/random_number';
  static const String pageToolTimeScreen = '/tool/time_screen';
  static const String pageToolHandheldDanmaku = '/tool/handheld_danmaku';
  static const String pageToolDrawBoard = '/tool/draw_board';
  static const String pageToolColorPicker = '/tool/color_picker';
  static const String pageToolNineGridImage = '/tool/nine_grid_image';
  static const String pageToolViewSource = '/tool/view_source';
  static const all = <String>{
    pageHome,
    pageSearch,
    pageSettingCommon,
    pageSettingThemes,
    pageFeedback,
    pageAbout,
    pageFavoritesManager,
    pageUserProfile,
    pageHistory,
    pageToolBmiCalculator,
    pageToolBaseConverter,
    pageToolBilibiliCover,
    pageToolChinesePinyin,
    pageToolCidrCalculator,
    pageToolDeviceInfo,
    pageToolExpressInquiry,
    pageToolGarbageSort,
    pageToolHistoryToday,
    pageToolImageCompress,
    pageToolIpQuery,
    pageToolMarketingArticleGeneration,
    pageToolMd5Summary,
    pageToolMorseCode,
    pageToolNumberChinese,
    pageToolQrcode,
    pageToolRelationshipCalculator,
    pageToolScreenInfo,
    pageToolSystemInfo,
    pageToolUrlEncoder,
    pageToolVideoToGif,
    pageToolWhatAnime,
    pageToolRandomNumber,
    pageToolTimeScreen,
    pageToolHandheldDanmaku,
    pageToolDrawBoard,
    pageToolColorPicker,
    pageToolNineGridImage,
    pageToolViewSource,
  };
}

class AppRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(AppRoutes.pageHome, page: PageHome),
    RouteDef(AppRoutes.pageSearch, page: PageSearch),
    RouteDef(AppRoutes.pageSettingCommon, page: PageSettingCommon),
    RouteDef(AppRoutes.pageSettingThemes, page: PageSettingThemes),
    RouteDef(AppRoutes.pageFeedback, page: PageFeedback),
    RouteDef(AppRoutes.pageAbout, page: PageAbout),
    RouteDef(AppRoutes.pageFavoritesManager, page: PageFavoritesManager),
    RouteDef(AppRoutes.pageUserProfile, page: PageUserProfile),
    RouteDef(AppRoutes.pageHistory, page: PageHistory),
    RouteDef(AppRoutes.pageToolBmiCalculator, page: PageToolBmiCalculator),
    RouteDef(AppRoutes.pageToolBaseConverter, page: PageToolBaseConverter),
    RouteDef(AppRoutes.pageToolBilibiliCover, page: PageToolBilibiliCover),
    RouteDef(AppRoutes.pageToolChinesePinyin, page: PageToolChinesePinyin),
    RouteDef(AppRoutes.pageToolCidrCalculator, page: PageToolCidrCalculator),
    RouteDef(AppRoutes.pageToolDeviceInfo, page: PageToolDeviceInfo),
    RouteDef(AppRoutes.pageToolExpressInquiry, page: PageToolExpressInquiry),
    RouteDef(AppRoutes.pageToolGarbageSort, page: PageToolGarbageSort),
    RouteDef(AppRoutes.pageToolHistoryToday, page: PageToolHistoryToday),
    RouteDef(AppRoutes.pageToolImageCompress, page: PageToolImageCompress),
    RouteDef(AppRoutes.pageToolIpQuery, page: PageToolIpQuery),
    RouteDef(AppRoutes.pageToolMarketingArticleGeneration,
        page: PageToolMarketingArticleGeneration),
    RouteDef(AppRoutes.pageToolMd5Summary, page: PageToolMd5Summary),
    RouteDef(AppRoutes.pageToolMorseCode, page: PageToolMorseCode),
    RouteDef(AppRoutes.pageToolNumberChinese, page: PageToolNumberChinese),
    RouteDef(AppRoutes.pageToolQrcode, page: PageToolQrcode),
    RouteDef(AppRoutes.pageToolRelationshipCalculator,
        page: PageToolRelationshipCalculator),
    RouteDef(AppRoutes.pageToolScreenInfo, page: PageToolScreenInfo),
    RouteDef(AppRoutes.pageToolSystemInfo, page: PageToolSystemInfo),
    RouteDef(AppRoutes.pageToolUrlEncoder, page: PageToolUrlEncoder),
    RouteDef(AppRoutes.pageToolVideoToGif, page: PageToolVideoToGif),
    RouteDef(AppRoutes.pageToolWhatAnime, page: PageToolWhatAnime),
    RouteDef(AppRoutes.pageToolRandomNumber, page: PageToolRandomNumber),
    RouteDef(AppRoutes.pageToolTimeScreen, page: PageToolTimeScreen),
    RouteDef(AppRoutes.pageToolHandheldDanmaku, page: PageToolHandheldDanmaku),
    RouteDef(AppRoutes.pageToolDrawBoard, page: PageToolDrawBoard),
    RouteDef(AppRoutes.pageToolColorPicker, page: PageToolColorPicker),
    RouteDef(AppRoutes.pageToolNineGridImage, page: PageToolNineGridImage),
    RouteDef(AppRoutes.pageToolViewSource, page: PageToolViewSource),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    PageHome: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageHome(),
        settings: data,
      );
    },
    PageSearch: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageSearch(),
        settings: data,
      );
    },
    PageSettingCommon: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageSettingCommon(),
        settings: data,
      );
    },
    PageSettingThemes: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageSettingThemes(),
        settings: data,
      );
    },
    PageFeedback: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageFeedback(),
        settings: data,
      );
    },
    PageAbout: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageAbout(),
        settings: data,
      );
    },
    PageFavoritesManager: (data) {
      final args = data.getArgs<PageFavoritesManagerArguments>(
        orElse: () => PageFavoritesManagerArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            PageFavoritesManager(isManageMode: args.isManageMode),
        settings: data,
      );
    },
    PageUserProfile: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageUserProfile(),
        settings: data,
      );
    },
    PageHistory: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageHistory(),
        settings: data,
      );
    },
    PageToolBmiCalculator: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolBmiCalculator(),
        settings: data,
      );
    },
    PageToolBaseConverter: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolBaseConverter(),
        settings: data,
      );
    },
    PageToolBilibiliCover: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolBilibiliCover(),
        settings: data,
      );
    },
    PageToolChinesePinyin: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolChinesePinyin(),
        settings: data,
      );
    },
    PageToolCidrCalculator: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolCidrCalculator(),
        settings: data,
      );
    },
    PageToolDeviceInfo: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolDeviceInfo(),
        settings: data,
      );
    },
    PageToolExpressInquiry: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolExpressInquiry(),
        settings: data,
      );
    },
    PageToolGarbageSort: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolGarbageSort(),
        settings: data,
      );
    },
    PageToolHistoryToday: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolHistoryToday(),
        settings: data,
      );
    },
    PageToolImageCompress: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolImageCompress(),
        settings: data,
      );
    },
    PageToolIpQuery: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolIpQuery(),
        settings: data,
      );
    },
    PageToolMarketingArticleGeneration: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolMarketingArticleGeneration(),
        settings: data,
      );
    },
    PageToolMd5Summary: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolMd5Summary(),
        settings: data,
      );
    },
    PageToolMorseCode: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolMorseCode(),
        settings: data,
      );
    },
    PageToolNumberChinese: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolNumberChinese(),
        settings: data,
      );
    },
    PageToolQrcode: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolQrcode(),
        settings: data,
      );
    },
    PageToolRelationshipCalculator: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolRelationshipCalculator(),
        settings: data,
      );
    },
    PageToolScreenInfo: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolScreenInfo(),
        settings: data,
      );
    },
    PageToolSystemInfo: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolSystemInfo(),
        settings: data,
      );
    },
    PageToolUrlEncoder: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolUrlEncoder(),
        settings: data,
      );
    },
    PageToolVideoToGif: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolVideoToGif(),
        settings: data,
      );
    },
    PageToolWhatAnime: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolWhatAnime(),
        settings: data,
      );
    },
    PageToolRandomNumber: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolRandomNumber(),
        settings: data,
      );
    },
    PageToolTimeScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolTimeScreen(),
        settings: data,
      );
    },
    PageToolHandheldDanmaku: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolHandheldDanmaku(),
        settings: data,
      );
    },
    PageToolDrawBoard: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolDrawBoard(),
        settings: data,
      );
    },
    PageToolColorPicker: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolColorPicker(),
        settings: data,
      );
    },
    PageToolNineGridImage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolNineGridImage(),
        settings: data,
      );
    },
    PageToolViewSource: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PageToolViewSource(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Navigation helper methods extension
/// *************************************************************************

extension AppRouterExtendedNavigatorStateX on ExtendedNavigatorState {
  Future<dynamic> pushPageHome() => push<dynamic>(AppRoutes.pageHome);

  Future<dynamic> pushPageSearch() => push<dynamic>(AppRoutes.pageSearch);

  Future<dynamic> pushPageSettingCommon() =>
      push<dynamic>(AppRoutes.pageSettingCommon);

  Future<dynamic> pushPageSettingThemes() =>
      push<dynamic>(AppRoutes.pageSettingThemes);

  Future<dynamic> pushPageFeedback() => push<dynamic>(AppRoutes.pageFeedback);

  Future<dynamic> pushPageAbout() => push<dynamic>(AppRoutes.pageAbout);

  Future<dynamic> pushPageFavoritesManager({
    bool isManageMode = false,
  }) =>
      push<dynamic>(
        AppRoutes.pageFavoritesManager,
        arguments: PageFavoritesManagerArguments(isManageMode: isManageMode),
      );

  Future<dynamic> pushPageUserProfile() =>
      push<dynamic>(AppRoutes.pageUserProfile);

  Future<dynamic> pushPageHistory() => push<dynamic>(AppRoutes.pageHistory);

  Future<dynamic> pushPageToolBmiCalculator() =>
      push<dynamic>(AppRoutes.pageToolBmiCalculator);

  Future<dynamic> pushPageToolBaseConverter() =>
      push<dynamic>(AppRoutes.pageToolBaseConverter);

  Future<dynamic> pushPageToolBilibiliCover() =>
      push<dynamic>(AppRoutes.pageToolBilibiliCover);

  Future<dynamic> pushPageToolChinesePinyin() =>
      push<dynamic>(AppRoutes.pageToolChinesePinyin);

  Future<dynamic> pushPageToolCidrCalculator() =>
      push<dynamic>(AppRoutes.pageToolCidrCalculator);

  Future<dynamic> pushPageToolDeviceInfo() =>
      push<dynamic>(AppRoutes.pageToolDeviceInfo);

  Future<dynamic> pushPageToolExpressInquiry() =>
      push<dynamic>(AppRoutes.pageToolExpressInquiry);

  Future<dynamic> pushPageToolGarbageSort() =>
      push<dynamic>(AppRoutes.pageToolGarbageSort);

  Future<dynamic> pushPageToolHistoryToday() =>
      push<dynamic>(AppRoutes.pageToolHistoryToday);

  Future<dynamic> pushPageToolImageCompress() =>
      push<dynamic>(AppRoutes.pageToolImageCompress);

  Future<dynamic> pushPageToolIpQuery() =>
      push<dynamic>(AppRoutes.pageToolIpQuery);

  Future<dynamic> pushPageToolMarketingArticleGeneration() =>
      push<dynamic>(AppRoutes.pageToolMarketingArticleGeneration);

  Future<dynamic> pushPageToolMd5Summary() =>
      push<dynamic>(AppRoutes.pageToolMd5Summary);

  Future<dynamic> pushPageToolMorseCode() =>
      push<dynamic>(AppRoutes.pageToolMorseCode);

  Future<dynamic> pushPageToolNumberChinese() =>
      push<dynamic>(AppRoutes.pageToolNumberChinese);

  Future<dynamic> pushPageToolQrcode() =>
      push<dynamic>(AppRoutes.pageToolQrcode);

  Future<dynamic> pushPageToolRelationshipCalculator() =>
      push<dynamic>(AppRoutes.pageToolRelationshipCalculator);

  Future<dynamic> pushPageToolScreenInfo() =>
      push<dynamic>(AppRoutes.pageToolScreenInfo);

  Future<dynamic> pushPageToolSystemInfo() =>
      push<dynamic>(AppRoutes.pageToolSystemInfo);

  Future<dynamic> pushPageToolUrlEncoder() =>
      push<dynamic>(AppRoutes.pageToolUrlEncoder);

  Future<dynamic> pushPageToolVideoToGif() =>
      push<dynamic>(AppRoutes.pageToolVideoToGif);

  Future<dynamic> pushPageToolWhatAnime() =>
      push<dynamic>(AppRoutes.pageToolWhatAnime);

  Future<dynamic> pushPageToolRandomNumber() =>
      push<dynamic>(AppRoutes.pageToolRandomNumber);

  Future<dynamic> pushPageToolTimeScreen() =>
      push<dynamic>(AppRoutes.pageToolTimeScreen);

  Future<dynamic> pushPageToolHandheldDanmaku() =>
      push<dynamic>(AppRoutes.pageToolHandheldDanmaku);

  Future<dynamic> pushPageToolDrawBoard() =>
      push<dynamic>(AppRoutes.pageToolDrawBoard);

  Future<dynamic> pushPageToolColorPicker() =>
      push<dynamic>(AppRoutes.pageToolColorPicker);

  Future<dynamic> pushPageToolNineGridImage() =>
      push<dynamic>(AppRoutes.pageToolNineGridImage);

  Future<dynamic> pushPageToolViewSource() =>
      push<dynamic>(AppRoutes.pageToolViewSource);
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// PageFavoritesManager arguments holder class
class PageFavoritesManagerArguments {
  final bool isManageMode;
  PageFavoritesManagerArguments({this.isManageMode = false});
}

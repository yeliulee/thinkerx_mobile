// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class AppLocale {
  AppLocale();
  
  static AppLocale current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<AppLocale> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      AppLocale.current = AppLocale();
      
      return AppLocale.current;
    });
  } 

  static AppLocale of(BuildContext context) {
    return Localizations.of<AppLocale>(context, AppLocale);
  }

  /// `关于 ThinkerX`
  String get about {
    return Intl.message(
      '关于 ThinkerX',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `账户管理`
  String get accountManager {
    return Intl.message(
      '账户管理',
      name: 'accountManager',
      desc: '',
      args: [],
    );
  }

  /// `应用列表`
  String get appGallery {
    return Intl.message(
      '应用列表',
      name: 'appGallery',
      desc: '',
      args: [],
    );
  }

  /// `ThinkerX`
  String get appName {
    return Intl.message(
      'ThinkerX',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `是否收藏此应用？`
  String get askAddThisToFavorites {
    return Intl.message(
      '是否收藏此应用？',
      name: 'askAddThisToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `清除缓存`
  String get cacheClear {
    return Intl.message(
      '清除缓存',
      name: 'cacheClear',
      desc: '',
      args: [],
    );
  }

  /// `确认清除缓存？`
  String get cacheClearConfirm {
    return Intl.message(
      '确认清除缓存？',
      name: 'cacheClearConfirm',
      desc: '',
      args: [],
    );
  }

  /// `清除运行时产生的临时数据.`
  String get cacheClearDetail {
    return Intl.message(
      '清除运行时产生的临时数据.',
      name: 'cacheClearDetail',
      desc: '',
      args: [],
    );
  }

  /// `选择语言`
  String get chooseLanguage {
    return Intl.message(
      '选择语言',
      name: 'chooseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `选择主题`
  String get chooseTheme {
    return Intl.message(
      '选择主题',
      name: 'chooseTheme',
      desc: '',
      args: [],
    );
  }

  /// `我的收藏`
  String get favoritesManager {
    return Intl.message(
      '我的收藏',
      name: 'favoritesManager',
      desc: '',
      args: [],
    );
  }

  /// `管理收藏`
  String get favoritesManagerSuper {
    return Intl.message(
      '管理收藏',
      name: 'favoritesManagerSuper',
      desc: '',
      args: [],
    );
  }

  /// `增加收藏`
  String get favoritesTextAdd {
    return Intl.message(
      '增加收藏',
      name: 'favoritesTextAdd',
      desc: '',
      args: [],
    );
  }

  /// `提示: 长按可管理收藏`
  String get favoritesTipLongPress {
    return Intl.message(
      '提示: 长按可管理收藏',
      name: 'favoritesTipLongPress',
      desc: '',
      args: [],
    );
  }

  /// `跟随系统`
  String get followDeviceLocale {
    return Intl.message(
      '跟随系统',
      name: 'followDeviceLocale',
      desc: '',
      args: [],
    );
  }

  /// `帮助和反馈`
  String get helpAndFeedBack {
    return Intl.message(
      '帮助和反馈',
      name: 'helpAndFeedBack',
      desc: '',
      args: [],
    );
  }

  /// `zh_CN`
  String get localeKey {
    return Intl.message(
      'zh_CN',
      name: 'localeKey',
      desc: '',
      args: [],
    );
  }

  /// `多语言`
  String get multipleLang {
    return Intl.message(
      '多语言',
      name: 'multipleLang',
      desc: '',
      args: [],
    );
  }

  /// `账户`
  String get pageHomeTabAccount {
    return Intl.message(
      '账户',
      name: 'pageHomeTabAccount',
      desc: '',
      args: [],
    );
  }

  /// `列表`
  String get pageHomeTabGallery {
    return Intl.message(
      '列表',
      name: 'pageHomeTabGallery',
      desc: '',
      args: [],
    );
  }

  /// `主页`
  String get pageHomeTabHome {
    return Intl.message(
      '主页',
      name: 'pageHomeTabHome',
      desc: '',
      args: [],
    );
  }

  /// `退出应用`
  String get quitApp {
    return Intl.message(
      '退出应用',
      name: 'quitApp',
      desc: '',
      args: [],
    );
  }

  /// `搜索工具...`
  String get searchTools {
    return Intl.message(
      '搜索工具...',
      name: 'searchTools',
      desc: '',
      args: [],
    );
  }

  /// `通用设置`
  String get settingCommon {
    return Intl.message(
      '通用设置',
      name: 'settingCommon',
      desc: '',
      args: [],
    );
  }

  /// `梦之蓝`
  String get themeBlue {
    return Intl.message(
      '梦之蓝',
      name: 'themeBlue',
      desc: '',
      args: [],
    );
  }

  /// `天之蓝`
  String get themeCyan {
    return Intl.message(
      '天之蓝',
      name: 'themeCyan',
      desc: '',
      args: [],
    );
  }

  /// `茵之绿`
  String get themeGreen {
    return Intl.message(
      '茵之绿',
      name: 'themeGreen',
      desc: '',
      args: [],
    );
  }

  /// `主题管理`
  String get themeManager {
    return Intl.message(
      '主题管理',
      name: 'themeManager',
      desc: '',
      args: [],
    );
  }

  /// `选择你喜欢的主题`
  String get themeManagerDetail {
    return Intl.message(
      '选择你喜欢的主题',
      name: 'themeManagerDetail',
      desc: '',
      args: [],
    );
  }

  /// `秋之橙`
  String get themeOrange {
    return Intl.message(
      '秋之橙',
      name: 'themeOrange',
      desc: '',
      args: [],
    );
  }

  /// `花之粉`
  String get themePink {
    return Intl.message(
      '花之粉',
      name: 'themePink',
      desc: '',
      args: [],
    );
  }

  /// `夏之红`
  String get themeRed {
    return Intl.message(
      '夏之红',
      name: 'themeRed',
      desc: '',
      args: [],
    );
  }

  /// `该应用已添加到收藏`
  String get tipAppAddedToFavorites {
    return Intl.message(
      '该应用已添加到收藏',
      name: 'tipAppAddedToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `收藏成功`
  String get tipAppAddToFavoritesSuccessfully {
    return Intl.message(
      '收藏成功',
      name: 'tipAppAddToFavoritesSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `警告`
  String get titleAlert {
    return Intl.message(
      '警告',
      name: 'titleAlert',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get titleCancel {
    return Intl.message(
      '取消',
      name: 'titleCancel',
      desc: '',
      args: [],
    );
  }

  /// `确认`
  String get titleConfirm {
    return Intl.message(
      '确认',
      name: 'titleConfirm',
      desc: '',
      args: [],
    );
  }

  /// `信息`
  String get titleInformation {
    return Intl.message(
      '信息',
      name: 'titleInformation',
      desc: '',
      args: [],
    );
  }

  /// `否`
  String get titleNO {
    return Intl.message(
      '否',
      name: 'titleNO',
      desc: '',
      args: [],
    );
  }

  /// `提示`
  String get titlePrompt {
    return Intl.message(
      '提示',
      name: 'titlePrompt',
      desc: '',
      args: [],
    );
  }

  /// `是`
  String get titleYES {
    return Intl.message(
      '是',
      name: 'titleYES',
      desc: '',
      args: [],
    );
  }

  /// `全部应用`
  String get toolCategoryAll {
    return Intl.message(
      '全部应用',
      name: 'toolCategoryAll',
      desc: '',
      args: [],
    );
  }

  /// `设备应用`
  String get toolCategoryDevice {
    return Intl.message(
      '设备应用',
      name: 'toolCategoryDevice',
      desc: '',
      args: [],
    );
  }

  /// `娱乐应用`
  String get toolCategoryFun {
    return Intl.message(
      '娱乐应用',
      name: 'toolCategoryFun',
      desc: '',
      args: [],
    );
  }

  /// `图片应用`
  String get toolCategoryImage {
    return Intl.message(
      '图片应用',
      name: 'toolCategoryImage',
      desc: '',
      args: [],
    );
  }

  /// `其他应用`
  String get toolCategoryOthers {
    return Intl.message(
      '其他应用',
      name: 'toolCategoryOthers',
      desc: '',
      args: [],
    );
  }

  /// `编程应用`
  String get toolCategoryProgramming {
    return Intl.message(
      '编程应用',
      name: 'toolCategoryProgramming',
      desc: '',
      args: [],
    );
  }

  /// `文本应用`
  String get toolCategoryText {
    return Intl.message(
      '文本应用',
      name: 'toolCategoryText',
      desc: '',
      args: [],
    );
  }

  /// `通用应用`
  String get toolCategoryUniversal {
    return Intl.message(
      '通用应用',
      name: 'toolCategoryUniversal',
      desc: '',
      args: [],
    );
  }

  /// `进制转换器`
  String get toolNameBaseConverter {
    return Intl.message(
      '进制转换器',
      name: 'toolNameBaseConverter',
      desc: '',
      args: [],
    );
  }

  /// `Bilibili 封面获取`
  String get toolNameBilibiliCover {
    return Intl.message(
      'Bilibili 封面获取',
      name: 'toolNameBilibiliCover',
      desc: '',
      args: [],
    );
  }

  /// `BMI 计算器`
  String get toolNameBmiCalculator {
    return Intl.message(
      'BMI 计算器',
      name: 'toolNameBmiCalculator',
      desc: '',
      args: [],
    );
  }

  /// `中文转拼音`
  String get toolNameChineseToPinyin {
    return Intl.message(
      '中文转拼音',
      name: 'toolNameChineseToPinyin',
      desc: '',
      args: [],
    );
  }

  /// `CIDR 计算器`
  String get toolNameCidrCalculator {
    return Intl.message(
      'CIDR 计算器',
      name: 'toolNameCidrCalculator',
      desc: '',
      args: [],
    );
  }

  /// `设备信息`
  String get toolNameDeviceInfo {
    return Intl.message(
      '设备信息',
      name: 'toolNameDeviceInfo',
      desc: '',
      args: [],
    );
  }

  /// `快递查询`
  String get toolNameExpressInquiry {
    return Intl.message(
      '快递查询',
      name: 'toolNameExpressInquiry',
      desc: '',
      args: [],
    );
  }

  /// `垃圾分类查询`
  String get toolNameGarbageSortQuery {
    return Intl.message(
      '垃圾分类查询',
      name: 'toolNameGarbageSortQuery',
      desc: '',
      args: [],
    );
  }

  /// `历史上的今天`
  String get toolNameHistoryToday {
    return Intl.message(
      '历史上的今天',
      name: 'toolNameHistoryToday',
      desc: '',
      args: [],
    );
  }

  /// `图片压缩`
  String get toolNameImageCompressor {
    return Intl.message(
      '图片压缩',
      name: 'toolNameImageCompressor',
      desc: '',
      args: [],
    );
  }

  /// `IP 信息查询`
  String get toolNameIpInformationQuery {
    return Intl.message(
      'IP 信息查询',
      name: 'toolNameIpInformationQuery',
      desc: '',
      args: [],
    );
  }

  /// `营销号文章生成`
  String get toolNameMarketingArticle {
    return Intl.message(
      '营销号文章生成',
      name: 'toolNameMarketingArticle',
      desc: '',
      args: [],
    );
  }

  /// `MD5 摘要`
  String get toolNameMd5Summary {
    return Intl.message(
      'MD5 摘要',
      name: 'toolNameMd5Summary',
      desc: '',
      args: [],
    );
  }

  /// `摩斯电码`
  String get toolNameMorseCode {
    return Intl.message(
      '摩斯电码',
      name: 'toolNameMorseCode',
      desc: '',
      args: [],
    );
  }

  /// `数字转中文`
  String get toolNameNumberToChinese {
    return Intl.message(
      '数字转中文',
      name: 'toolNameNumberToChinese',
      desc: '',
      args: [],
    );
  }

  /// `二维码工具`
  String get toolNameQrCode {
    return Intl.message(
      '二维码工具',
      name: 'toolNameQrCode',
      desc: '',
      args: [],
    );
  }

  /// `亲戚关系计算器`
  String get toolNameRelationshipCalculator {
    return Intl.message(
      '亲戚关系计算器',
      name: 'toolNameRelationshipCalculator',
      desc: '',
      args: [],
    );
  }

  /// `屏幕信息`
  String get toolNameScreenInfo {
    return Intl.message(
      '屏幕信息',
      name: 'toolNameScreenInfo',
      desc: '',
      args: [],
    );
  }

  /// `系统信息`
  String get toolNameSystemInfo {
    return Intl.message(
      '系统信息',
      name: 'toolNameSystemInfo',
      desc: '',
      args: [],
    );
  }

  /// `URL 编码`
  String get toolNameUrlEncoder {
    return Intl.message(
      'URL 编码',
      name: 'toolNameUrlEncoder',
      desc: '',
      args: [],
    );
  }

  /// `视频转 GIF`
  String get toolNameVideoToGif {
    return Intl.message(
      '视频转 GIF',
      name: 'toolNameVideoToGif',
      desc: '',
      args: [],
    );
  }

  /// `以图搜番`
  String get toolNameWhatAnime {
    return Intl.message(
      '以图搜番',
      name: 'toolNameWhatAnime',
      desc: '',
      args: [],
    );
  }

  /// `随机数生成`
  String get toolNameRandomNumber {
    return Intl.message(
      '随机数生成',
      name: 'toolNameRandomNumber',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocale> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocale> load(Locale locale) => AppLocale.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}
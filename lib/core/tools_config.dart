import 'package:flutter/cupertino.dart';
import 'package:thinkerx/constants/tool_category.dart';
import 'package:thinkerx/constants/tool_platform.dart';
import 'package:thinkerx/generated/l10n.dart';
import 'package:thinkerx/router/app_router.gr.dart';

class ToolConfig {
  int id;
  String name;
  ToolCategory category;
  ToolPlatform platform;
  String routeName;
  String keywords;
  String description;

  ToolConfig(
      {this.id, @required this.name, this.category, @required this.platform, this.description, @required this.keywords, @required this.routeName});
}

class AppToolsConfig {
  final List<ToolConfig> tools = [
    ToolConfig(
      id: 98,
      name: AppLocale.current.toolNameBilibiliCover,
      category: ToolCategory.CATE_UNIVERSAL,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolBilibiliCover,
      keywords: "bilibili,b站,封面,cover,获取,Bilibili 封面获取",
    ),
    ToolConfig(
      id: 22,
      name: AppLocale.current.toolNameBaseConverter,
      category: ToolCategory.CATE_PROGRAMMING,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolBaseConverter,
      keywords: "base,converter,binary,进制,转换,进制转换器",
    ),
    ToolConfig(
      id: 44,
      name: AppLocale.current.toolNameBmiCalculator,
      category: ToolCategory.CATE_UNIVERSAL,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolBmiCalculator,
      keywords: "bmi,calculator,计算器,BMI 计算器",
    ),
    ToolConfig(
      id: 75,
      name: AppLocale.current.toolNameChineseToPinyin,
      category: ToolCategory.CATE_TEXT,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolChinesePinyin,
      keywords: "中文,拼音,转换,chinese,pinyin,中文转拼音",
    ),
    ToolConfig(
      id: 4,
      name: AppLocale.current.toolNameCidrCalculator,
      category: ToolCategory.CATE_PROGRAMMING,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolCidrCalculator,
      keywords: "cidr,calculator,计算器,CIDR 计算器",
    ),
    ToolConfig(
      id: 60,
      name: AppLocale.current.toolNameDeviceInfo,
      category: ToolCategory.CATE_DEVICE,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolDeviceInfo,
      keywords: "device,information,设备,信息,设备信息",
    ),
    ToolConfig(
      id: 97,
      name: AppLocale.current.toolNameExpressInquiry,
      category: ToolCategory.CATE_UNIVERSAL,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolExpressInquiry,
      keywords: "express,query,快递,查询,inquiry,物流,快递查询",
    ),
    ToolConfig(
      id: 46,
      name: AppLocale.current.toolNameGarbageSortQuery,
      category: ToolCategory.CATE_UNIVERSAL,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolGarbageSort,
      keywords: "garbage,sort,垃圾,查询,分类,垃圾分类查询",
    ),
    ToolConfig(
      id: 49,
      name: AppLocale.current.toolNameHistoryToday,
      category: ToolCategory.CATE_UNIVERSAL,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolHistoryToday,
      keywords: "历史上的今天,history,today,历史,今天",
    ),
    ToolConfig(
      name: "时间屏幕",
      category: ToolCategory.CATE_UNIVERSAL,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolTimeScreen,
      keywords: "时间屏幕,shijian,sj,time,screen",
    ),
    ToolConfig(
      name: "拾色器",
      category: ToolCategory.CATE_UNIVERSAL,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolColorPicker,
      keywords: "取色器,拾色器,shiseqi,quseqi,sjq,qsq,picker,color",
    ),
    ToolConfig(
      id: 84,
      name: AppLocale.current.toolNameImageCompressor,
      category: ToolCategory.CATE_IMAGE,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolImageCompress,
      keywords: "gif,image,picture,photo,图片,照片,压缩,compress",
    ),
    ToolConfig(
      id: 3,
      name: AppLocale.current.toolNameIpInformationQuery,
      category: ToolCategory.CATE_UNIVERSAL,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolIpQuery,
      keywords: "ip,address,information,query,search,inquiry,查询,信息",
    ),
    ToolConfig(
      id: 113,
      name: AppLocale.current.toolNameMarketingArticle,
      category: ToolCategory.CATE_FUN,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolMarketingArticleGeneration,
      keywords: "营销号,文章,article,marketing",
    ),
    ToolConfig(
      name: "手持弹幕",
      category: ToolCategory.CATE_FUN,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolHandheldDanmaku,
      keywords: "shouchi,sc,danmu,dm,手持弹幕",
    ),
    ToolConfig(
      id: 29,
      name: AppLocale.current.toolNameMd5Summary,
      category: ToolCategory.CATE_PROGRAMMING,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolMd5Summary,
      keywords: "md5,encrypt,summary,加密,解密,md5,摘要",
    ),
    ToolConfig(
      id: 72,
      name: AppLocale.current.toolNameMorseCode,
      category: ToolCategory.CATE_OTHERS,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolMorseCode,
      keywords: "morse,code,莫斯电码,电码,摩斯",
    ),
    ToolConfig(
      id: 73,
      name: AppLocale.current.toolNameNumberToChinese,
      category: ToolCategory.CATE_TEXT,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolNumberChinese,
      keywords: "number,chinese,中文,数字,大写,金额",
    ),
    ToolConfig(
      id: 71,
      name: AppLocale.current.toolNameQrCode,
      category: ToolCategory.CATE_IMAGE,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolQrcode,
      keywords: "qr,qrcode,code,tool,二维码,工具",
    ),
    ToolConfig(
      id: 41,
      name: AppLocale.current.toolNameRelationshipCalculator,
      category: ToolCategory.CATE_UNIVERSAL,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolRelationshipCalculator,
      keywords: "relationship,calculator,relative,计算器,亲戚,关系",
    ),
    ToolConfig(
      name: AppLocale.current.toolNameScreenInfo,
      category: ToolCategory.CATE_DEVICE,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolScreenInfo,
      keywords: "屏幕,信息,screen,information,device,屏幕信息",
    ),
    ToolConfig(
      id: 52,
      name: AppLocale.current.toolNameSystemInfo,
      category: ToolCategory.CATE_DEVICE,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolSystemInfo,
      keywords: "system,系统,information,信息,系统信息",
    ),
    ToolConfig(
      id: 31,
      name: AppLocale.current.toolNameUrlEncoder,
      category: ToolCategory.CATE_PROGRAMMING,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolUrlEncoder,
      keywords: "url,encode,decode,uri,web,网址,编码",
    ),
    ToolConfig(
      name: "网页源码查看",
      category: ToolCategory.CATE_PROGRAMMING,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolViewSource,
      keywords: "source,code,html,网页,源码,wangye",
    ),
    ToolConfig(
      id: 87,
      name: AppLocale.current.toolNameVideoToGif,
      category: ToolCategory.CATE_UNIVERSAL,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolVideoToGif,
      keywords: "video,mp4,gif,视频,转换",
    ),
    ToolConfig(
      id: 104,
      name: AppLocale.current.toolNameWhatAnime,
      category: ToolCategory.CATE_IMAGE,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolWhatAnime,
      keywords: "image,photo,acg,search,query,inquiry,anime,图,图片,以图搜番,番",
    ),
    ToolConfig(
      name: "绘画板",
      category: ToolCategory.CATE_IMAGE,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolDrawBoard,
      keywords: "image,draw,hhb,hui,hua,ban,绘画板,board",
    ),
    ToolConfig(
      name: "九宫格切图",
      category: ToolCategory.CATE_IMAGE,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolNineGridImage,
      keywords: "九宫格切图,切图,九宫格,cropper,crop,jgg",
    ),
    ToolConfig(
      id: 90,
      name: AppLocale.current.toolNameRandomNumber,
      category: ToolCategory.CATE_OTHERS,
      platform: ToolPlatform.COMMON,
      routeName: AppRoutes.pageToolRandomNumber,
      keywords: "random,number,random number,数字,随机,批量,sj,suiji",
    ),
  ];

  List<ToolConfig> getTools({ToolCategory category, ToolPlatform platform}) {
    // 根据平台和分类筛选
    if (category != null && platform != null) {
      return tools.where((tool) => tool.category == category && (tool.platform == ToolPlatform.COMMON || tool.platform == platform)).toList();
    }

    // 根据分类筛选
    if (category != null) {
      return tools.where((tool) => tool.category == category).toList();
    }

    // 根据平台筛选
    if (platform != null) {
      return tools.where((tool) => (tool.platform == platform || tool.platform == ToolPlatform.COMMON)).toList();
    }

    return tools;
  }
}

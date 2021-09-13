import 'dart:convert';

class IpInformationEntity {
  IpInformationEntity({
    this.code,
    this.msg,
    this.data,
    this.author,
  });

  int code;
  String msg;
  Data data;
  Author author;

  factory IpInformationEntity.fromRawJson(String str) => IpInformationEntity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IpInformationEntity.fromJson(Map<String, dynamic> json) => IpInformationEntity(
        code: json["code"] == null ? null : json["code"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
        "author": author == null ? null : author.toJson(),
      };
}

class Author {
  Author({
    this.name,
    this.desc,
  });

  String name;
  String desc;

  factory Author.fromRawJson(String str) => Author.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        name: json["name"] == null ? null : json["name"],
        desc: json["desc"] == null ? null : json["desc"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "desc": desc == null ? null : desc,
      };
}

class Data {
  Data({
    this.beginip,
    this.endip,
    this.pos,
    this.isp,
    this.location,
    this.rectangle,
    this.adInfo,
    this.ip,
  });

  String beginip;
  String endip;
  String pos;
  String isp;
  Location location;
  String rectangle;
  AdInfo adInfo;
  String ip;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        beginip: json["beginip"] == null ? null : json["beginip"],
        endip: json["endip"] == null ? null : json["endip"],
        pos: json["pos"] == null ? null : json["pos"],
        isp: json["isp"] == null ? null : json["isp"],
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        rectangle: json["rectangle"] == null ? null : json["rectangle"],
        adInfo: json["ad_info"] == null ? null : AdInfo.fromJson(json["ad_info"]),
        ip: json["ip"] == null ? null : json["ip"],
      );

  Map<String, dynamic> toJson() => {
        "beginip": beginip == null ? null : beginip,
        "endip": endip == null ? null : endip,
        "pos": pos == null ? null : pos,
        "isp": isp == null ? null : isp,
        "location": location == null ? null : location.toJson(),
        "rectangle": rectangle == null ? null : rectangle,
        "ad_info": adInfo == null ? null : adInfo.toJson(),
        "ip": ip == null ? null : ip,
      };
}

class AdInfo {
  AdInfo({
    this.nation,
    this.province,
    this.city,
    this.district,
    this.adcode,
  });

  String nation;
  String province;
  String city;
  String district;
  int adcode;

  factory AdInfo.fromRawJson(String str) => AdInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdInfo.fromJson(Map<String, dynamic> json) => AdInfo(
        nation: json["nation"] == null ? null : json["nation"],
        province: json["province"] == null ? null : json["province"],
        city: json["city"] == null ? null : json["city"],
        district: json["district"] == null ? null : json["district"],
        adcode: json["adcode"] == null ? null : json["adcode"],
      );

  Map<String, dynamic> toJson() => {
        "nation": nation == null ? null : nation,
        "province": province == null ? null : province,
        "city": city == null ? null : city,
        "district": district == null ? null : district,
        "adcode": adcode == null ? null : adcode,
      };
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  factory Location.fromRawJson(String str) => Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lng: json["lng"] == null ? null : json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
      };
}

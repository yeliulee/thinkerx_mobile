import 'dart:convert';

class HistoryTodayDataEntity {
  HistoryTodayDataEntity({
    this.id,
    this.title,
    this.url,
    this.pic,
    this.year,
    this.month,
    this.day,
    this.des,
    this.hits,
  });

  int id;
  String title;
  String url;
  String pic;
  int year;
  int month;
  int day;
  String des;
  int hits;

  factory HistoryTodayDataEntity.fromRawJson(String str) => HistoryTodayDataEntity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoryTodayDataEntity.fromJson(Map<String, dynamic> json) => HistoryTodayDataEntity(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        url: json["url"] == null ? null : json["url"],
        pic: json["pic"] == null ? null : json["pic"],
        year: json["year"] == null ? null : json["year"],
        month: json["month"] == null ? null : json["month"],
        day: json["day"] == null ? null : json["day"],
        des: json["des"] == null ? null : json["des"],
        hits: json["hits"] == null ? null : json["hits"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "url": url == null ? null : url,
        "pic": pic == null ? null : pic,
        "year": year == null ? null : year,
        "month": month == null ? null : month,
        "day": day == null ? null : day,
        "des": des == null ? null : des,
        "hits": hits == null ? null : hits,
      };
}

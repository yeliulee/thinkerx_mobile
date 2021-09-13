import 'dart:convert';

class AppNewsEntity {
  AppNewsEntity({
    this.title,
    this.summary,
    this.image,
    this.url,
    this.avatar,
    this.author,
    this.type,
  });

  String title;
  String summary;
  String image;
  String url;
  String avatar;
  String author;
  String type;

  factory AppNewsEntity.fromRawJson(String str) => AppNewsEntity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppNewsEntity.fromJson(Map<String, dynamic> json) => AppNewsEntity(
        title: json["title"] == null ? null : json["title"],
        summary: json["summary"] == null ? null : json["summary"],
        image: json["image"] == null ? null : json["image"],
        url: json["url"] == null ? null : json["url"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        author: json["author"] == null ? null : json["author"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "summary": summary == null ? null : summary,
        "image": image == null ? null : image,
        "url": url == null ? null : url,
        "avatar": avatar == null ? null : avatar,
        "author": author == null ? null : author,
        "type": type == null ? null : type,
      };
}

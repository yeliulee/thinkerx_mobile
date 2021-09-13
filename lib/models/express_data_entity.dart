import 'dart:convert';

class ExpressDataEntity {
  ExpressDataEntity({
    this.status,
    this.nu,
    this.com,
    this.state,
    this.success,
    this.info,
  });

  int status;
  String nu;
  String com;
  String state;
  bool success;
  List<ExpressInfo> info;

  factory ExpressDataEntity.fromRawJson(String str) => ExpressDataEntity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExpressDataEntity.fromJson(Map<String, dynamic> json) => ExpressDataEntity(
        status: json["status"] == null ? null : json["status"],
        nu: json["nu"] == null ? null : json["nu"],
        com: json["com"] == null ? null : json["com"],
        state: json["state"] == null ? null : json["state"],
        success: json["success"] == null ? null : json["success"],
        info: json["info"] == null ? null : List<ExpressInfo>.from(json["info"].map((x) => ExpressInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "nu": nu == null ? null : nu,
        "com": com == null ? null : com,
        "state": state == null ? null : state,
        "success": success == null ? null : success,
        "info": info == null ? null : List<dynamic>.from(info.map((x) => x.toJson())),
      };
}

class ExpressInfo {
  ExpressInfo({
    this.time,
    this.content,
  });

  String time;
  String content;

  factory ExpressInfo.fromRawJson(String str) => ExpressInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExpressInfo.fromJson(Map<String, dynamic> json) => ExpressInfo(
        time: json["time"] == null ? null : json["time"],
        content: json["content"] == null ? null : json["content"],
      );

  Map<String, dynamic> toJson() => {
        "time": time == null ? null : time,
        "content": content == null ? null : content,
      };
}

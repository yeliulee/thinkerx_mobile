import 'package:floor/floor.dart';

@Entity(tableName: 'history_record')
class HistoryRecord {
  @primaryKey
  final String path;

  final int time;

  /// [path] 页面路径
  /// [time] 时间戳
  HistoryRecord({this.path, this.time});
}

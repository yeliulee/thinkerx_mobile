import 'package:thinkerx/database/dao/history_dao.dart';
import 'package:thinkerx/database/database.dart';

class DbHelper {
  static AppDatabase _instance;
  static AppDatabase get instance => _instance;

  static Future<void> init() async {
    _instance = await $FloorAppDatabase.databaseBuilder("thinkerx_app_database.db").build();
  }

  static HistoryRecordDao get historyRecordDao => _instance.historyRecordDao;
}

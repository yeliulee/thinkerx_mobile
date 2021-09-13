import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:thinkerx/database/dao/history_dao.dart';
import 'package:thinkerx/database/entity/history.dart';

part 'database.g.dart';

@Database(
  version: 1,
  entities: [
    HistoryRecord,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  HistoryRecordDao get historyRecordDao;
}

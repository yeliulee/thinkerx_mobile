import 'package:floor/floor.dart';
import 'package:thinkerx/database/entity/history.dart';

@dao
abstract class HistoryRecordDao {
  @Query('SELECT * FROM history_record')
  Future<List<HistoryRecord>> readAll();

  @Query("DELETE FROM `history_record` WHERE `path` = :path")
  Future<void> deleteByPath(String path);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> add(HistoryRecord historyRecord);

  @Query('DELETE FROM `history_record`')
  Future<void> deleteAll();
}

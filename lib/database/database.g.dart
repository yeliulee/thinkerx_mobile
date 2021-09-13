// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  HistoryRecordDao _historyRecordDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `history_record` (`path` TEXT, `time` INTEGER, PRIMARY KEY (`path`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  HistoryRecordDao get historyRecordDao {
    return _historyRecordDaoInstance ??=
        _$HistoryRecordDao(database, changeListener);
  }
}

class _$HistoryRecordDao extends HistoryRecordDao {
  _$HistoryRecordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _historyRecordInsertionAdapter = InsertionAdapter(
            database,
            'history_record',
            (HistoryRecord item) =>
                <String, dynamic>{'path': item.path, 'time': item.time});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _history_recordMapper = (Map<String, dynamic> row) =>
      HistoryRecord(path: row['path'] as String, time: row['time'] as int);

  final InsertionAdapter<HistoryRecord> _historyRecordInsertionAdapter;

  @override
  Future<List<HistoryRecord>> readAll() async {
    return _queryAdapter.queryList('SELECT * FROM history_record',
        mapper: _history_recordMapper);
  }

  @override
  Future<void> deleteByPath(String path) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM `history_record` WHERE `path` = ?',
        arguments: <dynamic>[path]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM `history_record`');
  }

  @override
  Future<int> add(HistoryRecord historyRecord) {
    return _historyRecordInsertionAdapter.insertAndReturnId(
        historyRecord, OnConflictStrategy.replace);
  }
}

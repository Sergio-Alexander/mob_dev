// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recorder_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorRecorderDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$RecorderDatabaseBuilder databaseBuilder(String name) =>
      _$RecorderDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$RecorderDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$RecorderDatabaseBuilder(null);
}

class _$RecorderDatabaseBuilder {
  _$RecorderDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$RecorderDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$RecorderDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<RecorderDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$RecorderDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$RecorderDatabase extends RecorderDatabase {
  _$RecorderDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  EmotionRecorderDao? _emotionRecorderDaoInstance;

  WorkoutRecorderDao? _workoutRecorderDaoInstance;

  DietRecorderDao? _dietRecorderDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
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
            'CREATE TABLE IF NOT EXISTS `EmotionRecorder` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `emoji` TEXT NOT NULL, `points` INTEGER NOT NULL, `timestamp` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WorkoutRecorder` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `workout` TEXT NOT NULL, `quantity` INTEGER NOT NULL, `points` INTEGER NOT NULL, `timestamp` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DietRecorder` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `diet` TEXT NOT NULL, `amount` INTEGER NOT NULL, `points` INTEGER NOT NULL, `timestamp` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  EmotionRecorderDao get emotionRecorderDao {
    return _emotionRecorderDaoInstance ??=
        _$EmotionRecorderDao(database, changeListener);
  }

  @override
  WorkoutRecorderDao get workoutRecorderDao {
    return _workoutRecorderDaoInstance ??=
        _$WorkoutRecorderDao(database, changeListener);
  }

  @override
  DietRecorderDao get dietRecorderDao {
    return _dietRecorderDaoInstance ??=
        _$DietRecorderDao(database, changeListener);
  }
}

class _$EmotionRecorderDao extends EmotionRecorderDao {
  _$EmotionRecorderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _emotionRecorderEntityInsertionAdapter = InsertionAdapter(
            database,
            'EmotionRecorder',
            (EmotionRecorderEntity item) => <String, Object?>{
                  'id': item.id,
                  'emoji': item.emoji,
                  'points': item.points,
                  'timestamp': _dateTimeConverter.encode(item.timestamp)
                },
            changeListener),
        _emotionRecorderEntityUpdateAdapter = UpdateAdapter(
            database,
            'EmotionRecorder',
            ['id'],
            (EmotionRecorderEntity item) => <String, Object?>{
                  'id': item.id,
                  'emoji': item.emoji,
                  'points': item.points,
                  'timestamp': _dateTimeConverter.encode(item.timestamp)
                },
            changeListener),
        _emotionRecorderEntityDeletionAdapter = DeletionAdapter(
            database,
            'EmotionRecorder',
            ['id'],
            (EmotionRecorderEntity item) => <String, Object?>{
                  'id': item.id,
                  'emoji': item.emoji,
                  'points': item.points,
                  'timestamp': _dateTimeConverter.encode(item.timestamp)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<EmotionRecorderEntity>
      _emotionRecorderEntityInsertionAdapter;

  final UpdateAdapter<EmotionRecorderEntity>
      _emotionRecorderEntityUpdateAdapter;

  final DeletionAdapter<EmotionRecorderEntity>
      _emotionRecorderEntityDeletionAdapter;

  @override
  Future<List<EmotionRecorderEntity>> findAllEmotionRecorders() async {
    return _queryAdapter.queryList('SELECT * FROM EmotionRecorder',
        mapper: (Map<String, Object?> row) => EmotionRecorderEntity(
            row['id'] as int?,
            row['emoji'] as String,
            row['points'] as int,
            _dateTimeConverter.decode(row['timestamp'] as int)));
  }

  @override
  Stream<EmotionRecorderEntity?> findEmotionRecorderById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM EmotionRecorder WHERE id = ?1',
        mapper: (Map<String, Object?> row) => EmotionRecorderEntity(
            row['id'] as int?,
            row['emoji'] as String,
            row['points'] as int,
            _dateTimeConverter.decode(row['timestamp'] as int)),
        arguments: [id],
        queryableName: 'EmotionRecorder',
        isView: false);
  }

  @override
  Future<EmotionRecorderEntity?> getLastEmotion() async {
    return _queryAdapter.query(
        'SELECT * FROM EmotionRecorder ORDER BY id DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => EmotionRecorderEntity(
            row['id'] as int?,
            row['emoji'] as String,
            row['points'] as int,
            _dateTimeConverter.decode(row['timestamp'] as int)));
  }

  @override
  Future<int?> countEmotions() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM EmotionRecorder',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertEmotionRecorder(EmotionRecorderEntity recorder) {
    return _emotionRecorderEntityInsertionAdapter.insertAndReturnId(
        recorder, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEmotionRecorder(EmotionRecorderEntity recorder) async {
    await _emotionRecorderEntityUpdateAdapter.update(
        recorder, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEmotionRecorder(EmotionRecorderEntity recorder) async {
    await _emotionRecorderEntityDeletionAdapter.delete(recorder);
  }
}

class _$WorkoutRecorderDao extends WorkoutRecorderDao {
  _$WorkoutRecorderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _workoutRecorderEntityInsertionAdapter = InsertionAdapter(
            database,
            'WorkoutRecorder',
            (WorkoutRecorderEntity item) => <String, Object?>{
                  'id': item.id,
                  'workout': item.workout,
                  'quantity': item.quantity,
                  'points': item.points,
                  'timestamp': _dateTimeConverter.encode(item.timestamp)
                },
            changeListener),
        _workoutRecorderEntityUpdateAdapter = UpdateAdapter(
            database,
            'WorkoutRecorder',
            ['id'],
            (WorkoutRecorderEntity item) => <String, Object?>{
                  'id': item.id,
                  'workout': item.workout,
                  'quantity': item.quantity,
                  'points': item.points,
                  'timestamp': _dateTimeConverter.encode(item.timestamp)
                },
            changeListener),
        _workoutRecorderEntityDeletionAdapter = DeletionAdapter(
            database,
            'WorkoutRecorder',
            ['id'],
            (WorkoutRecorderEntity item) => <String, Object?>{
                  'id': item.id,
                  'workout': item.workout,
                  'quantity': item.quantity,
                  'points': item.points,
                  'timestamp': _dateTimeConverter.encode(item.timestamp)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutRecorderEntity>
      _workoutRecorderEntityInsertionAdapter;

  final UpdateAdapter<WorkoutRecorderEntity>
      _workoutRecorderEntityUpdateAdapter;

  final DeletionAdapter<WorkoutRecorderEntity>
      _workoutRecorderEntityDeletionAdapter;

  @override
  Future<List<WorkoutRecorderEntity>> findAllWorkoutRecorders() async {
    return _queryAdapter.queryList('SELECT * FROM WorkoutRecorder',
        mapper: (Map<String, Object?> row) => WorkoutRecorderEntity(
            row['id'] as int?,
            row['workout'] as String,
            row['quantity'] as int,
            row['points'] as int,
            _dateTimeConverter.decode(row['timestamp'] as int)));
  }

  @override
  Stream<WorkoutRecorderEntity?> findWorkoutRecorderById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM WorkoutRecorder WHERE id = ?1',
        mapper: (Map<String, Object?> row) => WorkoutRecorderEntity(
            row['id'] as int?,
            row['workout'] as String,
            row['quantity'] as int,
            row['points'] as int,
            _dateTimeConverter.decode(row['timestamp'] as int)),
        arguments: [id],
        queryableName: 'WorkoutRecorder',
        isView: false);
  }

  @override
  Future<WorkoutRecorderEntity?> getLastWorkout() async {
    return _queryAdapter.query(
        'SELECT * FROM WorkoutRecorder ORDER BY id DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => WorkoutRecorderEntity(
            row['id'] as int?,
            row['workout'] as String,
            row['quantity'] as int,
            row['points'] as int,
            _dateTimeConverter.decode(row['timestamp'] as int)));
  }

  @override
  Future<int?> countWorkouts() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM WorkoutRecorder',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertWorkoutRecorder(WorkoutRecorderEntity recorder) {
    return _workoutRecorderEntityInsertionAdapter.insertAndReturnId(
        recorder, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWorkoutRecorder(WorkoutRecorderEntity recorder) async {
    await _workoutRecorderEntityUpdateAdapter.update(
        recorder, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWorkoutRecorder(WorkoutRecorderEntity recorder) async {
    await _workoutRecorderEntityDeletionAdapter.delete(recorder);
  }
}

class _$DietRecorderDao extends DietRecorderDao {
  _$DietRecorderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _dietRecorderEntityInsertionAdapter = InsertionAdapter(
            database,
            'DietRecorder',
            (DietRecorderEntity item) => <String, Object?>{
                  'id': item.id,
                  'diet': item.diet,
                  'amount': item.amount,
                  'points': item.points,
                  'timestamp': _dateTimeConverter.encode(item.timestamp)
                },
            changeListener),
        _dietRecorderEntityUpdateAdapter = UpdateAdapter(
            database,
            'DietRecorder',
            ['id'],
            (DietRecorderEntity item) => <String, Object?>{
                  'id': item.id,
                  'diet': item.diet,
                  'amount': item.amount,
                  'points': item.points,
                  'timestamp': _dateTimeConverter.encode(item.timestamp)
                },
            changeListener),
        _dietRecorderEntityDeletionAdapter = DeletionAdapter(
            database,
            'DietRecorder',
            ['id'],
            (DietRecorderEntity item) => <String, Object?>{
                  'id': item.id,
                  'diet': item.diet,
                  'amount': item.amount,
                  'points': item.points,
                  'timestamp': _dateTimeConverter.encode(item.timestamp)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DietRecorderEntity>
      _dietRecorderEntityInsertionAdapter;

  final UpdateAdapter<DietRecorderEntity> _dietRecorderEntityUpdateAdapter;

  final DeletionAdapter<DietRecorderEntity> _dietRecorderEntityDeletionAdapter;

  @override
  Future<List<DietRecorderEntity>> findAllDietRecorders() async {
    return _queryAdapter.queryList('SELECT * FROM DietRecorder',
        mapper: (Map<String, Object?> row) => DietRecorderEntity(
            row['id'] as int?,
            row['diet'] as String,
            row['amount'] as int,
            row['points'] as int,
            _dateTimeConverter.decode(row['timestamp'] as int)));
  }

  @override
  Stream<DietRecorderEntity?> findDietRecorderById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM DietRecorder WHERE id = ?1',
        mapper: (Map<String, Object?> row) => DietRecorderEntity(
            row['id'] as int?,
            row['diet'] as String,
            row['amount'] as int,
            row['points'] as int,
            _dateTimeConverter.decode(row['timestamp'] as int)),
        arguments: [id],
        queryableName: 'DietRecorder',
        isView: false);
  }

  @override
  Future<DietRecorderEntity?> getLastDiet() async {
    return _queryAdapter.query(
        'SELECT * FROM DietRecorder ORDER BY id DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => DietRecorderEntity(
            row['id'] as int?,
            row['diet'] as String,
            row['amount'] as int,
            row['points'] as int,
            _dateTimeConverter.decode(row['timestamp'] as int)));
  }

  @override
  Future<int?> countDiets() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM DietRecorder',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertDietRecorder(DietRecorderEntity recorder) {
    return _dietRecorderEntityInsertionAdapter.insertAndReturnId(
        recorder, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateDietRecorder(DietRecorderEntity diet) async {
    await _dietRecorderEntityUpdateAdapter.update(
        diet, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteDietRecorder(DietRecorderEntity recorder) async {
    await _dietRecorderEntityDeletionAdapter.delete(recorder);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();

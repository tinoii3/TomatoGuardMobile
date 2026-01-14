import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tomato_guard_mobile/models/leafRecord.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tomato_guard.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE diseases (
        disease_id INTEGER PRIMARY KEY AUTOINCREMENT,
        disease_name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE leaf_records (
        record_id INTEGER PRIMARY KEY AUTOINCREMENT,
        disease_id INTEGER NOT NULL,
        image_path TEXT NOT NULL,
        is_healthy INTEGER NOT NULL,
        confidence_score REAL NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (disease_id) REFERENCES diseases (disease_id)
      )
    ''');

    await _seedDiseases(db);
  }

  Future<void> _seedDiseases(Database db) async {
    List<String> diseases = [
      'Tomato_Bacterial_spot',
      'Tomato_Early_blight',
      'Tomato_Late_blight',
      'Tomato_Leaf_Mold',
      'Tomato_Septoria_leaf_spot',
      'Tomato_healthy',
    ];

    for (String d in diseases) {
      await db.insert('diseases', {'disease_name': d});
    }
  }

  Future<int> insertRecord(LeafRecord record) async {
    final db = await instance.database;
    return await db.insert('leaf_records', record.toMap());
  }

  Future<List<LeafRecord>> getAllRecords() async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT r.*, d.disease_name
      FROM leaf_records r
      INNER JOIN diseases d ON r.disease_id = d.disease_id
      ORDER BY r.created_at DESC
    ''');

    return result.map((json) => LeafRecord.fromMap(json)).toList();
  }

  Future<Map<String, dynamic>> getStats() async {
    final db = await instance.database;

    final total =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM leaf_records'),
        ) ??
        0;

    final healthy =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM leaf_records WHERE is_healthy = 1',
          ),
        ) ??
        0;

    final diseased = total - healthy;

    String mostCommon = "-";

    final mostCommonResult = await db.rawQuery('''
        SELECT d.disease_name, COUNT(r.record_id) as count
        FROM leaf_records r
        JOIN diseases d ON r.disease_id = d.disease_id
        WHERE r.is_healthy = 0
        GROUP BY d.disease_name
        ORDER BY count DESC
        LIMIT 1
      ''');

    if (mostCommonResult.isNotEmpty) {
      mostCommon = mostCommonResult.first['disease_name'] as String;
      mostCommon = mostCommon.replaceAll('Tomato_', '').replaceAll('_', ' ');
    }

    return {
      'total': total,
      'healthy': healthy,
      'diseased': diseased,
      'mostCommon': mostCommon,
    };
  }

  Future<int?> getDiseaseIdByName(String name) async {
    final db = await instance.database;
    final result = await db.query(
      'diseases',
      columns: ['disease_id'],
      where: 'disease_name = ?',
      whereArgs: [name],
    );

    if (result.isNotEmpty) {
      return result.first['disease_id'] as int;
    }
    return null;
  }

  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete(
      'leaf_records',
      where: 'record_id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllRecords() async {
    final db = await instance.database;
    return await db.delete('leaf_records');
  }

  Future<void> debugCheckDiseases() async {
    final db = await instance.database;
    final result = await db.query('diseases');
    print("--- ข้อมูลในตาราง Diseases ---");
    for (var row in result) {
      print(row);
    }
    print("----------------------------");
  }
}

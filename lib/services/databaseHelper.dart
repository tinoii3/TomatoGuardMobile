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

  // --- CRUD Operations ---

  // บันทึกข้อมูล (Create)
  Future<int> insertRecord(LeafRecord record) async {
    final db = await instance.database;
    return await db.insert('leaf_records', record.toMap());
  }

  // ดึงข้อมูลทั้งหมดพร้อม Join ชื่อโรค (Read)
  Future<List<LeafRecord>> getAllRecords() async {
    final db = await instance.database;

    // SQL Join เพื่อเอา disease_name มาด้วย ตาม Class Diagram
    final result = await db.rawQuery('''
      SELECT r.*, d.disease_name
      FROM leaf_records r
      INNER JOIN diseases d ON r.disease_id = d.disease_id
      ORDER BY r.created_at DESC
    ''');

    return result.map((json) => LeafRecord.fromMap(json)).toList();
  }

  // ดึงสถิติ (Statistics)
  Future<Map<String, dynamic>> getStats() async {
    final db = await instance.database;

    // 1. นับทั้งหมด
    final total =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM leaf_records'),
        ) ??
        0;

    // 2. นับใบสุขภาพดี
    final healthy =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM leaf_records WHERE is_healthy = 1',
          ),
        ) ??
        0;

    final diseased = total - healthy;

    // 3. หาโรคที่พบบ่อยที่สุด (ไม่นับ Healthy)
    String mostCommon = "-";

    // Query: นับจำนวนโรคแต่ละชนิด (ที่ healthy=0) เรียงจากมากไปน้อย แล้วเอาตัวแรกสุด
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
      // ตัดคำว่า "Tomato_" ออกเพื่อให้ชื่อสั้นลง (Optional)
      mostCommon = mostCommon.replaceAll('Tomato_', '').replaceAll('_', ' ');
    }

    return {
      'total': total,
      'healthy': healthy,
      'diseased': diseased,
      'mostCommon': mostCommon,
    };
  }

  // Helper: หา disease_id จากชื่อ (ใช้ตอนบันทึก)
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

  // ใน class DatabaseHelper เพิ่ม method เหล่านี้เข้าไปครับ

  // ลบทีละรายการด้วย ID
  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete(
      'leaf_records',
      where: 'record_id = ?',
      whereArgs: [id],
    );
  }

  // ลบทั้งหมด
  Future<int> deleteAllRecords() async {
    final db = await instance.database;
    return await db.delete('leaf_records');
  }

  // ฟังก์ชันเช็คว่ามีโรคอะไรใน DB บ้าง
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

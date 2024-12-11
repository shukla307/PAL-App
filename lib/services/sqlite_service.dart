import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteService {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await openDatabase(
      join(await getDatabasesPath(), 'akeera.db'),
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            name TEXT,
            phone TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE reports (
            id INTEGER PRIMARY KEY,
            userId INTEGER,
            reportName TEXT,
            filePath TEXT,
            date TEXT,
            FOREIGN KEY(userId) REFERENCES users(id)
          )
        ''');
      },
      version: 1,
    );

    return _db!;
  }

  Future<List<Map<String, dynamic>>> getAllUsersWithReports() async {
    final db = await database;
    return db.query('users');
  }

  Future<List<Map<String, dynamic>>> getUserReports(int userId) async {
    final db = await database;
    return db.query('reports', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> deleteReport(int reportId) async {
    final db = await database;
    await db.delete('reports', where: 'id = ?', whereArgs: [reportId]);
  }
}

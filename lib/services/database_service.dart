import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  // Table Names
  final String _uomeTableName = "uome";
  final String _iouTableName = "iou";

  // UOMe Column Names
  final String _uomeIdColumnName = "id";
  final String _uomeNameColumnName = "Name";
  final String _uomeContactNumColumnName = "Contact_Number";
  final String _uomeEmailColumnName = "Email";
  final String _uomeDescriptionColumnName = "Description";
  final String _uomeAmountColumnName = "Amount";
  final String _uomeStartDateColumnName = "Start_Date";
  final String _uomeEndDateColumnName = "End_Date";
  final String _uomeNotesColumnName = "Notes";
  final String _uomePaidColumnName = "Paid";

  // IOU Column Names
  final String _iouIdColumnName = "id";
  final String _iouNameColumnName = "Name";
  final String _iouContactNumColumnName = "Contact_Number";
  final String _iouEmailColumnName = "Email";
  final String _iouDescriptionColumnName = "Description";
  final String _iouAmountColumnName = "Amount";
  final String _iouStartDateColumnName = "Start_Date";
  final String _iouEndDateColumnName = "End_Date";
  final String _iouNotesColumnName = "Notes";
  final String _iouPaidColumnName = "Paid";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final databaseDirpath = await getDatabasesPath();
    final databasePath = join(databaseDirpath, "debts_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_uomeTableName (
          $_uomeIdColumnName INTEGER PRIMARY KEY,
          $_uomeNameColumnName TEXT NOT NULL,
          $_uomeContactNumColumnName TEXT NOT NULL,
          $_uomeEmailColumnName TEXT NOT NULL,
          $_uomeDescriptionColumnName TEXT NOT NULL,
          $_uomeAmountColumnName REAL NOT NULL,
          $_uomeStartDateColumnName TEXT NOT NULL,
          $_uomeEndDateColumnName TEXT,
          $_uomeNotesColumnName TEXT,
          $_uomePaidColumnName INTEGER
        )
        ''');
        db.execute('''
        CREATE TABLE $_iouTableName (
          $_iouIdColumnName INTEGER PRIMARY KEY,
          $_iouNameColumnName TEXT NOT NULL,
          $_iouContactNumColumnName TEXT NOT NULL,
          $_iouEmailColumnName TEXT NOT NULL,
          $_iouDescriptionColumnName TEXT NOT NULL,
          $_iouAmountColumnName REAL NOT NULL,
          $_iouStartDateColumnName TEXT NOT NULL,
          $_iouEndDateColumnName TEXT,
          $_iouNotesColumnName TEXT,
          $_iouPaidColumnName INTEGER
        )
        ''');
      },
    );
    return database;
  }

  Future<void> addUOMe(Map<String, dynamic> uomeData) async {
    final db = await database;
    try {
      await db.insert(_uomeTableName, uomeData);
    } catch (e) {
      // Handle error
      print("Error adding UOMe: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getUOMe() async {
    final db = await database;
    return await db.query(_uomeTableName);
  }

  Future<void> updateUOMe(int id, Map<String, dynamic> uomeData) async {
    final db = await database;
    try {
      await db.update(
        _uomeTableName,
        uomeData,
        where: '$_uomeIdColumnName = ?',
        whereArgs: [id],
      );
    } catch (e) {
      // Handle error
      print("Error updating UOMe: $e");
    }
  }

  Future<void> deleteUOMe(int id) async {
    final db = await database;
    try {
      await db.delete(
        _uomeTableName,
        where: '$_uomeIdColumnName = ?',
        whereArgs: [id],
      );
    } catch (e) {
      // Handle error
      print("Error deleting UOMe: $e");
    }
  }

  Future<void> addIOU(Map<String, dynamic> iouData) async {
    final db = await database;
    try {
      await db.insert(_iouTableName, iouData);
    } catch (e) {
      // Handle error
      print("Error adding IOU: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getIOU() async {
    final db = await database;
    return await db.query(_iouTableName);
  }

  Future<void> updateIOU(int id, Map<String, dynamic> iouData) async {
    final db = await database;
    try {
      await db.update(
        _iouTableName,
        iouData,
        where: '$_iouIdColumnName = ?',
        whereArgs: [id],
      );
    } catch (e) {
      // Handle error
      print("Error updating IOU: $e");
    }
  }

  Future<void> deleteIOU(int id) async {
    final db = await database;
    try {
      await db.delete(
        _iouTableName,
        where: '$_iouIdColumnName = ?',
        whereArgs: [id],
      );
    } catch (e) {
      // Handle error
      print("Error deleting IOU: $e");
    }
  }

  // Helper methods to handle boolean values for the Paid column
  int boolToInt(bool value) => value ? 1 : 0;

  bool intToBool(int value) => value == 1;
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database? _db;
  static const _dbName = 'summa_db';

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    final exists = await databaseExists(path);

    _db = await openDatabase(
      path,
      version: 4,
      onCreate: exists ? null : _onCreate,
    );

    return _db!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE shopping_lists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        plannedAt TEXT,
        isActive INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE shopping_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        listId INTEGER NOT NULL,
        name TEXT NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT NOT NULL,
        unitPrice INTEGER,
        isDone INTEGER NOT NULL,
        FOREIGN KEY (listId) REFERENCES shopping_lists(id) ON DELETE CASCADE
      )
    ''');
  }
}

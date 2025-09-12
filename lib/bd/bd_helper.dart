import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BdHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _dbName = 'moneyo.db';

  static Future<Database> get database async {
    if (_db != null) return _db!;

    // Inicializar la base de datos
    _db = await initDB();
    return _db!;
  }
  
  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Tabla de Tarjetas
    await db.execute('''
      CREATE TABLE tarjetas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        numero TEXT,
        fechaVencimiento TEXT,
        saldo REAL,
        esCredito INTEGER,
        color INTEGER,
        fechaCorte TEXT,
        fechaLimite TEXT
      )
    ''');

    // Tabla de Cuentas
    await db.execute('''
      CREATE TABLE cuentas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        saldo REAL,
        tipo TEXT,
        color INTEGER
      )
    ''');
  }
}
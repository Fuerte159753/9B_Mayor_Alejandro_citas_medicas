import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_login/models/usuario.dart';
import 'package:app_login/models/citas.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'usuarios.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        apellidoPaterno TEXT NOT NULL,
        usuario TEXT NOT NULL,
        contrasena TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertUsuario(Usuario usuario) async {
    Database db = await database;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<Usuario?> getUsuario(String usuario, String contrasena) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'usuario = ? AND contrasena = ?',
      whereArgs: [usuario, contrasena],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future<void> createCitaTable(Database db) async {
    await db.execute('''
      CREATE TABLE citas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT NOT NULL,
        razon TEXT NOT NULL,
        idUsuario INTEGER NOT NULL,
        estado TEXT NOT NULL,
        FOREIGN KEY(idUsuario) REFERENCES usuarios(id)
      )
    ''');
  }

  Future<void> insertCita(Cita cita) async {
    Database db = await database;
    await db.insert('citas', cita.toMap());
  }

  Future<List<Cita>> getCitasByUsuario(int idUsuario) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'citas',
      where: 'idUsuario = ?',
      whereArgs: [idUsuario],
    );
    return List.generate(maps.length, (i) {
      return Cita.fromMap(maps[i]);
    });
  }

  Future<void> deleteCita(int id) async {
    Database db = await database;
    await db.delete(
      'citas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateCita(Cita cita) async {
    Database db = await database;
    await db.update(
      'citas',
      cita.toMap(),
      where: 'id = ?',
      whereArgs: [cita.id],
    );
  }
}

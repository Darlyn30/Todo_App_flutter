// Servicio para manejar la base de datos local (SQLite) usando sqflite.
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DbService {
  // Patron singleton: una sola instancia de este servicio en toda la app
  static final DbService _instace = DbService._internal();
  factory DbService() => _instace;
  DbService._internal();

  // Referencia a la base de datos abierta (puede ser null si no se ha inicializado)
  Database? _database;

  // Getter que devuelve la BD. Si no existe, la crea/abre primero
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb();
    return _database!;
  }

  // Crea/abre la BD y define la estructura de tablas
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    // Nombre del archivo de la BD.
    // Nota: La extension '.dn' podria ser un typo, normalmente se usa '.db'
    final path = join(dbPath, 'todo_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, completed INTEGER)',
        );
      },
    );
  }

  // Inserta una nueva tarea y devuelve el id generado
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  // Obtiene todas las tareas guardadas en la tabla
  Future<List<Task>> getTasks() async {
    final db = await database;
    final maps = await db.query('tasks');
    return maps.map((e) => Task.fromMap(e)).toList();
  }

  // Actualiza una tarea existente por su id
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Elimina una tarea segun su id
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}

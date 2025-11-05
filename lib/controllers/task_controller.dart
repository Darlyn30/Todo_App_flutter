// Controlador que conecta la UI con el servicio de base de datos
import '../models/task.dart';
import '../services/db_service.dart';

class TaskController {
  // Usamos el servicio de BD (singleton)
  final DbService _db = DbService();

  // Devuelve la lista de tareas
  Future<List<Task>> getTasks() => _db.getTasks();

  // Agrega una nueva tarea
  Future<void> addTask(Task task) async {
    await _db.insertTask(task);
  }

  // Actualiza una tarea existente
  Future<void> updateTask(Task task) async {
    await _db.updateTask(task);
  }

  // Elimina una tarea por id
  Future<void> deleteTask(int id) async {
    await _db.deleteTask(id);
  }
}

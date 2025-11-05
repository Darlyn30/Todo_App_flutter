// Modelo de datos para una tarea en la app
class Task {
  // Identificador en la base de datos (puede ser null si aun no se guarda)
  int? id;
  // Titulo corto de la tarea
  String title;
  // Descripcion o detalles de la tarea
  String description;
  // Estado de completado (true si ya se hizo)
  bool completed;

  // Constructor de la tarea. Por defecto 'completed' es false
  Task({
    this.id,
    required this.title,
    required this.description,
    this.completed = false,
  });

  // Convierte el objeto a un mapa para guardarlo en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      // En la BD guardamos 1 para true y 0 para false
      'completed': completed ? 1 : 0,
    };
  }

  // Crea una tarea a partir de un mapa obtenido de SQLite
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      completed: map['completed'] == 1,
    );
  }
}

// Widget que representa una fila de tarea con acciones (completar/eliminar)
import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  // Tarea a mostrar
  final Task task;
  // Accion para marcar como completada o no
  final VoidCallback onToggle;
  // Accion para eliminar la tarea
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Boton izquierdo para alternar el estado de la tarea
      leading: IconButton(
        icon: Icon(
          task.completed ? Icons.check_circle : Icons.circle_outlined,
          color: task.completed ? Colors.green : null,
        ),
        onPressed: onToggle,
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(task.description),
      // Boton para eliminar la tarea
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}

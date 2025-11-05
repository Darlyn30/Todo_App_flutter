// Pantalla principal: lista de tareas y ajustes simples (tema/idioma)
import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../services/preferences_service.dart';
import '../widgets/task_item.dart';

class HomePage extends StatefulWidget {
  // Servicio para leer/guardar preferencias
  final PreferencesService pereferencesService;
  // Callback para avisar al widget raiz que cambien tema/idioma
  final VoidCallback onPreferencesChanged;

  const HomePage({
    super.key,
    required this.pereferencesService,
    required this.onPreferencesChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controlador para operaciones con tareas
  final TaskController _controller = TaskController();
  // Lista de tareas que mostraremos
  List<Task> _tasks = [];

  // Controladores para los campos del dialogo de nueva tarea
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  // Estados locales de preferencias (para los switches/menus)
  bool _isDarkMode = false;
  String _language = 'es';

  @override
  void initState() {
    super.initState();
    _loadingData();
  }

  // Carga tareas de la BD y preferencias actuales
  Future<void> _loadingData() async {
    final tasks = await _controller.getTasks();
    setState(() {
      _tasks = tasks;
      _isDarkMode = widget.pereferencesService.isDarkMode;
      _language = widget.pereferencesService.languageCode;
    });
  }

  // Crea una nueva tarea con los textos ingresados
  Future<void> _addTask() async {
    if (_titleController.text.isEmpty) return;

    final task = Task(
      title: _titleController.text,
      description: _descController.text,
    );

    await _controller.addTask(task);
    _titleController.clear();
    _descController.clear();
    _loadingData();
  }

  // Cambia el estado de completado de una tarea
  Future<void> _toggleComplete(Task task) async {
    task.completed = !task.completed;
    await _controller.updateTask(task);
    _loadingData();
  }

  // Elimina una tarea seleccionada
  Future<void> _deleteTask(Task task) async {
    await _controller.deleteTask(task.id!);
    _loadingData();
  }

  // Guarda los valores locales en SharedPreferences y avisa al padre
  Future<void> _savePreferences() async {
    await widget.pereferencesService.setDarkMode(_isDarkMode);
    await widget.pereferencesService.setLanguage(_language);
    widget.onPreferencesChanged();
  }

  // Muestra un dialogo para ingresar una nueva tarea
  void _showAddTaskDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva tarea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titulo'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Descripcion'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _addTask();
              Navigator.pop(context);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de tareas')),
      body: Column(
        children: [
          // Switch para activar/desactivar tema oscuro
          SwitchListTile(
            title: const Text('Modo oscuro'),
            value: _isDarkMode,
            onChanged: (v) => setState(() {
              _isDarkMode = v;
            }),
          ),
          // Selector de idioma (solo cambia el codigo guardado)
          DropdownButton(
            value: _language,
            items: const [
              DropdownMenuItem(value: 'es', child: Text('Espanol')),
              DropdownMenuItem(value: 'en', child: Text('Ingles')),
              DropdownMenuItem(value: 'fr', child: Text('Frances')),
            ],
            onChanged: (v) => setState(() {
              _language = v!;
            }),
          ),
          // Guarda y aplica las preferencias
          ElevatedButton(
            onPressed: _savePreferences,
            child: const Text('Guardar preferencias'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, i) => TaskItem(
                task: _tasks[i],
                onToggle: () => _toggleComplete(_tasks[i]),
                onDelete: () => _deleteTask(_tasks[i]),
              ),
            ),
          ),
        ],
      ),
      // Boton flotante para crear una nueva tarea
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

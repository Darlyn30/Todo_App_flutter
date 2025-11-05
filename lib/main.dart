// Archivo principal de la app. Aqui se configura el tema (claro/oscuro)
// y el idioma usando las preferencias guardadas.
import 'package:flutter/material.dart';
import 'package:todo_app/services/preferences_service.dart';
import 'package:todo_app/views/home_page.dart';

// Punto de entrada de Flutter. Hacemos async para poder inicializar SharedPreferences
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos las preferencias guardadas en SharedPreferences
  final prefs = PreferencesService();
  await prefs.init();
  // Pasamos las preferencias al widget raiz de la app
  runApp(TodoApp(preferencesService: prefs));
}

// Widget raiz con estado para poder reaccionar a cambios de tema/idioma
class TodoApp extends StatefulWidget {
  final PreferencesService preferencesService;

  const TodoApp({super.key, required this.preferencesService});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  // Modo de tema actual (claro u oscuro)
  late ThemeMode _themeMode;
  // Idioma actual de la app
  late Locale _locale;

  @override
  void initState() {
    super.initState();

    //cargar preferencias guardadas, tanto tema e idioma
    _themeMode = widget.preferencesService.isDarkMode
        ? ThemeMode.dark
        : ThemeMode.light;

    _locale = Locale(widget.preferencesService.languageCode);
  }

  //esto se llama si cambian las preferencias desde el homePage
  void _updatePreferences() {
    setState(() {
      _themeMode = widget.preferencesService.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light;

      _locale = Locale(widget.preferencesService.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // Este valor decide si se usa el tema claro u oscuro
      themeMode: _themeMode,
      locale: _locale,
      // Oculta la cinta de 'DEBUG' en la app
      debugShowCheckedModeBanner: false,
      home: HomePage(
        pereferencesService: widget.preferencesService,
        onPreferencesChanged: _updatePreferences,
      ),
    );
  }
}

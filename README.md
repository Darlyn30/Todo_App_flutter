## Todo App (Flutter)

Aplicación simple de tareas (To‑Do) hecha con Flutter. Permite crear, listar, completar y eliminar tareas de forma local usando SQLite. También guarda preferencias básicas (modo oscuro e idioma) en el dispositivo.

### Características
- **CRUD de tareas**: crear, leer, actualizar (completar) y eliminar
- **Almacenamiento local**: `sqflite` para persistencia en SQLite
- **Preferencias**: `shared_preferences` para modo oscuro e idioma
- **UI sencilla**: lista con acciones y diálogo para nueva tarea

## Arquitectura del proyecto

El código principal vive en `lib/` y se organiza por responsabilidades:

- **`lib/models/`**
  - `task.dart`: modelo de datos de una tarea, con conversión a/desde mapas para SQLite.

- **`lib/services/`**
  - `db_service.dart`: servicio de base de datos (pattern singleton) con métodos CRUD usando `sqflite`.
  - `preferences_service.dart`: servicio para leer/escribir modo oscuro e idioma con `shared_preferences`.

- **`lib/controllers/`**
  - `task_controller.dart`: capa intermedia entre UI y servicios; expone operaciones de tareas para la vista.

- **`lib/views/`**
  - `home_page.dart`: pantalla principal. Lista las tareas, permite crear nuevas, completar/eliminar, y cambiar preferencias.

- **`lib/widgets/`**
  - `task_item.dart`: item reutilizable para mostrar una tarea con acciones (completar/eliminar).

- **`lib/main.dart`**
  - Punto de entrada. Inicializa preferencias, configura `MaterialApp` con `ThemeMode` y `Locale`, y muestra `HomePage`.

## Requisitos
- Flutter (canal estable). Verifica con:
```bash
flutter --version
```
- Android SDK / Xcode según plataforma de destino
- Dispositivo/emulador configurado

## Instalación y ejecución
1. Instalar dependencias:
```bash
flutter pub get
```
2. Ejecutar en un dispositivo/emulador:
```bash
flutter run
```
3. Construir APK (Android):
```bash
flutter build apk --release
```

## Base de datos y preferencias

- **SQLite**
  - Archivo de BD: se crea en el directorio de bases de datos del sistema con nombre `todo_app.db`
  - Esquema:
    - Tabla `tasks`
      - `id INTEGER PRIMARY KEY AUTOINCREMENT`
      - `title TEXT`
      - `description TEXT`
      - `completed INTEGER` (1 = true, 0 = false)

- **Shared Preferences**
  - Claves usadas:
    - `isDarkMode`: `bool`
    - `languageCode`: `String` (`es` por defecto)

## Flujo principal de la app
1. `main.dart` inicializa `PreferencesService` y configura `MaterialApp`.
2. `HomePage` carga tareas desde `TaskController` y las muestra en una `ListView`.
3. El diálogo de “Nueva tarea” crea una `Task` y la inserta vía `TaskController` → `DbService`.
4. Completar/Eliminar actualiza/borra en SQLite y recarga la lista.
5. Cambiar modo oscuro/idioma guarda en `SharedPreferences` y actualiza el `ThemeMode`/`Locale`.

## Estructura de archivos (resumen)
```
lib/
  controllers/
    task_controller.dart
  models/
    task.dart
  services/
    db_service.dart
    preferences_service.dart
  views/
    home_page.dart
  widgets/
    task_item.dart
  main.dart
```

## Internacionalización y tema
- El selector de idioma guarda solo el código (`es`, `en`, `fr`) en preferencias. No se cargan traducciones aún; es base para futura i18n.
- El modo oscuro altera el `ThemeMode` global entre `light` y `dark`.

## Problemas comunes
- “No se encuentra un dispositivo”: abre un emulador o conecta un dispositivo con depuración USB.
- Error con dependencias: corre `flutter pub get` y `flutter clean && flutter pub get` si persiste.

## Siguientes pasos (roadmap)
- Migrar nombre de archivo de BD a `todo_app.db` y manejar migración.
- Añadir edición de tareas y validaciones de formulario.
- Implementar internacionalización real con `flutter_localizations` y ARB.
- Filtros de tareas (todas, completadas, pendientes).
- Tests unitarios e instrumentados para servicios y controlador.

## Licencia
Este proyecto se distribuye bajo la licencia MIT. Consulta el archivo LICENSE si se incluye, o ajusta según tus necesidades.

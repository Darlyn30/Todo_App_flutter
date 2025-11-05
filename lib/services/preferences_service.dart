// Servicio para leer/guardar preferencias simples en el dispositivo
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  // Claves para guardar los valores en SharedPreferences
  static const _themeKey = 'isDarkMode';
  static const _langKey = 'languageCode';

  // Instancia de SharedPreferences una vez inicializada
  late SharedPreferences _prefs;

  // Lee si el modo oscuro esta activado; por defecto false
  bool get isDarkMode => _prefs.getBool(_themeKey) ?? false;
  // Lee el codigo de idioma; por defecto 'es' (espanol)
  String get languageCode => _prefs.getString(_langKey) ?? 'es';

  // Debe llamarse antes de usar los getters/setters
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Guarda el modo oscuro (true/false)
  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_themeKey, value);
  }

  // Guarda el idioma (por ejemplo: 'es', 'en', 'fr')
  Future<void> setLanguage(String code) async {
    await _prefs.setString(_langKey, code);
  }
}

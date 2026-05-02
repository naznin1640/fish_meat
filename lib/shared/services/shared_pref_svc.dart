import 'package:shared_preferences/shared_preferences.dart';

/// Keys used for saving app settings and preferences.
class SharedPrefKeys {
  static const isDarkMode = 'is_dark_mode';
  static const accentColor = 'accent_color';
  static const isLoggedIn = 'is_logged_in';
  static const fcm = 'fcm';
  static const token = 'token';
  static const roles = 'roles';
  static const id = 'id';
  static const userName = 'user_name';
}

/// A singleton wrapper around [SharedPreferences]
/// for simplified and type-safe storage operations.
class SharedPrefSvc {
  // Private constructor
  SharedPrefSvc._internal();

  // The single instance (singleton)
  static final SharedPrefSvc _instance = SharedPrefSvc._internal();

  // Public getter to access the instance
  static SharedPrefSvc get instance => _instance;

  SharedPreferences? _prefs;

  /// Initializes the shared preferences instance.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Retrieves a stored value of type [T].
  T getValue<T>(String key, T defaultValue) {
    switch (defaultValue) {
      case String():
        return (_prefs?.getString(key) ?? defaultValue) as T;
      case int():
        return (_prefs?.getInt(key) ?? defaultValue) as T;
      case bool():
        return (_prefs?.getBool(key) ?? defaultValue) as T;
      case double():
        return (_prefs?.getDouble(key) ?? defaultValue) as T;
      case List<String>():
        return (_prefs?.getStringList(key) ?? defaultValue) as T;
    }
    return defaultValue;
  }

  /// Saves a value of type [T] into SharedPreferences.
  Future<bool?> setValue<T>(String key, T value) async {
    switch (value) {
      case String():
        return await _prefs?.setString(key, value);
      case int():
        return await _prefs?.setInt(key, value);
      case bool():
        return await _prefs?.setBool(key, value);
      case double():
        return await _prefs?.setDouble(key, value);
      case List<String>():
        return await _prefs?.setStringList(key, value);
    }
    return false;
  }

  /// Removes a stored value by [key].
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  /// Clears all stored preferences.
  Future<void> clear() async {
    await _prefs?.clear();
  }
}

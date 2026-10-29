// Secure Storage wrapper for KrakenDraw
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

/// Secure storage keys
class SecureStorageKeys {
  static const String userToken = 'user_token';
  static const String userData = 'user_data';
  static const String themeMode = 'theme_mode';
  static const String lastSync = 'last_sync';
  static const String appSettings = 'app_settings';
}

/// Secure storage wrapper with Flutter Secure Storage
class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      // encryptedSharedPreferences removed in v11+
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    lOptions: LinuxOptions(),
    mOptions: MacOsOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    wOptions: WindowsOptions(),
  );

  /// Documents directory for cookie storage
  static String get documentsDirectory {
    // This will be initialized in init()
    return _documentsDirectory;
  }

  static String _documentsDirectory = '';

  /// Initialize secure storage and get documents directory
  static Future<void> init() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _documentsDirectory = directory.path;
    } catch (_) {
      _documentsDirectory = '';
    }
  }

  /// Write value
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read value
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete value
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Check if key exists
  static Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// Read all values
  static Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  /// Delete all values
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Clear auth-related data
  static Future<void> clearAuthData() async {
    await Future.wait([
      delete(SecureStorageKeys.userToken),
      delete(SecureStorageKeys.userData),
    ]);
  }

  /// Save user token
  static Future<void> saveUserToken(String token) async {
    await write(SecureStorageKeys.userToken, token);
  }

  /// Get user token
  static Future<String?> getUserToken() async {
    return await read(SecureStorageKeys.userToken);
  }

  /// Save user data (JSON string)
  static Future<void> saveUserData(String userDataJson) async {
    await write(SecureStorageKeys.userData, userDataJson);
  }

  /// Get user data (JSON string)
  static Future<String?> getUserData() async {
    return await read(SecureStorageKeys.userData);
  }

  /// Save theme mode
  static Future<void> saveThemeMode(int themeModeIndex) async {
    await write(SecureStorageKeys.themeMode, themeModeIndex.toString());
  }

  /// Get theme mode
  static Future<int?> getThemeMode() async {
    final value = await read(SecureStorageKeys.themeMode);
    return value != null ? int.tryParse(value) : null;
  }

  /// Save last sync timestamp
  static Future<void> saveLastSync(DateTime dateTime) async {
    await write(SecureStorageKeys.lastSync, dateTime.toIso8601String());
  }

  /// Get last sync timestamp
  static Future<DateTime?> getLastSync() async {
    final value = await read(SecureStorageKeys.lastSync);
    if (value != null) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  /// Save app settings (JSON string)
  static Future<void> saveAppSettings(String settingsJson) async {
    await write(SecureStorageKeys.appSettings, settingsJson);
  }

  /// Get app settings (JSON string)
  static Future<String?> getAppSettings() async {
    return await read(SecureStorageKeys.appSettings);
  }
}
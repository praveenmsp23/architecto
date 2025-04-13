import 'dart:convert';
import 'package:get_storage/get_storage.dart';

/// Simple storage service for local data persistence
class StorageService {
  final GetStorage _storage;
  
  /// Default constructor with main storage box
  StorageService() : _storage = GetStorage();
  
  /// Named constructor for custom storage boxes
  StorageService.box(String boxName) : _storage = GetStorage(boxName);
  
  /// Initialize storage service
  static Future<void> init() async {
    await GetStorage.init();
  }
  
  /// Write data to storage
  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }
  
  /// Read data from storage with type safety
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }
  
  /// Read all data from storage
  Map<String, dynamic> readAll() {
    return _storage.getValues();
  }
  
  /// Check if key exists in storage
  bool hasKey(String key) {
    return _storage.hasData(key);
  }
  
  /// Remove data by key
  Future<void> remove(String key) async {
    await _storage.remove(key);
  }
  
  /// Clear all data in storage
  Future<void> clear() async {
    await _storage.erase();
  }
  
  /// Store object as JSON
  Future<void> writeObject(String key, Map<String, dynamic> data) async {
    await write(key, jsonEncode(data));
  }
  
  /// Read object from JSON
  Map<String, dynamic>? readObject(String key) {
    final data = read<String>(key);
    if (data == null) return null;
    
    try {
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
  
  /// Store list of objects as JSON
  Future<void> writeObjectList(String key, List<Map<String, dynamic>> dataList) async {
    await write(key, jsonEncode(dataList));
  }
  
  /// Read list of objects from JSON
  List<Map<String, dynamic>>? readObjectList(String key) {
    final data = read<String>(key);
    if (data == null) return null;
    
    try {
      final List<dynamic> decoded = jsonDecode(data);
      return List<Map<String, dynamic>>.from(decoded);
    } catch (_) {
      return null;
    }
  }
  
  /// Listen for changes to a key
  void listen(String key, Function(dynamic) callback) {
    _storage.listen(() {
      if (_storage.hasData(key)) {
        callback(_storage.read(key));
      }
    });
  }
}
import 'dart:convert';

import 'package:library_management/constants/constants.dart';
import 'package:library_management/model/user.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  SharedPreferences? _prefs;

  /// Gọi init trong main trước khi runApp
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Lưu string
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Lấy string
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Lưu bool
  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  /// Lấy bool
  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  /// Lưu int
  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  /// Lấy int
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// Xóa theo key
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  /// Clear tất cả
  Future<void> clear() async {
    await _prefs?.clear();
  }

  /// Lưu User vào SharedPreferences
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson()); // convert sang String
    await prefs.setString(Constants.userKey, jsonString);
  }

  /// Lấy User từ SharedPreferences
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(Constants.userKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> json = jsonDecode(jsonString);
    if (json['_id'] != null && json['_id'] is String) {
      json['_id'] = ObjectId.fromHexString(json['_id']);
    }
    
    return User.fromJson(json);
  }

  /// Xoá User khi logout
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.userKey);
  }
}

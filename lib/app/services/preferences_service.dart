// ignore_for_file: avoid_debugPrint

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static SharedPreferences? _prefs;

  /// Deve ser chamado antes de usar qualquer método de leitura/escrita
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Error initializing SharedPreferences: $e');
      // On web, sometimes SharedPreferences can fail to initialize
      _prefs = null;
    }
  }

  static Future<void> saveInt(String key, int value) async {
    try {
      await _prefs?.setInt(key, value);
    } catch (e) {
      debugPrint('Error saving int to preferences: $e');
    }
  }

  static int? getInt(String key) {
    try {
      return _prefs?.getInt(key);
    } catch (e) {
      debugPrint('Error getting int from preferences: $e');
      return null;
    }
  }

  static Future<void> saveString(String key, String value) async {
    try {
      await _prefs?.setString(key, value);
    } catch (e) {
      debugPrint('Error saving string to preferences: $e');
    }
  }

  static String? getString(String key) {
    try {
      return _prefs?.getString(key);
    } catch (e) {
      debugPrint('Error getting string from preferences: $e');
      return null;
    }
  }

  static Future<void> remove(String key) async {
    try {
      await _prefs?.remove(key);
    } catch (e) {
      debugPrint('Error removing from preferences: $e');
    }
  }

  static const _rollHistoryKey = 'roll_history';
  static const _diceListKey = 'dice_list';

  static Future<void> addRollHistory(int total, int possible) async {
    try {
      final list = _prefs?.getStringList(_rollHistoryKey) ?? <String>[];
      final now = DateTime.now();
      final hh = now.hour.toString().padLeft(2, '0');
      final mm = now.minute.toString().padLeft(2, '0');
      final ss = now.second.toString().padLeft(2, '0');
      // final ms = now.millisecond.toString().padLeft(3, '0');
      final record = '$hh:$mm:$ss:  $total  /  $possible';

      list.add(record);

      // Manter apenas as últimas 50 jogadas
      if (list.length > 50) {
        list.removeAt(0); // Remove a primeira (mais antiga)
      }

      await _prefs?.setStringList(_rollHistoryKey, list);
    } catch (e) {
      debugPrint('Error adding roll history: $e');
    }
  }

  static List<String> getRollHistory() {
    try {
      return _prefs?.getStringList(_rollHistoryKey) ?? <String>[];
    } catch (e) {
      debugPrint('Error getting roll history: $e');
      return <String>[];
    }
  }

  static Future<void> saveDiceList(List<Map<String, int>> diceList) async {
    try {
      final List<String> stringList =
          diceList.map((dice) => '${dice['id']},${dice['sides']}').toList();
      await _prefs?.setStringList(_diceListKey, stringList);
    } catch (e) {
      debugPrint('Error saving dice list: $e');
    }
  }

  static List<Map<String, int>> getDiceList() {
    try {
      final List<String> stringList = _prefs?.getStringList(_diceListKey) ?? [];
      return stringList.map((diceString) {
        final parts = diceString.split(',');
        return {'id': int.parse(parts[0]), 'sides': int.parse(parts[1])};
      }).toList();
    } catch (e) {
      debugPrint('Error getting dice list: $e');
      return <Map<String, int>>[];
    }
  }
}

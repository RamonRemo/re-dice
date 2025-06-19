import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static SharedPreferences? _prefs;

  /// Deve ser chamado antes de usar qualquer método de leitura/escrita
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  static const _rollHistoryKey = 'roll_history';
  static const _diceListKey = 'dice_list';

  static Future<void> addRollHistory(int total, int possible) async {
    final list = _prefs?.getStringList(_rollHistoryKey) ?? <String>[];
    final now = DateTime.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    final ss = now.second.toString().padLeft(2, '0');
    final ms = now.millisecond.toString().padLeft(3, '0');
    final record = '$hh:$mm:$ss:  $total  /  $possible';

    list.add(record);

    // Manter apenas as últimas 50 jogadas
    if (list.length > 50) {
      list.removeAt(0); // Remove a primeira (mais antiga)
    }

    await _prefs?.setStringList(_rollHistoryKey, list);
  }

  static List<String> getRollHistory() {
    return _prefs?.getStringList(_rollHistoryKey) ?? <String>[];
  }

  static Future<void> saveDiceList(List<Map<String, int>> diceList) async {
    final List<String> stringList =
        diceList.map((dice) => '${dice['id']},${dice['sides']}').toList();
    await _prefs?.setStringList(_diceListKey, stringList);
  }

  static List<Map<String, int>> getDiceList() {
    final List<String> stringList = _prefs?.getStringList(_diceListKey) ?? [];
    return stringList.map((diceString) {
      final parts = diceString.split(',');
      return {'id': int.parse(parts[0]), 'sides': int.parse(parts[1])};
    }).toList();
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  final String _autoShowKey = 'autoShow';
  final Future<SharedPreferences> _sPref = SharedPreferences.getInstance();

  Future<bool> getFloatingStatus() async {
    final SharedPreferences sPref = await _sPref;
    return sPref.getBool(_autoShowKey) ?? true;
  }

  void saveFloatingStatus(bool value) async {
    final SharedPreferences sPref = await _sPref;
    await sPref.setBool(_autoShowKey, value);
  }
}

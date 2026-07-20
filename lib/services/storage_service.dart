import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("last_city", city);
  }

  Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("last_city");
  }
}
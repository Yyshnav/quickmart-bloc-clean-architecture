import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString('AUTH_TOKEN');
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString('AUTH_TOKEN', token);
  }
}

import 'package:http/http.dart' as http;
import 'package:news_pbp/entity/user.dart';

class LoginRepository {
  static http.Client client = http.Client();

  static Future<User?> login({
    required String username,
    required String password,
    required http.Client client,
  }) async {
    String apiUrl = 'http://10.0.2.2:8000/api/login';
    try {
      var apiResult = await client.post(
        Uri.parse(apiUrl),
        body: {'username': username, 'password': password},
      );
      if (apiResult.statusCode == 200) {
        return User.fromRawJson(apiResult.body);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      return null;
    }
  }

  static Future<User?> loginTesting({
    required String username,
    required String password,
  }) async {
    String apiUrl = 'http://127.0.0.1:8000/api/login';
    try {
      var apiResult = await http.post(
        Uri.parse(apiUrl),
        body: {'username': username, 'password': password},
      );
      if (apiResult.statusCode == 200) {
        final result = User.fromRawJson(apiResult.body);
        return result;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      return null;
    }
  }
}

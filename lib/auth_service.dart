import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Đổi thành địa chỉ IP LAN của máy bạn nếu test trên điện thoại thật (VD: http://192.168.1.X:5000/api)
  // 10.0.2.2 là localhost của máy tính khi dùng Android Emulator
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await saveToken(data['token']);
          if (data['user'] != null && data['user']['fullName'] != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_name', data['user']['fullName']);
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static Future<bool> register(String fullName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'fullName': fullName, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await saveToken(data['token']);
          if (data['user'] != null && data['user']['fullName'] != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_name', data['user']['fullName']);
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
  
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_name');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

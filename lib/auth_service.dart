import 'models/app_user.dart';
import 'services/api_client.dart';
import 'services/api_exception.dart';
import 'services/auth_storage.dart';

class AuthService {
  static Future<AppUser> login(String email, String password) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      throw const ApiException('Vui lòng nhập đầy đủ email và mật khẩu.');
    }

    final response = await ApiClient.post(
      '/auth/login',
      body: {
        'email': trimmedEmail,
        'password': trimmedPassword,
      },
    );

    return _handleAuthResponse(
      response,
      fallbackMessage: 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.',
    );
  }

  static Future<AppUser> register(
    String fullName,
    String email,
    String password,
  ) async {
    final trimmedName = fullName.trim();
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    if (trimmedName.isEmpty ||
        trimmedEmail.isEmpty ||
        trimmedPassword.isEmpty) {
      throw const ApiException('Vui lòng nhập đầy đủ họ tên, email và mật khẩu.');
    }

    final response = await ApiClient.post(
      '/auth/register',
      body: {
        'fullName': trimmedName,
        'email': trimmedEmail,
        'password': trimmedPassword,
      },
    );

    return _handleAuthResponse(
      response,
      fallbackMessage: 'Đăng ký thất bại. Email có thể đã tồn tại.',
    );
  }

  static Future<AppUser> getProfile() async {
    final response = await ApiClient.get('/auth/me', requiresAuth: true);
    if (response['success'] != true) {
      throw ApiException(
        (response['message'] ?? 'Không thể lấy thông tin tài khoản.').toString(),
      );
    }

    final rawUser = response['user'];
    if (rawUser is! Map) {
      throw const ApiException(
        'Server không trả về thông tin người dùng hợp lệ.',
      );
    }

    final user = AppUser.fromJson(Map<String, dynamic>.from(rawUser));
    await AuthStorage.saveUserName(user.fullName);
    return user;
  }

  static Future<void> saveToken(String token) async {
    await AuthStorage.saveToken(token);
  }

  static Future<String?> getToken() async {
    return AuthStorage.getToken();
  }

  static Future<String?> getUserName() async {
    return AuthStorage.getUserName();
  }

  static Future<void> logout() async {
    await AuthStorage.clearSession();
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<AppUser> _handleAuthResponse(
    Map<String, dynamic> response, {
    required String fallbackMessage,
  }) async {
    if (response['success'] != true) {
      throw ApiException((response['message'] ?? fallbackMessage).toString());
    }

    final token = response['token']?.toString();
    if (token == null || token.isEmpty) {
      throw const ApiException('Server không trả về token đăng nhập hợp lệ.');
    }

    final rawUser = response['user'];
    if (rawUser is! Map) {
      throw const ApiException('Server không trả về thông tin người dùng hợp lệ.');
    }

    final user = AppUser.fromJson(Map<String, dynamic>.from(rawUser));
    await AuthStorage.saveSession(token: token, userName: user.fullName);
    return user;
  }
}

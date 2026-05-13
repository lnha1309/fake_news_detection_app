import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exception.dart';
import 'auth_storage.dart';

class ApiClient {
  ApiClient._();

  static final http.Client _httpClient = http.Client();
  static const Duration _timeout = Duration(minutes: 5);

  static Future<Map<String, dynamic>> get(
    String path, {
    bool requiresAuth = false,
  }) async {
    return _send(
      () async => _httpClient.get(
        _buildUri(path),
        headers: await _buildHeaders(requiresAuth: requiresAuth),
      ),
    );
  }

  static Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    return _send(
      () async => _httpClient.post(
        _buildUri(path),
        headers: await _buildHeaders(requiresAuth: requiresAuth),
        body: jsonEncode(body ?? const <String, dynamic>{}),
      ),
    );
  }

  static Future<Map<String, dynamic>> delete(
    String path, {
    bool requiresAuth = false,
  }) async {
    return _send(
      () async => _httpClient.delete(
        _buildUri(path),
        headers: await _buildHeaders(requiresAuth: requiresAuth),
      ),
    );
  }

  static Uri _buildUri(String path) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('${ApiConfig.baseUrl}/$normalizedPath');
  }

  static Future<Map<String, String>> _buildHeaders({
    required bool requiresAuth,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final token = await AuthStorage.getToken();
      if (token == null || token.isEmpty) {
        throw const ApiException('Bạn cần đăng nhập để tiếp tục.');
      }
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request().timeout(_timeout);
      return _parseResponse(response);
    } on TimeoutException {
      throw const ApiException(
        'Hết thời gian kết nối tới backend production. Hãy kiểm tra mạng hoặc DOMAIN_BACKEND.',
      );
    } on SocketException {
      throw const ApiException(
        'Không thể kết nối tới backend production. Hãy kiểm tra mạng hoặc DOMAIN_BACKEND.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Không thể gửi request tới backend. Hãy kiểm tra DOMAIN_BACKEND.',
      );
    }
  }

  static Map<String, dynamic> _parseResponse(http.Response response) {
    if (_looksLikeHtml(response)) {
      throw const ApiException(
        'API URL hiện đang trả về trang HTML thay vì JSON. DOMAIN_BACKEND đang trỏ vào frontend hoặc backend production chưa deploy route /api.',
      );
    }

    final payload = _decodeBody(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return payload;
    }

    if (response.statusCode == 401) {
      unawaited(AuthStorage.clearSession());
      throw const ApiException(
        'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
        statusCode: 401,
      );
    }

    throw ApiException(
      _extractMessage(payload) ?? _defaultMessage(response.statusCode),
      statusCode: response.statusCode,
    );
  }

  static Map<String, dynamic> _decodeBody(String body) {
    if (body.trim().isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return <String, dynamic>{'data': decoded};
    } on FormatException {
      return <String, dynamic>{'message': body};
    }
  }

  static bool _looksLikeHtml(http.Response response) {
    final contentType = response.headers['content-type']?.toLowerCase() ?? '';
    final trimmedBody = response.body.trimLeft().toLowerCase();

    return contentType.contains('text/html') ||
        trimmedBody.startsWith('<!doctype html') ||
        trimmedBody.startsWith('<html');
  }

  static String? _extractMessage(Map<String, dynamic> payload) {
    final message = payload['message'] ?? payload['error'];
    if (message == null) return null;
    return message.toString();
  }

  static String _defaultMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Dữ liệu gửi lên không hợp lệ.';
      case 404:
        return 'Không tìm thấy endpoint backend. Hãy kiểm tra DOMAIN_BACKEND.';
      case 500:
        return 'Backend đang lỗi 500. Vui lòng thử lại sau.';
      default:
        return 'Request thất bại với mã lỗi $statusCode.';
    }
  }
}

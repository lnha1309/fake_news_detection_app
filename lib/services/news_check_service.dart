import '../models/prediction_result.dart';
import 'api_client.dart';
import 'api_exception.dart';

class NewsCheckService {
  static Future<PredictionResult> predict(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) {
      throw const ApiException('Vui lòng nhập nội dung cần kiểm tra.');
    }

    final response = await ApiClient.post(
      '/news-checks',
      body: {'text': trimmedText},
      requiresAuth: true,
    );

    if (response['success'] != true) {
      throw ApiException(
        (response['message'] ?? 'Không thể phân tích nội dung.').toString(),
      );
    }

    return PredictionResult.fromJson(response);
  }
}

import 'api_client.dart';
import 'api_exception.dart';

class FeedbackService {
  static Future<void> submitFeedback(
    String checkId,
    String actualLabel,
    String comment,
  ) async {
    if (checkId.trim().isEmpty) {
      throw const ApiException('Không tìm thấy mã kiểm tra để gửi phản hồi.');
    }

    final response = await ApiClient.post(
      '/feedbacks',
      body: {
        'checkId': checkId,
        'actualLabel': actualLabel,
        'comment': comment,
      },
      requiresAuth: true,
    );

    if (response['success'] != true) {
      throw ApiException(
        (response['message'] ?? 'Gửi phản hồi thất bại.').toString(),
      );
    }
  }
}

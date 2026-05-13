import '../models/history_item.dart';
import 'api_client.dart';
import 'api_exception.dart';

class HistoryService {
  static Future<List<HistoryItem>> getHistory() async {
    final response = await ApiClient.get(
      '/news-checks/history',
      requiresAuth: true,
    );

    if (response['success'] != true) {
      throw ApiException(
        (response['message'] ?? 'Không thể tải lịch sử kiểm tra.').toString(),
      );
    }

    final data = response['data'];
    if (data is! List) return const <HistoryItem>[];

    return data
        .map(
          (item) => HistoryItem.fromJson(
            item is Map<String, dynamic>
                ? item
                : Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  static Future<void> deleteHistory(String id) async {
    if (id.trim().isEmpty) {
      throw const ApiException('Không tìm thấy mã lịch sử để xóa.');
    }

    final response = await ApiClient.delete(
      '/news-checks/$id',
      requiresAuth: true,
    );

    if (response['success'] != true) {
      throw ApiException(
        (response['message'] ?? 'Xóa lịch sử thất bại.').toString(),
      );
    }
  }
}

import 'models/history_item.dart';
import 'models/prediction_result.dart';
import 'services/feedback_service.dart';
import 'services/history_service.dart';
import 'services/news_check_service.dart';

export 'models/history_item.dart';
export 'models/prediction_result.dart';
export 'services/feedback_service.dart';
export 'services/history_service.dart';
export 'services/news_check_service.dart';

class ApiService {
  static Future<PredictionResult> predict(String text) {
    return NewsCheckService.predict(text);
  }

  static Future<List<HistoryItem>> getHistory() {
    return HistoryService.getHistory();
  }

  static Future<void> deleteHistory(String id) {
    return HistoryService.deleteHistory(id);
  }

  static Future<void> submitFeedback(
    String checkId,
    String actualLabel,
    String comment,
  ) {
    return FeedbackService.submitFeedback(checkId, actualLabel, comment);
  }
}

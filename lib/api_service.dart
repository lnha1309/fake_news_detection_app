import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class PredictionResult {
  final String label;
  final double confidence;
  final double probFake;
  final double probReal;
  final String explanation;
  final String qwenReasoning;
  final String qwenBranch;
  final bool overriddenByQwen;
  final String studentLabel;
  final List<String> topPhrases;
  final List<String> topTokens;
  final double emojiDensity;
  final double flipRatio;
  final double layerDivergence;
  final double semanticAnomaly;
  final double ensembleStd;
  final bool isTriggered;

  PredictionResult({
    required this.label,
    required this.confidence,
    required this.probFake,
    required this.probReal,
    required this.explanation,
    required this.qwenReasoning,
    required this.qwenBranch,
    required this.overriddenByQwen,
    required this.studentLabel,
    required this.topPhrases,
    required this.topTokens,
    required this.emojiDensity,
    required this.flipRatio,
    required this.layerDivergence,
    required this.semanticAnomaly,
    required this.ensembleStd,
    required this.isTriggered,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final studentReasoning = data['student_reasoning'] as Map<String, dynamic>? ?? {};
    return PredictionResult(
      label: data['label'] ?? 'UNKNOWN',
      confidence: (data['confidence'] ?? 0).toDouble(),
      probFake: (data['prob_fake'] ?? 0).toDouble(),
      probReal: (data['prob_real'] ?? 0).toDouble(),
      explanation: data['explanation'] ?? '',
      qwenReasoning: data['qwen_reasoning'] ?? '',
      qwenBranch: data['qwen_branch'] ?? '',
      overriddenByQwen: data['overridden_by_qwen'] ?? false,
      studentLabel: data['student_label'] ?? '',
      topPhrases: List<String>.from(studentReasoning['top_phrases'] ?? []),
      topTokens: List<String>.from(studentReasoning['top_tokens'] ?? []),
      emojiDensity: (data['emoji_density'] ?? 0).toDouble(),
      flipRatio: (data['flip_ratio'] ?? 0).toDouble(),
      layerDivergence: (data['layer_divergence'] ?? 0).toDouble(),
      semanticAnomaly: (data['semantic_anomaly'] ?? 0).toDouble(),
      ensembleStd: (data['ensemble_std'] ?? 0).toDouble(),
      isTriggered: data['is_triggered'] ?? false,
    );
  }

  bool get isFake => label == 'FAKE';
}

class HistoryItem {
  final int id;
  final String text;
  final String label;
  final double confidence;
  final String explanation;
  final String createdAt;

  HistoryItem({
    required this.id,
    required this.text,
    required this.label,
    required this.confidence,
    required this.explanation,
    required this.createdAt,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      text: json['text'] ?? '',
      label: json['predictLabel'] ?? 'UNKNOWN',
      confidence: double.tryParse(json['confidenceScore'].toString()) ?? 0.0,
      explanation: json['explanation'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  bool get isFake => label == 'FAKE';
}

class ApiService {
  static Future<PredictionResult> predict(String text) async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse('${AuthService.baseUrl}/checks'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success'] == true) {
        return PredictionResult.fromJson(json);
      } else {
        throw Exception('API trả về lỗi');
      }
    } else {
      throw Exception('Lỗi kết nối: ${response.statusCode}');
    }
  }

  static Future<List<HistoryItem>> getHistory() async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse('${AuthService.baseUrl}/checks/history'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success'] == true) {
        final List data = json['data'] ?? [];
        return data.map((e) => HistoryItem.fromJson(e)).toList();
      }
    }
    return [];
  }

  static Future<bool> deleteHistory(int id) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final response = await http.delete(
      Uri.parse('${AuthService.baseUrl}/checks/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['success'] == true;
    }
    return false;
  }

  static Future<bool> submitFeedback(int checkId, String actualLabel, String comment) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final response = await http.post(
      Uri.parse('${AuthService.baseUrl}/feedbacks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'checkId': checkId,
        'actualLabel': actualLabel,
        'comment': comment,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['success'] == true;
    }
    return false;
  }
}

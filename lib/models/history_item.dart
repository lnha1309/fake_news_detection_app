double _historyToDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

double _historyToPercentage(dynamic value) {
  final parsed = _historyToDouble(value);
  return parsed <= 1 ? parsed * 100 : parsed;
}

class HistoryItem {
  const HistoryItem({
    required this.id,
    required this.text,
    required this.label,
    required this.confidence,
    required this.explanation,
    required this.createdAt,
  });

  final String id;
  final String text;
  final String label;
  final double confidence;
  final String explanation;
  final String createdAt;

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      label: (json['predictLabel'] ?? json['label'] ?? 'UNKNOWN').toString(),
      confidence: _historyToPercentage(
        json['confidenceScore'] ?? json['confidence'] ?? 0,
      ),
      explanation: json['explanation']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  bool get isFake => label.toUpperCase() == 'FAKE';
}

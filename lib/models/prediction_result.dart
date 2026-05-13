double _predictionToDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

double _predictionToRatio(dynamic value) {
  final parsed = _predictionToDouble(value);
  final ratio = parsed > 1 ? parsed / 100 : parsed;
  return ratio.clamp(0.0, 1.0);
}

bool _predictionToBool(dynamic value) {
  if (value is bool) return value;
  return value?.toString().toLowerCase() == 'true';
}

class PredictionResult {
  const PredictionResult({
    required this.id,
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

  final String id;
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

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final data = rawData is Map<String, dynamic>
        ? rawData
        : rawData is Map
            ? Map<String, dynamic>.from(rawData)
            : <String, dynamic>{};
    final rawReasoning = data['student_reasoning'];
    final studentReasoning = rawReasoning is Map<String, dynamic>
        ? rawReasoning
        : rawReasoning is Map
            ? Map<String, dynamic>.from(rawReasoning)
            : <String, dynamic>{};

    return PredictionResult(
      id: data['id']?.toString() ?? '',
      label: (data['label'] ??
              data['predictLabel'] ??
              data['predict_label'] ??
              data['result'] ??
              'UNKNOWN')
          .toString(),
      confidence: _predictionToRatio(
        data['confidence'] ?? data['confidenceScore'] ?? data['confidence_score'],
      ),
      probFake: _predictionToRatio(data['prob_fake']),
      probReal: _predictionToRatio(data['prob_real']),
      explanation: (data['explanation'] ?? '').toString(),
      qwenReasoning: (data['qwen_reasoning'] ?? '').toString(),
      qwenBranch: (data['qwen_branch'] ?? '').toString(),
      overriddenByQwen: _predictionToBool(data['overridden_by_qwen']),
      studentLabel: (data['student_label'] ?? '').toString(),
      topPhrases: List<String>.from(studentReasoning['top_phrases'] ?? const []),
      topTokens: List<String>.from(studentReasoning['top_tokens'] ?? const []),
      emojiDensity: _predictionToDouble(data['emoji_density']),
      flipRatio: _predictionToDouble(data['flip_ratio']),
      layerDivergence: _predictionToDouble(data['layer_divergence']),
      semanticAnomaly: _predictionToDouble(data['semantic_anomaly']),
      ensembleStd: _predictionToDouble(data['ensemble_std']),
      isTriggered: _predictionToBool(data['is_triggered']),
    );
  }

  bool get isFake => label.toUpperCase() == 'FAKE';
}

import 'package:flutter/material.dart';
import 'api_service.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> with TickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _isLoading = false;
  PredictionResult? _result;
  String? _error;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() { _isLoading = true; _error = null; _result = null; });
    try {
      final result = await ApiService.predict(text);
      setState(() { _result = result; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Kiểm tra tin tức', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.edit_note_rounded, color: Color(0xFF2563EB), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text('Nhập nội dung cần kiểm tra', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Dán hoặc nhập nội dung tin tức tại đây...',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _analyze,
                      icon: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.search_rounded),
                      label: Text(_isLoading ? 'Đang phân tích...' : 'Phân tích ngay'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E40AF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Loading animation
            if (_isLoading)
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Opacity(
                    opacity: 0.5 + _pulseController.value * 0.5,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: const Column(
                        children: [
                          Icon(Icons.psychology_rounded, size: 48, color: Color(0xFF2563EB)),
                          SizedBox(height: 16),
                          Text('AI đang phân tích nội dung...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                          SizedBox(height: 8),
                          Text('Vui lòng chờ trong giây lát', style: TextStyle(color: Color(0xFF9CA3AF))),
                        ],
                      ),
                    ),
                  );
                },
              ),

            // Error
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFCA5A5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFDC2626)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_error!, style: const TextStyle(color: Color(0xFFDC2626)))),
                  ],
                ),
              ),

            // Result
            if (_result != null) _buildResult(_result!),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(PredictionResult r) {
    final isFake = r.isFake;
    final mainColor = isFake ? const Color(0xFFDC2626) : const Color(0xFF16A34A);
    final bgColor = isFake ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4);
    final iconBg = isFake ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7);
    final pct = (r.confidence * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Verdict card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: mainColor.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(
                  isFake ? Icons.warning_amber_rounded : Icons.verified_rounded,
                  color: mainColor, size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isFake ? 'TIN GIẢ' : 'TIN THẬT',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: mainColor),
              ),
              const SizedBox(height: 8),
              Text('Độ tin cậy: $pct%', style: TextStyle(fontSize: 16, color: mainColor.withOpacity(0.8), fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              // Confidence bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: r.confidence,
                  minHeight: 10,
                  backgroundColor: mainColor.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation(mainColor),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('FAKE: ${(r.probFake * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 12, color: const Color(0xFFDC2626).withOpacity(0.7), fontWeight: FontWeight.w600)),
                  Text('REAL: ${(r.probReal * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 12, color: const Color(0xFF16A34A).withOpacity(0.7), fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Explanation
        _infoCard(
          icon: Icons.lightbulb_outline_rounded,
          title: 'Giải thích',
          child: Text(r.explanation, style: const TextStyle(fontSize: 14, color: Color(0xFF374151), height: 1.6)),
        ),
        const SizedBox(height: 12),

        // Qwen reasoning
        if (r.qwenReasoning.isNotEmpty)
          _infoCard(
            icon: Icons.psychology_alt_rounded,
            title: 'Phân tích Qwen (${r.qwenBranch})',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.qwenReasoning, style: const TextStyle(fontSize: 14, color: Color(0xFF374151), height: 1.6)),
                if (r.overriddenByQwen) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)),
                    child: const Text('⚡ Qwen đã ghi đè kết quả', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF92400E))),
                  ),
                ],
              ],
            ),
          ),
        if (r.qwenReasoning.isNotEmpty) const SizedBox(height: 12),

        // Key phrases & tokens
        _infoCard(
          icon: Icons.text_snippet_outlined,
          title: 'Từ khóa phát hiện',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (r.topPhrases.isNotEmpty) ...[
                const Text('Cụm từ quan trọng:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: r.topPhrases.map((p) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFBFDBFE))),
                    child: Text(p, style: const TextStyle(fontSize: 13, color: Color(0xFF1E40AF), fontWeight: FontWeight.w500)),
                  )).toList(),
                ),
                const SizedBox(height: 12),
              ],
              if (r.topTokens.isNotEmpty) ...[
                const Text('Tokens:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: r.topTokens.map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(6)),
                    child: Text(t, style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563))),
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Metrics
        _infoCard(
          icon: Icons.analytics_outlined,
          title: 'Chỉ số kỹ thuật',
          child: Column(
            children: [
              _metricRow('Emoji density', r.emojiDensity.toStringAsFixed(4)),
              _metricRow('Flip ratio', r.flipRatio.toStringAsFixed(4)),
              _metricRow('Layer divergence', r.layerDivergence.toStringAsFixed(4)),
              _metricRow('Semantic anomaly', r.semanticAnomaly.toStringAsFixed(4)),
              _metricRow('Ensemble STD', r.ensembleStd.toStringAsFixed(4)),
              _metricRow('Student label', r.studentLabel),
              _metricRow('Triggered', r.isTriggered ? 'Có' : 'Không'),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _infoCard({required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: const Color(0xFF2563EB), size: 20),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
          ]),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
        ],
      ),
    );
  }
}

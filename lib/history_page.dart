import 'package:flutter/material.dart';
import 'api_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _isLoading = true;
  List<HistoryItem> _history = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final data = await ApiService.getHistory();
      setState(() {
        _history = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Lỗi tải lịch sử: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteItem(int id) async {
    final success = await ApiService.deleteHistory(id);
    if (success) {
      setState(() {
        _history.removeWhere((item) => item.id == id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa thành công')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xóa thất bại')));
      }
    }
  }

  void _showFeedbackDialog(int checkId) {
    String actualLabel = 'REAL';
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Gửi phản hồi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kết quả thực tế theo bạn là:'),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('TIN THẬT'),
                    selected: actualLabel == 'REAL',
                    onSelected: (val) => setDialogState(() => actualLabel = 'REAL'),
                    selectedColor: const Color(0xFF16A34A).withOpacity(0.2),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('TIN GIẢ'),
                    selected: actualLabel == 'FAKE',
                    onSelected: (val) => setDialogState(() => actualLabel = 'FAKE'),
                    selectedColor: const Color(0xFFDC2626).withOpacity(0.2),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Nhận xét của bạn (không bắt buộc)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () async {
                final success = await ApiService.submitFeedback(checkId, actualLabel, commentController.text);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(success ? 'Cảm ơn phản hồi của bạn!' : 'Gửi phản hồi thất bại')),
                  );
                }
              },
              child: const Text('Gửi ngay'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final date = DateTime.parse(isoString).toLocal();
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Lịch sử kiểm tra', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadHistory, child: const Text('Thử lại')),
          ],
        ),
      );
    }

    if (_history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.history, size: 64, color: Colors.black26),
            SizedBox(height: 16),
            Text('Chưa có lịch sử kiểm tra nào', style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[index];
        final isFake = item.isFake;
        final color = isFake ? const Color(0xFFDC2626) : const Color(0xFF16A34A);
        final bgColor = isFake ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4);
        
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          child: ExpansionTile(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    isFake ? 'TIN GIẢ' : 'TIN THẬT',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Độ tin cậy: ${item.confidence}%',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                item.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black87),
              ),
            ),
            childrenPadding: const EdgeInsets.all(16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: 8),
              const Text('Nội dung chi tiết:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
              const SizedBox(height: 4),
              Text(item.text, style: const TextStyle(color: Colors.black87, height: 1.5)),
              const SizedBox(height: 16),
              const Text('Giải thích AI:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item.explanation, style: const TextStyle(height: 1.5)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ngày: ${_formatDate(item.createdAt)}', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => _showFeedbackDialog(item.id),
                        icon: const Icon(Icons.feedback_outlined, size: 16, color: Color(0xFF1E3A8A)),
                        label: const Text('Phản hồi', style: TextStyle(color: Color(0xFF1E3A8A), fontSize: 13)),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Xác nhận xóa'),
                              content: const Text('Bạn có chắc muốn xóa lịch sử này không?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    _deleteItem(item.id);
                                  },
                                  child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                        label: const Text('Xóa', style: TextStyle(color: Colors.red, fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

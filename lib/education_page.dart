import 'package:flutter/material.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Cách nhận biết tin giả', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Trang bị kiến thức để bảo vệ bản thân khỏi thông tin sai lệch',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4B5563),
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildAccordion(
              title: 'Dấu hiệu nhận biết tin giả',
              content: [
                '1. Tiêu đề giật gân: Tiêu đề quá cảm tính, sử dụng chữ in hoa quá mức, hoặc có nhiều dấu chấm than.',
                '2. Thiếu nguồn tin: Không có tác giả rõ ràng, không trích dẫn nguồn, hoặc nguồn không đáng tin cậy.',
                '3. Ngôn ngữ cảm tính: Sử dụng ngôn từ kích động, thiên vị, hoặc gây chia rẽ.',
                '4. Hình ảnh chỉnh sửa: Hình ảnh bị cắt ghép, chỉnh sửa, hoặc sử dụng sai ngữ cảnh.',
                '5. Thông tin lỗi thời: Tin tức cũ được đăng lại như tin mới.'
              ],
            ),
            const SizedBox(height: 16),
            
            _buildAccordion(
              title: 'Kỹ thuật xác minh thông tin',
              content: [
                '1. Kiểm tra nguồn gốc: Tìm hiểu về trang web, tác giả, và lịch sử xuất bản của họ.',
                '2. Tìm kiếm chéo: Tìm kiếm cùng thông tin trên nhiều nguồn tin uy tín khác nhau.',
                '3. Kiểm tra ngày tháng: Xác nhận thời gian xuất bản và đảm bảo thông tin còn hiện hành.',
                '4. Tìm kiếm hình ảnh ngược: Sử dụng Google Images hoặc TinEye để kiểm tra nguồn gốc hình ảnh.',
                '5. Đọc toàn bộ bài viết: Không chỉ đọc tiêu đề, hãy đọc kỹ nội dung để hiểu đầy đủ.'
              ],
            ),
            const SizedBox(height: 16),
            
            _buildAccordion(
              title: 'Ví dụ thực tế',
              content: [
                'Ví dụ 1 - Tiêu đề giật gân: "CHẤN ĐỘNG!!! Phát hiện bí mật kinh hoàng!!!" - Đây là dấu hiệu rõ ràng của tin giả với việc lạm dụng chữ in hoa và dấu chấm than.',
                'Ví dụ 2 - Hình ảnh sai ngữ cảnh: Hình ảnh từ sự kiện năm 2015 được sử dụng cho tin tức năm 2026 mà không ghi rõ nguồn gốc.',
                'Ví dụ 3 - Thiếu nguồn tin: Bài viết tuyên bố "Các chuyên gia cho biết..." nhưng không nêu tên chuyên gia hoặc tổ chức cụ thể.'
              ],
            ),
            const SizedBox(height: 16),
            
            _buildAccordion(
              title: 'Nguồn tin đáng tin cậy',
              content: [
                'Báo chí chính thống: Các tờ báo lớn có uy tín, đã hoạt động lâu năm và có quy trình biên tập chặt chẽ.',
                'Tổ chức quốc tế: WHO, UNESCO, UN và các tổ chức uy tín khác.',
                'Trang web chính phủ: Thông tin từ các cơ quan nhà nước chính thức (.gov.vn).',
                'Tổ chức kiểm chứng: Các trang fact-checking như AFP Fact Check, Reuters Fact Check.',
                'Chuyên gia được xác minh: Ý kiến từ các chuyên gia có bằng cấp và kinh nghiệm được công nhận.'
              ],
            ),
            const SizedBox(height: 32),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Lời khuyên quan trọng',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                  ),
                  SizedBox(height: 12),
                  Text('• Luôn nghi ngờ thông tin gây sốc hoặc quá tốt để có thể tin được', style: TextStyle(color: Color(0xFF1E40AF), height: 1.6)),
                  Text('• Không chia sẻ thông tin chưa được xác minh', style: TextStyle(color: Color(0xFF1E40AF), height: 1.6)),
                  Text('• Kiểm tra kỹ trước khi tin tưởng và hành động', style: TextStyle(color: Color(0xFF1E40AF), height: 1.6)),
                  Text('• Giáo dục người thân về cách nhận biết tin giả', style: TextStyle(color: Color(0xFF1E40AF), height: 1.6)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordion({required String title, required List<String> content}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF111827)),
        ),
        iconColor: const Color(0xFF2563EB),
        collapsedIconColor: const Color(0xFF6B7280),
        childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: content.map((text) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.5),
            ),
          );
        }).toList(),
      ),
    );
  }
}

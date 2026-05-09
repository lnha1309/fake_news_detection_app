# KLKS - Mobile App (Flutter)

Ứng dụng di động trong hệ thống Phát hiện tin giả, được xây dựng bằng Flutter.

## 🚀 Hướng Dẫn Chạy Ứng Dụng

### 1. Điều kiện tiên quyết
* Đã cài đặt Flutter SDK.
* Đã cài đặt Android Studio hoặc VS Code (với Flutter extension).
* **Quan trọng**: Server Node.js (Backend) phải đang chạy.

### 2. Cấu hình Server API
Mở file `lib/auth_service.dart` và kiểm tra biến `baseUrl`:
* **Sử dụng Máy ảo Android (Emulator)**: Dùng `http://10.0.2.2:5000/api`.
* **Sử dụng Điện thoại thật**: Đổi `10.0.2.2` thành địa chỉ IP nội bộ của máy tính (ví dụ: `http://192.168.1.15:5000/api`). Đảm bảo điện thoại và máy tính dùng chung Wi-Fi.

### 3. Chạy ứng dụng
Mở terminal tại thư mục này và chạy:
```bash
flutter pub get
flutter run
```

---

## 📦 Xuất File Cài Đặt (APK)

Để tạo file `.apk` để cài lên máy khác:
1. Đảm bảo `baseUrl` trỏ đúng địa chỉ IP máy tính hoặc link Public (Ngrok).
2. Chạy lệnh:
```bash
flutter build apk --release
```
3. File sau khi build xong sẽ nằm tại:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 🛠 Các Tính Năng Đã Có
* **Đăng nhập / Đăng ký**: Đồng bộ với hệ thống Web.
* **Kiểm tra tin tức**: Gửi văn bản để AI phân tích.
* **Biểu đồ phân tích**: Hiển thị độ tin cậy và các chỉ số kỹ thuật.
* **Lịch sử**: Xem lại các lần kiểm tra trước đó và phản hồi kết quả.
* **Giáo dục**: Cung cấp kiến thức nhận biết tin giả.

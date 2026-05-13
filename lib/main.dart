import 'package:flutter/material.dart';
import 'detection_page.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'auth_service.dart';
import 'education_page.dart';
import 'history_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phát hiện tin giả',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Navbar(),
              _HeroSection(),
              _FeaturesSection(),
              _CtaSection(),
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── NAVBAR ───────────────────────────
class _Navbar extends StatefulWidget {
  const _Navbar();

  @override
  State<_Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<_Navbar> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Thêm một chút delay để đảm bảo SharedPreferences đã được đồng bộ kịp
    await Future.delayed(const Duration(milliseconds: 200));
    var loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      try {
        await AuthService.getProfile();
      } catch (_) {
        loggedIn = false;
      }
    }
    if (mounted) {
      setState(() {
        _isLoggedIn = loggedIn;
      });
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    _checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Logo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF1E3A8A), width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/image/huit_logo.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Title
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'XÁC THỰC THÔNG TIN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF1E3A8A),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          if (_isLoggedIn) ...[
            // Menu for links & logout
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Color(0xFF1E3A8A)),
              onSelected: (value) {
                if (value == 'home') {
                  // Already on home
                } else if (value == 'check') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DetectionPage()));
                } else if (value == 'edu') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const EducationPage()));
                } else if (value == 'history') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage()));
                } else if (value == 'logout') {
                  _logout();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(value: 'home', child: Text('Trang chủ')),
                const PopupMenuItem<String>(value: 'check', child: Text('Kiểm tra')),
                const PopupMenuItem<String>(value: 'edu', child: Text('Giáo dục')),
                const PopupMenuItem<String>(value: 'history', child: Text('Lịch sử')),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ] else ...[
            // Menu for links & login
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Color(0xFF1E3A8A)),
              onSelected: (value) {
                if (value == 'login') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())).then((_) => _checkAuth());
                } else if (value == 'signup') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage())).then((_) => _checkAuth());
                } else if (value == 'check') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())).then((_) => _checkAuth());
                } else if (value == 'edu') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const EducationPage()));
                } else if (value == 'home') {
                  // Already on home
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(value: 'home', child: Text('Trang chủ')),
                const PopupMenuItem<String>(value: 'check', child: Text('Kiểm tra')),
                const PopupMenuItem<String>(value: 'edu', child: Text('Giáo dục')),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(value: 'login', child: Text('Đăng nhập')),
                const PopupMenuItem<String>(value: 'signup', child: Text('Đăng ký')),
              ],
            ),
          ]
        ],
      ),
    );
  }
}

// ─────────────────────────── HERO ───────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F2460),
            Color(0xFF153080),
            Color(0xFF1A3A9A),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 56),
      child: Column(
        children: [
          // Logo card
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/image/huit_logo.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          ),
          const SizedBox(height: 36),
          // Title
          const Text(
            'Phát hiện tin giả\nBảo vệ thông tin của bạn',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          // Subtitle
          const Text(
            'Sử dụng công nghệ phân tích thông minh để xác minh tin tức, hình ảnh và bảo vệ bạn khỏi thông tin sai lệch trên không gian mạng.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFBFDBFE),
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
          // Button 1
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                final loggedIn = await AuthService.isLoggedIn();
                if (!context.mounted) return;
                if (loggedIn) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DetectionPage()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1E40AF),
                backgroundColor: Colors.white,
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Bắt đầu kiểm tra ngay',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Button 2
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Tìm hiểu thêm',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── FEATURES ───────────────────────────
class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  static const _features = [
        _FeatureData(
      icon: Icons.search_rounded,
      title: 'Phân tích nhanh',
      description:
          'Nhận kết quả phân tích chi tiết trong vài giây với điểm tin cậy và giải thích rõ ràng',
    ),
    _FeatureData(
      icon: Icons.newspaper_outlined,
      title: 'Mẫu tin tức',
      description:
          'Phân tích các mẫu tin tức phổ biến để xác định xem một bài báo có thể là tin giả hay không dựa trên cấu trúc và ngôn ngữ sử dụng',
    ),
    _FeatureData(
      icon: Icons.history_rounded,
      title: 'Lưu lịch sử',
      description:
          'Lưu trữ các kết quả kiểm tra để xem lại sau và theo dõi các thông tin đã xác minh',
    ),
    _FeatureData(
      icon: Icons.menu_book_outlined,
      title: 'Tài liệu giáo dục',
      description:
          'Học cách nhận biết tin giả với hướng dẫn chi tiết và ví dụ thực tế từ chuyên gia',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 52),
      child: Column(
        children: [
          const Text(
            'Tính năng chính',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Công cụ toàn diện giúp bạn xác minh thông tin một cách nhanh chóng và chính xác',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 36),
          ...List.generate(
            _features.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _FeatureCard(feature: _features[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String description;
  const _FeatureData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData feature;
  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(feature.icon, color: const Color(0xFF2563EB), size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            feature.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feature.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── CTA ───────────────────────────
class _CtaSection extends StatelessWidget {
  const _CtaSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 60),
      child: Column(
        children: [
          const Text(
            'Sẵn sàng bảo vệ bản thân?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Bắt đầu xác minh thông tin ngay hôm nay và tránh xa tin giả',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final loggedIn = await AuthService.isLoggedIn();
                if (!context.mounted) return;
                if (loggedIn) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DetectionPage()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Kiểm tra ngay',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── FOOTER ───────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand
          Row(
            children: const [
              Icon(Icons.shield_outlined, color: Color(0xFF2563EB), size: 22),
              SizedBox(width: 8),
              Text(
                'Phát hiện tin giả',
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Công cụ hỗ trợ phát hiện và xác minh thông tin, giúp bạn bảo vệ mình khỏi tin giả và thông tin sai lệch.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),
          // Quick links
          const Text(
            'Liên kết nhanh',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          ...[
            'Trang chủ',
            'Kiểm tra tin tức',
            'Giáo dục',
          ].map(
            (link) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  link,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          // Contact
          const Text(
            'Liên hệ',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _SocialIcon(icon: Icons.email_outlined),
              const SizedBox(width: 16),
              _SocialIcon(icon: Icons.code),
              const SizedBox(width: 16),
              _SocialIcon(icon: Icons.flutter_dash),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFFE5E7EB)),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              '© 2026 Phát hiện tin giả. Bảo lưu mọi quyền.',
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Chính sách bảo mật',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Điều khoản sử dụng',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Icon(icon, size: 20, color: const Color(0xFF374151)),
    );
  }
}

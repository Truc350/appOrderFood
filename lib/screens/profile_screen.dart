import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  bool isUSCitizen = true;
  bool receiveMarketing = true;

  final Color primaryColor = const Color(0xFF667EEA);
  final Color secondaryColor = const Color(0xFF764BA2);
  final Color bgGradientStart = const Color(0xFFF0F2FF);
  final Color bgGradientEnd = const Color(0xFFE0EAFF);
  final Color textPrimary = const Color(0xFF1A1A1A);

  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgGradientStart, bgGradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            _buildProfileContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildAnimatedGradientBackground(),
            _buildProfileHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedGradientBackground() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
          CircleAvatar(
            radius: 65,
            backgroundColor: Colors.white,
            child: const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Tommy Jason",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "segunphilips@mail.com",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_slideAnimation),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 100),
            child: Column(
              children: [
                _buildEnhancedStatsRow(),
                const SizedBox(height: 30),
                _buildSection("Thông tin cá nhân", _buildPersonalInfo()),
                const SizedBox(height: 24),
                _buildSection("Cấu hình tài khoản", _buildAccountSettings()),
                const SizedBox(height: 30),
                _buildPremiumActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedStatsRow() {
    return Row(
      children: [
        Expanded(child: _statCard("2.4k", "Đơn hàng")),
        const SizedBox(width: 12),
        Expanded(child: _statCard("4.9", "Đánh giá")),
        const SizedBox(width: 12),
        Expanded(child: _statCard("98%", "Hoàn thành")),
      ],
    );
  }

  Widget _statCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      children: [
        _infoTile("Họ và tên", "Tommy Jason"),
        _infoTile("Số điện thoại", "+234 806 2856 543"),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text("Xác minh công dân Mỹ"),
          value: isUSCitizen,
          onChanged: (v) => setState(() => isUSCitizen = v),
        ),
        SwitchListTile(
          title: const Text("Nhận thông báo Marketing"),
          value: receiveMarketing,
          onChanged: (v) => setState(() => receiveMarketing = v),
        ),
      ],
    );
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildPremiumActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text("Chỉnh sửa hồ sơ"),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {},
          child: const Text("Đăng xuất"),
        ),
      ],
    );
  }
}
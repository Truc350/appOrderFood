import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F6),

      bottomNavigationBar: _buildBottomNav(),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  const SizedBox(height: 16),
                  _sectionTitle("HÔM NAY", true),
                  const SizedBox(height: 14),
                  _notificationCard(
                    icon: Icons.local_shipping_outlined,
                    title: "Cập nhật đơn hàng",
                    subtitle: "Đơn hàng #NF-92831 đang trên đường giao đến bạn!",
                    time: "10:30",
                    unread: true,
                    iconBg: const Color(0xFFFFEAEA),
                  ),
                  const SizedBox(height: 14),
                  _notificationCard(
                    icon: Icons.local_offer_outlined,
                    title: "Ưu đãi độc quyền",
                    subtitle:
                    "Giảm 50k cho đơn hàng đầu tiên của bạn tại NguyenFood!",
                    time: "08:15",
                    unread: true,
                    iconBg: const Color(0xFFF3E8FF),
                  ),
                  const SizedBox(height: 28),
                  _sectionTitle("TRƯỚC ĐÓ", false),
                  const SizedBox(height: 14),
                  _notificationCard(
                    icon: Icons.info_outline,
                    title: "Hệ thống",
                    subtitle:
                    "Chào mừng bạn đến với NguyenFood, bắt đầu khám phá ngay!",
                    time: "Hôm qua",
                    unread: false,
                    iconBg: const Color(0xFFF3F3F3),
                  ),
                  const SizedBox(height: 14),
                  _notificationCard(
                    icon: Icons.check_circle_outline,
                    title: "Xác thực tài khoản",
                    subtitle:
                    "Số điện thoại của bạn đã được xác thực thành công.",
                    time: "2 ngày trước",
                    unread: false,
                    iconBg: const Color(0xFFF3F3F3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Row(
        children: [
          const Icon(Icons.arrow_back, color: Colors.red),
          const Spacer(),
          const Text(
            "Thông báo",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const Spacer(),
          Container(width: 24),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, bool showBadge) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.brown.shade300,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (showBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade300,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              "2 MỚI",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          )
      ],
    );
  }

  Widget _notificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required bool unread,
    required Color iconBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.red),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.brown.shade300,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          if (unread)
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            )
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_outlined, "TRANG\nCHỦ", false),
          _navItem(Icons.receipt_long, "ĐƠN\nHÀNG", false),
          _navItem(Icons.notifications, "THÔNG\nBÁO", true),
          _navItem(Icons.chat_bubble_outline, "TIN\nNHẮN", false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String text, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: active ? Colors.red : Colors.grey),
        const SizedBox(height: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? Colors.red : Colors.grey,
            fontSize: 11,
          ),
        )
      ],
    );
  }
}
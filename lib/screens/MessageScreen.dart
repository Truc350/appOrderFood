import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      bottomNavigationBar: _buildBottomNav(),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildFilterTabs(),
            _buildRecentTitle(),
            _buildMessageCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.arrow_back, size: 24),
          const SizedBox(width: 14),
          const Text(
            "Tin nhắn",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          const Icon(Icons.search, color: Colors.red),
          const SizedBox(width: 18),
          const CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade400),
          const SizedBox(width: 10),
          Text(
            "Tìm kiếm tin nhắn...",
            style: TextStyle(
              color: Colors.grey.shade400,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          _tab("Tất cả", true),
          const SizedBox(width: 10),
          _tab("Chưa đọc", false),
          const SizedBox(width: 10),
          _tab("Quan trọng", false),
        ],
      ),
    );
  }

  Widget _tab(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: active ? Colors.red : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRecentTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 24, bottom: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "GẦN ĐÂY",
          style: TextStyle(
            color: Colors.blueGrey.shade200,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Nguyễn Bảo Ngọc",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Chào shop, tôi muốn hỏi về kết quả...",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                )
              ],
            ),
          ),

          const Text(
            "10:30",
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 74,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_outlined, "Trang chủ", false),
          _navItem(Icons.receipt_long, "Đơn hàng", false),
          _navItem(Icons.notifications_none, "Thông báo", false),
          _navItem(Icons.chat_bubble, "Tin nhắn", true),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: active ? Colors.red : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.red : Colors.grey,
            fontSize: 12,
          ),
        )
      ],
    );
  }
}
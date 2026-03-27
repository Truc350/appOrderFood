import 'package:flutter/material.dart';
import 'orders_page.dart';
import 'order_detail_page.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  int _selectedNavIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Theo dõi đơn hàng',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                _buildMapSection(context),
                _buildTrackingSheet(context),
              ],
            ),
          ),
          // Bottom Nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return SizedBox(
      height: 486,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0, 0, 0, 0.9, 0, // opacity 0.9 and grayscale
              ]),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuB43WCg6Mj8gv3lXsEQoMZjwVQ7Uzg7KB01NTkUadoPRLeycjN88h275HVb_hNcX1TxsJLLLQR5x49dBs3gtsClnWl-kUBkq6n919qxLMDKWIvet191b2KsTCrLq15tLJhVEXQqFwSerbGW3rm7G6TXFBYc7s2x7w72MhCC8IpBjuzLmkST6TLQcm2-zyJCWRJT1BdzQTkQQ3RS7LqRTnjyR6VyPqKkpyOZhMRmxAnxnM06ibgJSXVxqTFyMeT8Ux6mgkLKjQZnrIw',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey.shade300),
              ),
            ),
          ),
          Container(color: const Color(0xFFEEEEEE).withOpacity(0.5)),

          // Restaurant Icon
          Positioned(
            top: 140,
            left: MediaQuery.of(context).size.width * 0.3,
            child: _buildMapIcon(Icons.restaurant, AppColors.primary),
          ),
          // Driver Icon
          Positioned(
            top: 243,
            left: MediaQuery.of(context).size.width * 0.5 - 24,
            child: Transform.scale(
              scale: 1.25,
              child: _buildMapIcon(
                Icons.moped,
                AppColors.primaryContainer,
                textColor: AppColors.onPrimaryContainer,
              ),
            ),
          ),
          // Home Icon
          Positioned(
            bottom: 120,
            right: MediaQuery.of(context).size.width * 0.25,
            child: _buildMapIcon(Icons.location_on, AppColors.onSurface),
          ),
          // Time Card
          Positioned(
            top: kToolbarHeight + 40,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.outlineVariant.withOpacity(0.2),
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8)
                ],
              ),
              child: Column(
                children: const [
                  Text(
                    'GIAO HÀNG DỰ KIẾN',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '12:45 PM',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapIcon(IconData icon, Color bgColor,
      {Color textColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      child: Icon(icon, color: textColor, size: 20),
    );
  }

  Widget _buildTrackingSheet(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -48),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4D2126).withOpacity(0.12),
              blurRadius: 40,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Status Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tiến độ đơn hàng',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Text(
                    '#NF-92831',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Timeline
            _buildTimeline(),
            const SizedBox(height: 32),
            // Order Summary High End Card
            _buildOrderSummary(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background lines
        Positioned(
          top: 16,
          left: 32,
          right: 32,
          child: Container(
              height: 2, color: AppColors.outlineVariant.withOpacity(0.2)),
        ),
        Positioned(
          top: 16,
          left: 32,
          right: 80, // roughly 2/3 width
          child: Container(height: 2, color: AppColors.primary),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimelineStep(Icons.check, 'Đã xác\nnhận', true, false),
            _buildTimelineStep(Icons.restaurant, 'Đang chuẩn\nbị', true, false),
            _buildTimelineStep(Icons.local_shipping, 'Đang\ngiao', true, true),
            _buildTimelineStep(Icons.home, 'Đã giao\nhàng', false, false),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineStep(
      IconData icon, String label, bool isCompleted, bool isCurrent) {
    return Column(
      children: [
        Container(
          width: isCurrent ? 40 : 32,
          height: isCurrent ? 40 : 32,
          margin: EdgeInsets.only(top: isCurrent ? 0 : 4),
          decoration: BoxDecoration(
            color: isCurrent
                ? null
                : (isCompleted
                    ? AppColors.primary
                    : AppColors.outlineVariant.withOpacity(0.3)),
            gradient: isCurrent
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryContainer])
                : null,
            shape: BoxShape.circle,
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 10)
                  ]
                : null,
            border: Border.all(
                color: isCompleted
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
                width: 4),
          ),
          child: Icon(icon,
              color: isCompleted ? Colors.white : AppColors.onSurface,
              size: isCurrent ? 20 : 16),
        ),
        const SizedBox(height: 8),
        Opacity(
          opacity: isCompleted || isCurrent ? 1.0 : 0.4,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isCurrent ? FontWeight.w800 : FontWeight.bold,
              color: isCurrent ? AppColors.primary : AppColors.onSurface,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tóm tắt đơn hàng',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface.withOpacity(0.8),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const OrderDetailPage()));
              },
              child: const Text(
                'Chi tiết',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCirbzNNPrwlKbcAfVd8xlfENUP8eJSDMmMRx5iCDXW48HKl-HY7qvBWO5DWw1cp4v0rLI-S-MtF-L2CeTbJVCuN9tkI8Ei947ol6MjwV215gCN8eU9QvewgT42N7V6cly9Sp8JGKmQJD0_IVmTY826E0MoUjws9AKfoqlggnrE3oTRGZVGAB31nLtNW4aW2aPr8nU9sZXdio8b20wwIGbpUQYKJ85LEIUVxAL_eTP88tURHZdI_Ve0dC1jUROE23bW-47eAGzAO_4',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.surfaceContainer),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Burger Bò Wagyu Truffle',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '1x Đơn hàng • Extra Cheese',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '245.000đ',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4D2126).withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Trang chủ', false, () {}),
              _buildNavItem(Icons.receipt_long, 'Đơn hàng', true, () {}),
              _buildNavItem(Icons.notifications, 'Thông báo', false, () {}),
              _buildNavItem(Icons.chat_bubble, 'Tin nhắn', false, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFECED),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF4D2126).withOpacity(0.6)),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4D2126).withOpacity(0.6),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

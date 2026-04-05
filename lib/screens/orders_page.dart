import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/order_manager.dart';
import 'order_detail_page.dart';
import 'order_tracking_page.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'order_tracking_page.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'MessageScreen.dart';
import 'NotificationScreen.dart';
class AppColors {
  static const primary = Color(0xFFBB0100);
  static const onPrimary = Color(0xFFFFEFED);
  static const primaryContainer = Color(0xFFFF7763);
  static const onPrimaryContainer = Color(0xFF4F0000);
  static const secondary = Color(0xFF5A5C5C);
  static const onSecondary = Color(0xFFF3F3F3);
  static const secondaryContainer = Color(0xFFE2E2E2);
  static const onSecondaryContainer = Color(0xFF505252);
  static const tertiary = Color(0xFF7B40A2);
  static const surface = Color(0xFFFFF4F4);
  static const onSurface = Color(0xFF4D2126);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFFFECED);
  static const surfaceContainer = Color(0xFFFFE1E2);
  static const surfaceContainerHigh = Color(0xFFFFDADB);
  static const surfaceContainerHighest = Color(0xFFFFD2D4);
  static const surfaceVariant = Color(0xFFFFD2D4);
  static const onSurfaceVariant = Color(0xFF824C51);
  static const outline = Color(0xFFA2676B);
  static const outlineVariant = Color(0xFFDE9CA0);
  static const background = Color(0xFFFFF4F4);
  static const onBackground = Color(0xFF4D2126);
  static const error = Color(0xFFB41340);
  static const errorContainer = Color(0xFFF74B6D);
  static const inverseOnSurface = Color(0xFFCC8C90);
  static const inverseSurface = Color(0xFF240307);
}

enum OrderStatus { pending, waitingPickup, delivering, delivered, cancelled }

class OrderItem {
  final String name;
  final int quantity;
  final int price;
  final String imageUrl;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

class Order {
  final String id;
  final OrderStatus status;
  final List<OrderItem> items;
  final int totalPrice;
  final String? cancelReason;

  const Order({
    required this.id,
    required this.status,
    required this.items,
    required this.totalPrice,
    this.cancelReason,
  });
}

final List<Order> mockOrders = [
  Order(
    id: 'ORD001',
    status: OrderStatus.delivering,
    items: const [
      OrderItem(
        name: 'Burger Bò Wagyu Truffle',
        quantity: 1,
        price: 245000,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBKslNrZa8ghocespk8mCk-ZQGobWm63eswxGE72mdUOS_k3RvFYgTrrujER-96BFdmqrIohJ_S304c_GV7dM-ze_bQcw1pfYT1FBUOK-Mi18wanjahbd2sgfvwETEEsPcCGWG7uMwQ4KNp2H1z2uZcBSNMgTo7iJ_yj8a3M4jtsREyEBoivKc1NfDCkY5oKfRAv-dbap-2_3ZiTeL_SgoIBh4004IE0p7zK9t8f_zRzszlz285IL68f3LAo236u-7B6JvBHmGe0PI',
      ),
      OrderItem(
        name: 'Khoai tây chiên Parmesan',
        quantity: 2,
        price: 130000,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAwT_AQ0cbvZPcCB-5mG3EyseLzN7bpjLWhTlnOLskTiYPQXs9yC_k0DT66vHfXG5g7C5jtVBMzE7CXGpJLs9Pa5DFtvYNai5yW6djnEK7nJbzeUkdAeDtwgfzFfWL9E7uJ5tKzUAYYWl5Zc4vRLcMa6WXTk5h75ZYL7coYcWh_OQ6UXPb9GOPwHVFzmEcWyDK7CY63kLkZKdUyyyuEXNRXl60zkmHXaohWlAq4_nkCF9csJQAwuY6wlrRFBsJV2H5tD_DWYzPs6SI',
      ),
      OrderItem(
        name: 'Salad Caesar Tôm Nướng',
        quantity: 1,
        price: 155000,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAwT_AQ0cbvZPcCB-5mG3EyseLzN7bpjLWhTlnOLskTiYPQXs9yC_k0DT66vHfXG5g7C5jtVBMzE7CXGpJLs9Pa5DFtvYNai5yW6djnEK7nJbzeUkdAeDtwgfzFfWL9E7uJ5tKzUAYYWl5Zc4vRLcMa6WXTk5h75ZYL7coYcWh_OQ6UXPb9GOPwHVFzmEcWyDK7CY63kLkZKdUyyyuEXNRXl60zkmHXaohWlAq4_nkCF9csJQAwuY6wlrRFBsJV2H5tD_DWYzPs6SI',
      ),
      OrderItem(
        name: 'Trà Sữa Trân Châu Oolong',
        quantity: 2,
        price: 55000,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDt3e8nUCIquisAWW66vb2P4gylNpIw_4nA4Fa8tv62jv-UcheJlyRL9I8PjexzGqfjH2-ajQsgOKuV-al6RjmwPFci12RVeBS-cfFZX8O11vnNVlgECRRU0_VIS_GPewDHqZL2Or8pzs2Nq9PjL_KLNrnXJL5Bu8SjoKd5Ys5uhS0Adrt1y97HyTJFCpw5SM8q8ifqjHDIZbeTs2-329zcmyivqLxF3PHYV6cnyRF5HCUgJt32B7Mn-d6zWFmtTBg0QVjhnVDMS9k',
      ),
      OrderItem(
        name: 'Bánh Mì Garlic Cheese',
        quantity: 1,
        price: 65000,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCnvcRaNUqbcZ4EvVnUvpDv_VaRePeewsLJQHiVuUYC-m4t9pjFZIsOKXOWeoUJve29pFtbsgz0aEO-wzfMxA2FL5FKCSFEOWu9OQlVkMeURMfP9SDBf1eeDPIlsYLREzqk9_QlWerd0LMgtaEBGw9KvYVoB0iW0JvrvwcfQZT5fmfElbrnEcyBEgZwYCATQ5joOTjwheem1I0xndX4vT2oBcTiAso2omLEtf98YFTcEQvl5x_t98iAfl6Nms4oRVuJUN9Iypjrvug',
      ),
    ],
    totalPrice: 705000,
  ),
  Order(
    id: 'ORD002',
    status: OrderStatus.delivered,
    items: const [
      OrderItem(
        name: 'Pizza Quattro Formaggi',
        quantity: 1,
        price: 185000,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCnvcRaNUqbcZ4EvVnUvpDv_VaRePeewsLJQHiVuUYC-m4t9pjFZIsOKXOWeoUJve29pFtbsgz0aEO-wzfMxA2FL5FKCSFEOWu9OQlVkMeURMfP9SDBf1eeDPIlsYLREzqk9_QlWerd0LMgtaEBGw9KvYVoB0iW0JvrvwcfQZT5fmfElbrnEcyBEgZwYCATQ5joOTjwheem1I0xndX4vT2oBcTiAso2omLEtf98YFTcEQvl5x_t98iAfl6Nms4oRVuJUN9Iypjrvug',
      ),
      OrderItem(
        name: 'Coke Zero',
        quantity: 1,
        price: 25000,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBC-y082_Zt-nO3vO53Lp0011G_R8z-06R_9yA4C-wB-4B-4B-4B-4B-4B-4B-4B-4B-4B-4B-4B-4B-4B-4B-4B-4B-4B-4B-4B-4B',
      ),
    ],
    totalPrice: 210000,
  ),
  Order(
    id: 'ORD003',
    status: OrderStatus.cancelled,
    items: const [
      OrderItem(
        name: 'Green Poke Bowl Artisan',
        quantity: 1,
        price: 165000,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAwT_AQ0cbvZPcCB-5mG3EyseLzN7bpjLWhTlnOLskTiYPQXs9yC_k0DT66vHfXG5g7C5jtVBMzE7CXGpJLs9Pa5DFtvYNai5yW6djnEK7nJbzeUkdAeDtwgfzFfWL9E7uJ5tKzUAYYWl5Zc4vRLcMa6WXTk5h75ZYL7coYcWh_OQ6UXPb9GOPwHVFzmEcWyDK7CY63kLkZKdUyyyuEXNRXl60zkmHXaohWlAq4_nkCF9csJQAwuY6wlrRFBsJV2H5tD_DWYzPs6SI',
      ),
    ],
    totalPrice: 165000,
    cancelReason: 'Nhà hàng quá bận',
  ),
];


class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _selectedStatusIndex = 0; // Default to 'Đang giao'
  int _selectedNavIndex = 1;

  final List<String> _statusLabels = [
    'Chờ xác nhận',
    'Chờ lấy hàng',
    'Đang giao',
    'Đã giao',
    'Đã hủy',
  ];

  List<Order> _allOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final String response = await rootBundle.loadString('assets/orders_api.json');
      final List<dynamic> data = jsonDecode(response);
      
      final parsedOrders = data.map((json) {
        final itemsList = (json['items'] as List).map((i) => OrderItem(
          name: i['name'],
          quantity: i['quantity'],
          price: i['price'],
          imageUrl: i['imageUrl'],
        )).toList();

        OrderStatus status;
        switch(json['status']) {
          case 'pending': status = OrderStatus.pending; break;
          case 'waitingPickup': status = OrderStatus.waitingPickup; break;
          case 'delivering': status = OrderStatus.delivering; break;
          case 'delivered': status = OrderStatus.delivered; break;
          case 'cancelled': status = OrderStatus.cancelled; break;
          default: status = OrderStatus.pending;
        }

        return Order(
          id: json['id'],
          status: status,
          items: itemsList,
          totalPrice: json['totalPrice'],
          cancelReason: json['cancelReason'],
        );
      }).toList();

      if (mounted) {
        setState(() {
          _allOrders = parsedOrders;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading orders JSON: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  List<Order> get filteredOrders {
    final allOrders = [...OrderManager.instance.orders, ..._allOrders];

    OrderStatus targetStatus;
    switch (_selectedStatusIndex) {
      case 0: targetStatus = OrderStatus.pending; break;
      case 1: targetStatus = OrderStatus.waitingPickup; break;
      case 2: targetStatus = OrderStatus.delivering; break;
      case 3: targetStatus = OrderStatus.delivered; break;
      case 4: targetStatus = OrderStatus.cancelled; break;
      default: targetStatus = OrderStatus.pending;
    }
    return allOrders.where((o) => o.status == targetStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // AppBar
          _buildAppBar(),
          // Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Đơn hàng của bạn',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Theo dõi hành trình ẩm thực của bạn',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xB3824C51), // on-surface-variant/70
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Status filter bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _StatusBarDelegate(
              statusLabels: _statusLabels,
              selectedIndex: _selectedStatusIndex,
              onSelected: (i) => setState(() => _selectedStatusIndex = i),
            ),
          ),
          // Order cards
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            sliver: isLoading 
              ? const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
              : filteredOrders.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text(
                            'Không có đơn hàng nào',
                            style: TextStyle(color: AppColors.secondary, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final order = filteredOrders[index];
                          Widget card;
                          if (order.status == OrderStatus.delivering) {
                            card = ActiveOrderCard(order: order);
                          } else if (order.status == OrderStatus.delivered) {
                            card = CompletedOrderCard(order: order);
                          } else if (order.status == OrderStatus.cancelled) {
                            card = CancelledOrderCard(order: order);
                          } else {
                            card = ActiveOrderCard(order: order);
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: card,
                          );
                        },
                        childCount: filteredOrders.length,
                      ),
                    ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, size: 26, color: Colors.black87),
        onPressed: () {
          showCategoryDrawer(context);
        },
      ),
      title: const Text(
        'NguyenFood',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
      actions: [
        // Cart button
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26),
          ),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, size: 20, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            },
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ),
        // Profile button
        Container(
          margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8, left: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26),
          ),
          child: IconButton(
            icon: const Icon(Icons.person_outline, size: 20, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          if (index == 0) {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
          } else if (index == 2) {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
          } else if (index == 3) {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MessageScreen()));
          } else {
            setState(() => _selectedNavIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFE53935),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Tin nhắn',
          ),
        ],
      ),
    );
  }
}

// ─── Status Bar Delegate ──────────────────────────────────────────────────────

class _StatusBarDelegate extends SliverPersistentHeaderDelegate {
  final List<String> statusLabels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _StatusBarDelegate({
    required this.statusLabels,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  double get minExtent => 64;

  @override
  double get maxExtent => 64;

  @override
  bool shouldRebuild(_StatusBarDelegate oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.background.withOpacity(0.95),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: statusLabels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(99),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  statusLabels[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.onPrimary
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Active Order Card ────────────────────────────────────────────────────────

class ActiveOrderCard extends StatefulWidget {
  final Order order;
  const ActiveOrderCard({super.key, required this.order});

  @override
  State<ActiveOrderCard> createState() => _ActiveOrderCardState();
}

class _ActiveOrderCardState extends State<ActiveOrderCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasExtra = widget.order.items.length > 2;
    final displayItems = _isExpanded
        ? widget.order.items
        : widget.order.items.take(2).toList();
    final hiddenCount = widget.order.items.length - 2;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4D2126).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.2),
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              'ĐANG GIAO',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.primary.withOpacity(0.1),
                  width: 2,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...displayItems.map((item) => _OrderItemRow(item: item)),
                if (hasExtra)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, top: 4, bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isExpanded 
                                ? 'Thu gọn' 
                                : 'Xem thêm $hiddenCount món khác',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _isExpanded 
                                ? Icons.keyboard_arrow_up 
                                : Icons.keyboard_arrow_down,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.surfaceContainer),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TỔNG CỘNG',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: AppColors.onSurfaceVariant.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatCurrency(widget.order.totalPrice),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => OrderTrackingPage(order: widget.order)));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFDC2626), Color(0xFFF97316)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Theo dõi đơn hàng',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Completed Order Card ─────────────────────────────────────────────────────

class CompletedOrderCard extends StatelessWidget {
  final Order order;
  const CompletedOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4D2126).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              'ĐÃ GIAO',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.onSecondaryContainer,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.secondary.withOpacity(0.1),
                  width: 2,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.items
                  .map((item) => _OrderItemRow(item: item, dimmed: true))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.surfaceContainer),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TỔNG CỘNG',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: AppColors.onSurfaceVariant.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatCurrency(order.totalPrice),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderDetailPage()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Mua lại',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Cancelled Order Card ─────────────────────────────────────────────────────

class CancelledOrderCard extends StatelessWidget {
  final Order order;
  const CancelledOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4D2126).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.errorContainer.withOpacity(0.2),
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              'ĐÃ HỦY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.error.withOpacity(0.1),
                  width: 2,
                ),
              ),
            ),
            child: Opacity(
              opacity: 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: order.items
                    .map((item) => _OrderItemRow(item: item))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.surfaceContainer.withOpacity(0.5),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lý do: ${order.cancelReason}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderDetailPage()));
                  },
                  child: const Text(
                    'Chi tiết',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared Sub-widgets ───────────────────────────────────────────────────────

class _OrderItemRow extends StatelessWidget {
  final OrderItem item;
  final bool dimmed;

  const _OrderItemRow({required this.item, this.dimmed = false});

  @override
  Widget build(BuildContext context) {
    final opacity = dimmed ? 0.6 : 0.8;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 32,
                    height: 32,
                    color: AppColors.surfaceContainer,
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.fastfood,
                        size: 16,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${item.quantity}x ${item.name}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface.withOpacity(opacity),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formatCurrency(item.price),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant.withOpacity(opacity),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Utilities ────────────────────────────────────────────────────────────────

String _formatCurrency(int amount) {
  final formatted = amount.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  );
  return '${formatted}đ';
}
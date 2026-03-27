import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';
import 'home_screen.dart';
import 'MessageScreen.dart';
import 'NotificationScreen.dart';
import 'orders_page.dart';
import '../models/cart_manager.dart';

class ProductDetailScreen extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;

  const ProductDetailScreen({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int mainQuantity = 1;
  Map<String, bool> selectedAddons = {
    'Trà tắc': false,
    'Trà đào': false,
    'Coca': false,
  };
  Map<String, int> addonQuantities = {
    'Trà tắc': 1,
    'Trà đào': 1,
    'Coca': 1,
  };
  Map<String, int> addonPrices = {
    'Trà tắc': 10000,
    'Trà đào': 15000,
    'Coca': 10000,
  };

  int get totalPrice {
    int total = widget.price * mainQuantity;
    selectedAddons.forEach((name, selected) {
      if (selected) {
        total += (addonPrices[name] ?? 0) * (addonQuantities[name] ?? 1);
      }
    });
    return total;
  }

  String get orderSummary {
    List<String> parts = ['$mainQuantity ${widget.name.toLowerCase()}'];
    selectedAddons.forEach((name, selected) {
      if (selected) {
        final qty = addonQuantities[name] ?? 1;
        parts.add('$qty ${name.toLowerCase()}');
      }
    });
    return parts.join(' + ');
  }

  String formatPrice(int price) {
    return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Hero Image with back button
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: false,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        // Food image
                        SizedBox(
                          width: double.infinity,
                          height: 280,
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.orange[100],
                              child: const Icon(Icons.restaurant, size: 80, color: Colors.orange),
                            ),
                          ),
                        ),
                        // Back button
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 8,
                          left: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.arrow_back, size: 20, color: Colors.black87),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
                                const SizedBox(width: 12),
                                Icon(Icons.favorite_border, color: Colors.grey[400], size: 22),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Price + sold count
                        Row(
                          children: [
                            Text(
                              formatPrice(widget.price),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE84B3A),
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.shopping_bag_outlined, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              '500+ người mua',
                              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Quantity selector
                        Row(
                          children: [
                            _buildQuantityButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (mainQuantity > 1) {
                                  setState(() => mainQuantity--);
                                }
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$mainQuantity',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            _buildQuantityButton(
                              icon: Icons.add,
                              onTap: () => setState(() => mainQuantity++),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Ingredients
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Add-ons section
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3F2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tùy chọn thêm',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE84B3A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...addonPrices.keys.map((name) => _buildAddonRow(name)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom summary bar
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Order summary
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8F7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFFD5D0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          orderSummary,
                          style: const TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ),
                      Text(
                        formatPrice(totalPrice),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          CartManager.instance.addItem(CartItem(
                            id: widget.id,
                            name: widget.name,
                            price: totalPrice,
                            quantity: 1,
                            imageUrl: widget.imageUrl,
                            optionsLabel: orderSummary,
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã thêm món vào giỏ hàng!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE84B3A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Thêm vào giỏ hàng',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          CartManager.instance.addItem(CartItem(
                            id: widget.id,
                            name: widget.name,
                            price: totalPrice,
                            quantity: 1,
                            imageUrl: widget.imageUrl,
                            optionsLabel: orderSummary,
                          ));
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE84B3A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Mua ngay',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom nav bar
          Container(
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
              currentIndex: 0,
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                } else if (index == 1) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrdersPage()));
                } else if (index == 2) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
                } else if (index == 3) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MessageScreen()));
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
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildAddonRow(String name) {
    final isSelected = selectedAddons[name] ?? false;
    final qty = addonQuantities[name] ?? 1;
    final price = addonPrices[name] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => selectedAddons[name] = !isSelected),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? const Color(0xFFE84B3A) : Colors.grey[400]!,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(4),
                color: isSelected ? const Color(0xFFE84B3A) : Colors.white,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          // Quantity control for addon
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if ((addonQuantities[name] ?? 1) > 1) {
                    setState(() => addonQuantities[name] = (addonQuantities[name] ?? 1) - 1);
                  }
                },
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.remove, size: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('$qty', style: const TextStyle(fontSize: 13)),
              ),
              GestureDetector(
                onTap: () => setState(() => addonQuantities[name] = (addonQuantities[name] ?? 1) + 1),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.add, size: 12),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 70,
            child: Text(
              '${price ~/ 1000}.000 đ',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
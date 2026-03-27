import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'orders_page.dart';
import 'product_detail_screen.dart';
import 'MessageScreen.dart';
import 'NotificationScreen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryDetailScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  Map<String, dynamic>? _categoryData;
  bool _isLoading = true;
  String _sortMode = 'none'; // 'asc', 'desc', 'none'

  @override
  void initState() {
    super.initState();
    _loadCategoryData();
  }

  Future<void> _loadCategoryData() async {
    try {
      final String response = await rootBundle.loadString('assets/categories.json');
      final List<dynamic> data = jsonDecode(response);
      final category = data.firstWhere((cat) => cat['id'] == widget.categoryId, orElse: () => null);
      setState(() {
        _categoryData = category;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sortItems(String mode) {
    setState(() {
      _sortMode = mode;
      if (_categoryData != null && _categoryData!['subcategories'] != null) {
        for (var sub in _categoryData!['subcategories']) {
          List items = sub['items'];
          if (mode == 'asc') {
            items.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
          } else if (mode == 'desc') {
            items.sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
          }
        }
      }
    });
  }

  String _formatPrice(int price) {
    return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}.000 VND'.replaceAll('.000.000', '.000');
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFDC2626);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _categoryData == null
          ? const Center(child: Text('Không tìm thấy dữ liệu danh mục này.', style: TextStyle(color: Colors.black54)))
              : CustomScrollView(
                  slivers: [
                    // Filter Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        child: Row(
                          children: [
                            const Text(
                              'Lọc: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildFilterChip('Giá thấp đến cao', 'asc', primaryColor),
                            const SizedBox(width: 8),
                            _buildFilterChip('Giá cao đến thấp', 'desc', primaryColor),
                          ],
                        ),
                      ),
                    ),
                    // Subcategories
                    ...(_categoryData!['subcategories'] as List).map((sub) {
                      return SliverToBoxAdapter(
                        child: _buildSubcategorySection(sub, primaryColor),
                      );
                    }).toList(),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFilterChip(String label, String mode, Color primaryColor) {
    final isSelected = _sortMode == mode;
    return GestureDetector(
      onTap: () => _sortItems(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? primaryColor : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildSubcategorySection(Map<String, dynamic> sub, Color primaryColor) {
    final items = sub['items'] as List;
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sub['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Xem tất cả',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 290,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return _buildItemCard(items[index], primaryColor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, Color primaryColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductDetailScreen()));
      },
      child: Container(
        width: 190,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item['imageUrl'],
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: Colors.orange[100],
                  child: const Icon(Icons.fastfood, size: 40, color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                item['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(item['price']),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
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
    );
  }
}

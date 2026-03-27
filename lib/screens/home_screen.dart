import 'package:flutter/material.dart';
import 'dart:async';
import 'product_detail_screen.dart';
import 'orders_page.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

void main() {
  runApp(const NguyenFoodApp());
}

class NguyenFoodApp extends StatelessWidget {
  const NguyenFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NguyenFood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE53935)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

// ──────────────────────────────────────────────
// DATA MODELS
// ──────────────────────────────────────────────

class FoodItem {
  final String name;
  final String description;
  final String price;
  final String imageUrl;

  const FoodItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

// ──────────────────────────────────────────────
// HOME PAGE
// ──────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;

  final List<String> _bannerImages = const [
    'https://images.unsplash.com/photo-1555126634-323283e090fa?w=800&h=300&fit=crop', // Phở
    'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=800&h=300&fit=crop', // Bún bò
    'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800&h=300&fit=crop', // Cơm tấm
    'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=800&h=300&fit=crop', // Hủ tiếu
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      final next = (_currentBanner + 1) % _bannerImages.length;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }


  final List<FoodItem> suggestedItems = const [
    FoodItem(
      name: 'Cơm tấm sườn bì',
      description: 'Sườn nướng + bì + chả + cơm tấm',
      price: '55.000 VND',
      imageUrl: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=300&h=200&fit=crop',
    ),
    FoodItem(
      name: 'Phở bò tái',
      description: 'Bò tái + gân + bánh phở + rau thơm',
      price: '65.000 VND',
      imageUrl: 'https://images.unsplash.com/photo-1555126634-323283e090fa?w=300&h=200&fit=crop',
    ),
    FoodItem(
      name: 'Bún bò Huế',
      description: 'Bò + giò heo + mắm ruốc + rau sống',
      price: '60.000 VND',
      imageUrl: 'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=300&h=200&fit=crop',
    ),
  ];

  final List<FoodItem> popularItems = const [
    FoodItem(
      name: 'Hủ tiếu Nam Vang',
      description: 'Tôm + thịt + gan + hủ tiếu dai',
      price: '70.000 VND',
      imageUrl: 'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=100&h=100&fit=crop',
    ),
    FoodItem(
      name: 'Bún riêu cua',
      description: 'Cua đồng + cà chua + đậu hũ + bún',
      price: '60.000 VND',
      imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=100&h=100&fit=crop',
    ),
    FoodItem(
      name: 'Cơm tấm sườn bì chả',
      description: 'Cơm tấm + sườn + bì + chả trứng + dưa chua',
      price: '50.000 VND',
      imageUrl: 'https://images.unsplash.com/photo-1516100882582-96c3a05fe590?w=100&h=100&fit=crop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top App Bar ──
            _buildAppBar(),

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildHeroBanner(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Gợi ý món ăn'),
                    const SizedBox(height: 12),
                    _buildSuggestedItems(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Món ăn phổ biến'),
                    const SizedBox(height: 12),
                    _buildPopularItems(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ── App Bar ──
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.menu, size: 26, color: Colors.black87),
          const Expanded(
            child: Center(
              child: Text(
                'NguyenFood',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          // Cart button
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black26),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, size: 20),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
              },
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
          // Profile button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black26),
            ),
            child: IconButton(
              icon: const Icon(Icons.person_outline, size: 20),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              },
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ──
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          readOnly: true,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
          },
          decoration: InputDecoration(
            hintText: 'Tìm kiếm món ăn mà bạn thích...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE53935)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  // Banner
  Widget _buildHeroBanner() {
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 170,
            child: PageView.builder(
              controller: _bannerController,
              onPageChanged: (index) =>
                  setState(() => _currentBanner = index),
              itemCount: _bannerImages.length,
              itemBuilder: (context, index) {
                return Image.network(
                  _bannerImages[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFE53935),
                    child: const Center(
                      child: Icon(Icons.fastfood, size: 60, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ),


        Positioned(
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_bannerImages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentBanner == index ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: _currentBanner == index
                      ? Colors.white
                      : Colors.white54,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    ),
    );
  }

  // ── Section Title ──
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ── Suggested Items (Horizontal Scroll) ──
  Widget _buildSuggestedItems() {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: suggestedItems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _SuggestedItemCard(item: suggestedItems[index]);
        },
      ),
    );
  }

  // ── Popular Items (Vertical List) ──
  Widget _buildPopularItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: popularItems
            .map((item) => _PopularItemCard(item: item))
            .toList(),
      ),
    );
  }

  // ── Bottom Nav Bar ──
  Widget _buildBottomNavBar() {
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
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrdersPage()));
          } else {
            setState(() => _selectedIndex = index);
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

// ──────────────────────────────────────────────
// SUGGESTED ITEM CARD
// ──────────────────────────────────────────────

class _SuggestedItemCard extends StatelessWidget {
  final FoodItem item;

  const _SuggestedItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductDetailScreen()),
        );
      },
      child: Container(
        width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              item.imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 110,
                color: Colors.grey[200],
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.price,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE53935),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

// ──────────────────────────────────────────────
// POPULAR ITEM CARD
// ──────────────────────────────────────────────

class _PopularItemCard extends StatelessWidget {
  final FoodItem item;

  const _PopularItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductDetailScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: Colors.grey[200],
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Price
          Text(
            item.price,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE53935),
            ),
          ),
        ],
      ),
    ));
  }
}
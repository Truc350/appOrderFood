import 'package:flutter/material.dart';
import 'category_detail_screen.dart';

class FoodCategory {
  final String name;
  final String imageUrl;
  final int count;
  final Color bgColor;

  const FoodCategory({
    required this.name,
    required this.imageUrl,
    required this.count,
    required this.bgColor,
  });
}

void showCategoryDrawer(BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false, // Ensures the layout behind is visible
      barrierColor: Colors.black54, // Dim background
      barrierDismissible: true, // Close when tapping outside
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.transparent,
            child: CategoryDrawer(),
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0), // Slide from left
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic, // Smooth slide
          )),
          child: child,
        );
      },
    ),
  );
}

class CategoryDrawer extends StatelessWidget {
  const CategoryDrawer({super.key});

  static const List<FoodCategory> categories = [
    FoodCategory(
      name: 'CƠM',
      imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=300&fit=crop',
      count: 120,
      bgColor: Color(0xFFD7E8C8),
    ),
    FoodCategory(
      name: 'BÚN BÒ',
      imageUrl: 'https://images.unsplash.com/photo-1555126634-323283e090fa?w=400&h=300&fit=crop',
      count: 85,
      bgColor: Color(0xFFF5E6C8),
    ),
    FoodCategory(
      name: 'PHỞ',
      imageUrl: 'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=400&h=300&fit=crop',
      count: 64,
      bgColor: Color(0xFFE8D5C4),
    ),
    FoodCategory(
      name: 'MÌ',
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=300&fit=crop',
      count: 47,
      bgColor: Color(0xFFFDE8CC),
    ),
    FoodCategory(
      name: 'NUI',
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=300&fit=crop',
      count: 93,
      bgColor: Color(0xFFD4E8F0),
    ),
    FoodCategory(
      name: 'HỦ TIẾU',
      imageUrl: 'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=400&h=300&fit=crop',
      count: 38,
      bgColor: Color(0xFFE8C8C8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.75, // side drawer takes up 75% width
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(5, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 12, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Danh mục',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gợi ý hôm nay',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 26),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.black12),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 110,
                    child: _CategoryCard(category: categories[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final FoodCategory category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close the drawer
        
        String id = 'pho';
        final name = category.name.toLowerCase();
        if (name.contains('cơm')) id = 'com';
        else if (name.contains('hủ tiếu')) id = 'hutieu';
        else if (name.contains('bún bò')) id = 'bunbo';
        else if (name.contains('mì')) id = 'mi';
        else if (name.contains('nui')) id = 'nui';
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryDetailScreen(
              categoryId: id,
              categoryName: category.name,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              category.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: category.bgColor,
                child: const Icon(Icons.fastfood, color: Colors.white, size: 36),
              ),
            ),
            // Gradient to make the left text highly visible
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${category.count} món',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
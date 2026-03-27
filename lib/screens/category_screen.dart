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
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const CategoryDrawer(),
  );
}

class CategoryDrawer extends StatelessWidget {
  const CategoryDrawer({super.key});

  static const List<FoodCategory> categories = [
    FoodCategory(
      name: 'CƠM',
      imageUrl:
      'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=300&fit=crop',
      count: 120,
      bgColor: Color(0xFFD7E8C8),
    ),
    FoodCategory(
      name: 'BÚN BÒ',
      imageUrl:
      'https://images.unsplash.com/photo-1555126634-323283e090fa?w=400&h=300&fit=crop',
      count: 85,
      bgColor: Color(0xFFF5E6C8),
    ),
    FoodCategory(
      name: 'PHỞ',
      imageUrl:
      'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=400&h=300&fit=crop',
      count: 64,
      bgColor: Color(0xFFE8D5C4),
    ),
    FoodCategory(
      name: 'MÌ',
      imageUrl:
      'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=300&fit=crop',
      count: 47,
      bgColor: Color(0xFFFDE8CC),
    ),
    FoodCategory(
      name: 'NUI',
      imageUrl:
      'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=300&fit=crop',
      count: 93,
      bgColor: Color(0xFFD4E8F0),
    ),
    FoodCategory(
      name: 'HỦ TIẾU',
      imageUrl:
      'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=400&h=300&fit=crop',
      count: 38,
      bgColor: Color(0xFFE8C8C8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.55,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thực đơn',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      'Khám phá tinh hoa ẩm thực Việt',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[500],
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 22),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.black54,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.55,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _CategoryCard(category: categories[index]);
                },
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
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
        Navigator.pop(context);
        
        String id = 'pho';
        if (category.name.toLowerCase().contains('cơm')) id = 'com';
        else if (category.name.toLowerCase().contains('hủ tiếu')) id = 'hutieu';
        
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
        borderRadius: BorderRadius.circular(14),
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

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.65),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),

            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  decoration: TextDecoration.none,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 4,
                      offset: Offset(0, 1),
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
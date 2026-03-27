import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cartItems = [
    {
      'name': 'Cơm tấm sườn bì',
      'restaurant': 'Quán Cơm Tấm Đêm',
      'price': 45000,
      'quantity': 1,
      'checked': true,
      'image': 'assets/images/cart/com_tam.png',
    },
    {
      'name': 'Phở bò tái nạm',
      'restaurant': 'Phở Hà Nội',
      'price': 50000,
      'quantity': 1,
      'checked': true,
      'image': 'assets/images/cart/pho.png',
    },
    {
      'name': 'Hủ tiếu Nam Vang',
      'restaurant': 'Hủ Tiếu Nam Vang',
      'price': 40000,
      'quantity': 1,
      'checked': true,
      'image': 'assets/images/cart/hu_tieu.png',
    },
    {
      'name': 'Mì cay đủ loại 7 cấp',
      'restaurant': 'Mì Cay Sasin',
      'price': 55000,
      'quantity': 1,
      'checked': false,
      'image': 'assets/images/cart/mi_cay.png',
    },
  ];

  int get _totalPrice {
    return _cartItems.where((item) => item['checked'] == true).fold(0, (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int));
  }

  bool get _isAllChecked => _cartItems.isNotEmpty && _cartItems.every((item) => item['checked']);

  String _formatPrice(int price) {
    return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ';
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQty = _cartItems[index]['quantity'] + delta;
      if (newQty >= 0) {
        _cartItems[index]['quantity'] = newQty;
      }
    });
  }

  void _toggleItem(int index, bool? value) {
    setState(() {
      _cartItems[index]['checked'] = value ?? false;
    });
  }

  void _toggleAll(bool? value) {
    setState(() {
      for (var item in _cartItems) {
        item['checked'] = value ?? false;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _removeSelected() {
    setState(() {
      _cartItems.removeWhere((item) => item['checked'] == true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            if (_cartItems.isNotEmpty) _buildSelectAllRow(),
            Expanded(
              child: _cartItems.isEmpty
                  ? const Center(child: Text('Giỏ hàng trống'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        return _buildCartItem(index);
                      },
                    ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
          const Text(
            'Giỏ hàng',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildSelectAllRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
               Checkbox(
                value: _isAllChecked,
                onChanged: _toggleAll,
                activeColor: const Color(0xFFD81F19), // Theme red
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Text(
                'Tất cả',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: _cartItems.any((item) => item['checked']) ? _removeSelected : null,
            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
            label: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(int index) {
    final item = _cartItems[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: item['checked'],
            onChanged: (val) => _toggleItem(index, val),
            activeColor: const Color(0xFFD81F19), // Theme red
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              item['image'],
              width: 65,
              height: 65,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 65,
                  height: 65,
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatPrice(item['price']),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD81F19), // Theme red
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildQtyBtn(Icons.remove, () => _updateQuantity(index, -1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '${item['quantity']}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildQtyBtn(Icons.add, () => _updateQuantity(index, 1), isAdd: true),
                      ],
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _removeItem(index),
                      icon: const Icon(Icons.delete_outline, color: Color(0xFFD81F19), size: 22), // Theme red
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap, {bool isAdd = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isAdd ? const Color(0xFFD81F19) : Colors.grey[200], // Theme red for add, grey for minus
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isAdd ? Colors.white : Colors.black87,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Color(0xFFD81F19), // Theme red
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               const Text(
                'Tổng cộng',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                _formatPrice(_totalPrice),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFD81F19), // Theme red
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Mua ngay',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

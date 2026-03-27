import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final int price;
  int quantity;
  final String imageUrl;
  final String optionsLabel;
  bool isChecked;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.optionsLabel = '',
    this.isChecked = true,
  });

  int get totalPrice => price * quantity;
}

class CartManager extends ChangeNotifier {
  static final CartManager instance = CartManager._internal();
  CartManager._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Tổng tiền của các món đang check
  int get selectedTotalPrice {
    return _items
        .where((item) => item.isChecked)
        .fold(0, (sum, item) => sum + item.totalPrice);
  }

  bool get isAllChecked {
    if (_items.isEmpty) return false;
    return _items.every((item) => item.isChecked);
  }

  void addItem(CartItem newItem) {
    // Check if item with same id & options exists
    final index = _items.indexWhere(
        (i) => i.id == newItem.id && i.optionsLabel == newItem.optionsLabel);

    if (index != -1) {
      _items[index].quantity += newItem.quantity;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuantity(int index, int delta) {
    if (index >= 0 && index < _items.length) {
      final newQty = _items[index].quantity + delta;
      if (newQty > 0) {
        _items[index].quantity = newQty;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void toggleItem(int index, bool value) {
    if (index >= 0 && index < _items.length) {
      _items[index].isChecked = value;
      notifyListeners();
    }
  }

  void toggleAll(bool value) {
    for (var item in _items) {
      item.isChecked = value;
    }
    notifyListeners();
  }

  void removeSelected() {
    _items.removeWhere((item) => item.isChecked);
    notifyListeners();
  }
}

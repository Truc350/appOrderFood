import '../screens/orders_page.dart';

class OrderManager {
  static final OrderManager instance = OrderManager._();
  OrderManager._();

  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.insert(0, order);
  }
}
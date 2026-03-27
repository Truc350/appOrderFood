import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = 'Tiền mặt';

  final List<Map<String, dynamic>> orderItems = [
    {
      'name': '1 x Bún bò truyền thống',
      'sub': 'Size L, ít cay',
      'price': 90000,
      'icon': Icons.ramen_dining,
    },
    {
      'name': '1 x Coca',
      'sub': 'Lon 330ml',
      'price': 10000,
      'icon': Icons.local_drink,
    },
  ];

  int get subtotal => orderItems.fold(0, (sum, item) => sum + (item['price'] as int));
  int get shippingFee => 15000;
  int get discount => 0;
  int get total => subtotal + shippingFee - discount;

  String formatPrice(int price) {
    return '${price ~/ 1000}.000đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F2),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AppBar
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 8,
                      right: 16,
                      bottom: 12,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, size: 22),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Thanh toán',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Delivery info section
                  _sectionLabel('Thông tin giao hàng'),
                  const SizedBox(height: 8),


                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: _cardDecoration(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFECEA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.location_on, color: Color(0xFFE84B3A), size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nhà riêng',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '123 Đường Lê Lợi, Phường Bến Thành, Quận 1, TP. Hồ Chí Minh',
                                style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Thay\nđổi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFE84B3A),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _sectionLabel('Đơn hàng của bạn'),
                  const SizedBox(height: 6),

                  // Address card


                  const SizedBox(height: 10),

                  // Order items
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: _cardDecoration(),
                    child: Column(
                      children: orderItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(item['icon'] as IconData, size: 24, color: Colors.grey[500]),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'] as String,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item['sub'] as String,
                                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    formatPrice(item['price'] as int),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            if (index < orderItems.length - 1)
                              Divider(height: 1, color: Colors.grey[100]),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Voucher
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: _cardDecoration(),
                      child: Row(
                        children: [
                          const Icon(Icons.discount_outlined, color: Color(0xFFE84B3A), size: 20),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Áp dụng mã giảm giá',
                              style: TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Payment method
                  _sectionLabel('Phương thức thanh toán'),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _paymentOption(
                          label: 'Tiền mặt',
                          icon: Icons.payments_outlined,
                        ),
                        const SizedBox(width: 12),
                        _paymentOption(
                          label: 'Thẻ',
                          icon: Icons.credit_card,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Price summary
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: _cardDecoration(),
                    child: Column(
                      children: [
                        _summaryRow('Tạm tính', formatPrice(subtotal), Colors.black87),
                        const SizedBox(height: 10),
                        _summaryRow('Phí vận chuyển', formatPrice(shippingFee), Colors.black87),
                        const SizedBox(height: 10),
                        _summaryRow('Giảm giá', '-${formatPrice(discount)}', const Color(0xFFE84B3A)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Bottom bar
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
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TỔNG THANH TOÁN',
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                    Text(
                      formatPrice(total),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD05A3A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ĐẶT HÀNG\nNGAY',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                        ],
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

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _paymentOption({required String label, required IconData icon}) {
    final isSelected = selectedPayment == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedPayment = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFE84B3A) : Colors.grey[200]!,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 24, color: isSelected ? const Color(0xFFE84B3A) : Colors.grey[500]),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? const Color(0xFFE84B3A) : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: valueColor)),
      ],
    );
  }
}
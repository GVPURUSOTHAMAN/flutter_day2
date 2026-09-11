import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../Add to cart/cartmodel.dart';
import '../Add to cart/cartprovider.dart';
import '../core/api constants/api_constant.dart';
import '../order Success Page/orderscreen.dart';

class CheckoutScreen extends StatefulWidget {
  final String userId;
  final String addressId;
  final String address;
  final String landmark;
  final String cityId;

  const CheckoutScreen({
    super.key,
    required this.userId,
    required this.addressId,
    required this.address,
    required this.landmark,
    required this.cityId,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPaymentMethod = '1';

  double deliveryCharge = 0.0;
  double couponAmount = 0.0;
  double walletAmount = 0.0;

  bool isPlacingOrder = false;

  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  String cleanApiResponse(String response) {
    String cleaned = response.trim();
    final jsonStart = cleaned.indexOf('{');
    if (jsonStart > 0) {
      cleaned = cleaned.substring(jsonStart);
    }
    final jsonEnd = cleaned.lastIndexOf('}');

    if (jsonEnd >= 0 && jsonEnd < cleaned.length - 1) {
      cleaned = cleaned.substring(0, jsonEnd + 1);
    }

    return cleaned.trim();
  }

  // ------------------------------------------------------------
  // SHOW PAYMENT METHOD
  // ------------------------------------------------------------
  Widget paymentMethod({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool selected = selectedPaymentMethod == value;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: isPlacingOrder
          ? null
          : () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF7D6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFFFEC800) : const Color(0xFFE5E5E5),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFFEC800)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected ? const Color(0xFF8C0021) : Colors.black54,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: selectedPaymentMethod,
              activeColor: const Color(0xFF8C0021),
              onChanged: isPlacingOrder
                  ? null
                  : (value) {
                if (value == null) return;

                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PRICE FORMAT
  // ------------------------------------------------------------
  String money(double value) {
    return '₹${value.toStringAsFixed(2)}';
  }
  // ------------------------------------------------------------
  // PLACE ORDER
  // ------------------------------------------------------------
  Future<void>  placeOrder() async {
    if (isPlacingOrder) return;
    final cartProvider = context.read<CartProvider>();
    final List<CartItem> cartItems = cartProvider.items;
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      return;
    }

    setState(() {
      isPlacingOrder = true;
    });

    try {
      final double subtotal = cartProvider.subtotal;
      final double total = subtotal + deliveryCharge - couponAmount - walletAmount;
      final List<Map<String, dynamic>> productData = cartItems.map((item) {
        debugPrint('ORDER IMAGE: ${item.image}');
        return {
          'title': item.title,
          'variation': '',
          'price': item.price.toStringAsFixed(2),
          'qty': item.quantity,
          'discount': '0',
          'image': item.image,
          'pid': item.productid,
        };
      }).toList();

      // --------------------------------------------------------
      // IMPORTANT:
      // NO DELIVERY TIME SELECTION.
      // tslot is sent empty.
      // --------------------------------------------------------
      final Map<String, dynamic> orderData = {
        'uid': widget.userId,
        'type': 'Normal',
        'p_method_id': selectedPaymentMethod,

        // Primary address only
        'full_address': widget.address,
        'aid': widget.addressId,
        'landmark': widget.landmark,

        'd_charge': deliveryCharge.toStringAsFixed(2),

        'cou_id': '0',
        'cou_amt': couponAmount.toStringAsFixed(2),

        'wall_amt': walletAmount.toStringAsFixed(2),

        'transaction_id': '',

        'city_id': widget.cityId,

        'product_total': total.toStringAsFixed(2),
        'product_subtotal': subtotal.toStringAsFixed(2),

        'a_note': noteController.text.trim(),

        'ndate': DateFormat('dd-MM-yyyy').format(DateTime.now()),

        // No delivery time
        'tslot': '',

        'ProductData': productData,
      };

      debugPrint('====================================');
      debugPrint('PLACE ORDER');
      debugPrint('ORDER URL: ${ApiConstant.url}d_order_now.php');
      debugPrint('ORDER DATA: ${jsonEncode(orderData)}');
      debugPrint('====================================');

      final response = await http.post(
        Uri.parse('${ApiConstant.url}d_order_now.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(orderData),
      );

      debugPrint('ORDER STATUS: ${response.statusCode}');

      debugPrint('ORDER RESPONSE:\n${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      // --------------------------------------------------------
      // CLEAN PHP WARNING OUTPUT
      // --------------------------------------------------------
      final String cleanedResponse = cleanApiResponse(response.body);

      debugPrint('CLEAN ORDER RESPONSE: $cleanedResponse');

      if (cleanedResponse.isEmpty) {
        throw Exception('Empty response from server');
      }

      Map<String, dynamic> responseData;

      try {
        responseData = jsonDecode(cleanedResponse) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('JSON PARSE ERROR: $e');

        throw Exception('Invalid response from server');
      }

      debugPrint('PARSED ORDER RESPONSE: $responseData');
      final String responseCode = responseData['ResponseCode']?.toString() ?? '';
      final String result = responseData['Result']?.toString().toLowerCase() ?? '';
      final String responseMessage = responseData['ResponseMsg']?.toString() ?? 'Unable to place order';

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------
      if (responseCode == '200' && result == 'true') {
        if (!mounted) return;

        cartProvider.clearCart();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseMessage),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrderScreen()),
        );

        return;
      }

      // --------------------------------------------------------
      // FAILED
      // --------------------------------------------------------
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      debugPrint('ORDER ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isPlacingOrder = false;
        });
      }
    }
  }

  // ------------------------------------------------------------
  // ADDRESS CARD
  // ------------------------------------------------------------
  Widget addressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5CC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF8C0021),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 7),
                Text(
                  widget.address.isEmpty ? 'Primary Address' : widget.address,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
                if (widget.landmark.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    'Landmark: ${widget.landmark}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6EA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'PRIMARY',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ORDER ITEMS
  // ------------------------------------------------------------
  Widget orderItems(List<CartItem> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Items',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 15),
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: item.image.isNotEmpty
                        ? Image.network(
                      item.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.black26,
                        );
                      },
                    )
                        : const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.quantity} × ${money(item.price)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    money(item.price),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PRICE SUMMARY
  // ------------------------------------------------------------
  Widget priceSummary(double subtotal, double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Price Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 15),
          priceRow('Subtotal', money(subtotal)),
          const SizedBox(height: 10),
          priceRow(
            'Delivery Charge',
            deliveryCharge == 0 ? 'FREE' : money(deliveryCharge),
          ),
          if (couponAmount > 0) ...[
            const SizedBox(height: 10),
            priceRow('Coupon Discount', '- ${money(couponAmount)}'),
          ],
          if (walletAmount > 0) ...[
            const SizedBox(height: 10),
            priceRow('Wallet', '- ${money(walletAmount)}'),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          priceRow('Total', money(total), bold: true),
        ],
      ),
    );
  }

  Widget priceRow(String title, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: bold ? Colors.black87 : Colors.black54,
            fontWeight: bold ? FontWeight.w800 : null,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 17 : 13,
            color: bold ? const Color(0xFF8C0021) : Colors.black87,
            fontWeight: bold ? FontWeight.w900 : null,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // NOTE FIELD
  // ------------------------------------------------------------
  Widget noteField() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Note',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: noteController,
            maxLines: 3,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: 'Add a note for your order (optional)',
              hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
              filled: true,
              fillColor: const Color(0xFFF8F8F8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final List<CartItem> items = cartProvider.items;
    final double subtotal = cartProvider.subtotal;

    double total = subtotal + deliveryCharge - couponAmount - walletAmount;

    if (total < 0) {
      total = 0;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8EF),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Color(0xFF8C0021),
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF8C0021)),
      ),
      body: items.isEmpty
          ? const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      )
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addressCard(),
              const SizedBox(height: 15),

              orderItems(items),

              const SizedBox(height: 15),

              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 12),

              paymentMethod(
                value: '1',
                title: 'Cash on Delivery',
                subtitle: 'Pay when your order arrives',
                icon: Icons.local_atm_rounded,
              ),

              paymentMethod(
                value: '2',
                title: 'Wallet',
                subtitle: 'Pay using wallet balance',
                icon: Icons.account_balance_wallet_rounded,
              ),

              paymentMethod(
                value: '3',
                title: 'Online Payment',
                subtitle: 'Pay securely online',
                icon: Icons.payment_rounded,
              ),

              const SizedBox(height: 4),

              noteField(),

              const SizedBox(height: 15),

              priceSummary(subtotal, total),
            ],
          ),
        ),
      ),
      bottomNavigationBar: items.isEmpty
          ? null
          : SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      money(total),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF8C0021),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 53,
                  child: ElevatedButton(
                    onPressed: isPlacingOrder ? null : placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8C0021),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: isPlacingOrder
                        ? const SizedBox(
                      width: 23,
                      height: 23,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Place Order',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

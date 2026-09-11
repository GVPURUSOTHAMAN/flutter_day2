import 'package:cached_network_image/cached_network_image.dart';
import 'package:day2/checkout%20page/checkout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/api constants/api_constant.dart';
import 'cartmodel.dart';
import 'cartprovider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String getImageUrl(String image) {
    if (image.trim().isEmpty) return '';
    var value = image.trim();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      value = value.replaceFirst(RegExp(r'/app/product(?!/)'), '/app/product/');
      return value;
    }

    final cleanImage = value.replaceFirst(RegExp(r'^/+'), '');
    final base = ApiConstant.imageBaseUrl.endsWith('/') ? ApiConstant.imageBaseUrl : '${ApiConstant.imageBaseUrl}/';
    return '$base$cleanImage';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, provider, child) {
                return IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: Text("Clear Cart?"),
                          content: Text(
                              "Are you sure you want to remove all products from your cart?"
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<CartProvider>().clearCart();
                                Navigator.pop(dialogContext);
                              },
                              child: Text("Clear"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete_sweep),
                );
              }
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, product, child) {
          if (product.items.isEmpty) {
            return _emptyproduct(context);
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: product.items.length,
                  itemBuilder: (context, index) {
                    final item = product.items[index];
                    return _productItem(context, item);
                  },
                ),
              ),
              _bottomSummary(context, product),
            ],
          );
        },
      ),
    );
  }

  Widget _productItem(BuildContext context, CartItem item) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: getImageUrl(item.image),
                height: 90,
                width: 90,
                fit: BoxFit.contain,
                placeholder: (context, url) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Container(
                    height: 90,
                    width: 90,
                    color: Colors.grey.shade200,
                    child: Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "₹${item.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (item.unitValue.isNotEmpty || item.unit.isNotEmpty)
                    Text(
                      "${item.unitValue} ${item.unit}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          constraints: BoxConstraints(
                            minHeight: 35,
                            maxWidth: 35,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            context.read<CartProvider>().decrease(
                              item.productid,
                            );
                          },
                          icon: Icon(
                            Icons.remove,
                            size: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Center(
                          child: Text(
                            "${item.quantity}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: IconButton(
                          constraints: BoxConstraints(
                            minHeight: 35,
                            maxWidth: 35,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {context.read<CartProvider>().increase(item.productid);
                          },
                          icon: Icon(
                            Icons.add,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<CartProvider>().removeCart(item.productid);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "₹${item.total.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSummary(BuildContext context, CartProvider cart) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Items",
                  style: TextStyle(fontSize: 15),
                ),
                Text("Total",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(width: 220,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${cart.itemCount}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("₹${cart.subtotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen(userId: '1', addressId: '1', address: "primary address0", landmark: "", cityId: "1")));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Checkout"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Proceed to Checkout",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyproduct(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart,
              size: 100,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 20),
            Text(
              "Your cart is empty",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Add some products to your cart and they will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              child: Text("Continue Shopping"),
            ),
          ],
        ),
      ),
    );
  }
}
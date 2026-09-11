import 'package:cached_network_image/cached_network_image.dart';
import 'package:day2/Add%20to%20cart/cartscreen.dart';
import 'package:day2/product/provider/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Add to cart/cartmodel.dart';
import '../../Add to cart/cartprovider.dart';
import '../../core/api constants/api_constant.dart';
import '../../fav/fav.dart';
import '../../fav/favprovider.dart';
import '../../homePage/models/product.dart';
import '../../homePage/provider/home_provider.dart';

class SelectProductScreen extends StatefulWidget {
  final String title;
  final String catid;
  final String productid;

  const SelectProductScreen({
    super.key,
    required this.title,
    required this.catid,
    required this.productid,
  });

  @override
  State<SelectProductScreen> createState() => _SelectProductScreenState();
}
class _SelectProductScreenState extends State<SelectProductScreen> {
  int quantity = 1;
  bool addtocart = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProductProvider>().loadpdturl(widget.catid);
    });
  }
  String getImageUrl(String image) {
    if (image.trim().isEmpty) {
      return '';
    }
    final value = image.trim();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    final cleanImage = value.replaceFirst(RegExp(r'^/+'), '');
    final base = ApiConstant.imageBaseUrl.endsWith('/') ? ApiConstant.imageBaseUrl : '${ApiConstant.imageBaseUrl}/';
    return '$base$cleanImage';
  }
  void increment() {
    setState(() {
      quantity++;
    });
  }
  void decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }
  void addproducttocard(Product product) {
    if (addtocart) return;
    setState(() {
      addtocart = true;
    });

    final cartItem = CartItem(
      productid: product.productid,
      title: product.title,
      image: getImageUrl(product.productimg),
      price: double.tryParse(product.regularprice) ?? 0,
      subscribePrice: product.subscriberprice,
      unit: product.unit,
      unitValue: product.unitvalue,
      quantity: quantity,
    );
    context.read<CartProvider>().addtocart(cartItem);
    setState(() {
      addtocart = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$quantity  ${product.title} added to cart',
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CartScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.back),
        ),
        title: Text(widget.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen()));
              },
                icon: Icon(Icons.shopping_cart_outlined),
              ),
              if(cart.itemCount > 0)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text("${cart.itemCount}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errormsg != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),

                    SizedBox(height: 10),
                    Text("Something went wrong",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),
                    Text(
                      provider.errormsg!,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        provider.loadpdturl(widget.catid);
                      },
                      child: Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }
          final products = provider.products;
          if (products.isEmpty) {
            return Center(
              child: Text(
                "No products available",
              ),
            );
          }
          final matchingProducts = products.where(
                (item) => item.productid.toString() == widget.productid.toString(),).toList();

          if (matchingProducts.isEmpty) {
            return Center(
              child: Text(
                "Product not found",
              ),
            );
          }

          final product = matchingProducts.first;
          final double price = double.tryParse(product.regularprice) ?? 0;
          final double total = price * quantity;
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey.shade50,
                  child: CachedNetworkImage(
                    imageUrl: getImageUrl(product.productimg),
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Center(
                        child: Icon(Icons.image_not_supported,
                          size: 60,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(product.title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text("₹${product.regularprice}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),

                      SizedBox(height: 8),
                      if (product.unitvalue.isNotEmpty)
                        Text("${product.unitvalue} ${product.unit}",
                          style: TextStyle(
                            fontSize: 14,
                            color:
                            Colors.grey.shade600,
                          ),
                        ),
                      SizedBox(height: 12),
                      if (product.pdesc.isNotEmpty) ...[
                        Text("Description",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(product.pdesc,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                      Divider(color: Colors.grey.shade200,),
                      SizedBox(height: 16),
                      Text("Quantity",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                              icon: Icon(Icons.remove,
                                size: 20,
                              ),
                            ),
                          ),

                          SizedBox(width: 16),
                          Text('$quantity',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(width: 16),
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              icon: Icon(Icons.add,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("₹${total.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            addproducttocard(product);
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),

                            elevation: 0,
                          ),
                          child: Text("Add to Cart",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
        },
      ),
    );
  }
}
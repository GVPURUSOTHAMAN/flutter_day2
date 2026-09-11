import 'package:cached_network_image/cached_network_image.dart';
import 'package:day2/category/category%20Screen/selectproduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api constants/api_constant.dart';
import '../../product/provider/product_provider.dart';

class ListCat extends StatefulWidget {
  final String title;
  final String catid;

  const ListCat({super.key, required this.title, required this.catid});

  @override
  State<ListCat> createState() => _ListCatState();
}

class _ListCatState extends State<ListCat> {
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    // Load API data when screen opens
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
    final base = ApiConstant.imageBaseUrl.endsWith('/')
        ? ApiConstant.imageBaseUrl
        : '${ApiConstant.imageBaseUrl}/';
    final finalUrl = '$base$cleanImage';
    debugPrint('PRODUCT IMAGE: $image');
    debugPrint('FINAL IMAGE URL: $finalUrl');
    return finalUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.back),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errormsg != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline_outlined,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Something went wrong",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(provider.errormsg!,
                        textAlign: TextAlign.center
                    ),
                    const SizedBox(height: 8),
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
          // final pdturl = provider.loadpdturl(widget.catid);
          return ListView.builder(
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.products.length,
            padding: EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final product = provider.products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SelectProductScreen(
                        title: product.title,
                        catid: product.catid,
                        productid: product.productid,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: getImageUrl(product.productimg),
                          height: 85,
                          width: 85,
                          fit: BoxFit.contain,
                          placeholder: (context, url) {
                            return Container(
                              height: 85,
                              width: 85,
                              color: Colors.grey.shade100,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return Container(
                              height: 85,
                              width: 85,
                              color: Colors.grey.shade100,
                              child: const Icon(
                                Icons.fastfood,
                                size: 35,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "₹${product.regularprice}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 34,
                        width: 34,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: const Icon(Icons.add, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

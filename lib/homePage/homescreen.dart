import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:day2/category/category%20Screen/listcat.dart';
import 'package:day2/category/category%20Screen/selectproduct.dart';
import 'package:day2/homePage/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../category/category Screen/categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState(){
    super.initState();
    // Load API data when screen opens
    Future.microtask(() {
      context.read<HomeProvider>().loadhomeurl();
    },);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        ),
        centerTitle: true,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
        // LOADING
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // if error
        if (provider.errormsg != null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.error_outline_outlined,
                    size: 60,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 10,),
                  Text("Something went wrong",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Text(provider.errormsg!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8,),
                  ElevatedButton(onPressed: () {
                    provider.loadhomeurl();
                  },
                    child: Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        if(provider.homedata == null){
          return const Center(
            child:  Text("No data available",
            style: TextStyle(fontSize: 16,
            ),
            ),
          );
        }
        final homeData = provider.homedata!;
        // home context
        return RefreshIndicator(onRefresh: provider.loadhomeurl,
            child: ListView(
              physics:  AlwaysScrollableScrollPhysics(),
              children: [
                if(homeData.Bannerhome.isNotEmpty)...[
                  const SizedBox(height: 10,),
                  CarouselSlider.builder(
                      itemCount: homeData.Bannerhome.length,
                      itemBuilder: (BuildContext context, int index, int realIndex) {
                        final banner = homeData.Bannerhome[index];
                        return GestureDetector(
                          onTap: (){
                            debugPrint("Banner clicked: ${banner.id}");
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: banner.img,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                         height: 200,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 4),
                        autoPlayAnimationDuration: Duration(
                          milliseconds: 800
                        ),
                        viewportFraction: 0.94,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: true,
                      ),
                  ),
                ],

                // CATEGORIES

                if (homeData.categoryhome.isNotEmpty) ...[
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(catid: 'id'.toString(), cattitle: 'title'.toString(), uid: 'id'.toString(),),));
                            debugPrint('View all categories');
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: homeData.categoryhome.length,
                      itemBuilder: (context, index) {
                        final category = homeData.categoryhome[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ListCat(title: category.title, catid: category.id),));
                            debugPrint('Category ID: ${category.id}');
                            debugPrint('Category ID: ${category.title}');
                          },
                          child: Container(
                            width: 105,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                // Category Image
                                Container(
                                  height: 85,
                                  width: 85,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.08,
                                        ),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl: category.catimg,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return const Icon(
                                          Icons.category,
                                          size: 35,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Category Name
                                Text(category.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                // PRODUCTS
                if (homeData.producthome.isNotEmpty) ...[
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Product',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            debugPrint('View all product');
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: homeData.producthome.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.63
                      ),
                      itemBuilder: (context, index) {
                        final prod = homeData.producthome[index];
                        return GestureDetector(
                          onTap: (){
                            debugPrint("Product id : ${prod.productid}");
                            Navigator.push(context, MaterialPageRoute(builder: (_) => SelectProductScreen(title: prod.title, catid: prod.catid, productid: prod.productid),));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: prod.productimg,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return Container(
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
                                          color: Colors.grey.shade100,
                                          child: const Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 40,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // PRODUCT DETAILS
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Product title
                                        Text(prod.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        // Unit
                                        if (prod.unitvalue.isNotEmpty)
                                          Text(
                                            '${prod.unitvalue} ${prod.unit}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        const Spacer(),
                                        // Price
                                        Row(
                                          children: [
                                            Text('\$${prod.regularprice}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            // Add button
                                            Container(
                                              height: 34,
                                              width: 34,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Subscribe price
                                        if (prod.subscriberprice.isNotEmpty &&
                                            prod.subscriberprice != '0') ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            'Subscribe ₹${prod.subscriberprice}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                  ),
                ],
                // Bottom spacing
                const SizedBox(height: 30),
              ],
            ),
        );
      },
      ),
    );
  }
}

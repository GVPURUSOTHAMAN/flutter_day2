import 'package:day2/category/provider/category_provider.dart';
import 'package:day2/product/provider/product_provider.dart';
import 'package:day2/product/resposiontary/product_resposiontary.dart';
import 'package:day2/splash%20screen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Add to cart/cartprovider.dart';
import 'Add to cart/cartrepository.dart';
import 'bottomnavigation.dart';
import 'category/respository/category_respository.dart';
import 'homePage/homescreen.dart';
import 'homePage/provider/home_provider.dart';
import 'homePage/repository/repository.dart';
import 'login/login.dart';
import 'login/loginprovider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider(repository: Repository()),),
        ChangeNotifierProvider(create: (_) => ProductProvider(repository: ProductRepository())),
        ChangeNotifierProvider(create: (_) => CartProvider(repository: CartRepository())),
      ],
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const BottomNav(),
    );
  }
}
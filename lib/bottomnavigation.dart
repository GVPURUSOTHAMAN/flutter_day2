import 'package:day2/Add%20to%20cart/cartscreen.dart';
import 'package:day2/profile.dart';
import 'package:flutter/material.dart';

import 'fav/fav.dart';
import 'homePage/homescreen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  late final List<Widget> pages = [
    const HomeScreen(),
    const CartScreen(),
    const Fav(),
    const Profile(),
  ];

  final List<String> labels = [
    "Home",
    "Cart",
    "Wishlist",
    "Profile",
  ];

  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.shopping_cart_outlined,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10,
          ),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepOrange,
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(icons.length, (index) {
                  final bool isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 250,
                      ),
                      width: 62,
                      height: 45,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE9E9E9)
                            : Colors.transparent,
                        borderRadius:
                        BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            icons[index],
                            size: 20,
                            color: const Color(0xFF333333),
                          ),

                          const SizedBox(height: 1),

                          Text(
                            labels[index],
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

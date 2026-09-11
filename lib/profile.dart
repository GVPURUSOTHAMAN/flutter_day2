import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  void logoutdialog(){
    showDialog(context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text("Logout",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("Do you want Logout?",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context);
            },
              child: Text("Cancel",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),
            ElevatedButton(onPressed: (){
              SnackBar(content: Text("logout"));
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text("Logout",),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector( onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: const EdgeInsets.all(20),
                            child: InteractiveViewer(
                              minScale: 0.5,
                              maxScale: 1.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset( 'assets/vijay.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/vijay.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Purusoth',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.edit_outlined,
                                size: 18,
                              ),
                              color: Colors.green,
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'gvp@gmail.com',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(height: 1,),
              ListView(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.shopping_bag_outlined,),
                      ),
                      Text("order",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 1,),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.badge_outlined),
                      ),
                      Text("My Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 1,),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.location_on_outlined),
                      ),
                      Text("Delivery Address",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 1,),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.credit_card_outlined),
                      ),
                      Text("Payment Methods",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 1,),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.local_offer_outlined),
                      ),
                      Text("Promo Card",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 1,),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.notifications_none_outlined),
                      ),
                      Text("Notification",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 1,),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.help_outline),
                      ),
                      Text("Help",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 1,),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.info_outline),
                      ),
                      Text("About",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: (){
                        logoutdialog();
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green,
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 20,),
                            Icon(Icons.logout_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 80,),
                            Center(
                              child: Text("Logout",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:loop_cart/features/client/presentation/widgets/account/user_account.dart';
import 'package:loop_cart/features/client/presentation/widgets/home/client_home.dart';
class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  int currentPage = 0;
  final List<Widget> contents = [
    // Improved home page content
   ClientHome(),
    // Improved account page content
   const UserAccount(),
    // Improved cart page content
    const Center(
      child: Text(
        "Your Cart",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    ),
  ];

  void setPage(int value) {
    setState(() {
      currentPage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title: SizedBox(
            width: 120, // Set desired width
            height: 120, // Set desired height
            child: Image.asset(
              "assets/images/loop_cart_logo.png",
              fit: BoxFit.contain, // Ensure the image fits within the box
            ),
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Action for notifications
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Action for notifications
              },
            ),
          ],
        ),
      ),
      body: contents[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: currentPage,
        onTap: (value) {
          setPage(value);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
          ),
          BottomNavigationBarItem(
            icon: badges.Badge(
              badgeContent: Text('3'),
              child: Icon(Icons.shopping_cart),
            ),
            label: "Cart",
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loop_cart/features/client/presentation/widgets/account/user_account.dart';
import 'package:loop_cart/features/client/presentation/widgets/home/client_home.dart';

import '../../cart/modal/cart_modal.dart';
import '../../cart/presentation/screen/show_carts.dart';
import '../../cart/view_modal/cart_provider.dart';
class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  int currentPage = 0;
  final List<Widget> contents = [
    // Improved home page content
   const ClientHome(),
    // Improved account page content
   const UserAccount(),
    // Improved cart page content
    const ShowCarts()
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
        preferredSize: const Size.fromHeight(70),
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
            // IconButton(
            //   icon: const Icon(Icons.search),
            //   onPressed: () {
            //     // Action for notifications
            //   },
            // ),
            Consumer(
                builder: (context,ref,child) {
                  List<CartModal>  carts = ref.watch(cartProvider);
                  return GestureDetector(
                    onTap: (){
                      setPage(2);
                    },
                    child: badges.Badge(
                      badgeContent: Text(carts.length.toString()),
                      child: const Icon(Icons.shopping_cart),
                    ),
                  );
                }
            ),
            const SizedBox(width: 20,)

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
        items:  [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
          ),

          BottomNavigationBarItem(
            icon: Consumer(
              builder: (context,ref,child) {
                List<CartModal>  carts = ref.watch(cartProvider);
                return badges.Badge(
                  badgeContent: Text(carts.length.toString()),
                  child: Icon(Icons.shopping_cart),
                );
              }
            ),
            label: "Cart",
          ),
        ],
      ),
    );
  }
}

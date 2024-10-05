
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/admin/modals/transactions_modal.dart';
import 'package:loop_cart/features/admin/presentation/pages/add_product_screen.dart';
import 'package:loop_cart/features/admin/presentation/widgets/admin_home/show_posts.dart';
import 'package:loop_cart/features/admin/presentation/widgets/analytics/show_analytics.dart';
import 'package:loop_cart/features/admin/presentation/widgets/orders/show_orders.dart';
import 'package:loop_cart/features/admin/view_modal/tab_index_provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {



  List<Widget> contents = [
    const ShowPosts(),
   ShowAnalytics(),
    ShowOrders(),
  ];
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
            // IconButton(
            //   icon: const Icon(Icons.add),
            //   onPressed: () {
            //     // Action for notifications
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Action for notifications
              },
            ),
            const Text("Admin",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            const SizedBox(width: 20,),
            // IconButton(
            //   icon: const Icon(Icons.search),
            //   onPressed: () {
            //     // Action for notifications
            //   },
            // ),
          ],
        ),
      ),
      body:Consumer(
        builder: (context,ref,child){
          int currentIndex = ref.watch(tabIndexProvider);
          return contents[currentIndex];
        },
      ),
      bottomNavigationBar: Consumer(
        builder: (context,ref,child) {
          int currentIndex = ref.watch(tabIndexProvider);
          return BottomNavigationBar(

            currentIndex: currentIndex,
            onTap: (vale){
              ref.read(tabIndexProvider.notifier).update((cb)=>vale);
            },
            items:  const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics),
                label: "Analytics",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border_sharp),
                label: "Orders",
              ),
            ],

          );
        }
      ),
        floatingActionButton:FloatingActionButton(
          onPressed: () {
           Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AddProductScreen()));
          },
          tooltip: "Add a product",
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
          ),
          child: Icon(Icons.add),
        )

    );
  }
}

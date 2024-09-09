
import 'package:flutter/material.dart';
import 'package:loop_cart/features/admin/presentation/pages/add_product_screen.dart';
import 'package:loop_cart/features/admin/presentation/widgets/admin_home/show_posts.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {


  int currentIndex = 0;
  List<Widget> contents = [
    ShowPosts(),
    Center(
      child: Text("Admin analytics"),
    ),
    Center(
      child: Text("Orders"),
    ),
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
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Action for notifications
              },
            ),
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
      body:contents[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (vale){
          setState(() {
            currentIndex=vale;
          });
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

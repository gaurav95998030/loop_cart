import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/utils/show_snackbar.dart';


import '../../../address/screens/address_screen.dart';
import '../../modal/cart_modal.dart';
import '../../view_modal/cart_provider.dart';
import '../widgets/show_cart.dart';

class ShowCarts extends StatefulWidget {
  const ShowCarts({super.key});

  @override
  State<ShowCarts> createState() => _ShowCartsState();
}

class _ShowCartsState extends State<ShowCarts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(70),
      //   child: AppBar(
      //     title: SizedBox(
      //       width: 120, // Set desired width
      //       height: 120, // Set desired height
      //       child: Image.asset(
      //         "assets/images/loop_cart_logo.png",
      //         fit: BoxFit.contain, // Ensure the image fits within the box
      //       ),
      //     ),
      //     actions: [
      //       IconButton(
      //         icon: const Icon(Icons.notifications),
      //         onPressed: () {
      //           // Action for notifications
      //         },
      //       ),
      //       IconButton(
      //         icon: const Icon(Icons.search),
      //         onPressed: () {
      //           // Action for notifications
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Consumer(
           builder: (context,ref,child) {
             List<CartModal> carts = ref.watch(cartProvider);
              double getTotal(){
                double sum =0;
                for(var item in carts){
                  sum+=item.quantity*item.price;
                }

                return sum;
              }
             return Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       const Text(
                         "Total",
                         style: TextStyle(
                           fontSize: 30,
                           fontWeight: FontWeight.bold,
                           color: Colors.black87, // Stylish dark color
                         ),
                       ),
                       Container(
                         padding: const EdgeInsets.all(8.0), // Adds padding to make it look more balanced
                         decoration: BoxDecoration(
                           color: Colors.blueAccent.withOpacity(0.1), // Light background for emphasis
                           borderRadius: BorderRadius.circular(10), // Rounded corners
                         ),
                         child: Text(
                           getTotal().toString(),
                           style: const TextStyle(
                             fontSize: 30,
                             fontWeight: FontWeight.bold,
                             color: Colors.blueAccent, // Makes the total more prominent
                           ),
                         ),
                       ),
                     ],
                   ),
                   ElevatedButton(onPressed: (){
                     if(carts.isEmpty){
                       ShowSnackbarMsg.showSnack("Please add items to cart first");
                       return;
                     }
                     Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AddressScreen(carts: carts,)));
                   }, child: Text("Check Out All (${carts.length})"))
                 ],
               )

             );
           }
         ),


          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                List<CartModal> carts = ref.watch(cartProvider);
                return ListView.builder(
                  itemCount: carts.length,
                  itemBuilder: (context, index) {
                    return ShowCart(cart:carts[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}




import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loop_cart/features/client/orders/modals/order_modal.dart';
import 'package:loop_cart/features/client/orders/presentation/screens/order_detail.dart';

import '../../pages/update_order.dart';

class ShowOrders extends StatefulWidget {
  const ShowOrders({super.key});

  @override
  State<ShowOrders> createState() => _ShowOrdersState();
}

class _ShowOrdersState extends State<ShowOrders> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("orders").where("adminId",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),

        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasData){
            List<OrderModal> orders = [];
            QuerySnapshot docs = snapshot.data!;

            for (var item in docs.docs){
              orders.add(OrderModal.fromJson(item.data() as Map<String,dynamic>));
            }

            final formatter = DateFormat.yMd();
            final textStyleBold = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
            final textStyleRegular = TextStyle(fontSize: 15, color: Colors.grey[700]);


            return ListView.builder(
              itemCount: orders.length,
                itemBuilder: (context,index){
                  OrderModal order = orders[index];
                   return GestureDetector(
                     onTap: (){
                       Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>UpdateOrder(order: order)));
                     },
                     child: Padding(
                       padding: const EdgeInsets.all(16.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           const SizedBox(height: 10),
                           Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               // Image with rounded corners and subtle shadow
                               Container(
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(8.0),
                                   boxShadow: [
                                     BoxShadow(
                                       color: Colors.black12,
                                       blurRadius: 8,
                                       offset: Offset(0, 4), // Shadow position
                                     ),
                                   ],
                                 ),
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.circular(8.0), // Rounded corners
                                   child: CachedNetworkImage(
                                     imageUrl: order.product.mainImage,
                                     width: 120,
                                     height: 120,
                                     fit: BoxFit.cover,
                                     progressIndicatorBuilder: (context, url, downloadProgress) =>
                                         Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                     errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                                   ),
                                 ),
                               ),
                               const SizedBox(width: 20), // Space between image and text
                               // Text content with better spacing and typography
                               Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(
                                       order.product.productTitle,
                                       style: textStyleBold.copyWith(fontSize: 20, color: Colors.black87),
                                       overflow: TextOverflow.ellipsis,
                                       maxLines: 2, // Limiting to 2 lines to maintain neatness
                                     ),
                                     const SizedBox(height: 8),
                                     Text(
                                       "Quantity: ${order.product.quantity}",
                                       style: textStyleRegular.copyWith(fontSize: 16, color: Colors.grey[700]),
                                     ),
                                     const SizedBox(height: 8),
                                     // Add a badge or label-like status representation
                                     Container(
                                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                       decoration: BoxDecoration(
                                        // Dynamic background color based on status
                                         borderRadius: BorderRadius.circular(12),
                                       ),
                                       child: Text(
                                         "Status: ${order.status.name}",
                                         style: textStyleBold.copyWith(color: Colors.black),
                                       ),
                                     ),
                                     const Divider()
                                   ],
                                 ),
                               ),
                             ],
                           ),
                           const SizedBox(height: 20),
                           // Any additional information can go here
                         ],
                       ),
                     ),
                   );

                }
            );
          }


          return const Center(
            child: Text("Looks like you don't have any orders "),
          );
        }
    );


  }
  Widget _buildInfoRow(String label, String value, TextStyle labelStyle, TextStyle valueStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}

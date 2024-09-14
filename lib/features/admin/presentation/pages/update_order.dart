


import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/features/admin/services/admin_service.dart';
import 'package:loop_cart/features/client/payment/view_modal/payement_method_provider.dart';

import '../../../client/orders/modals/order_modal.dart';
import '../../../client/orders/presentation/screens/order_detail.dart';

class UpdateOrder extends StatefulWidget {
  final OrderModal order;
  const UpdateOrder({required this.order,super.key});

  @override
  State<UpdateOrder> createState() => _UpdateOrderState();
}

class _UpdateOrderState extends State<UpdateOrder> {
  @override
  Widget build(BuildContext context) {

    final formatter = DateFormat.yMd();
    final textStyleBold = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    final textStyleRegular = TextStyle(fontSize: 15, color: Colors.grey[700]);

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
          backgroundColor: Colors.blueAccent, // Stylish background for the AppBar
          centerTitle: true, // Centers the title
        ),
      ),
      body: SingleChildScrollView(
        // Add some padding
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("orders").where("orderId",isEqualTo: widget.order.orderId).where('adminId',isEqualTo: widget.order.adminId).snapshots(),
            builder: (context, snapshot) {

              if(snapshot.connectionState==ConnectionState.waiting){
                const Center(
                  child: CircularProgressIndicator(),
                );


              }

              if(snapshot.hasData){
                Map<String, dynamic>? orderData = snapshot.data?.docs.first.data();

                OrderModal order = OrderModal.fromJson(orderData!);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow("Order Date", formatter.format(order.date), textStyleBold, textStyleRegular),
                      const SizedBox(height: 10),
                      _buildInfoRow("Order ID", order.orderId, textStyleBold, textStyleRegular),
                      const SizedBox(height: 10),
                      _buildInfoRow("Order Total", "₹${order.product.price.toString()}", textStyleBold, textStyleRegular),
                      const Divider(thickness: 1.5), // Stylish divider
                      const SizedBox(height: 10),
                      Text(
                        "Product Details",
                        style: textStyleBold.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0), // Rounded image corners
                            child: CachedNetworkImage(
                              imageUrl: order.product.mainImage,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 16), // Space between image and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.product.productTitle,
                                  style: textStyleBold.copyWith(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Quantity: ${order.product.quantity}",
                                  style: textStyleRegular,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      UpdateOrderStatus(order: order,),
                    ],
                  ),
                );
              }

              return Center(
                child: Text("Could not load order Detail"),
              );

            }
        ),
      ),
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



class UpdateOrderStatus extends StatefulWidget {
 final OrderModal order;
  const UpdateOrderStatus({required this.order,super.key});

  @override
  State<UpdateOrderStatus> createState() => _UpdateOrderStatusState();
}

class _UpdateOrderStatusState extends State<UpdateOrderStatus> {
  @override
  Widget build(BuildContext context) {
    int currentStatusIndex = widget.order.status.index;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tracking Information",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Stepper(
            controlsBuilder: (context,details){
              print(details.currentStep);
              return ElevatedButton(onPressed: () async{
                AdminService.changeOrderStatus(widget.order, OrderStatus.values[details.currentStep+1]);

                if(details.currentStep==3){
                 await AdminService.addOrderToTransaction(widget.order.productId, PaymentMethod.Cash, widget.order.userId);
                  // add transaction collection
                }
              }, child: const Text("Done"));
            },
            currentStep: currentStatusIndex,
            steps: [
              Step(
                isActive: currentStatusIndex>=0,
                title: Text("Pending"), content: Text(""),
              ),
              Step(
                isActive: currentStatusIndex>=1,
                title: Text("Shipped"), content: Text(""),
              ),
              Step(
                isActive: currentStatusIndex>=2,
                title: Text("Delivered"), content: Text(""),
              )
              ,Step(
                isActive: currentStatusIndex>=3,
                title: Text("Recieved"), content: Text(""),
              )
              ,Step(
                isActive: currentStatusIndex>=4,
                title: Text("Completed"), content: Text(""),
              )
            ]



        )
        // Container(
        //   width: double.infinity,
        //   padding: const EdgeInsets.all(12),
        //   decoration: BoxDecoration(
        //     color: Colors.blue[50],
        //     borderRadius: BorderRadius.circular(8),
        //     border: Border.all(color: Colors.blueAccent),
        //   ),
        //   child: const Text(
        //     "Your order is being processed.",
        //     style: TextStyle(fontSize: 16, color: Colors.black87),
        //   ),
        // ),
      ],
    );
  }
}

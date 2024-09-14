


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/client/orders/presentation/screens/order_detail.dart';


import '../../../orders/modals/order_modal.dart';
import '../../../orders/view_modal/load_orders_providers.dart';
import '../../../orders/view_modal/orders_provider.dart';

class ShowOrders extends StatefulWidget {
  const ShowOrders({super.key});

  @override
  State<ShowOrders> createState() => _ShowOrdersState();
}

class _ShowOrdersState extends State<ShowOrders> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        List<OrderModal> orders = ref.watch(ordersProvider);
        return SizedBox(
          height: 250, // Increased height for better visual appeal
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>OrderDetail(order: order)));
                  // _showStatusDialog(order);
                },
                child: Container(
                  width: 180, // Adjusted width for better layout
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), // Updated margins
                  decoration: BoxDecoration(
                    color: Colors.white, // Changed background color for a cleaner look
                    borderRadius: BorderRadius.circular(16), // More rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),
                  child: Consumer(
                    builder: (context,ref,child) {
                      bool isLoading = ref.watch(loadOrderLoader);
                      return isLoading?const Center(child: CircularProgressIndicator(),): Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            child: CachedNetworkImage(
                              imageUrl: order.product.mainImage,
                              width: double.infinity,
                              height: 120, // Increased image height for better visibility
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              order.product.productTitle,
                              style: const TextStyle(
                                fontSize: 16, // Slightly larger font size for better readability
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2, // Allowing more lines for longer titles
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "\$${order.product.price.toStringAsFixed(2)}", // Fixed decimal places for price
                            style: const TextStyle(
                              fontSize: 16, // Larger font size for better emphasis
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }



  void _showStatusDialog(OrderModal order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            order.product.productTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Status",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                order.status.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}

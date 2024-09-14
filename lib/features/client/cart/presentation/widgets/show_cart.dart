




import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../address/screens/address_screen.dart';
import '../../modal/cart_modal.dart';
import '../../view_modal/cart_provider.dart';
import '../../view_modal/single_cart_provider.dart';

class ShowCart extends StatefulWidget {
 final CartModal cart;
  const ShowCart({required this.cart,super.key});

  @override
  State<ShowCart> createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,child) {

        CartModal? cart = ref.watch(singleCartProvider(widget.cart.cartId));
        return GestureDetector(

          onLongPress: (){
            _showDialog(widget.cart,ref);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                CachedNetworkImage(
                  imageUrl: cart!.mainImage,
                  width: 80,
                  height: 100,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                ),
                const SizedBox(width: 16), // Space between image and details
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cart.productTitle,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Quantity Control
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              ref.read(singleCartProvider(widget.cart.cartId).notifier).decreaseQuantity(cart);
                            },
                            icon: Icon(Icons.remove, color: Colors.redAccent),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                          Text(
                            "Quantity: ${cart.quantity}",
                            style: TextStyle(fontSize: 14),
                          ),
                          IconButton(
                            onPressed: () {
                              ref.read(singleCartProvider(widget.cart.cartId).notifier).increaseQuantity(cart);
                            },
                            icon: Icon(Icons.add, color: Colors.green),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Checkout Button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>AddressScreen(carts:[widget.cart])));
                      },
                      child: Text(
                        "Check Out",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      }
    );
  }



  void _showDialog(CartModal cart,WidgetRef ref){

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Product Options",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cart.productTitle,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CachedNetworkImage(
                imageUrl: cart.mainImage,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.visibility),
              label: Text("View Product"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(cartProvider.notifier).deleteCart(widget.cart);
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.delete),
              label: Text("Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );

  }



}

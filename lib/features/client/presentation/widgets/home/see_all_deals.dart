

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';

import '../../pages/product_detail.dart';

class SeeAllDeals extends StatefulWidget {
  const SeeAllDeals({super.key});

  @override
  State<SeeAllDeals> createState() => _SeeAllDealsState();
}

class _SeeAllDealsState extends State<SeeAllDeals> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("products").snapshots(),
        builder: (context,snapshot) {

          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasData){

            QuerySnapshot<Map<String,dynamic>>? querySnapshot = snapshot.data;
            List<ProductModal> items = [];

            if( querySnapshot!=null &&querySnapshot.docs.isNotEmpty){
              for(var doc in querySnapshot.docs){
                final data = doc.data();
                items.add(ProductModal.fromJson(data));
              }
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                mainAxisExtent: 320.0, // Adjusted for better spacing
              ),
              itemBuilder: (context, index) {
                final product = items[index];

                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (Ctx)=>ProductDetail(product: product)));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: product.mainImage,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        RatingBarIndicator(
                          rating: product.rating,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20,
                          direction: Axis.horizontal,
                        ),
                        Text(
                          product.productTitle,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Rs. ${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(

            child: const Text("Could Not Load"),

          );
        }
    );
  }
}

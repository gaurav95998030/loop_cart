import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';

import 'package:loop_cart/features/client/presentation/widgets/client_button.dart';
import 'package:loop_cart/features/client/services/client_services.dart';
import 'package:loop_cart/utils/vertical_space.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uuid/uuid.dart';

import '../../cart/modal/cart_modal.dart';
import '../../cart/view_modal/add_cart_loader.dart';
import '../../cart/view_modal/cart_provider.dart';

class ProductDetail extends StatefulWidget {
  final ProductModal product;
  const ProductDetail({required this.product, super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> imagesList = [
      widget.product.mainImage,
      ...widget.product.featureImages
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.productTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("products")
                .where('productId', isEqualTo: widget.product.productId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No active items found'));
              }

              // Access the fetched data
              final items = snapshot.data!.docs.first;

              ProductModal product = ProductModal.fromJson(items.data());

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
// Product Title
                  Text(
                    product.productTitle,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 16),

// Image Carousel
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: PageView.builder(
                              controller: controller,
                              scrollDirection: Axis.horizontal,
                              itemCount: imagesList.length,
                              itemBuilder: (context, index) {
                                return CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: imagesList[index],
                                  progressIndicatorBuilder: (context, url,
                                          downloadProgress) =>
                                      Center(
                                          child: CircularProgressIndicator(
                                              value:
                                                  downloadProgress.progress)),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (controller.page! > 0) {
                                  controller.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              icon: const Icon(Icons.keyboard_arrow_left_sharp),
                            ),
                            SmoothPageIndicator(
                              controller: controller,
                              count: imagesList.length,
                              effect: const WormEffect(),
                              onDotClicked: (index) {
                                controller.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                if (controller.page! < imagesList.length - 1) {
                                  controller.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              icon:
                                  const Icon(Icons.keyboard_arrow_right_sharp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

// Price
                  Text(
                    "Amount: \$${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 16),

// Rating
                  Row(
                    children: [
                      const Text("Rating:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 8),
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
                    ],
                  ),
                  SizedBox(height: 24),

// Description
                  const Text(
                    "Description",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                        fontSize: 16, color: Colors.black54, height: 1.5),
                  ),

                  ClientButton(label: "Buy Now", onClick: () {}),
                  const VerticalSpace(height: 10),
                  Center(
                    child: SizedBox(
                      width: double.infinity * 0.8,
                      height: 50,
                      child: Consumer(
                        builder: (context,ref,child) {
                          bool isLoading = ref.watch(addCartLoader);
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  )),
                              onPressed: (){

                                CartModal cart = CartModal(userId: FirebaseAuth.instance.currentUser!.uid, productId: product.productId, cartId: const Uuid().v4(), quantity: 1, productTitle:product.productTitle, mainImage: product.mainImage,price: product.price,adminId: product.adminId);
                                ref.read(cartProvider.notifier).addCart(cart);
                              },
                              child:  Text(isLoading?"Adding":"Add to Cart"));
                        }
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 20), // Increased vertical space for better layout
                  const Text(
                    "Rate This Product",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Use a color that fits your theme
                    ),
                  ),
                  const SizedBox(
                      height: 10), // Space between text and rating bar
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 30, // Increased size for better visibility
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(1, 2),
                        ),
                      ], // Added shadow to give depth
                    ),
                    onRatingUpdate: (rating) {
                      ClientServices.rateProduct(
                          product.productId, product.adminId, rating);
                      print(rating);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          )),
    );
  }
}

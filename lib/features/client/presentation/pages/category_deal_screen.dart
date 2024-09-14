import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';

import 'package:loop_cart/features/client/presentation/pages/product_detail.dart';
import 'package:loop_cart/features/client/view_modal/category_products_provider.dart';
import 'package:loop_cart/utils/vertical_space.dart';
import 'package:badges/badges.dart' as badges;

import '../../cart/modal/cart_modal.dart';
import '../../cart/presentation/screen/show_carts.dart';
import '../../cart/view_modal/cart_provider.dart';

class CategoryDealScreen extends StatefulWidget {
  final String category;
  const CategoryDealScreen({required this.category, super.key});

  @override
  State<CategoryDealScreen> createState() => _CategoryDealScreenState();
}

class _CategoryDealScreenState extends State<CategoryDealScreen> {
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
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Action for search
              },
            ),
            Consumer(
                builder: (context,ref,child) {
                  List<CartModal>  carts = ref.watch(cartProvider);
                  return badges.Badge(
                    onTap: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>ShowCarts()));
                    },
                    badgeContent: Text(carts.length.toString()),
                    child: const Icon(Icons.shopping_cart),
                  );
                }
            ),
            const SizedBox(width: 20,),

          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Keep Shopping for ${widget.category}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const VerticalSpace(height: 10),
            Consumer(
              builder: (context, ref, child) {
                // Watch the provider
                AsyncValue<List<ProductModal>> items = ref.watch(categoryProductsProvider(widget.category));

                return items.when(
                  data: (items) {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          // Refresh the provider to reload data
                          ref.invalidate(categoryProductsProvider(widget.category));
                        },
                        child: GridView.builder(
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
                        ),
                      ),
                    );
                  },
                  error: (err, stack) => Center(child: Text("No Items Found")),
                  loading: () => const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

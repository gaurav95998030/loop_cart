




import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/features/admin/view_modal/loader/load_product_loader.dart';
import 'package:loop_cart/features/admin/view_modal/product_provider.dart';
import 'package:loop_cart/utils/vertical_space.dart';

class ShowPosts extends ConsumerStatefulWidget {
  const ShowPosts({super.key});

  @override
  ConsumerState<ShowPosts> createState() => _ShowPostsState();
}

class _ShowPostsState extends ConsumerState<ShowPosts> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer(
        builder: (context,ref,child) {
          bool isLoading = ref.watch(loadProductLoaderProvider);

          return Column(
            children: [
              if(isLoading)
                const Center(child: CircularProgressIndicator(),),
              const VerticalSpace(height: 10),
              Expanded(
                child: Consumer(
                  builder: (context,ref,child) {

                    List<ProductModal> products = ref.watch(productsProvider);
                    return GridView.builder(
                      itemCount: products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        mainAxisExtent: 320.0, // Adjusted for better spacing
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Container(
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
                                  imageUrl: products[index].mainImage,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(height: 8.0),
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
                        );
                      },
                    );

                  }
                ),
              ),

            ],
          );
        }
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetail extends StatefulWidget {
  final ProductModal product;
  const ProductDetail({required this.product,super.key});

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

    List<String> imagesList =  [widget.product.mainImage,...widget.product.featureImages];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.productTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Title
            Text(
              widget.product.productTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 16),

            // Image Carousel
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
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
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
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
                        icon: const Icon(Icons.keyboard_arrow_right_sharp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Price
            Text(
              "Amount: \$${widget.product.price.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.green),
            ),
            SizedBox(height: 16),

            // Rating
            Row(
              children: [
                Text("Rating:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                SizedBox(width: 8),
                RatingBarIndicator(
                  rating: widget.product.rating,
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
            Text(
              "Description",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 8),
            Text(
              widget.product.description,
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            ),
          ],
        ),
      ),
    );

  }
}

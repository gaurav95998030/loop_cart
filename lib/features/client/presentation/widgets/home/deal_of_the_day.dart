import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/features/client/presentation/pages/product_detail.dart';
import 'package:loop_cart/features/client/view_modal/deal_of_day_provider.dart';

class DealOfTheDay extends StatefulWidget {
  const DealOfTheDay({super.key});

  @override
  State<DealOfTheDay> createState() => _DealOfTheDayState();
}

class _DealOfTheDayState extends State<DealOfTheDay> {
  @override
  Widget build(BuildContext context) {
    return Container(
       // Added padding
      width: double.infinity,
      height: 400, // Increased height slightly for a better layout
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Deal of the Day",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16), // Added spacing
          Expanded(
            child: Consumer(
              builder: (context,ref,child) {
                AsyncValue<ProductModal?> data = ref.watch(dealOfDayProvider);

               return data.when(
                    data: (data){
                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>ProductDetail(product: data)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16), // Rounded corners
                          ),
                          elevation: 4, // Added shadow for elevation effect
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),

                                    ),


                                  ),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: data!.mainImage,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    data!.productTitle,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8), // Added spacing
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 children: [
                                   Text(
                                     data.price.toString(),
                                     style: TextStyle(
                                       fontSize: 22,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.green[700],
                                     ),
                                   ),
                                   ElevatedButton(
                                     onPressed: () {
                                       // Add your buy now action here
                                     },
                                     style: ElevatedButton.styleFrom(
                                       shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(8), // Rounded button
                                       ),

                                     ),
                                     child: const Text(
                                       "Buy Now",
                                       style: TextStyle(fontSize: 16),
                                     ),
                                   ),
                                 ],
                               )
                                ],
                              ),

                              const SizedBox(height: 16), // Spacing below button
                            ],
                          ),
                        ),
                      );
                    },
                    error: (err,stt)=>const Center(child: Text("Some error Occurred"),),
                    loading: ()=>const Center(child: CircularProgressIndicator(),)
                );

              }
            ),
          ),
        ],
      ),
    );
  }
}

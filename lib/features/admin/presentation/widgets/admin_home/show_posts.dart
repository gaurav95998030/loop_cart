


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/features/admin/view_modal/product_provider.dart';
import 'package:loop_cart/utils/vertical_space.dart';

class ShowPosts extends StatefulWidget {
  const ShowPosts({super.key});

  @override
  State<ShowPosts> createState() => _ShowPostsState();
}

class _ShowPostsState extends State<ShowPosts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const VerticalSpace(height: 10),
          Expanded(
            child: Consumer(
              builder: (context,ref,child) {
                
                List<ProductModal> products = ref.watch(productsProvider);
                return GridView.builder(
                  itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5
                
                    ),
                    itemBuilder: (context,index){
                    return Container(
                
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.file(File(products[index].mainImage),fit: BoxFit.cover,),
                    );
                    }
                );
              }
            ),
          ),

        ],
      ),
    );
  }
}

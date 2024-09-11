



import 'package:flutter/material.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/features/client/presentation/pages/category_deal_screen.dart';

class TopCategories extends StatefulWidget {
  const TopCategories({super.key});

  @override
  State<TopCategories> createState() => _TopCategoriesState();
}

class _TopCategoriesState extends State<TopCategories> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width:double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ProductCategory.values.length,
          itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>CategoryDealScreen(category: ProductCategory.values[index].name)));
              },
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 7,vertical: 4),
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,

                    ),
                    child: Image.asset(categoryIcons[ProductCategory.values[index]]!),
                  ),
                  Text(ProductCategory.values[index].name,style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
            );
          }
      ),
    );
  }
}

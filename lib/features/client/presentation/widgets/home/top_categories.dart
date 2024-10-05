



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
    return SizedBox(
      height: 100,
      width:double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ProductCategory.values.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => CategoryDealScreen(
                      category: ProductCategory.values[index].name)));
            },
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.purple.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      categoryIcons[ProductCategory.values[index]]!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ProductCategory.values[index].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          );
        },
      )

    );
  }
}





import 'package:flutter/material.dart';

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
        itemCount: List.generate(10, (val)=>val).length,
          itemBuilder: (context,index){
            return Container(
              margin: const EdgeInsets.all(4),
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red
              ),
            );
          }
      ),
    );
  }
}

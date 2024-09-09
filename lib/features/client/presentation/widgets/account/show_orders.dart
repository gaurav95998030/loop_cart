


import 'package:flutter/material.dart';

class ShowOrders extends StatefulWidget {
  const ShowOrders({super.key});

  @override
  State<ShowOrders> createState() => _ShowOrdersState();
}

class _ShowOrdersState extends State<ShowOrders> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: List.generate(5, (val)=>val).length,
          itemBuilder: (context,index){
          return Container(
            width: 200,
            height: 200,
            margin: const EdgeInsets.all(5),

            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12)
            ),
          );
          }
      )
    );
  }
}

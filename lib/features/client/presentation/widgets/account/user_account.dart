


import 'package:flutter/material.dart';
import 'package:loop_cart/features/client/presentation/widgets/account/greet_client.dart';
import 'package:loop_cart/features/client/presentation/widgets/account/show_orders.dart';
import 'package:loop_cart/features/client/presentation/widgets/account/user_options.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          GreetClient(),
          // UserOptions(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Your Orders",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),),


            ],
          ),
          ShowOrders()
        ],
      ),
    );
  }
}

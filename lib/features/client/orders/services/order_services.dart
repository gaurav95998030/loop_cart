



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:loop_cart/utils/show_snackbar.dart';

import '../modals/order_modal.dart';

class OrderServices{

  static Future<List<OrderModal>> loadOrders () async{
    try{
      List<OrderModal> orders = [];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("orders").where("userId",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

      if(querySnapshot.docs.isNotEmpty){
        for(var item in querySnapshot.docs){
          final doc = item.data() as Map<String,dynamic>;
          orders.add(OrderModal.fromJson(doc));
        }


      }
      return orders;
    }catch(err){
      ShowSnackbarMsg.showSnack("Some error occurred while loading orders");
      return [];
    }
  }
  static Future<bool> placeOrder(OrderModal order) async{
    try{
      await FirebaseFirestore.instance.collection("orders").add(order.toJson());

      return true;
    }catch(err){
      ShowSnackbarMsg.showSnack("Some error occurred");
      return false;
    }
  }
}
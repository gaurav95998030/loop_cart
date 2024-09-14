





import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../utils/show_snackbar.dart';
import '../../cart/modal/cart_modal.dart';
import '../modals/order_modal.dart';
import '../services/order_services.dart';
import 'add_order_loader.dart';
import 'load_orders_providers.dart';

class OrdersNotifer extends StateNotifier<List<OrderModal>>{
  Ref ref;
  OrdersNotifer(this.ref):super([

  ]){
    Future.microtask((){
      loadOrders();
    });
  }


  void loadOrders() async{
    ref.read(loadOrderLoader.notifier).update((cb)=>true);

    state = await OrderServices.loadOrders();
    ref.read(loadOrderLoader.notifier).update((cb)=>false);


  }

  void addToOrders(List<CartModal> carts,BuildContext context) async{
    ref.read(addOrderLoader.notifier).update((cb)=>true);


    for(var item in carts){
      OrderModal order = OrderModal(date: DateTime.now(), product: item, status: OrderStatus.Pending, userId: FirebaseAuth.instance.currentUser!.uid,orderId: const Uuid().v4(),adminId: item.adminId, productId: item.productId);
      bool res= await OrderServices.placeOrder(order);
      if(res){
        state = [order,...state];



      }
    }


    ShowSnackbarMsg.showSnack("Order Placed Successfully");


    ref.read(addOrderLoader.notifier).update((cb)=>false);
  }



}


final ordersProvider = StateNotifierProvider<OrdersNotifer,List<OrderModal>>((ref)=>OrdersNotifer(ref));
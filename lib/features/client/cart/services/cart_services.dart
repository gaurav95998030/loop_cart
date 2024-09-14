



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:loop_cart/utils/show_snackbar.dart';

import '../modal/cart_modal.dart';

class CartServices{

  static Future<bool> addCart(CartModal cart) async{
    try{

      await FirebaseFirestore.instance.collection("carts").add(cart.toJson());
      ShowSnackbarMsg.showSnack("Added to cart!, Check cart Section!!");
      return true;
    }catch(err){
      print (err);
      ShowSnackbarMsg.showSnack("Some error occured");
      return false;
    }
  }

  static Future<List<CartModal>> loadCarts() async{

    try{
      List<CartModal> carts = [];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("carts").where('userId',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

      if(querySnapshot.docs.isNotEmpty){


        for(var item in querySnapshot.docs){
          final data = item.data() as Map<String,dynamic>;

          carts.add(CartModal.fromJson(data));


        }
        return carts;
      }
      return [];
    }catch(err){
      print(err);
      return [];
    }
  }

  static void deleteCart(CartModal cart) async{
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("carts").where('cartId',isEqualTo: cart.cartId).where('userId',isEqualTo:cart.userId).get();

      if(querySnapshot.docs.isNotEmpty){
       await querySnapshot.docs.first.reference.delete();

      }
    }catch(err){
      print(err);
      ShowSnackbarMsg.showSnack("Some error Ocurred");
    }
  }
}






import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/admin/view_modal/loader/load_product_loader.dart';

import 'package:loop_cart/features/client/services/client_services.dart';
import 'package:loop_cart/utils/show_snackbar.dart';

import '../modal/cart_modal.dart';
import '../services/cart_services.dart';
import 'add_cart_loader.dart';

class CartNotifer extends StateNotifier<List<CartModal>>{
  Ref ref;
  CartNotifer(this.ref):super([]){
    Future.microtask(()=>loadCarts());
  }


  void loadCarts()async{
    ref.read(loadProductLoaderProvider.notifier).update((cb)=>true);
    List<CartModal> carts = await CartServices.loadCarts();


    state = carts;
    ref.read(loadProductLoaderProvider.notifier).update((cb)=>false);



  }



  Future<bool> addCart(CartModal cart) async{


    for(var item in state){
      if(item.productId==cart.productId){
        ShowSnackbarMsg.showSnack("Already added");
        return false;
      }
    }

    ref.read(addCartLoader.notifier).update((cb)=>true);
    bool res = await CartServices.addCart(cart);

    if(res){
      state = [cart,...state];
      ref.read(addCartLoader.notifier).update((cb)=>false);
      return true;
    }

    ref.read(addCartLoader.notifier).update((cb)=>false);
    return false;

  }

  void updateCart( CartModal cart){

    state = [
      for(var item in state)
        if(cart.cartId==item.cartId)
          cart
        else
        item
    ];

  }

  void deleteCart(CartModal cart){

    state = [
      for(var item in state)
        if(item.cartId!=cart.cartId)
          item
    ];

    CartServices.deleteCart(cart);
  }

  void deleteCartAfterPurchase(List<CartModal> carts) {
    List<CartModal> newState = [];

    // Iterate over the current state and only add carts that are NOT in the list of purchased carts
    for (var cart in state) {
      bool isPurchased = carts.any((item) => item.cartId == cart.cartId);
      if (!isPurchased) {
        newState.add(cart); // Add carts that were not purchased
      }
    }

    // Update the state with the new filtered list
    state = newState;

    // Now delete the purchased carts outside of the loop to avoid multiple calls
    for (var item in carts) {
      CartServices.deleteCart(item);
    }
  }


}



final cartProvider = StateNotifierProvider<CartNotifer,List<CartModal>>((ref)=>CartNotifer(ref));
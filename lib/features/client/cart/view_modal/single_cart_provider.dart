




import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../modal/cart_modal.dart';
import 'cart_provider.dart';

class SingleCartNotifier extends StateNotifier<CartModal?>{
  Ref ref;
  String cartId;
  SingleCartNotifier(this.ref,this.cartId):super(null){
    loadCart();
  }

  void loadCart(){

    List<CartModal> carts = ref.read(cartProvider);

    for(var item in carts){
      if(item.cartId==cartId){
        state = item;
        return;
      }
    }
  }


  void increaseQuantity(CartModal cart){

      CartModal newCart = CartModal(productTitle: state!.productTitle,  mainImage: state!.mainImage, userId: state!.userId, productId: state!.productId, cartId: cartId, quantity: state!.quantity+1,price: cart.price, adminId: state!.adminId);
      state = newCart;
      ref.read(cartProvider.notifier).updateCart(newCart);

  }
  void decreaseQuantity(CartModal cart){


    if(state!.quantity==1){
      return;
    }

    CartModal newCart = CartModal(productTitle: state!.productTitle,  mainImage: state!.mainImage, userId: state!.userId, productId: state!.productId, cartId: cartId, quantity: state!.quantity-1,price: cart.price, adminId: state!.adminId);

    state = newCart;
    ref.read(cartProvider.notifier).updateCart(newCart);


  }

}



final singleCartProvider = StateNotifierProvider.family<SingleCartNotifier,CartModal?,String>((ref,cartId)=>SingleCartNotifier(ref,cartId));
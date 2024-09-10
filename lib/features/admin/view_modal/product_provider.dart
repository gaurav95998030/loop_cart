



import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/features/admin/services/admin_service.dart';
import 'package:loop_cart/features/admin/view_modal/features_images_provider.dart';
import 'package:loop_cart/features/admin/view_modal/loader/load_product_loader.dart';
import 'package:loop_cart/features/admin/view_modal/main_image_provider.dart';
import 'package:uuid/uuid.dart';


const uuid = Uuid();
class ProductNotifier extends StateNotifier<List<ProductModal>>{

  Ref ref;
  ProductNotifier(this.ref):super([]){

    Future.microtask(loadProducts);
  }



  void loadProducts () async{
    ref.read(loadProductLoaderProvider.notifier).update((cb)=>true);
    List<ProductModal> products = await AdminService.loadProducts();
    state = [...products];
    ref.read(loadProductLoaderProvider.notifier).update((cb)=>false);

  }

  Future<bool> addProduct({required String title,required String description,required double price,required ProductCategory category}) async {

    String productId = uuid.v4();
    String mainImage = ref.read(mainImageProvider).url;



    List<String> images = ref.read(featuresImagesProvider).url;
    ProductModal product = ProductModal(buyCount: 0, price: price, category: category, adminId: FirebaseAuth.instance.currentUser!.uid, description: description, featureImages: images, mainImage: mainImage, productId: productId, productTitle: title, time: DateTime.now());
    bool res = await AdminService.addProduct(product);
    if(res){
      state = [product,...state];
      return true;
    }




    return false;
  }

}



final productsProvider = StateNotifierProvider<ProductNotifier,List<ProductModal>>((ref)=>ProductNotifier(ref));
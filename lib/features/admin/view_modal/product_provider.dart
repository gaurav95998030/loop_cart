



import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/features/admin/view_modal/features_images_provider.dart';
import 'package:loop_cart/features/admin/view_modal/main_image_provider.dart';
import 'package:uuid/uuid.dart';


const uuid = Uuid();
class ProductNotifier extends StateNotifier<List<ProductModal>>{

  Ref ref;
  ProductNotifier(this.ref):super([]);


  bool addProduct({required String title,required String description,required double price,required ProductCategory category}) {

    String productId = uuid.v4();
    XFile? mainImage = ref.read(mainImageProvider).pickedImage;
    List<XFile?> imagesFeature = ref.read(featuresImagesProvider).images;
    List<String> images = imagesFeature.map((item)=>item!.path).toList();
    if(mainImage!=null){
      ProductModal product = ProductModal(buyCount: 0, price: price, category: category, adminId: FirebaseAuth.instance.currentUser!.uid, description: description, featureImages: images, mainImage: mainImage.path, productId: productId, productTitle: title, time: DateTime.now());
     state = [product,...state];
     return true;

    }

    return false;
  }

}



final productsProvider = StateNotifierProvider<ProductNotifier,List<ProductModal>>((ref)=>ProductNotifier(ref));
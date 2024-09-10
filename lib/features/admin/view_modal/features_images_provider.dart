



import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loop_cart/features/admin/services/storage_services/storage_services.dart';


class FeaturedImagesState{
  List<XFile?> images;
  bool isLoading;

  FeaturedImagesState({required this.isLoading,required this.images});
}

class FeaturesImagesNotifier extends StateNotifier<FeaturedImagesState> {
  FeaturesImagesNotifier() : super(FeaturedImagesState(isLoading: false, images: []));



  Future<List<String>> uploadImage() async {


    List<String> imagesUrl=[];
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    state = FeaturedImagesState(isLoading: true, images: images);
    for(var image in images){

      String? url = await StorageServices.uploadImage(File(image.path));

      if(url!=null){
        imagesUrl.add(url);
      }

    }
    state = FeaturedImagesState(isLoading: false, images: images);
    return imagesUrl;
  }
}

final featuresImagesProvider = StateNotifierProvider<FeaturesImagesNotifier, FeaturedImagesState>(
      (ref) => FeaturesImagesNotifier(),
);

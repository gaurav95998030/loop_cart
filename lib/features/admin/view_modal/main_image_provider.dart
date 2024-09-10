import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loop_cart/features/admin/services/storage_services/storage_services.dart';


class MainImageState{
 XFile? pickedImage;
 bool isLoading;
 MainImageState({required this.pickedImage,required this.isLoading});
}
class MainImageNotifier extends StateNotifier<MainImageState> {
  MainImageNotifier() : super(MainImageState(pickedImage: null, isLoading: false));



  Future<bool> uploadImage() async {


    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    state = MainImageState(pickedImage: state.pickedImage, isLoading: true);
    if(image != null){
      String? res = await StorageServices.uploadImage(File(image.path));

      if(res!=null){
        state = MainImageState(pickedImage: image, isLoading: false);
        return true;
      }

      state = MainImageState(pickedImage: state.pickedImage, isLoading: false);
      return false;

    }

    return false;
  }
}

final mainImageProvider = StateNotifierProvider<MainImageNotifier, MainImageState>(
      (ref) => MainImageNotifier(),
);

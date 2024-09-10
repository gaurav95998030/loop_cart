import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';




class StorageServices {

  static Future<String?> uploadImage(File pickedImage) async {
    try{
      FirebaseStorage storage = FirebaseStorage.instance;


      Reference ref = storage.ref().child("productImages/${DateTime.now().toIso8601String()}.png");


      UploadTask uploadTask = ref.putFile(pickedImage);


      await uploadTask.whenComplete(() {});


      String url = await ref.getDownloadURL();

      return url;
    }catch(err){
      return null;
    }
  }
}

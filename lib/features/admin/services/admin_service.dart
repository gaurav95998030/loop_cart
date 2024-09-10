



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/utils/show_snackbar.dart';

class AdminService {


  static Future<bool> addProduct(ProductModal product) async{
     try{

       await FirebaseFirestore.instance.collection("products").add(product.toJson());
       return true;
     }catch(err){
       return false;
     }

  }

  static Future<List<ProductModal>> loadProducts() async{

    try{
      List<ProductModal> products = [];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("products").where('adminId',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();


      if(querySnapshot.docs.isNotEmpty){

        for(var doc in querySnapshot.docs){

          products.add(ProductModal.fromJson(doc.data() as Map<String,dynamic>));
        }
      }

      return products;

    }catch(err){
      print(err);
      ShowSnackbarMsg.showSnack("Some error While loading products!!! ${err}");
      return [];
    }
  }
}
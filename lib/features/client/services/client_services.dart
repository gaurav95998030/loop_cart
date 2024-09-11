



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/utils/show_snackbar.dart';

class ClientServices {

   static Future<List<ProductModal>> loadProductsWithCategory(String category) async{

     try{
       print("gaurav");
       List<ProductModal> items = [];
       QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('products').where('category',isEqualTo: category).get();

       if(querySnapshot.docs.isNotEmpty){

        for(var data in querySnapshot.docs){
          ProductModal productModal = ProductModal.fromJson(data.data() as Map<String,dynamic>);
          items.add(productModal);
        }
       }

       return items;
     }catch(err){
       print(err);
       ShowSnackbarMsg.showSnack("Some error occurred");
       return [];
     }

   }

}
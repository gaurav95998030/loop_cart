



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loop_cart/features/admin/modals/product_modal.dart';
import 'package:loop_cart/features/client/orders/modals/order_modal.dart';
import 'package:loop_cart/features/client/payment/view_modal/payement_method_provider.dart';
import 'package:loop_cart/utils/show_snackbar.dart';
import 'package:uuid/uuid.dart';

import '../modals/transactions_modal.dart';

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
      ShowSnackbarMsg.showSnack("Some error While loading products!!! $err");
      return [];
    }
  }

  static void changeOrderStatus ( OrderModal order,OrderStatus newStatus) async{
    try{
   QuerySnapshot querySnapshot=   await FirebaseFirestore.instance.collection("orders").where('orderId',isEqualTo: order.orderId).where("adminId",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

      if(querySnapshot.docs.isNotEmpty){
        await querySnapshot.docs.first.reference.update({
          'status':newStatus.name
        });
      }

    }catch(err){
      ShowSnackbarMsg.showSnack("Some error occurred");
    }
  }

  static Future<void> addOrderToTransaction( String productId,PaymentMethod method,String userId) async{

    try{
      QuerySnapshot query =  await FirebaseFirestore.instance.collection("products").where("adminId",isEqualTo: FirebaseAuth.instance.currentUser!.uid).where('productId',isEqualTo: productId).get();
      final doc = query.docs.first.data() as Map<String,dynamic>;
      ProductModal product = ProductModal.fromJson(doc);
      print(product.productId);
      TransactionsModal trans = TransactionsModal(adminId: product.adminId, paymentMethod: method, product: product, date: DateTime.now(), userId: userId, amount: product.price, transactionId: const Uuid().v4());
       await FirebaseFirestore.instance.collection("transactions").add(trans.toJson());
    }catch(err){
      print(err);
    }

  }

  static Future<Map<ProductCategory, double>> getAllCategoryWiseEarnings() async {
    Map<ProductCategory, double> categoryEarnings = {
      for (var category in ProductCategory.values) category: 0.0,
    };

    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection("transactions")
          .where("adminId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (query.docs.isNotEmpty) {
        for (var item in query.docs) {
          final docData = item.data() as Map<String, dynamic>;

          // Assuming 'category' field is stored as a string and matches enum values
          String categoryStr = docData['product']['category'];
          ProductCategory? category = ProductCategory.values
              .firstWhere((e) => e.toString().split('.').last == categoryStr);

          // Safely handle the 'amount' being null by defaulting to 0
          double amount = (docData['amount'] ?? 0).toDouble();
          categoryEarnings[category] = categoryEarnings[category]! + amount;
                }
      }

      return categoryEarnings;
    } catch (err) {
      print(err);
      ShowSnackbarMsg.showSnack("Some error occurred while fetching the category-wise earnings");
      return categoryEarnings; // Returning the map with default values
    }
  }

}
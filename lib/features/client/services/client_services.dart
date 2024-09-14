



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

   static void rateProduct(String productId, String adminId, double rating) async {
     try {
       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
           .collection("products")
           .where('productId', isEqualTo: productId)
           .where('adminId', isEqualTo: adminId)
           .get();

       // Check if any documents are found
       if (querySnapshot.docs.isNotEmpty) {
         // Get the first document reference
         final DocumentReference productRef = querySnapshot.docs.first.reference;
         final Map<String, dynamic> productData = querySnapshot.docs.first.data() as Map<String, dynamic>;

         int users = await countUsers();
         // Calculate the new rating (Modify this logic as needed)
         double newRating = (productData['rating'] ?? 0).toDouble() + (rating/users);

         // Update the document with the new rating
         await productRef.update({
           'rating': newRating,
         });

         ShowSnackbarMsg.showSnack("Rated Successfully");
       } else {
         // Handle case when no product is found
         ShowSnackbarMsg.showSnack("Product not found or some error occurred");
       }
     } catch (err) {
       print(err);
       ShowSnackbarMsg.showSnack("Some error occurred");
     }
   }

   static Future<int> countUsers() async {
     try {
       // Fetch the documents from the "users" collection
       QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").get();

       // Return the count of documents
       return snapshot.docs.length;
     } catch (e) {
       // Handle any errors here
       print('Error counting users: $e');
       return 0; // Return 0 or handle error accordingly
     }
   }

   static Future<ProductModal?> getDealOfTheDay() async {
     try {
       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
           .collection('products')
           .orderBy('rating', descending: true)
           .limit(1)
           .get();

       if (querySnapshot.docs.isNotEmpty) {
         final data = querySnapshot.docs.first.data();

         if (data is Map<String, dynamic>) {
           return ProductModal.fromJson(data);
         }
       }

       return null;
     } catch (err) {
       print('Error fetching deal of the day: $err'); // Improved error message
       return null;
     }
   }



}
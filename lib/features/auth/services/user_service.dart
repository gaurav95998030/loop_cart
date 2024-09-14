



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loop_cart/features/auth/modal/user_modal.dart';
import 'package:loop_cart/utils/show_snackbar.dart';
import 'package:uuid/uuid.dart';


const uuid = Uuid();
class UserService{

  Future<bool> addUserToDB({required String email,required userName,required String uid}) async{
    try{

      UserModal userModal = UserModal(userName: userName, email: email, date: DateTime.now(), profileUrl: null, address: null, dob: null, phoneNumber: null, userId: uid,role: "client");
      await FirebaseFirestore.instance.collection("users").add(userModal.toJson());
      return true;
    }catch(err){
      print(err);
      return false;
    }
  }

  static void updateAddress(String address,String mobileNumber) async{
    try{
     QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("users").where("userId",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

     if(  querySnapshot.docs.isNotEmpty){
       querySnapshot.docs.first.reference.update({'address':address,'phoneNumber':mobileNumber});
       ShowSnackbarMsg.showSnack("Added successfully");
     }
    }catch(err){
      print(err);
      ShowSnackbarMsg.showSnack("Some error occurred");
    }
  }
}
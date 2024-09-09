




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loop_cart/features/auth/modal/user_modal.dart';

Future<bool> isAdmin (User user) async{

  try{
  QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection('users').where('userId',isEqualTo: user.uid).get();

  if(querySnapshot.docs.isNotEmpty){
    final userData = querySnapshot.docs.first.data() as Map<String,dynamic>;

    UserModal userModal = UserModal.fromJson(userData);

    if(userModal.role=="admin"){
      return true;
    }
  }
  return false;
  }catch(err){
    return false;
  }
}
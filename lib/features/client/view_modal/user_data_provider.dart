



//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:loop_cart/features/auth/modal/user_modal.dart';
//
// class UserDateNotifier extends StateNotifier<User>{
//
//   UserDateNotifier():super(UserModal(userName: 'User', email: '', date: DateTime.now(), userId: '', role: '')){
//
//   }
//
//
//   void loadUserData(){
//
//     User? user =  FirebaseAuth.instance.currentUser;
//
//     if(user!=null){
//       state = UserModal(userName: user.displayName!, email: user.email!, date: user.da, userId: userId, role: role)
//     }
//   }
//
// }
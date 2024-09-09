







import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/auth/services/auth_service.dart';
import 'package:loop_cart/features/auth/view_modal/loader_provider/signup_user_loader_provider.dart';

class UserFormState {
 String email;
 String userName;
 String password;

  UserFormState({required this.email,required this.userName,required this.password});
}




class FormStateNotifier extends StateNotifier<UserFormState>{
Ref ref;
  FormStateNotifier(this.ref):super(UserFormState(email: '', userName: '', password: ''));

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  String? validUserName(String userName){

    if(userName.isEmpty){
      return "Username cannot be empty";

    }
    if(userName.length>30){
      return "Username length should be less than 30 character";
    }


    return null;


  }

  String? validateEmail(String email){
    if(email.isEmpty){
      return "Email field cannot be empty";

    }

    if(_isValidEmail(email)==false){
      return "Invalid email format ";
    }


    return null;
  }

  String ?validatePass(String pass){

    if(pass.isEmpty){
      return 'Password field cannot be empty';
    }
    if(pass.length<6){
      return "Password length should be greater than 6 character";
    }

    return null;
  }


  Future<String> handleCreateAccountSubmit({required String email,required String password,required String userName}) async{

    ref.read(signUpUserLoaderProvider.notifier).update((cb)=>true);
    AuthService authService = AuthService(auth: FirebaseAuth.instance);
    String res = await authService.signUpUser(email: email, password: password, userName:userName);
     // await FirebaseAuth.instance.signOut(); //firebase sign up ke baad authomatically login kr deta hai isiliye homepage dikha jaa raha hai isliye pehle logot kr lo
    if(res=="success"){
      state = UserFormState(email: email, userName: userName, password: password);
      ref.read(signUpUserLoaderProvider.notifier).update((cb)=>false);
      return res;
    }else{
      ref.read(signUpUserLoaderProvider.notifier).update((cb)=>false);
      return res;
    }

  }
}





final formStateProvider= StateNotifierProvider<FormStateNotifier,UserFormState>((ref)=>FormStateNotifier(ref));
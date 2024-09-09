


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_cart/features/auth/services/auth_service.dart';
import 'package:loop_cart/features/auth/view_modal/loader_provider/login_user_loader_provider.dart';

class LoginFormState{
  String email;
  String password;

  LoginFormState({required this.password,required this.email});


}



class LoginFormStateNotifier extends StateNotifier<LoginFormState>{
  Ref ref;
  LoginFormStateNotifier(this.ref):super(LoginFormState(password: '', email: ''));

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
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

  Future<String> handleLoginClick({required String email,required String password}) async{

    ref.read(loginUserLoaderProvider.notifier).update((cb)=>true);
    String res = await AuthService(auth:FirebaseAuth.instance).loginUser(email: email, password: password);
    ref.read(loginUserLoaderProvider.notifier).update((cb)=>false);
    return res;
  }
}




final loginFormStateProvider = StateNotifierProvider<LoginFormStateNotifier,LoginFormState>((ref)=>LoginFormStateNotifier(ref));
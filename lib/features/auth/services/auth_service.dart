





import 'package:firebase_auth/firebase_auth.dart';
import 'package:loop_cart/features/auth/services/user_service.dart';

class AuthService{
  FirebaseAuth auth;

    AuthService({required this.auth});
   Future<String>signUpUser({required String email,required String password,required String userName}) async{
     try{

       UserCredential userCredential= await auth.createUserWithEmailAndPassword(email: email, password: password);


       if(userCredential.user!=null){

         User? user = userCredential.user;


        await user?.updateDisplayName(userName);
        UserService userService = UserService();

         bool res= await userService.addUserToDB(email: email, userName: userName, uid:userCredential.user!.uid );

         if(res){
           return 'success';
         }
         else{
           return 'failed';
         }


       }

       return 'failed';
     } on FirebaseAuthException catch (e) {
       if (e.code == 'weak-password') {
         return "weak-password";
       } else if (e.code == 'email-already-in-use') {
         return "email already in use";

       }
     }
     catch(err){
       print (err);
     }

      return 'failed';
   }
   Future<String>loginUser({required String  email,required String password}) async{
    try{

    UserCredential userCredential = await   auth.signInWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;

    if(user!=null){

      return 'success';
    }

      return 'failed';
    } on FirebaseAuthException catch(err){
      return err.code;
    }
    catch(err){
      print (err);
      return 'failed';
    }
  }
}
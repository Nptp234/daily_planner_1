// ignore_for_file: use_build_context_synchronously

import 'package:daily_planner_1/data/api/user_api.dart';
import 'package:daily_planner_1/data/model/user.dart';
import 'package:daily_planner_1/data/sqlite/auth_sqlite.dart';
import 'package:daily_planner_1/model/alert.dart';
import 'package:daily_planner_1/model/bottom_bar.dart';
import 'package:daily_planner_1/state/task_provider.dart';
import 'package:daily_planner_1/ui/wellcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickalert/models/quickalert_type.dart';

class AuthCenter{
  UserApi userApi = UserApi();
  TaskProvider taskProvider = TaskProvider();
  UserSqlite userSqlite = UserSqlite();
  bool isCheck = false;
  final currentUser = CurrentUser();

  Future<void> _addSqlite(BuildContext context, String email, String pass) async{
    try{
      await userSqlite.updateUser(email, pass);
    }
    catch(e){
      Navigator.of(context).pop();
      showAlert(context, QuickAlertType.error, "An error occurred when check local user. Please try again.");
    }
  } 

  Future<void> handleSignIn(BuildContext context, String email, String pass) async {
    showAlert(context, QuickAlertType.loading, "Authenticating...");

    try {
      bool isAuth = await userApi.checkUser(email, pass);
      Navigator.of(context).pop();
      
      if (isAuth) {
        if(isCheck){_addSqlite(context, email, pass);}
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomMenu()),);
      } 
      else {
        showAlert(context, QuickAlertType.error, "Error email or password!");
      }
    } catch (e) {
      Navigator.of(context).pop();
      showAlert(context, QuickAlertType.error, "An error occurred. Please try again.");
    }
  }

  Future<void> handleSignUp(BuildContext context, UserThis user) async{
    showAlert(context, QuickAlertType.loading, "Authenticating...");

    try{
      bool isCheck = await userApi.checkUser(user.email!, user.pass!);
      Navigator.of(context).pop();
      
      if(!isCheck){

        final body = {
          "records":[
                  {
                      "fields":{
                            "Email": user.email,
                            "Pass": user.pass,
                            "Username": user.username
                        }
                  }
              ]
        };
        bool isAdd = await userApi.addUser(body);
        if(isAdd){
          _addSqlite(context, user.email!, user.pass!);
          currentUser.setCurrent(UserThis(username: user.username, email: user.email, pass: user.pass));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomMenu()),);
        }
        else{
          showAlert(context, QuickAlertType.error, "An error occurred when try to connect server. Please try later.");
        }
      }
      else{
        showAlert(context, QuickAlertType.error, "User already exist!");
      }

    }
    catch(e){
      Navigator.of(context).pop();
      showAlert(context, QuickAlertType.error, "An error occurred. Please try again.");
    }
  } 

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> handleSignInGoogle(BuildContext context) async{
    showAlert(context, QuickAlertType.loading, "Authenticating...");

    try{
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(authCredential);

      Navigator.pop(context);
      UserThis user = UserThis(email: userCredential.user!.email, username: userCredential.user!.displayName, pass: "123");
      currentUser.setCurrent(user);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomMenu()),);
    }
    catch(e){
      Navigator.of(context).pop();
      showAlert(context, QuickAlertType.error, "An error occurred. Please try again.");
    }
  } 

  void handleLogOut(BuildContext context){
    currentUser.setCurrent(UserThis());
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>WellcomePage()), (Route<dynamic> route) => false);
  }
}
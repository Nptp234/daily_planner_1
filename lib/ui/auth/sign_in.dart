// ignore: must_be_immutable
import 'package:daily_planner_1/data/api/user_api.dart';
import 'package:daily_planner_1/data/model/user.dart';
import 'package:daily_planner_1/data/sqlite/auth_sqlite.dart';
import 'package:daily_planner_1/model/alert.dart';
import 'package:daily_planner_1/model/bottom_bar.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/main_button.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class SignIn extends StatefulWidget{
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignIn();
}

class _SignIn extends State<SignIn>{

  TextEditingController emailControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();
  
  bool isCheck = false;

  UserApi userApi = UserApi();
  final currentUser = CurrentUser();
  final userSqlite = UserSqlite();

  Future<void> _addSqlite(BuildContext context) async{
    try{
      await userSqlite.addUser(emailControl.text, passwordControl.text);
    }
    catch(e){
      Navigator.of(context).pop();
      showAlert(context, QuickAlertType.error, "An error occurred when check local user. Please try again.");
    }
  } 

  Future<void> _handleSignIn(BuildContext context) async {
    showAlert(context, QuickAlertType.loading, "Authenticating...");

    try {
      bool isAuth = await userApi.checkUser(emailControl.text, passwordControl.text);
      Navigator.of(context).pop();
      
      if (isAuth) {
        if(isCheck){_addSqlite(context);}
        Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomMenu()),);
      } 
      else {
        showAlert(context, QuickAlertType.error, "Error email or password!");
      }
    } catch (e) {
      Navigator.of(context).pop();
      showAlert(context, QuickAlertType.error, "An error occurred. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Flexible(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          child: _body(context),
        ),
      )
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: getMainWidth(context),
      height: getMainHeight(context),
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _input(context, 'Your email', emailControl, false),
          _input(context, 'Your password', passwordControl, true),
          const SizedBox(height: 30,),

          _checkBox(),
          const SizedBox(height: 50,),

          //button
          GestureDetector(
            onTap: () async{_handleSignIn(context);},
            child: ButtonCustom(text: "Sign In", currentContext: context)
          )
        ],
      ),
    );
  }

  Icon iconNullCheck = Icon(Icons.square_outlined, size: 30, color: Colors.grey,);
  Icon iconChecked = Icon(Icons.check_box, size: 30, color: mainColor,);
  Widget _checkBox(){
    return Container(
      width: getMainWidth(context),
      // padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: (){
              if(isCheck){
                setState(() {
                  isCheck = false;
                });
              }else{
                setState(() {
                  isCheck = true;
                });
              }
            }, 
            icon: isCheck?iconChecked:iconNullCheck
          ),
          Text("Remember you next time?", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),)
        ],
      ),
    );
  }

  bool isObscure=true;

  Widget _input(BuildContext context, String title, TextEditingController input, bool isPassword){
    return Container(
      padding: const EdgeInsets.all(10),
      width: getMainWidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.start,),
          TextFormField(
            controller: input,
            obscureText: isPassword ? isObscure : false,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              fillColor: Colors.grey[100],
              errorBorder: null,
              enabledBorder: null,
              focusedBorder: null,
              disabledBorder: null,
              focusedErrorBorder: null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure; // Toggle the password visibility
                    });
                  },
                )
                : null,
            ),
          )
        ],
      ),
    );
  }
  
}
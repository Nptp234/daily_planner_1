import 'package:daily_planner_1/controller/auth_logic.dart';
import 'package:daily_planner_1/data/model/user.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/main_button.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget{
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp>{

  TextEditingController emailControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();
  TextEditingController usernameControl = TextEditingController();
  
  bool isObscure = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthCenter authCenter = AuthCenter();

  String? _checkNullInput(BuildContext context, String value){
    if (value=="") {
      return 'Please fill out this!';
    }
    return null;
  }

  String? _checkEmail(BuildContext context, String value){
    String? checkNull = _checkNullInput(context, value);
    if(checkNull=='Please fill out this!'){return 'Please fill out this!';}
    if(!value.contains("@")){return "This is not a mail address!";}

    List<String> emailPart = value.split("@");
    String firstPart = emailPart[0];
    String lastPart = emailPart[1];

    bool _checkSpecialChar = checkSpecialChar(firstPart);
    bool checkEmailAddress = lastPart.contains("gmail.com");

    if(_checkSpecialChar){return "We don't accept special char!";}
    if(!checkEmailAddress){return "We don't accept this address!";}

    return null;
  }

  String? _checkUsername(BuildContext context, String value){
    String? checkNull = _checkNullInput(context, value);
    if(checkNull=='Please fill out this!'){return 'Please fill out this!';}

    bool _checkSpecialChar = checkSpecialChar(value);
    if(_checkSpecialChar){return "We don't accept special char!";}

    if(value.length<4){return "We don't accept name too short!";}

    return null;
  }

  String? _checkPassword(BuildContext context, String value){
    String? checkNull = _checkNullInput(context, value);
    if(checkNull=='Please fill out this!'){return 'Please fill out this!';}

    if(value.length<8){return "Password too short!";}
    if(value.contains(" ")){return "We don't accept space in your password!";}
    if(!checkSpecialChar(value)){return "Your pass too weak, try add some special char!";}
    return null;    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context){
    return Form(
      key: formKey,
      child: Container(
        width: getMainWidth(context),
        height: getMainHeight(context),
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _input(context, 'Your username', usernameControl, false, validator: (value) => _checkUsername(context, value!),),
            _input(context, 'Your email', emailControl, false, validator: (value) => _checkEmail(context, value!),),
            _input(context, 'Your password', passwordControl, true, validator: (value) => _checkPassword(context, value!),),
            const SizedBox(height: 30,),

            //button
            GestureDetector(
              onTap: () async{
                if(formKey.currentState?.validate()??false){
                  authCenter.handleSignUp(context, UserThis(email: emailControl.text, pass: passwordControl.text, username: usernameControl.text));
                }
                
              },
              child: ButtonCustom(text: "Sign Up", currentContext: context)
            )
          ],
        ),
      )
    );
  }


  Widget _input(BuildContext context, String title, TextEditingController input, bool isPassword, {String? Function(String?)? validator}){
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
            validator: validator,
          )
        ],
      ),
    );
  }

}
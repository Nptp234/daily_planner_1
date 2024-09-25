import 'package:daily_planner_1/model/logo.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/main_button.dart';
import 'package:daily_planner_1/ui/auth/sign_in.dart';
import 'package:flutter/material.dart';

class WellcomePage extends StatelessWidget{
  const WellcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flexible(child: _body(context))
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: getMainWidth(context),
      height: getMainHeight(context),
      padding: const EdgeInsets.all(10),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          // Logo
          Logo(),

          // Button
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignIn()));
            },
            child: SizedBox(
              height: getMainHeight(context)/3,
              width: getMainWidth(context),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ButtonCustom(currentContext: context, text: 'Sign In',)
                  ),
                ],
              )
            ),
          )
        ],
      ),
    );
  }

}
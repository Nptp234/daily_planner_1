import 'package:daily_planner_1/data/api/user_api.dart';
import 'package:daily_planner_1/data/model/user.dart';
import 'package:daily_planner_1/data/sqlite/auth_sqlite.dart';
import 'package:daily_planner_1/model/alert.dart';
import 'package:daily_planner_1/model/bottom_bar.dart';
import 'package:daily_planner_1/model/logo.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/main_button.dart';
import 'package:daily_planner_1/ui/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class WellcomePage extends StatelessWidget{
  WellcomePage({super.key});

  UserApi userApi = UserApi();
  final currentUser = CurrentUser();
  final userSqlite = UserSqlite();
  
  Future<bool> _checkData(BuildContext context) async{
    showAlert(context, QuickAlertType.loading, "Loading local user data...");
    try{
      Map<String, dynamic> lst = await userSqlite.getUser();
      if(lst.isEmpty){
        //no local user
        return false;
      }
      else{
        final bool sign = await userApi.checkUser(lst['email'], lst['password']);
        return sign;
      }
    }
    catch(e){
      rethrow;
    }
  }

  goPage(BuildContext context, Widget widget){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
    });
  }

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
            onTap: () async{
              bool isCheck = await _checkData(context);
              if(isCheck){goPage(context, BottomMenu());}
              else{goPage(context, SignIn());}
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
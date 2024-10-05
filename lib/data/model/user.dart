class UserThis{
  String? username, email, pass;
  UserThis({this.username, this.email, this.pass});

  UserThis.fromJson(Map<dynamic, dynamic> e){
    username = e["Username"];
    email = e["Email"];
    pass = e["Pass"];
  }
}

class CurrentUser extends UserThis{
  //singleton
  CurrentUser._privateContructor();
  static final CurrentUser _instance = CurrentUser._privateContructor();
  factory CurrentUser(){
    return _instance;
  }
  //
  
  void setCurrent(UserThis user){
    username = user.username;
    email = user.email;
    pass = user.pass;
  }
}
class User{
  String? username, email, pass;
  User({this.username, this.email, this.pass});

  User.fromJson(Map<dynamic, dynamic> e){
    username = e["Username"];
    email = e["Email"];
    pass = e["Pass"];
  }
}

class CurrentUser extends User{
  //singleton
  CurrentUser._privateContructor();
  static final CurrentUser _instance = CurrentUser._privateContructor();
  factory CurrentUser(){
    return _instance;
  }
  //
  
  void setCurrent(User user){
    username = user.username;
    email = user.email;
    pass = user.pass;
  }
}
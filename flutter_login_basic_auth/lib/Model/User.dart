class User {
  String? userId;
  String? email;
  String? password;

  User({String? userId, String? email, String? password});

  constructorUser(
      {String? userId, required String email, required String password}) {
    this.userId = userId!;
    this.email = email;
    this.password = password;
  }
}

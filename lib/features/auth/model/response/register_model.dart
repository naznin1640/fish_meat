class RegisterModel {
    final String? username;
    final String? email;
    final String? password;

    RegisterModel({
         this.username,
         this.email,
         this.password,
    });

    factory RegisterModel.fromJson(Map<String, dynamic> json){
      return RegisterModel(
        username: json["username"]?.toString(),
        email: json["email"]?.toString(),
        password: json["password"]?.toString()
      );
    }

    Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
    };
}

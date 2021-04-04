class User {
  String email;
  String password;
  String name;
  String phone;
  String role;

  User({this.email, this.password, this.name, this.phone, this.role});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["email"] = this.email;
    data["password"] = this.password;
    data["name"] = this.name;
    data["phone"] = this.phone;
    data["role"] = this.role;
    return data;
  }
}
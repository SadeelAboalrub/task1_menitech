class UserModel {
  String name;
  String email;
  bool isAdmin;

  UserModel({
    required this.name,
    required this.email,
    required this.isAdmin,
  });

  factory UserModel.fromMap(Map<String, dynamic>map){
    return UserModel(name: map['name'], email: map['email'],isAdmin: map['isAdmin']);
  }

  Map<String, dynamic>toMap(){
    return{
      'name': name,
      'email':email,
      'isAdmin': isAdmin,
    };
  }
}
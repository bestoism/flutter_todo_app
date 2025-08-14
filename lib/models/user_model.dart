// Lokasi: lib/models/user_model.dart

class UserModel {
  final String id;
  String username;
  final String email;
  final String password;
  final DateTime joinDate;
  String bio; 
  String themeMode; 

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.joinDate,
    this.bio = 'Flutter enthusiast!', 
    this.themeMode = 'system', 
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'joinDate': joinDate.toIso8601String(),
      'bio': bio, 
      'themeMode': themeMode, 
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      joinDate: DateTime.parse(json['joinDate']),
      bio: json['bio'] ?? 'Flutter enthusiast!', 
      themeMode: json['themeMode'] ?? 'system', 
    );
  }
}
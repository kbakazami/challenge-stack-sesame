class User {
  String? email;
  String? username;
  String? role;
  String? photoUrl;
  User ({
    this.email,
    this.username,
    this.photoUrl,
    this.role
  });

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        email = json['email'],
        photoUrl = json['photoUrl'],
        role = json['role'];
}
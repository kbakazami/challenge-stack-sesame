class User {
  String? id;
  String? email;
  String? username;
  String? role;
  String? photoUrl;
  User ({
    this.id,
    this.email,
    this.username,
    this.photoUrl,
    this.role
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        username = json['username'],
        photoUrl = json['photoUrl'],
        role = json['role'];
}
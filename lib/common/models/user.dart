class User {
  final String username;
  final String email;
  final String bio;
  final String password;
  final String profilePhoto;
  final String uid;
  final List<dynamic> followers;
  final List<dynamic> followings;
  const User(
      {required this.username,
      required this.email,
      required this.bio,
      required this.password,
      required this.profilePhoto,
      required this.uid,
      required this.followers,
      required this.followings});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        bio: json['bio'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        password: json['password'] as String,
        profilePhoto: json['profilePhoto'] as String,
        uid: json['uid'] as String,
        followers: json['followers'] ?? [],
        followings: json['followings'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'bio': bio,
      'profilePhoto': profilePhoto,
      'followers': followers,
      'followings': followings,
      'password': password
    };
  }
}

class Comment {
  final String comment;
  final String uid;
  final DateTime postTime;
  final String username;
  final String photoUrl;
  final String id;
  final List<dynamic> likes;
  const Comment(
      {required this.comment,
      required this.uid,
      required this.postTime,
      required this.username,
      required this.photoUrl,
      required this.id,
      required this.likes});

  factory Comment.fromJson({json}) {
    return Comment(
        comment: json['comment'].toString(),
        uid: json['uid'].toString(),
        postTime: DateTime.parse(json['postTime'].toString()),
        username: json['username'].toString(),
        photoUrl: json['photoUrl'].toString(),
        id: json['id'].toString(),
        likes: json['likes']);
  }

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'uid': uid,
      'postTime': postTime.toString(),
      'photoUrl': photoUrl,
      'id': id,
      'likes': likes
    };
  }
}

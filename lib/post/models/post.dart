class Post {
  final String caption;
  final String uid;
  final String username;
  final String id;
  final DateTime publishedDate;
  final String photoPostUrl;
  final String photoPoster;
  final List<dynamic> likes;

  const Post(
      {required this.photoPoster,
      required this.caption,
      required this.uid,
      required this.username,
      required this.id,
      required this.publishedDate,
      required this.photoPostUrl,
      required this.likes});

  factory Post.fromJson({json}) {
    return Post(
      caption: json['caption'],
      uid: json['uid'],
      username: json['username'],
      id: json['id'],
      publishedDate: DateTime.parse(json['publishedDate'].toString()),
      photoPostUrl: json['photoPostUrl'],
      photoPoster: json['photoPoster'],
      likes: json['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photoPoster': photoPoster,
      'caption': caption,
      'uid': uid,
      'username': username,
      'id': id,
      'publishedDate': publishedDate.toString(),
      'photoPostUrl': photoPostUrl,
      'likes': likes
    };
  }
}

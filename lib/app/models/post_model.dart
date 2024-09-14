class Post {
  int id;
  String title;
  String body;
  bool isRead;

  Post({required this.id, required this.title, required this.body, this.isRead = false});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'isRead': isRead,
    };
  }
}

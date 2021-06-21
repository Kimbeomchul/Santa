class Board {
  String title;
  String content;
  String user;
  String created;

  Board({this.title, this.content, this.user, this.created});

  Board.fromJson(Map<String, dynamic> json)
    : title = json['title'] as String,
      content = json['content'] as String,
      user = json['user'] as String,
      created = json['created_at'] as String;
}
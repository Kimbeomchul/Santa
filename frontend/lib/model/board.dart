class Board {
  String title;
  String content;

  Board({this.title, this.content});

  Board.fromJson(Map<String, dynamic> json)
    : title = json['title'] as String,
      content = json['content'] as String;
}
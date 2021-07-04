class Board{
  Board({this.id, this.user, this.title, this.content, this.created_at, this.modified_at});

  final String id;       //주소
  final String user;     //관리자?
  final String title;  //번호
  final String content;   //짧막한 소개
  final String created_at;      //높이
  final String modified_at;   //산 이름


  Board.fromJson(Map<String, dynamic> json)
      :  id = json['id'] as String,
        user =json['user']as String,
        title = json['title']as String,
        content = json['content']as String,
        created_at = json['created_at']as String,
        modified_at = json['modified_at']as String;

}
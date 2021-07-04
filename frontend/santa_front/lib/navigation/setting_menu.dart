/*
*
* 게시판 리스트 페이지의 우측상단 메뉴버튼
* 친구?인 사람의 글만 보는 메뉴와
* 전체글을 볼 수 있는 메뉴가 존재
* BoardList의 choiceAction함수에서 분기처리
*
* */



class Constants{
  static const String followtype = "팔로워글보기";
  static const String alltype = "전체글보기";
  static const String mytype = "내가쓴글";

  static const List<String> choices  = <String>[
    alltype,
    followtype,
    mytype,
  ];

}
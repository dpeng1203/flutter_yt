class MyQuestionModel {
  final int id;
  final String detail;
  final String language;
  final String publishTime;
  final int state;
  final String title;

  MyQuestionModel({this.id, this.detail, this.language, this.publishTime,
      this.state, this.title});

  factory MyQuestionModel.fromJson(Map<String, dynamic> json) {
    return MyQuestionModel(
        id: json['id'],
        detail: json['detail'],
        language: json['language'],
        publishTime: json['publishTime'],
        title: json['title'],
        state: json['state']
        );
  }
}

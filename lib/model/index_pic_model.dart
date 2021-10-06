class IndexPicModel {
  String detail;
  String publishTime;
  int state;
  String title;

  IndexPicModel({this.detail, this.publishTime, this.state, this.title});

  IndexPicModel.fromJson(Map<String, dynamic> json) {
    detail = json['detail'];
    publishTime = json['publishTime'];
    state = json['state'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['detail'] = this.detail;
    data['publishTime'] = this.publishTime;
    data['state'] = this.state;
    data['title'] = this.title;
    return data;
  }
}

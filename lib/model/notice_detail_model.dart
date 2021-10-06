class NoticeDetailModel {
  int id;
  String title;
  String publishTime;
  String detail;
  int state;
  Null picUrl;
  Null clickUrl;
  Null language;

  NoticeDetailModel(
      {this.id,
      this.title,
      this.publishTime,
      this.detail,
      this.state,
      this.picUrl,
      this.clickUrl,
      this.language});

  NoticeDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    publishTime = json['publishTime'];
    detail = json['detail'];
    state = json['state'];
    picUrl = json['picUrl'];
    clickUrl = json['clickUrl'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['publishTime'] = this.publishTime;
    data['detail'] = this.detail;
    data['state'] = this.state;
    data['picUrl'] = this.picUrl;
    data['clickUrl'] = this.clickUrl;
    data['language'] = this.language;
    return data;
  }
}
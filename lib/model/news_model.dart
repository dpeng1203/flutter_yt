class NewsModel {
  int pageIndex;
  int pageSize;
  int total;
  int pageCount;
  int firstItemIndex;
  List<Rows> rows;

  NewsModel(
      {this.pageIndex,
      this.pageSize,
      this.total,
      this.pageCount,
      this.firstItemIndex,
      this.rows});

  NewsModel.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    total = json['total'];
    pageCount = json['pageCount'];
    firstItemIndex = json['firstItemIndex'];
    if (json['rows'] != null) {
      rows = new List<Rows>();
      json['rows'].forEach((v) {
        rows.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;
    data['total'] = this.total;
    data['pageCount'] = this.pageCount;
    data['firstItemIndex'] = this.firstItemIndex;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rows {
  int id;
  String title;
  String logo;
  String author;
  String updateTime;
  String publishTime;
  int pid;
  String terrace;
  Null context;
  int pageviews;
  int isTop;

  Rows(
      {this.id,
      this.title,
      this.logo,
      this.author,
      this.updateTime,
      this.publishTime,
      this.pid,
      this.terrace,
      this.context,
      this.pageviews,
      this.isTop});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    logo = json['logo'];
    author = json['author'];
    updateTime = json['updateTime'];
    publishTime = json['publishTime'];
    pid = json['pid'];
    terrace = json['terrace'];
    context = json['context'];
    pageviews = json['pageviews'];
    isTop = json['isTop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['logo'] = this.logo;
    data['author'] = this.author;
    data['updateTime'] = this.updateTime;
    data['publishTime'] = this.publishTime;
    data['pid'] = this.pid;
    data['terrace'] = this.terrace;
    data['context'] = this.context;
    data['pageviews'] = this.pageviews;
    data['isTop'] = this.isTop;
    return data;
  }
}
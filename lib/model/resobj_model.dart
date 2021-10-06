class ResObj<T> {
  String code;
  String message;
  T data;
  ResObj({this.code, this.message, this.data});

  ResObj.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    // var fromJson = fromJson;
    // data = T.fromJson(json('data'));
  }
}

// class BaseClass {
//   fromJson(Map<String, dynamic> json) {}
//   Map<String, dynamic> toJson() {}
// }

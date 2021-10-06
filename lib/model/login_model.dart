class LoginModel {
  int memberId;
  String logoPath;
  String mobile;
  String loginAccount;
  String userName;
  int memberState;
  String token;
  String accountType;

  LoginModel({this.memberId, this.logoPath, this.mobile, this.loginAccount, this.userName, this.memberState, this.token, this.accountType});

  LoginModel.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    logoPath = json['logoPath'];
    mobile = json['mobile'];
    loginAccount = json['loginAccount'];
    userName = json['userName'];
    memberState = json['memberState'];
    token = json['token'];
    accountType = json['accountType'];
  }

//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['memberId'] = this.memberId;
//    data['logoPath'] = this.logoPath;
//    data['mobile'] = this.mobile;
//    data['loginAccount'] = this.loginAccount;
//    data['userName'] = this.userName;
//    data['memberState'] = this.memberState;
//    data['token'] = this.token;
//    data['accountType'] = this.accountType;
//    return data;
//  }
}


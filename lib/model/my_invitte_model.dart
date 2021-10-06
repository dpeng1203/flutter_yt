class MyInvitteModel {
  int memberId;
  String inviteCode;
  String createTime;
  int state;
  String inviteImage;
  String lanuage;

  MyInvitteModel(
      {this.memberId,
        this.inviteCode,
        this.createTime,
        this.state,
        this.inviteImage,this.lanuage});

  MyInvitteModel.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    inviteCode = json['inviteCode'];
    createTime = json['createTime'];
    state = json['state'];
    inviteImage = json['inviteImage'];
    lanuage = json['lanuage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberId'] = this.memberId;
    data['inviteCode'] = this.inviteCode;
    data['createTime'] = this.createTime;
    data['state'] = this.state;
    data['inviteImage'] = this.inviteImage;
    data['lanuage'] = this.lanuage;
    return data;
  }
}

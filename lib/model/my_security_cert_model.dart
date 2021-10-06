class MySecurityCertModel {
  int id;
  int memberId;
  String certProfileType;
  String certData;
  int state;
  String refuseReason;
  String submitTime;
  String realName;

  MySecurityCertModel(
      {this.id,
      this.memberId,
      this.certProfileType,
      this.certData,
      this.state,
      this.refuseReason,
      this.submitTime,
      this.realName});

  MySecurityCertModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['memberId'];
    certProfileType = json['certProfileType'];
    certData = json['certData'];
    state = json['state'];
    refuseReason = json['refuseReason'];
    submitTime = json['submitTime'];
    realName = json['realName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['memberId'] = this.memberId;
    data['certProfileType'] = this.certProfileType;
    data['certData'] = this.certData;
    data['state'] = this.state;
    data['refuseReason'] = this.refuseReason;
    data['submitTime'] = this.submitTime;
    data['realName'] = this.realName;
    return data;
  }
}

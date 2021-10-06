class CoinAddressModel {
  int id;
  int memberId;
  String coinType;
  String memo;
  String remarks;
  String createTime;
  String address;

  CoinAddressModel(
      {this.id,
        this.memberId,
        this.coinType,
        this.memo,
        this.remarks,
        this.createTime,
        this.address});

  CoinAddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['memberId'];
    coinType = json['coinType'];
    memo = json['memo'];
    remarks = json['remarks'];
    createTime = json['createTime'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['memberId'] = this.memberId;
    data['coinType'] = this.coinType;
    data['memo'] = this.memo;
    data['remarks'] = this.remarks;
    data['createTime'] = this.createTime;
    data['address'] = this.address;
    return data;
  }
}

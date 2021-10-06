class MyWalletListModel {
  int id;
  int memberId;
  String coinType;
  String memo;
  String createTime;
  String address;

  MyWalletListModel(
      {this.id,
        this.memberId,
        this.coinType,
        this.memo,
        this.createTime,
        this.address});

  MyWalletListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['memberId'];
    coinType = json['coinType'];
    memo = json['memo'];
    createTime = json['createTime'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['memberId'] = this.memberId;
    data['coinType'] = this.coinType;
    data['memo'] = this.memo;
    data['createTime'] = this.createTime;
    data['address'] = this.address;
    return data;
  }
}

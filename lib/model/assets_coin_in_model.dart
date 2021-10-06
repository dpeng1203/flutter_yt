class AssetsCoinInModel {
  int memberId;
  String coinType;
  String address;
  String createTime;
  String addressQr;

  AssetsCoinInModel(
      {this.memberId,
        this.coinType,
        this.address,
        this.createTime,
        this.addressQr});

  AssetsCoinInModel.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    coinType = json['coinType'];
    address = json['address'];
    createTime = json['createTime'];
    addressQr = json['addressQr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberId'] = this.memberId;
    data['coinType'] = this.coinType;
    data['address'] = this.address;
    data['createTime'] = this.createTime;
    data['addressQr'] = this.addressQr;
    return data;
  }
}

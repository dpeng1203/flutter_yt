class AssetsOutCoinTypeModel {
  String coinType;
  double coinPrice;
  double outMin;
  double outFees;

  AssetsOutCoinTypeModel(
      {this.coinType, this.coinPrice, this.outMin, this.outFees});

  AssetsOutCoinTypeModel.fromJson(Map<String, dynamic> json) {
    coinType = json['coinType'];
    coinPrice = json['coinPrice'];
    outMin = json['outMin'];
    outFees = json['outFees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coinType'] = this.coinType;
    data['coinPrice'] = this.coinPrice;
    data['outMin'] = this.outMin;
    data['outFees'] = this.outFees;
    return data;
  }
}

class HomeCoinModel {
  final double coinPrice;
  final String coinType;
  final double outFees;
  final double outMin;
  final String pic;

  HomeCoinModel({this.coinPrice, this.coinType, this.outFees, this.outMin, this.pic});

  factory HomeCoinModel.fromJson(Map<String, dynamic> json) {
    return HomeCoinModel(
        coinPrice: json['coinPrice'],
        coinType: json['coinType'],
        outFees: json['outFees'],
        pic: json['pic'],
        outMin: json['outMin']);
  }
}

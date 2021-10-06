class MyModel {
  final num totalAmount;
  final num totalAmountLock;
  final num totalBalance;
  final bool transfer;
  final String logoPath;
  final String nickName;
  final int memberId;

  MyModel({this.totalAmount, this.totalAmountLock, this.totalBalance,this.transfer,this.logoPath,this.memberId,this.nickName});

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
        totalAmount: json['totalAmount'],
        transfer: json['transfer'],
        totalAmountLock: json['totalAmountLock'],
        logoPath: json['logoPath'],
        nickName: json['nickName'],
        memberId: json['memberId'],
        totalBalance: json['totalBalance']);
  }
}
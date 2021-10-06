class AssetsModel {
  int id;
  int memberId;
  String coinType;
  String amount;
  dynamic amountLock;
  dynamic displayState;
  int displayOrder;
  int totalUnit;
  String fmLimit;
  String totalBalance;
  String usdtAmountValue;
  String yesterdaysEarnings;

  AssetsModel(
      {this.id,
        this.memberId,
        this.coinType,
        this.amount,
        this.amountLock,
        this.displayState,
        this.displayOrder,
        this.totalUnit,
        this.fmLimit,
        this.totalBalance,
        this.usdtAmountValue,
        this.yesterdaysEarnings});

  AssetsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['memberId'];
    coinType = json['coinType'];
    amount = json['amount'];
    amountLock = json['amountLock'];
    displayState = json['displayState'];
    displayOrder = json['displayOrder'];
    totalUnit = json['totalUnit'];
    fmLimit = json['fmLimit'];
    totalBalance = json['totalBalance'];
    usdtAmountValue = json['usdtAmountValue'];
    yesterdaysEarnings = json['yesterdaysEarnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['memberId'] = this.memberId;
    data['coinType'] = this.coinType;
    data['amount'] = this.amount;
    data['amountLock'] = this.amountLock;
    data['displayState'] = this.displayState;
    data['displayOrder'] = this.displayOrder;
    data['totalUnit'] = this.totalUnit;
    data['fmLimit'] = this.fmLimit;
    data['totalBalance'] = this.totalBalance;
    data['usdtAmountValue'] = this.usdtAmountValue;
    data['yesterdaysEarnings'] = this.yesterdaysEarnings;
    return data;
  }
}

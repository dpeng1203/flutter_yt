class ModelBalance {
  num id;
  num memberId;
  String coinType;
  String address;
  String balance;
  String amount;
  num amountLock;

  num displayState;
  num displayOrder;
  String sum;
  num totalUnit;
  String btc;
  String fm;
  String fmLimit;
  String totalBalance;

  String goodsValue;

  String usdtAmountValue;
  String usdtAmount;
  String usdtLock;
  String btcAmount;
  String btcLock;
  String ethAmount;
  String ethLock;
  String fmAmount;
  String fmLock;
  String cxcAmount;
  String cxcLock;
  String etcAmount;
  String etcLock;
  String ltcAmount;
  String ltcLock;
  String bchAmount;
  String bchLock;
  Null brcAmount;
  String brcLock;
  String eosAmount;
  String eosLock;
  String xrpAmount;
  String xrpLock;
  String yesterdaysEarnings;
  String totalAmountLock;
  String totalAmount;
  AssignAssets assignAssets;

  ModelBalance(
      {this.id,
      this.memberId,
      this.coinType,
      this.address,
      this.balance,
      this.amount,
      this.amountLock,
      this.displayState,
      this.displayOrder,
      this.sum,
      this.totalUnit,
      this.btc,
      this.fm,
      this.fmLimit,
      this.totalBalance,
      this.goodsValue,
      this.usdtAmountValue,
      this.usdtAmount,
      this.usdtLock,
      this.btcAmount,
      this.btcLock,
      this.ethAmount,
      this.ethLock,
      this.fmAmount,
      this.fmLock,
      this.cxcAmount,
      this.cxcLock,
      this.etcAmount,
      this.etcLock,
      this.ltcAmount,
      this.ltcLock,
      this.bchAmount,
      this.bchLock,
      this.brcAmount,
      this.brcLock,
      this.eosAmount,
      this.eosLock,
      this.xrpAmount,
      this.xrpLock,
      this.yesterdaysEarnings,
      this.totalAmountLock,
      this.assignAssets,
      this.totalAmount});

  ModelBalance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['memberId'];
    coinType = json['coinType'];
    address = json['address'];
    balance = json['balance'];
    amount = json['amount'];
    amountLock = json['amountLock'];
    displayState = json['displayState'];
    displayOrder = json['displayOrder'];
    sum = json['sum'];
    totalUnit = json['totalUnit'];
    btc = json['btc'];
    fm = json['fm'];
    fmLimit = json['fmLimit'];
    totalBalance = json['totalBalance'];

    goodsValue = json['goodsValue'];

    usdtAmountValue = json['usdtAmountValue'];
    usdtAmount = json['usdtAmount'];
    usdtLock = json['usdtLock'];
    btcAmount = json['btcAmount'];
    btcLock = json['btcLock'];
    ethAmount = json['ethAmount'];
    ethLock = json['ethLock'];
    fmAmount = json['fmAmount'];
    fmLock = json['fmLock'];
    cxcAmount = json['cxcAmount'];
    cxcLock = json['cxcLock'];
    etcAmount = json['etcAmount'];
    etcLock = json['etcLock'];
    ltcAmount = json['ltcAmount'];
    ltcLock = json['ltcLock'];
    bchAmount = json['bchAmount'];
    bchLock = json['bchLock'];
    brcAmount = json['brcAmount'];
    brcLock = json['brcLock'];
    eosAmount = json['eosAmount'];
    eosLock = json['eosLock'];
    xrpAmount = json['xrpAmount'];
    xrpLock = json['xrpLock'];
    yesterdaysEarnings = json['yesterdaysEarnings'];
    totalAmountLock = json['totalAmountLock'];
    assignAssets = json['assignAssets'] != null
        ? new AssignAssets.fromJson(json['assignAssets'])
        : null;
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['memberId'] = this.memberId;
    data['coinType'] = this.coinType;
    data['address'] = this.address;
    data['balance'] = this.balance;
    data['amount'] = this.amount;
    data['amountLock'] = this.amountLock;
    data['displayState'] = this.displayState;
    data['displayOrder'] = this.displayOrder;
    data['sum'] = this.sum;
    data['totalUnit'] = this.totalUnit;
    data['btc'] = this.btc;
    data['fm'] = this.fm;
    data['fmLimit'] = this.fmLimit;
    data['totalBalance'] = this.totalBalance;
    data['goodsValue'] = this.goodsValue;
    data['usdtAmountValue'] = this.usdtAmountValue;
    data['usdtAmount'] = this.usdtAmount;
    data['usdtLock'] = this.usdtLock;
    data['btcAmount'] = this.btcAmount;
    data['btcLock'] = this.btcLock;
    data['ethAmount'] = this.ethAmount;
    data['ethLock'] = this.ethLock;
    data['fmAmount'] = this.fmAmount;
    data['fmLock'] = this.fmLock;
    data['cxcAmount'] = this.cxcAmount;
    data['cxcLock'] = this.cxcLock;
    data['etcAmount'] = this.etcAmount;
    data['etcLock'] = this.etcLock;
    data['ltcAmount'] = this.ltcAmount;
    data['ltcLock'] = this.ltcLock;
    data['bchAmount'] = this.bchAmount;
    data['bchLock'] = this.bchLock;
    data['brcAmount'] = this.brcAmount;
    data['brcLock'] = this.brcLock;
    data['eosAmount'] = this.eosAmount;
    data['eosLock'] = this.eosLock;
    data['xrpAmount'] = this.xrpAmount;
    data['xrpLock'] = this.xrpLock;
    if (this.assignAssets != null) {
      data['assignAssets'] = this.assignAssets.toJson();
    }
    data['yesterdaysEarnings'] = this.yesterdaysEarnings;
    data['totalAmountLock'] = this.totalAmountLock;
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}

class AssignAssets {
  String assignCoin;
  String assignAmount;
  String assignRepaid;
  String assignBeRepaid;
  String state;

  AssignAssets(
      {this.assignCoin,
      this.assignAmount,
      this.assignRepaid,
      this.assignBeRepaid,
      this.state});

  AssignAssets.fromJson(Map<String, dynamic> json) {
    assignCoin = json['assignCoin'];
    assignAmount = json['assignAmount'];
    assignRepaid = json['assignRepaid'];
    assignBeRepaid = json['assignBeRepaid'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assignCoin'] = this.assignCoin;
    data['assignAmount'] = this.assignAmount;
    data['assignRepaid'] = this.assignRepaid;
    data['assignBeRepaid'] = this.assignBeRepaid;
    data['state'] = this.state;
    return data;
  }
}

class ModelAssignCheck {
  String useAmount;
  String useAssignAmount;

  ModelAssignCheck({this.useAmount, this.useAssignAmount});

  ModelAssignCheck.fromJson(Map<String, dynamic> json) {
    useAmount = json['useAmount'];
    useAssignAmount = json['useAssignAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['useAmount'] = this.useAmount;
    data['useAssignAmount'] = this.useAssignAmount;
    return data;
  }
}

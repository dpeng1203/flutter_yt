class ModelGoods {
  int id;
  String goodsCode;
  String goodsType;
  String coinType;
  int cycle;
  String cycleType;
  String settlementType;
  int returnRent;
  double electricityFees;
  double maintenanceFees;
  int stock;
  double fmRewardNum;
  int fmRewardType;
  double serviceFees;
  String unit;
  double price;
  int state;
  int isTop;
  int sortNumber;
  bool isMining;
  double rentIncomeRate = 0;
  String coinName;
  int packType;
  int isSuper;
  String goodsName;
  String detail;
  double btcDayIncome = 0;
  String riskWarning;
  String contractDescription;
  bool mining;

  ModelGoods(
      {this.id,
      this.goodsCode,
      this.btcDayIncome,
      this.goodsType,
      this.coinType,
      this.cycle,
      this.cycleType,
      this.settlementType,
      this.returnRent,
      this.electricityFees,
      this.maintenanceFees,
      this.stock,
      this.fmRewardNum,
      this.fmRewardType,
      this.serviceFees,
      this.unit,
      this.price,
      this.state,
      this.isTop,
      this.sortNumber,
      this.isMining,
      this.rentIncomeRate,
      this.coinName,
      this.packType,
      this.isSuper,
      this.goodsName,
      this.detail,
      this.riskWarning,
      this.contractDescription,
      this.mining});

  ModelGoods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsCode = json['goodsCode'];
    goodsType = json['goodsType'];
    coinType = json['coinType'];
    cycle = json['cycle'];
    cycleType = json['cycleType'];
    settlementType = json['settlementType'];
    returnRent = json['returnRent'];
    electricityFees = json['electricityFees'];
    maintenanceFees = json['maintenanceFees'];
    stock = json['stock'];
    fmRewardNum = json['fmRewardNum'];
    fmRewardType = json['fmRewardType'];
    serviceFees = json['serviceFees'];
    unit = json['unit'];
    price = json['price'];
    state = json['state'];
    isTop = json['isTop'];
    sortNumber = json['sortNumber'];
    isMining = json['isMining'];
    rentIncomeRate = json['rentIncomeRate'];
    coinName = json['coinName'];
    packType = json['packType'];
    isSuper = json['isSuper'];
    goodsName = json['goodsName'];
    detail = json['detail'];
    riskWarning = json['riskWarning'];
    contractDescription = json['contractDescription'];
    mining = json['mining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goodsCode'] = this.goodsCode;
    data['btcDayIncome'] = this.btcDayIncome;
    data['goodsType'] = this.goodsType;
    data['coinType'] = this.coinType;
    data['cycle'] = this.cycle;
    data['cycleType'] = this.cycleType;
    data['settlementType'] = this.settlementType;
    data['returnRent'] = this.returnRent;
    data['electricityFees'] = this.electricityFees;
    data['maintenanceFees'] = this.maintenanceFees;
    data['stock'] = this.stock;
    data['fmRewardNum'] = this.fmRewardNum;
    data['fmRewardType'] = this.fmRewardType;
    data['serviceFees'] = this.serviceFees;
    data['unit'] = this.unit;
    data['price'] = this.price;
    data['state'] = this.state;
    data['isTop'] = this.isTop;
    data['sortNumber'] = this.sortNumber;
    data['isMining'] = this.isMining;
    data['rentIncomeRate'] = this.rentIncomeRate;
    data['coinName'] = this.coinName;
    data['packType'] = this.packType;
    data['isSuper'] = this.isSuper;
    data['goodsName'] = this.goodsName;
    data['detail'] = this.detail;
    data['riskWarning'] = this.riskWarning;
    data['contractDescription'] = this.contractDescription;
    data['mining'] = this.mining;
    return data;
  }
}

class ModelUpGrade {
  String goodsCode;
  num price;
  String unit;
  num remainPayAmount;

  ModelUpGrade({this.goodsCode, this.price, this.unit, this.remainPayAmount});

  ModelUpGrade.fromJson(Map<String, dynamic> json) {
    goodsCode = json['goodsCode'];
    price = json['price'];
    unit = json['unit'];
    remainPayAmount = json['remainPayAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodsCode'] = this.goodsCode;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['remainPayAmount'] = this.remainPayAmount;
    return data;
  }
}

class GoodsUpGradeAmount {
  num remainPayAmount;
  num remainPayAmount2;
  String unit;
  String unit2;

  GoodsUpGradeAmount(
      {this.remainPayAmount, this.remainPayAmount2, this.unit, this.unit2});

  GoodsUpGradeAmount.fromJson(Map<String, dynamic> json) {
    remainPayAmount = json['remainPayAmount'];
    remainPayAmount2 = json['remainPayAmount2'];
    unit = json['unit'];
    unit2 = json['unit2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remainPayAmount'] = this.remainPayAmount;
    data['remainPayAmount2'] = this.remainPayAmount2;
    data['unit'] = this.unit;
    data['unit2'] = this.unit2;
    return data;
  }
}

class ModelGoodsView {
  List<ModelUpGrade> uplist;
  ModelGoods goods;
  ModelGoodsView({this.uplist, this.goods});
}

class GoodsDetailsParams {
  String goodsCode;
  String orderCode;
  num totalcount;
  GoodsDetailsParams({this.goodsCode, this.orderCode, this.totalcount});
}

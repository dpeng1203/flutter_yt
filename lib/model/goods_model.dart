class GoodsModel {
  int pageIndex;
  int pageSize;
  int total;
  int pageCount;
  int firstItemIndex;
  List<Rows> rows;

  GoodsModel(
      {this.pageIndex,
        this.pageSize,
        this.total,
        this.pageCount,
        this.firstItemIndex,
        this.rows});

  GoodsModel.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    total = json['total'];
    pageCount = json['pageCount'];
    firstItemIndex = json['firstItemIndex'];
    if (json['rows'] != null) {
      rows = new List<Rows>();
      json['rows'].forEach((v) {
        rows.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;
    data['total'] = this.total;
    data['pageCount'] = this.pageCount;
    data['firstItemIndex'] = this.firstItemIndex;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rows {
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
  double rentIncomeRate;
  String coinName;
  int packType;
  int isSuper;
  String goodsName;
  String detail;
  String riskWarning;
  String contractDescription;
  bool mining;

  Rows(
      {this.id,
        this.goodsCode,
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

  Rows.fromJson(Map<String, dynamic> json) {
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
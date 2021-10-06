class MiningData {
  MiningSettlementBooksVo settlementBooksVo;
  List<MiningGoods> goods;
  MiningOrdersVo ordersVo;
  MiningPayBooksVo payBooksVo;
  num totalHashRate;
  num totalMiningAmount;
  num totalRewardAmount;
  num hashRateValuation;

  MiningData(
      {this.goods,
      this.ordersVo,
      this.payBooksVo,
      this.settlementBooksVo,
      this.totalHashRate,
      this.totalMiningAmount,
      this.totalRewardAmount,
      this.hashRateValuation});

  MiningData.fromJson(Map<String, dynamic> json) {
    settlementBooksVo = json['settlementBooksVo'] != null
        ? new MiningSettlementBooksVo.fromJson(json['settlementBooksVo'])
        : null;
    payBooksVo = json['payBooksVo'] != null
        ? new MiningPayBooksVo.fromJson(json['payBooksVo'])
        : null;
    ordersVo = json['ordersVo'] != null
        ? new MiningOrdersVo.fromJson(json['ordersVo'])
        : null;
    if (json['goods'] != null) {
      goods = new List<MiningGoods>();
      json['goods'].forEach((v) {
        goods.add(new MiningGoods.fromJson(v));
      });
    }
    totalHashRate = json['totalHashRate'];
    totalMiningAmount = json['totalMiningAmount'];
    totalRewardAmount = json['totalRewardAmount'];
    hashRateValuation = json['hashRateValuation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.goods != null) {
      data['goods'] = this.goods.map((v) => v.toJson()).toList();
    }
    data['totalHashRate'] = this.totalHashRate;
    data['totalMiningAmount'] = this.totalMiningAmount;
    data['totalRewardAmount'] = this.totalRewardAmount;
    data['hashRateValuation'] = this.hashRateValuation;
    return data;
  }
}

class MiningGoods {
  int id;
  String goodsCode;
  String goodsName;
  String goodsType;
  String coinType;
  int cycle;
  String cycleType;
  String settlementType;
  int returnRent;
  double electricityFees = 0;
  double maintenanceFees;
  int stock;
  double fmRewardNum;
  int fmRewardType;
  double serviceFees;
  String unit;
  double price;
  String detail;
  int state;
  int isTop;
  int sortNumber;
  int page;
  int pageSize;
  String riskWarning;
  String contractDescription;
  double rentIncomeRate;
  String coinName;
  String packType;
  int isSuper;
  int totalHashrate;
  int totalCount;
  double totalMiningAmount;
  double totalRewardAmount;
  String lastEndDate;
  int orderState;
  bool judge;
  bool mining;
  int fmRate;
  int coinRate;

  MiningGoods(
      {this.id,
      this.goodsCode,
      this.goodsName,
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
      this.detail,
      this.state,
      this.isTop,
      this.sortNumber,
      this.page,
      this.pageSize,
      this.riskWarning,
      this.contractDescription,
      this.rentIncomeRate,
      this.coinName,
      this.packType,
      this.isSuper,
      this.totalHashrate,
      this.totalCount,
      this.totalMiningAmount,
      this.totalRewardAmount,
      this.lastEndDate,
      this.orderState,
      this.judge,
      this.mining,
      this.fmRate,
      this.coinRate});

  MiningGoods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsCode = json['goodsCode'];
    goodsName = json['goodsName'];
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
    detail = json['detail'];
    state = json['state'];
    isTop = json['isTop'];
    sortNumber = json['sortNumber'];
    page = json['page'];
    pageSize = json['pageSize'];
    riskWarning = json['riskWarning'];
    contractDescription = json['contractDescription'];
    rentIncomeRate = json['rentIncomeRate'];
    coinName = json['coinName'];
    packType = json['packType'];
    isSuper = json['isSuper'];
    totalHashrate = json['totalHashrate'];
    totalCount = json['totalCount'];
    totalMiningAmount = json['totalMiningAmount'];
    totalRewardAmount = json['totalRewardAmount'];
    lastEndDate = json['lastEndDate'];
    orderState = json['orderState'];
    judge = json['judge'];
    mining = json['mining'];
    fmRate = json['fmRate'];
    coinRate = json['coinRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goodsCode'] = this.goodsCode;
    data['goodsName'] = this.goodsName;
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
    data['detail'] = this.detail;
    data['state'] = this.state;
    data['isTop'] = this.isTop;
    data['sortNumber'] = this.sortNumber;
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    data['riskWarning'] = this.riskWarning;
    data['contractDescription'] = this.contractDescription;
    data['rentIncomeRate'] = this.rentIncomeRate;
    data['coinName'] = this.coinName;
    data['packType'] = this.packType;
    data['isSuper'] = this.isSuper;
    data['totalHashrate'] = this.totalHashrate;
    data['totalCount'] = this.totalCount;
    data['totalMiningAmount'] = this.totalMiningAmount;
    data['totalRewardAmount'] = this.totalRewardAmount;
    data['lastEndDate'] = this.lastEndDate;
    data['orderState'] = this.orderState;
    data['judge'] = this.judge;
    data['mining'] = this.mining;
    data['fmRate'] = this.fmRate;
    data['coinRate'] = this.coinRate;
    return data;
  }
}

class MiningOrdersVo {
  int pageIndex;
  int pageSize;
  int total;
  int pageCount;
  int firstItemIndex;
  List<MiningOrdersRow> rows;

  MiningOrdersVo(
      {this.pageIndex,
      this.pageSize,
      this.total,
      this.pageCount,
      this.firstItemIndex,
      this.rows});

  MiningOrdersVo.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    total = json['total'];
    pageCount = json['pageCount'];
    firstItemIndex = json['firstItemIndex'];
    if (json['rows'] != null) {
      rows = new List<MiningOrdersRow>();
      json['rows'].forEach((v) {
        rows.add(new MiningOrdersRow.fromJson(v));
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

class MiningOrdersRow {
  int id;
  String orderCode;
  int memberId;
  String goodsCode;
  String goodsName;
  String goodsType;
  int num;
  double price;
  double amount;
  String orderTime;
  String payType;
  String payType2;
  String payTime;
  double payAmount;
  double payAmount2;
  String startTime;
  String endTime;
  double coinProfit;
  double fmProfit;
  int state;
  String ransomLimitDate;
  int inviteFlag;
  int locking;
  int isBooked;
  String rentProportion;
  String unit;
  double fmRewardNum;
  int activate;
  double couponAmount = 0;
  int totalHashrate;
  dynamic totalMiningAmount;
  dynamic totalRewardAmount;
  int days;
  String deduct;
  String settlementType;
  String stateStr;
  bool judge;
  String coinName;
  double rentIncomeRate;
  int packType;
  int isSuper;
  String amountUnit;
  String couponAmountValue;
  int ransomLimitFlag;
  int orderLevelUpFlag;
  String beforePayAmount;
  double profitCoinAmount = 0;

  MiningOrdersRow(
      {this.id,
      this.orderCode,
      this.memberId,
      this.goodsCode,
      this.goodsName,
      this.goodsType,
      this.num,
      this.price,
      this.amount,
      this.orderTime,
      this.payType,
      this.payType2,
      this.payTime,
      this.payAmount,
      this.payAmount2,
      this.startTime,
      this.endTime,
      this.coinProfit,
      this.fmProfit,
      this.state,
      this.inviteFlag,
      this.isBooked,
      this.rentProportion,
      this.unit,
      this.locking,
      this.fmRewardNum,
      this.activate,
      this.couponAmount,
      this.totalHashrate,
      this.totalMiningAmount,
      this.totalRewardAmount,
      this.days,
      this.deduct,
      this.settlementType,
      this.stateStr,
      this.judge,
      this.coinName,
      this.rentIncomeRate,
      this.ransomLimitDate,
      this.packType,
      this.isSuper,
      this.amountUnit,
      this.couponAmountValue,
      this.ransomLimitFlag,
      this.orderLevelUpFlag,
      this.beforePayAmount,
      this.profitCoinAmount});

  MiningOrdersRow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderCode = json['orderCode'];
    memberId = json['memberId'];
    goodsCode = json['goodsCode'];
    goodsName = json['goodsName'];
    goodsType = json['goodsType'];
    num = json['num'];
    price = json['price'];
    amount = json['amount'];
    orderTime = json['orderTime'];
    payType = json['payType'];
    payType2 = json['payType2'];
    payTime = json['payTime'];
    payAmount = json['payAmount'];
    payAmount2 = json['payAmount2'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    coinProfit = json['coinProfit'];
    fmProfit = json['fmProfit'];
    state = json['state'];
    inviteFlag = json['inviteFlag'];
    isBooked = json['isBooked'];
    rentProportion = json['rentProportion'];
    unit = json['unit'];
    fmRewardNum = json['fmRewardNum'];
    activate = json['activate'];
    couponAmount = json['couponAmount'];
    totalHashrate = json['totalHashrate'];
    totalMiningAmount = json['totalMiningAmount'];
    totalRewardAmount = json['totalRewardAmount'];
    days = json['days'];
    deduct = json['deduct'];
    settlementType = json['settlementType'];
    stateStr = json['stateStr'];
    judge = json['judge'];
    coinName = json['coinName'];
    rentIncomeRate = json['rentIncomeRate'];
    locking = json['locking'];
    packType = json['packType'];
    ransomLimitDate = json['ransomLimitDate'];
    isSuper = json['isSuper'];
    couponAmountValue = json['couponAmountValue'];
    amountUnit = json['amountUnit'];
    ransomLimitFlag = json['ransomLimitFlag'];
    orderLevelUpFlag = json['orderLevelUpFlag'];
    beforePayAmount = json['beforePayAmount'];
    profitCoinAmount = json['profitCoinAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderCode'] = this.orderCode;
    data['memberId'] = this.memberId;
    data['goodsCode'] = this.goodsCode;
    data['goodsName'] = this.goodsName;
    data['goodsType'] = this.goodsType;
    data['num'] = this.num;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['orderTime'] = this.orderTime;
    data['payType'] = this.payType;
    data['payType2'] = this.payType2;
    data['payTime'] = this.payTime;
    data['payAmount'] = this.payAmount;
    data['payAmount2'] = this.payAmount2;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['coinProfit'] = this.coinProfit;
    data['fmProfit'] = this.fmProfit;
    data['state'] = this.state;
    data['inviteFlag'] = this.inviteFlag;
    data['isBooked'] = this.isBooked;
    data['rentProportion'] = this.rentProportion;
    data['locking'] = this.locking;
    data['unit'] = this.unit;
    data['fmRewardNum'] = this.fmRewardNum;
    data['activate'] = this.activate;
    data['couponAmount'] = this.couponAmount;
    data['totalHashrate'] = this.totalHashrate;
    data['totalMiningAmount'] = this.totalMiningAmount;
    data['totalRewardAmount'] = this.totalRewardAmount;
    data['days'] = this.days;
    data['deduct'] = this.deduct;
    data['settlementType'] = this.settlementType;
    data['stateStr'] = this.stateStr;
    data['judge'] = this.judge;
    data['coinName'] = this.coinName;
    data['ransomLimitDate'] = this.ransomLimitDate;
    data['rentIncomeRate'] = this.rentIncomeRate;
    data['packType'] = this.packType;
    data['isSuper'] = this.isSuper;
    data['amountUnit'] = this.amountUnit;
    data['couponAmountValue'] = this.couponAmountValue;
    data['ransomLimitFlag'] = this.ransomLimitFlag;
    data['orderLevelUpFlag'] = this.orderLevelUpFlag;
    data['beforePayAmount'] = this.beforePayAmount;
    data['profitCoinAmount'] = this.profitCoinAmount;
    return data;
  }
}

class MiningPayBooksVo {
  int pageIndex;
  int pageSize;
  int total;
  int pageCount;
  int firstItemIndex;
  List<MiningPayBooksVoRows> rows;

  MiningPayBooksVo(
      {this.pageIndex,
      this.pageSize,
      this.total,
      this.pageCount,
      this.firstItemIndex,
      this.rows});

  MiningPayBooksVo.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    total = json['total'];
    pageCount = json['pageCount'];
    firstItemIndex = json['firstItemIndex'];
    if (json['rows'] != null) {
      rows = new List<MiningPayBooksVoRows>();
      json['rows'].forEach((v) {
        rows.add(new MiningPayBooksVoRows.fromJson(v));
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

class MiningPayBooksVoRows {
  String payCode;
  int memberId;
  String orderCode;
  String payType;
  String payType2;
  String payTime;
  num usdtAmount;
  num actualAmount;
  num actualAmount2;
  int state;
  String goodsName;
  String goodsType;

  MiningPayBooksVoRows(
      {this.payCode,
      this.memberId,
      this.orderCode,
      this.payType,
      this.payType2,
      this.payTime,
      this.usdtAmount,
      this.actualAmount,
      this.actualAmount2,
      this.state,
      this.goodsName,
      this.goodsType});

  MiningPayBooksVoRows.fromJson(Map<String, dynamic> json) {
    payCode = json['payCode'];
    memberId = json['memberId'];
    orderCode = json['orderCode'];
    payType = json['payType'];
    payType2 = json['payType2'];
    payTime = json['payTime'];
    usdtAmount = json['usdtAmount'];
    actualAmount = json['actualAmount'];
    actualAmount2 = json['actualAmount2'];
    state = json['state'];
    goodsName = json['goodsName'];
    goodsType = json['goodsType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payCode'] = this.payCode;
    data['memberId'] = this.memberId;
    data['orderCode'] = this.orderCode;
    data['payType'] = this.payType;
    data['payType2'] = this.payType2;
    data['payTime'] = this.payTime;
    data['usdtAmount'] = this.usdtAmount;
    data['actualAmount'] = this.actualAmount;
    data['actualAmount2'] = this.actualAmount2;
    data['state'] = this.state;
    data['goodsName'] = this.goodsName;
    data['goodsType'] = this.goodsType;
    return data;
  }
}

class MiningSettlementBooksVo {
  int pageIndex;
  int pageSize;
  int total;
  int pageCount;
  int firstItemIndex;
  List<MiningSettlementBooksVoRows> rows;

  MiningSettlementBooksVo(
      {this.pageIndex,
      this.pageSize,
      this.total,
      this.pageCount,
      this.firstItemIndex,
      this.rows});

  MiningSettlementBooksVo.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    total = json['total'];
    pageCount = json['pageCount'];
    firstItemIndex = json['firstItemIndex'];
    if (json['rows'] != null) {
      rows = new List<MiningSettlementBooksVoRows>();
      json['rows'].forEach((v) {
        rows.add(new MiningSettlementBooksVoRows.fromJson(v));
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

class MiningSettlementBooksVoRows {
  int id;
  String settlementCode;
  int memberId;
  String goodsCode;
  String goodsName;
  String orderCode;
  String coinType;
  String settlementType;
  String settlementTime;
  double amount;
  int state;
  String confirmTime;
  String confirmAdminCode;
  double electricityFees = 0;
  double maintenanceFees;
  double serviceFees;
  double coinPrice;
  double miningAmount;
  num miningCoinReward;

  MiningSettlementBooksVoRows(
      {this.id,
      this.settlementCode,
      this.memberId,
      this.goodsCode,
      this.goodsName,
      this.orderCode,
      this.coinType,
      this.settlementType,
      this.settlementTime,
      this.amount,
      this.state,
      this.confirmTime,
      this.confirmAdminCode,
      this.electricityFees,
      this.maintenanceFees,
      this.serviceFees,
      this.coinPrice,
      this.miningAmount,
      this.miningCoinReward});

  MiningSettlementBooksVoRows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    settlementCode = json['settlementCode'];
    memberId = json['memberId'];
    goodsCode = json['goodsCode'];
    goodsName = json['goodsName'];
    orderCode = json['orderCode'];
    coinType = json['coinType'];
    settlementType = json['settlementType'];
    settlementTime = json['settlementTime'];
    amount = json['amount'];
    state = json['state'];
    confirmTime = json['confirmTime'];
    confirmAdminCode = json['confirmAdminCode'];
    electricityFees = json['electricityFees'];
    maintenanceFees = json['maintenanceFees'];
    serviceFees = json['serviceFees'];
    coinPrice = json['coinPrice'];
    miningAmount = json['miningAmount'];
    miningCoinReward = json['miningCoinReward'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['settlementCode'] = this.settlementCode;
    data['memberId'] = this.memberId;
    data['goodsCode'] = this.goodsCode;
    data['goodsName'] = this.goodsName;
    data['orderCode'] = this.orderCode;
    data['coinType'] = this.coinType;
    data['settlementType'] = this.settlementType;
    data['settlementTime'] = this.settlementTime;
    data['amount'] = this.amount;
    data['state'] = this.state;
    data['confirmTime'] = this.confirmTime;
    data['confirmAdminCode'] = this.confirmAdminCode;
    data['electricityFees'] = this.electricityFees;
    data['maintenanceFees'] = this.maintenanceFees;
    data['serviceFees'] = this.serviceFees;
    data['coinPrice'] = this.coinPrice;
    data['miningAmount'] = this.miningAmount;
    data['miningCoinReward'] = this.miningCoinReward;
    return data;
  }
}

class MiningPages {
  String index;
  int page;
  int pagesize;
  MiningPages({this.index, this.page, this.pagesize});
}

class IconList {
  static String btc = 'assets/images/icon_btc.png';
  static String fm = 'assets/images/icon_fm.png';
  static String usdt = 'assets/images/icon_usdt.png';
  static String rent = 'assets/images/index_rent_icon.png';
  static String cxc = 'assets/images/icon_cxc.png';
  static String eth = 'assets/images/icon_eth.png';
  static String etc = 'assets/images/icon_etc.png';
  static String ltc = 'assets/images/icon_ltc.png';
  static String bch = 'assets/images/icon_bch.png';
  static String xrp = 'assets/images/icon_xrp.png';
  static String eos = 'assets/images/icon_eos.png';
  static String brc = 'assets/images/icon_brc.png';
  static String netValue = 'assets/images/netValve.png';
  static String exchangeotc = 'assets/images/icon-assets-change-otc.png';
  static String get(String type) {
    if (type == 'btc') {
      return btc;
    } else if (type == 'fm') {
      return fm;
    } else if (type == 'usdt') {
      return usdt;
    } else if (type == 'rent') {
      return rent;
    } else if (type == 'cxc') {
      return cxc;
    } else if (type == 'eth') {
      return eth;
    } else if (type == 'etc') {
      return etc;
    } else if (type == 'ltc') {
      return ltc;
    } else if (type == 'bch') {
      return bch;
    } else if (type == 'xrp') {
      return xrp;
    } else if (type == 'eos') {
      return eos;
    } else if (type == 'brc') {
      return brc;
    } else if (type == 'netValue') {
      return netValue;
    } else if (type == 'exchangeotc') {
      return exchangeotc;
    } else {
      return btc;
    }
  }
}

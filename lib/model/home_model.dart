class HomeModel {
  int totalUnit;
  List<AppIndexPic> appIndexPic;
  Home home;
  List<NoticeDTO> noticeDTO;
  PageData pageData;
  bool reinvestOrderState;
  String reinvestTitle;
  String reinvestMsg;

  HomeModel(
      {this.totalUnit,
        this.appIndexPic,
        this.home,
        this.noticeDTO,
        this.pageData,
        this.reinvestMsg,
        this.reinvestOrderState,
        this.reinvestTitle});

  HomeModel.fromJson(Map<String, dynamic> json) {
    totalUnit = json['totalUnit'];
    if (json['appIndexPic'] != null) {
      appIndexPic = new List<AppIndexPic>();
      json['appIndexPic'].forEach((v) {
        appIndexPic.add(new AppIndexPic.fromJson(v));
      });
    }
    home = json['home'] != null ? new Home.fromJson(json['home']) : null;
    if (json['noticeDTO'] != null) {
      noticeDTO = new List<NoticeDTO>();
      json['noticeDTO'].forEach((v) {
        noticeDTO.add(new NoticeDTO.fromJson(v));
      });
    }
    pageData = json['pageData'] != null
        ? new PageData.fromJson(json['pageData'])
        : null;
    reinvestMsg = json['reinvestMsg'] ?? null;
    reinvestTitle = json['reinvestTitle'] ?? null;
    reinvestOrderState = json['reinvestOrderState'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalUnit'] = this.totalUnit;
    if (this.appIndexPic != null) {
      data['appIndexPic'] = this.appIndexPic.map((v) => v.toJson()).toList();
    }
    if (this.home != null) {
      data['home'] = this.home.toJson();
    }
    if (this.noticeDTO != null) {
      data['noticeDTO'] = this.noticeDTO.map((v) => v.toJson()).toList();
    }
    if (this.pageData != null) {
      data['pageData'] = this.pageData.toJson();
    }
    data['reinvestMsg'] = this.reinvestMsg;
    data['reinvestTitle'] = this.reinvestTitle;
    data['reinvestOrderState'] = this.reinvestOrderState;
    return data;
  }
}

class AppIndexPic {
  int id;
  String picUrl;
  int state;
  String language;
  String clickUrl;

  AppIndexPic({this.id, this.picUrl, this.state, this.language, this.clickUrl});

  AppIndexPic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    picUrl = json['picUrl'];
    state = json['state'];
    language = json['language'];
    clickUrl = json['clickUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['picUrl'] = this.picUrl;
    data['state'] = this.state;
    data['language'] = this.language;
    data['clickUrl'] = this.clickUrl;
    return data;
  }
}

class Home {
  String homeBtcDifficulty;
  String homeBtcHashrate;
  String homeFmRewarded;
  String homeHashrateBalance;
  String homeHashrateTotal;
  String homeFmTotal;

  Home(
      {this.homeBtcDifficulty,
        this.homeBtcHashrate,
        this.homeFmRewarded,
        this.homeHashrateBalance,
        this.homeHashrateTotal,
        this.homeFmTotal});

  Home.fromJson(Map<String, dynamic> json) {
    homeBtcDifficulty = json['home_btc_difficulty'];
    homeBtcHashrate = json['home_btc_hashrate'];
    homeFmRewarded = json['home_fm_rewarded'];
    homeHashrateBalance = json['home_hashrate_balance'];
    homeHashrateTotal = json['home_hashrate_total'];
    homeFmTotal = json['home_fm_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home_btc_difficulty'] = this.homeBtcDifficulty;
    data['home_btc_hashrate'] = this.homeBtcHashrate;
    data['home_fm_rewarded'] = this.homeFmRewarded;
    data['home_hashrate_balance'] = this.homeHashrateBalance;
    data['home_hashrate_total'] = this.homeHashrateTotal;
    data['home_fm_total'] = this.homeFmTotal;
    return data;
  }
}

class NoticeDTO {
  int id;
  String title;
  int state;
  String language;

  NoticeDTO({this.id, this.title, this.state, this.language});

  NoticeDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    state = json['state'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['state'] = this.state;
    data['language'] = this.language;
    return data;
  }
}

class PageData {
  int pageIndex;
  int pageSize;
  int total;
  int pageCount;
  int firstItemIndex;
  List<Rows> rows;

  PageData(
      {this.pageIndex,
        this.pageSize,
        this.total,
        this.pageCount,
        this.firstItemIndex,
        this.rows});

  PageData.fromJson(Map<String, dynamic> json) {
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
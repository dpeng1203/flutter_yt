class BillsItemsModel {
  int pageIndex;
  int pageSize;
  int total;
  int pageCount;
  int firstItemIndex;
  List<BillItemRow> rows;

  BillsItemsModel(
      {this.pageIndex,
      this.pageSize,
      this.total,
      this.pageCount,
      this.firstItemIndex,
      this.rows});

  BillsItemsModel.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    total = json['total'];
    pageCount = json['pageCount'];
    firstItemIndex = json['firstItemIndex'];
    if (json['rows'] != null) {
      rows = new List<BillItemRow>();
      json['rows'].forEach((v) {
        rows.add(new BillItemRow.fromJson(v));
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

class BillItemRow {
  int id;
  String recordCode;
  String recordTime;
  String coinType;
  String changeType;
  double amount;
  String fromAddress;
  String toAddress;
  int state;
  String billName;
  String billChr;

  BillItemRow(
      {this.id,
      this.recordCode,
      this.recordTime,
      this.coinType,
      this.changeType,
      this.amount,
      this.fromAddress,
      this.toAddress,
      this.state,
      this.billName,
      this.billChr});

  BillItemRow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recordCode = json['recordCode'];
    recordTime = json['recordTime'];
    coinType = json['coinType'];
    changeType = json['changeType'];
    amount = json['amount'];
    fromAddress = json['fromAddress'];
    toAddress = json['toAddress'];
    state = json['state'];
    billName = json['billName'];
    billChr = json['billChr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['recordCode'] = this.recordCode;
    data['recordTime'] = this.recordTime;
    data['coinType'] = this.coinType;
    data['changeType'] = this.changeType;
    data['amount'] = this.amount;
    data['fromAddress'] = this.fromAddress;
    data['toAddress'] = this.toAddress;
    data['state'] = this.state;
    data['billName'] = this.billName;
    data['billChr'] = this.billChr;
    return data;
  }
}

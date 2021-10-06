class MyWorkOrderModel {
  final int id;
  final String detail;
  final String workOrderCode;
  final String submitTime;
  final int state;
  final String title;
  final int memberId;

  MyWorkOrderModel(
      {this.id,
      this.detail,
      this.workOrderCode,
      this.submitTime,
      this.state,
      this.title,
      this.memberId});

  factory MyWorkOrderModel.fromJson(Map<String, dynamic> json) {
    return MyWorkOrderModel(
        id: json['id'],
        detail: json['detail'],
        workOrderCode: json['workOrderCode'],
        submitTime: json['submitTime'],
        title: json['title'],
        state: json['state'],
        memberId: json['memberId']);
  }
}

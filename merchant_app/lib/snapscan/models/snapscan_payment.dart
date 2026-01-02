class SnapScanPayment {
  int? id;
  String? status;
  int? totalAmount;
  int? tipAmount;
  int? feeAmount;
  int? settleAmount;
  int? requiredAmount;
  String? date;
  String? snapCode;
  String? snapCodeReference;
  String? userReference;
  String? merchantReference;
  String? statementReference;
  String? authCode;
  String? deliveryAddress;
  String? deviceSerialNumber;
  dynamic extra;
  bool? isVoucher;
  bool? isVoucherRedemption;
  String? paymentType;
  String? transactionType;

  SnapScanPayment({
    this.id,
    this.status,
    this.totalAmount,
    this.tipAmount,
    this.feeAmount,
    this.settleAmount,
    this.requiredAmount,
    this.date,
    this.snapCode,
    this.snapCodeReference,
    this.userReference,
    this.merchantReference,
    this.statementReference,
    this.authCode,
    this.deliveryAddress,
    this.deviceSerialNumber,
    this.extra,
    this.isVoucher,
    this.isVoucherRedemption,
    this.paymentType,
    this.transactionType,
  });

  SnapScanPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    totalAmount = json['totalAmount'];
    tipAmount = json['tipAmount'];
    feeAmount = json['feeAmount'];
    settleAmount = json['settleAmount'];
    requiredAmount = json['requiredAmount'];
    date = json['date'];
    snapCode = json['snapCode'];
    snapCodeReference = json['snapCodeReference'];
    userReference = json['userReference'];
    merchantReference = json['merchantReference'];
    statementReference = json['statementReference'];
    authCode = json['authCode'];
    deliveryAddress = json['deliveryAddress'];
    deviceSerialNumber = json['deviceSerialNumber'];
    extra = json['extra'];
    isVoucher = json['isVoucher'];
    isVoucherRedemption = json['isVoucherRedemption'];
    paymentType = json['paymentType'];
    transactionType = json['transactionType'];
  }
}

class Payment {
  final int id;
  final String paymentId;
  final String status;
  final num amount;
  final PaymentInfo info;
  final String createdAt;

  const Payment({
    this.id,
    this.paymentId,
    this.status,
    this.amount,
    this.info,
    this.createdAt,
  });

  static Payment fromJson(dynamic json) {
    return Payment(
      id: json['id'] as int,
      paymentId: json['payment_id'] as String,
      status: json['status'] as String,
      amount: json['amount'] as num,
      info: (json['info'] != null) ? PaymentInfo.fromJson(json['info']) : null,
      createdAt: json['created_at'] as String,
    );
  }

  @override
  List<Object> get props => [id, paymentId, status, amount, info, createdAt];

  @override
  String toString() => 'Payment { id: $id }';
}

class PaymentInfo {
  final String pan;
  final String expiration;
  final String approvalCode;
  final String cardholderName;

  const PaymentInfo({
    this.pan,
    this.expiration,
    this.approvalCode,
    this.cardholderName,
  });

  static PaymentInfo fromJson(dynamic json) {
    return PaymentInfo(
      pan: json["pan"] as String ?? "",
      expiration: json["expiration"] as String ?? "",
      approvalCode: json["approvalCode"] as String ?? "",
      cardholderName: json["cardholderName"] as String ?? "",
    );
  }

  @override
  List<Object> get props => [pan, expiration, approvalCode, cardholderName];

  @override
  String toString() => 'PaymentInfo { $cardholderName }';
}

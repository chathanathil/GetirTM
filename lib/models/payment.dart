import 'package:getirtm/provider/provider.dart';

final String locale = RootProvider.locale;

class Payment {
  final int id;
  final String paymentId;
  final String status;
  final amount;
  final PaymentInfo info;
  final String cardHolder;
  final String cardNumber;
  final num createdAt;

  const Payment({
    this.id,
    this.paymentId,
    this.status,
    this.cardHolder,
    this.cardNumber,
    this.amount,
    this.info,
    this.createdAt,
  });

  static Payment fromJson(dynamic json) {
    return Payment(
      id: json['id'] != null ? json['id'] as int : null,
      paymentId: json['payment_id'] as String,
      status: json['status'] as String,
      amount: json['amount'] != null ? json['amount'] : null,
      cardHolder: json['cardHolderName'] != null
          ? json['cardHolderName'] as String
          : "",
      cardNumber:
          json['cardNumber'] != null ? json['cardNumber'] as String : "",
      info: (json['info'] != null) ? PaymentInfo.fromJson(json['info']) : null,
      createdAt: json['created_at'] as num,
    );
  }
}

class PaymentType {
  final int id;
  final bool isOnline;
  final String name;
  final String description;

  PaymentType({this.id, this.isOnline, this.name, this.description});

  static PaymentType fromJson(dynamic json) {
    return PaymentType(
      id: json['id'] as int,
      isOnline: json['is_online'] as bool,
      name: json['name'][locale] != null ? json['name'][locale] as String : '',
      description: json['description'][locale] != null
          ? json['description'][locale] as String
          : '',
    );
  }
}

class Shipping {
  final num minAmount;
  final num shippingPrice;

  Shipping({this.minAmount, this.shippingPrice});

  static Shipping fromJson(dynamic json) {
    return Shipping(
      minAmount: json['min_amount_for_free_shipping'] as int,
      shippingPrice: json['shipping_price'] as int,
    );
  }
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
}

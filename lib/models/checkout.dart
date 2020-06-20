import 'package:equatable/equatable.dart';

class Checkout extends Equatable {
  final String errorCode;
  final String orderId;
  final String formUrl;
  final String type;

  const Checkout({
    this.errorCode,
    this.orderId = '0',
    this.formUrl,
    this.type = 'online',
  });

  static Checkout fromJson(dynamic json) {
    return Checkout(
      errorCode: json['errorCode'] as String ?? '',
      orderId: json['orderId'] as String ?? '',
      formUrl: json['formUrl'] as String ?? '',
    );
  }

  @override
  List<Object> get props => [errorCode, orderId, formUrl, type];

  @override
  String toString() => 'Checkout { orderId: $orderId }';
}

class Checkout {
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
}

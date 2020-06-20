import 'package:getirtm/provider/provider.dart';

import './payment.dart';
import './product.dart';
import './address.dart';

final locale = RootProvider.locale;

class Order {
  final int id;
  final String type;
  final String status;
  final num productsPrice;
  final num shippingPrice;
  final num totalPrice;
  final String createdAt;
  final Address address;
  final List<Product> products;
  final List<Payment> payments;

  final num date;
  final String description;
  final num point;
  final String title;

  const Order(
      {this.id,
      this.type,
      this.status,
      this.productsPrice,
      this.shippingPrice,
      this.totalPrice,
      this.createdAt,
      this.address,
      this.products,
      this.payments,
      this.date,
      this.description,
      this.point,
      this.title});

  static Order fromJson(dynamic json) {
    return Order(
      id: json['id'] as int,
      type: json['type'] as String ?? "",
      status: json['status'] as String ?? "",
      productsPrice: json['products_price'] as num,
      shippingPrice: json['shipping_price'] as num,
      totalPrice: json['total_price'] as num,
      createdAt: json['created_at'] as String,
      address:
          (json['address'] != null) ? Address.fromJson(json['address']) : null,
      products: (json.containsKey('products'))
          ? (json['products'] as List)
              .map((item) => Product.fromJson(item))
              .toList()
          : [],
      payments: (json.containsKey('payments'))
          ? (json['payments'] as List)
              .map((item) => Payment.fromJson(item))
              .toList()
          : [],
      date: json['date'] as num,
      point: json['point'] as num,
      description: json['description'][locale] != null
          ? json['description'][locale] as String
          : '',
      title:
          json['title'][locale] != null ? json['title'][locale] as String : '',
    );
  }

  // bool get hasCardInfo => type == 'online' && payments.last.info != null;
  // Payment get payment => payments.length > 0 ? payments.last : null;

  // @override
  // List<Object> get props => [
  //       id,
  //       type,
  //       status,
  //       productsPrice,
  //       shippingPrice,
  //       totalPrice,
  //       createdAt,
  //       address,
  //       products,
  //       payments
  //     ];

  // @override
  // String toString() => 'Order { id: $id }';
}

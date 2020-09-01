import 'package:getirtm/provider/provider.dart';

import './payment.dart';
import './address.dart';

final locale = RootProvider.locale;

class Order {
  final int id;
  final String type;
  final String status;
  final String statusType;
  final String productsPrice;
  final String shippingPrice;
  final String totalPrice;
  final num createdAt;
  final Address address;
  final List<Product> products;
  final Payment payment;
  final String paymentType;
  final num date;
  final String description;
  final num point;
  final String title;

  const Order(
      {this.id,
      this.type,
      this.status,
      this.statusType,
      this.productsPrice,
      this.shippingPrice,
      this.totalPrice,
      this.createdAt,
      this.address,
      this.products,
      this.payment,
      this.paymentType,
      this.date,
      this.description,
      this.point,
      this.title});

  static Order fromJson(dynamic json) {
    return Order(
      id: json['id'] as int,
      type: json['type'] as String ?? "",
      status:
          json['status'] != null ? json['status'][locale] as String ?? "" : "",
      statusType:
          json['status'] != null ? json['status']['name'] as String ?? "" : "",
      paymentType: json['payment_type'] != null
          ? json['payment_type'][locale] as String ?? ""
          : "",
      productsPrice: json['products_price'] as String,
      shippingPrice: json['shipping_price'] as String,
      totalPrice: json['total_price'] as String,
      createdAt: json['created_at'] as num,
      address:
          (json['address'] != null) ? Address.fromJson(json['address']) : null,
      products: (json.containsKey('products'))
          ? (json['products'] as List)
              .map((item) => Product.fromJson(item))
              .toList()
          : [],
      payment:
          json['payment'] != null ? Payment.fromJson(json['payment']) : null,
      date: json['date'] as num,
      point: json['point'] as num,
      description: json['description'] != null
          ? json['description'][locale] as String
          : '',
      title: json['title'] != null ? json['title'][locale] as String : '',
    );
  }
}

class Product {
  final int id;
  final String actualPrice;
  final String discount;
  final String soldPrice;
  final String quantity;
  final String description;
  final String image;
  final String name;
  final int produtId;

  Product({
    this.id,
    this.name,
    this.image,
    this.actualPrice,
    this.discount,
    this.soldPrice,
    this.produtId,
    this.quantity,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['product']['name'][locale] != null
          ? json['product']['name'][locale] as String
          : '',
      image: json['product']['image'] as String,
      produtId: json['product']['id'] as num,
      soldPrice: json['sold_price'] as String,
      quantity: json['quantity'] as String,
      actualPrice: json['actual_price'] as String,
      discount: json['discount'] as String,
    );
  }
}

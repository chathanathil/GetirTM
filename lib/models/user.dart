import './address.dart';

class User {
  final int id;
  String name;
  final int phone;
  final String email;
  final Address address;
  final num balance;
  final int discountPercentage;

  User(
      {this.id,
      this.name,
      this.phone,
      this.email,
      this.address,
      this.balance,
      this.discountPercentage});

  static User fromJson(dynamic json) {
    return User(
        id: json['id'] as int,
        name: json['name'] ?? '',
        phone: json['phone'],
        email: json['email'] ?? '',
        address: (json['address'] != null)
            ? Address.fromJson(json['address'])
            : null,
        balance: json['balance'] as num ?? null,
        discountPercentage: json['percentage'] as int ?? null);
  }
}

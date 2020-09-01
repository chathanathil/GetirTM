import 'package:getirtm/provider/provider.dart';

final String locale = RootProvider.locale;

class Address {
  int id;
  String address;
  AddressType type;
  City city;
  bool isDefault;

  Address({
    this.id,
    this.isDefault,
    this.type,
    this.city,
    this.address,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as int,
      isDefault: json['is_default'] as bool,
      address: json['address'] != null ? json['address'] as String : '',
      city: json.containsKey('city') ? City.fromJson(json['city']) : null,
      type:
          json.containsKey('type') ? AddressType.fromJson(json['type']) : null,
    );
  }
}

class AddressType {
  final int id;
  final String name;

  const AddressType({this.id, this.name});

  static AddressType fromJson(dynamic json) {
    return AddressType(
      id: json['id'] as int,
      name: json['name'][locale] != null ? json['name'][locale] as String : '',
    );
  }
}

class City {
  final int id;
  final String name;

  const City({this.id, this.name});

  static City fromJson(dynamic json) {
    return City(
      id: json['id'] as int,
      name: json['name'][locale] != null ? json['name'][locale] as String : '',
    );
  }
}

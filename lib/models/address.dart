import 'package:getirtm/provider/provider.dart';

final String locale = RootProvider.locale;

class Address {
  int id;
  //  String title;
  String address;
  AddressType type;
  City city;
  // final State state;
  // final Region region;
  bool isDefault;

  Address({
    this.id,
    this.isDefault,
    // this.title,
    this.type,
    this.city,
    this.address,
    // this.state,
    // this.region,
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

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "is_default": isDefault,
  //       // "title": title,
  //       "address": address,
  //     };

  // @override
  // List<Object> get props => [id, isDefault, title, address, state, region];

  // @override
  // String toString() => 'Address { id: $id, is_default: $isDefault }';
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

  // @override
  // List<Object> get props => [id, title];

  // @override
  // String toString() => 'State { id: $id, regions: ${regions.length} }';
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

// class Region {
//   final int id;
//   final String title;

//   const Region({this.id, this.title});

//   static Region fromJson(dynamic json) {
//     return Region(
//       id: json['id'] as int,
//       title: json['title'] as String,
//     );
//   }

//   @override
//   List<Object> get props => [id, title];

//   @override
//   String toString() => 'Region { id: $id }';
// }

class Contact {
  final String address;
  final String phone;
  final String email;

  Contact({this.address, this.email, this.phone});

  static Contact fromJson(dynamic json) {
    return Contact(
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
    );
  }
}

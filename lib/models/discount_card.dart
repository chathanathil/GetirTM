import 'package:equatable/equatable.dart';
import 'package:getirtm/provider/provider.dart';

class DiscountCardPoint {
  final DiscountCard discountCard;
  final List<Point> points;

  DiscountCardPoint({this.discountCard, this.points});

  static DiscountCardPoint fromJson(Map<String, dynamic> json) {
    var points =
        (json['points'] as List).map((item) => Point.fromJson(item)).toList();
    points.sort((a, b) => b.id.compareTo(a.id));
    return DiscountCardPoint(
      discountCard: DiscountCard.fromJson(json['card']),
      points: points,
    );
  }
}

final String locale = RootProvider.locale;

class DiscountCard {
  final int id;
  final num cardNumber;
  final String birthday;
  final num percentage;
  final num point;
  final bool isVerified;
  final String name;
  final String gender;
  final String background;

  DiscountCard({
    this.id,
    this.cardNumber,
    this.percentage,
    this.point,
    this.birthday,
    this.isVerified,
    this.name,
    this.gender,
    this.background,
  });

  factory DiscountCard.fromJson(Map<String, dynamic> json) => DiscountCard(
        id: json["id"] as int,
        cardNumber: json["card_number"] as num,
        birthday: json['birthday'] as String,
        gender: json['gender'][locale] as String,
        name: json['name'] as String,
        percentage: json["percentage"] as num ?? 0,
        point: json["point"] as num ?? 0.0,
        background: json["background"] as String,
      );

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "code": code,
  //       "percentage": percentage,
  //       "balance": balance,
  //       "background": background,
  //     };

  // @override
  // List<Object> get props => [id, code, percentage, balance];

  // @override
  // String toString() =>
  //     'DiscountCard { id: $id, code: $code, percentage: $percentage, balance: $balance }';
}

class Point extends Equatable {
  final int id;
  final int orderId;
  final num point;
  final String createdAt;

  Point({
    this.id,
    this.orderId,
    this.point,
    this.createdAt,
  });

  factory Point.fromJson(dynamic json) => Point(
        id: json["id"],
        orderId: json["order_id"],
        point: num.parse(json["point"]),
        createdAt: json["created_at"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "point": point,
        "created_at": createdAt,
      };

  @override
  List<Object> get props => [id, orderId, point, createdAt];

  @override
  String toString() =>
      'Point { id: $id, orderId: $orderId, point: $point, created_at: $createdAt }';
}

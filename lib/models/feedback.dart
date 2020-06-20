import 'package:getirtm/provider/provider.dart';

final String locale = RootProvider.locale;

class FeedBackType {
  final int id;
  final String name;

  const FeedBackType({this.id, this.name});

  static FeedBackType fromJson(dynamic json) {
    return FeedBackType(
      id: json['id'] as int,
      name: json['name'][locale] != null ? json['name'][locale] as String : '',
    );
  }

  // @override
  // List<Object> get props => [id, title];

  // @override
  // String toString() => 'State { id: $id, regions: ${regions.length} }';
}

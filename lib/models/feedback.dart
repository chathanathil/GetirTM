import 'dart:io';
import 'package:getirtm/provider/provider.dart';

final String locale = RootProvider.locale;

class FeedBack {
  final int id;
  final String title;
  final String text;
  final List<File> images;

  const FeedBack({this.id, this.title, this.text, this.images});

  Map<String, dynamic> toJson() =>
      {"type_id": id, "title": title, "text": text, "images": images};
}

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
}

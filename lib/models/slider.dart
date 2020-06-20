import 'package:getirtm/provider/provider.dart';

final String locale = RootProvider.locale;

class Slide {
  final int id;
  final String title;
  final String image;

  Slide({this.id, this.title, this.image});

  factory Slide.fromJson(Map<String, dynamic> json) {
    return Slide(
      id: json['id'] as int,
      title:
          json['title'][locale] != null ? json['title'][locale] as String : '',
      image:
          json['image'][locale] != null ? json['image'][locale] as String : '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
      };
}

import 'package:getirtm/models/product.dart';
import 'package:getirtm/provider/provider.dart';

class SubCategory {
  final String locale = RootProvider.locale;

  int id;
  int categoryId;
  String slug;
  String image;
  Map<String, dynamic> name;
  int order;
  String deletedAt;
  List<Product> products;

  SubCategory({
    this.id,
    this.categoryId,
    this.image,
    this.name,
    this.order,
    this.products,
    this.slug,
    this.deletedAt,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] as int,
      categoryId: json['category_id'] as int,
      name: json['name'],
      image: json['image'] as String,
      order: json['order'] as int,
      deletedAt: json['deleted_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        'subcategory_id': categoryId,
        'name': name[locale],
        "image": image,
        "order": order,
        "slug": slug,
      };
}

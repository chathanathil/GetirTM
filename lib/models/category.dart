import './product.dart';
import 'package:getirtm/provider/provider.dart';

class Category {
  final String locale = RootProvider.locale;

  int id;
  int categoryId;
  String slug;
  String image;
  Map<String, dynamic> name;
  int order;
  String deletedAt;
  List<Category> subCategories;
  List<Product> products;

  Category({
    this.id,
    this.categoryId,
    this.image,
    this.name,
    this.order,
    this.subCategories,
    this.products,
    this.slug,
    this.deletedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      categoryId: json['subcategory_id'] as int,
      name: json['name'],
      image: json['image'] as String,
      order: json['order'] as int,
      deletedAt: json['deleted_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": categoryId,
        'name': name[locale],
        "image": image,
        "order": order,
        "slug": slug,
      };
}

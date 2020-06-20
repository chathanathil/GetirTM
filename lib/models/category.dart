import './product.dart';
import 'package:getirtm/provider/provider.dart';

final String locale = RootProvider.locale;

class Category {
  int id;
  int categoryId;
  String slug;
  String image;
  String name;
  int image_id;
  //  DateTime updatedAt;
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
    this.image_id,
    this.deletedAt,
    // this.updatedAt
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    print(locale);
    return Category(
      id: json['id'] as int,
      categoryId: json['subcategory_id'] as int,
      name: json['name'][locale],
      // slug: json['slug'] as String,
      image: json['image'] as String,
      order: json['order'] as int,
      deletedAt: json['deleted_at'] as String,
      // subCategories: json.containsKey('children')
      //     // ?
      //     List<Category>.from(
      //         json['children'].map((item) => Category.fromJson(item)),
      //       )
      //     : [],
      // products: json.containsKey('products')
      //     ? List<Product>.from(
      //         json['products'].map((item) => Product.fromJson(item)),
      //       )
      //     : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": categoryId,
        'name': name,
        "image": image,
        "order": order,
        "slug": slug,
      };
}

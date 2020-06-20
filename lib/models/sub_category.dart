import 'package:getirtm/models/product.dart';
import 'package:getirtm/provider/provider.dart';

final String locale = RootProvider.locale;

class SubCategory {
  int id;
  int categoryId;
  String title;
  String slug;
  String image;
  String name;
  int image_id;
  //  DateTime updatedAt;
  int order;
  String deletedAt;
  // List<Category> subCategories;
  List<Product> products;

  SubCategory({
    this.id,
    this.categoryId,
    this.image,
    this.name,
    this.title,
    this.order,
    // this.subCategories,
    this.products,
    this.slug,
    this.image_id,
    this.deletedAt,

    // this.updatedAt
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] as int,
      categoryId: json['subcategory_id'] as int,
      // parentId: json['parent_id'] as int,
      title: json['title'] as String,
      name: json['name'][locale] as String,
      // slug: json['slug'] as String,
      image: json['image'] as String,
      order: json['order'] as int,
      deletedAt: json['deleted_at'] as String,
      // subCategories: json.containsKey('children')
      //     ? List<Category>.from(
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
        // "parent_id": parentId,
        'subcategory_id': categoryId,
        'name': name,
        "title": title,
        "image": image,
        "order": order,
        "slug": slug,
      };
}

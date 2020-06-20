import 'package:getirtm/provider/provider.dart';

final String locale = RootProvider.locale;

class Product {
  final int id;
  final int categoryId;
  final int subcategoryId;
  final num createdAt;
  final String name;
  final String description;
  final String image;
  final num order;
  final num stock;
  final num price;
  // final num discountStarts;
  // final num discountEnds;
  final num discountPercentage;
  final num discountPrice;
  final bool isPackage;
  bool isFavorited;
  num quantity;
  Product(
      {this.id,
      this.name,
      this.image,
      this.subcategoryId,
      this.categoryId,
      this.isPackage,
      this.quantity,
      // this.discountStarts,
      // this.discountEnds,
      this.discountPercentage,
      this.discountPrice,
      this.price,
      this.order,
      this.stock,
      this.isFavorited = false,
      this.description,
      this.createdAt});

  Product copyWith({num quantity, bool isFavorited}) {
    return Product(
      id: this.id,
      categoryId: this.categoryId,
      subcategoryId: this.subcategoryId,
      name: this.name,
      // slug: this.slug,
      image: this.image,
      description: this.description,
      price: this.price,
      discountPrice: this.discountPrice,
      discountPercentage: this.discountPercentage,
      // discountStarts: this.discountStarts,
      // discountEnds: this.discountEnds,
      stock: this.stock,
      quantity: quantity ?? this.quantity,
      isPackage: this.isPackage,
      // deletedAt: this.deletedAt,
      order: this.order,
      isFavorited: this.isFavorited,
      createdAt: this.createdAt,
      // discountDate: this.discountDate,
      // children: this.children,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'][locale] != null ? json['name'][locale] as String : '',
      image: json['image'] as String,
      subcategoryId: json['subcategory_id'] as int,
      categoryId: json['category_id'] as int,
      createdAt: json['created_at'] as num,
      description: json['description'][locale] != null
          ? json['description'][locale] as String
          : '',
      isPackage: json['is_package'] == 1,
      price: json['price'] as num,
      stock: json['stock'] as num,
      order: json['order'] as num,
      quantity: json['quantity'] as num,
      // discountStarts: json['discount_starts_at'] as num,
      // discountEnds: json['discount_expires_at'] as num,
      discountPrice: json['discount_price'] as num,
      // isFavorited: fav,
      discountPercentage: json['discount_percentage'] as num,
    );
  }
  factory Product.fromSql(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      subcategoryId: json['subcategory_id'] as int,
      categoryId: json['category_id'] as int,
      // createdAt: json['created_at'] as num,
      description: json['description'] as String,
      isPackage: json['is_package'] == 1,
      price: json['price'] as num,
      stock: json['stock'] as num,
      order: json['order'] as num,
      quantity: json['quantity'] as num,
      // // discountStarts: json['discount_starts_at'] as num,
      // // discountEnds: json['discount_expires_at'] as num,
      discountPrice: json['discount_price'] as num,
      // // isFavorited: json['is_favorited'] == true,
      discountPercentage: json['discount_percentage'] as num,
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        'subcategory_id': subcategoryId,
        "name": name,
        "image": image,
        "description": description,
        "price": price,
        "discount_price": discountPrice,
        "discount_percentage": discountPercentage,
        "stock": stock,
        "is_package": isPackage,
        "order": order,
        'created_at': createdAt,
        // 'discount_starts_at': discountStarts,
        // 'discount_expires_at': discountEnds
      };
}

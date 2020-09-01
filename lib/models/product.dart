import 'package:getirtm/provider/provider.dart';

class Product {
  final String locale = RootProvider.locale;

  final int id;
  final int categoryId;
  final int subcategoryId;
  final num createdAt;
  final Map<String, dynamic> name;
  final Map<String, dynamic> description;
  final String image;
  final num order;
  final num stock;
  final num price;
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
      image: this.image,
      description: this.description,
      price: this.price,
      discountPrice: this.discountPrice,
      discountPercentage: this.discountPercentage,
      stock: this.stock,
      quantity: quantity ?? this.quantity,
      isPackage: this.isPackage,
      order: this.order,
      isFavorited: this.isFavorited,
      createdAt: this.createdAt,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] != null ? json['name'] : '',
      image: json['image'] as String,
      subcategoryId: json['subcategory_id'] as int,
      categoryId: json['category_id'] as int,
      createdAt: json['created_at'] as num,
      description: json['description'] != null ? json['description'] : '',
      isPackage: json['is_package'] == 1,
      price: json['price'] as num,
      stock: json['stock'] as num,
      order: json['order'] as num,
      quantity: json['quantity'] as num,
      discountPrice: json['discount_price'] as num,
      discountPercentage: json['discount_percentage'] as num,
    );
  }
  factory Product.fromSql(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: {'ru': json['name_ru'], 'tm': json['name_tm']},
      image: json['image'] as String,
      subcategoryId: json['subcategory_id'] as int,
      categoryId: json['category_id'] as int,
      description: {"ru": json['description_ru'], "tm": json['description_tm']},
      isPackage: json['is_package'] == 1,
      price: json['price'] as num,
      stock: json['stock'] as num,
      order: json['order'] as num,
      quantity: json['quantity'] as num,
      discountPrice: json['discount_price'] as num,
      discountPercentage: json['discount_percentage'] as num,
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        'subcategory_id': subcategoryId,
        "name_ru": name['ru'],
        "name_tm": name['tm'],
        "image": image,
        "description_ru": description['ru'],
        "description_tm": description['tm'],
        "price": price,
        "discount_price": discountPrice,
        "discount_percentage": discountPercentage,
        "stock": stock,
        "is_package": isPackage,
        "order": order,
        'created_at': createdAt,
      };
}

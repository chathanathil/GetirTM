// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';

// class Product with ChangeNotifier {
//   final int id;
//   final int categoryId;
//   final int subcategoryId;
//   final Map<String, dynamic> name;
//   final title;
//   final String slug;
//   final String image;
//   final int imageId;
//   final Map<String, dynamic> description;
//   final num price;
//   final num discount;
//   final num discountPrice;
//   final String discountStarts;
//   final String discountEnds;
//   final num stock;
//   final bool isPackage;
//   final int order;
//   bool isFavorited;
//   final num amount;
//   final int createdAt;
//   final String deletedAt;

//   Product({
//     this.id,
//     this.categoryId,
//     this.subcategoryId,
//     this.name,
//     this.title,
//     this.slug,
//     this.image,
//     this.imageId,
//     this.description,
//     this.price,
//     this.discountPrice,
//     this.discountStarts,
//     this.discountEnds,
//     this.discount,
//     this.stock,
//     this.isPackage = false,
//     this.deletedAt,
//     this.amount = 1,
//     this.order = 0,
//     this.isFavorited = false,
//     this.createdAt,
//     // this.children = const [],
//   });

//   num get productPrice => price;
//   num get productAmount => amount;

//   Product copyWith({num amount, bool isFavorited}) {
//     return Product(
//       id: this.id,
//       categoryId: this.categoryId,
//       subcategoryId: this.subcategoryId,
//       name: name,
//       title: this.title,
//       slug: this.slug,
//       image: this.image,
//       description: this.description,
//       price: this.price,
//       discountPrice: this.discountPrice,
//       discount: this.discount,
//       discountStarts: this.discountStarts,
//       discountEnds: this.discountEnds,
//       stock: this.stock,
//       amount: amount ?? this.amount,
//       isPackage: this.isPackage,
//       deletedAt: this.deletedAt,
//       order: this.order,
//       isFavorited: this.isFavorited,
//       createdAt: this.createdAt,
//       // discountDate: this.discountDate,
//       // children: this.children,
//     );
//   }

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'] as int,
//       categoryId: json['category_id'] as int,
//       subcategoryId: json['subcategory_id'] as int,
//       name: json['name'] as Map<String, dynamic>,
//       title: json['title'] as String,
//       slug: json['slug'] as String,
//       image: json['image'] as String,
//       description: json['description'] as Map<String, dynamic>,
//       price: json['price'] as num,
//       discount: json['discount_percentage'] as num,
//       discountPrice: json['discount_value'] as num ?? 0,
//       discountStarts: json['discount_starts_at'] as String,
//       discountEnds: json['discount_expires_at'] as String,
//       stock: json['stock'] as num,
//       amount: json['amount'] as num,
//       isPackage: json['is_package'] == 1,
//       order: json['order'] as int,
//       isFavorited: json['is_favorited'] == 1,
//       createdAt: json['created_at'] as int,
//       deletedAt: json['deleted_at'] as String,
//       // children: (json.containsKey('children'))
//       //     ? new List<Product>.from(
//       //         json["children"].map(
//       //           (product) => Product.fromJson(product),
//       //         ),
//       //       )
//       //     : [],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "category_id": categoryId,
//         'subcategory_id': subcategoryId,
//         "name": name,
//         "title": title,
//         "image": image,
//         "description": description,
//         "price": price,
//         "discount_value": discountPrice,
//         "discount_percentage": discount,
//         "stock": stock,
//         "is_package": isPackage,
//         "order": order,
//         'created_at': createdAt,
//         'discount_starts_at': discountStarts,
//         'discount_expires_at': discountEnds
//       };

//   void toggleFavoriteStatus() {
//     isFavorited = !isFavorited;
//     notifyListeners();
//   }
// }

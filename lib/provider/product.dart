import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../models/slider.dart';
import '../helpers/db_helper.dart';
import '../models/sub_category.dart';

class ProductProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;

  Stream<List<Slide>> get slideStream {
    final k = _db.collection('sliders').snapshots();

    return k.map(
        (event) => event.documents.map((e) => Slide.fromJson(e.data)).toList());
  }

  Stream<List<Category>> get categoriesStream {
    final k = _db.collection('categories').orderBy('order').snapshots();

    return k.map((event) =>
        event.documents.map((e) => Category.fromJson(e.data)).toList());
  }

  Stream<List<SubCategory>> subCategoriesStream(int id) {
    final k = _db
        .collection('subcategories')
        .where('category_id', isEqualTo: id)
        .orderBy('order')
        .snapshots();
    return k.map((event) =>
        event.documents.map((e) => SubCategory.fromJson(e.data)).toList());
  }

  // Test with yield

  Stream<List<Product>> productsStream(int id) {
    final k = _db
        .collection('products')
        .where('category_id', isEqualTo: id)
        .orderBy('stock')
        .where('stock', isGreaterThanOrEqualTo: 1)
        .orderBy('order')
        .snapshots();

    return k.map((event) => event.documents
        .map((e) => Product.fromJson(
              e.data,
            ))
        .toList());
  }

  void toggleFavoriteStatus(Product product) async {
    await DB.instance.createProduct(product);
    bool isFavorited = await DB.instance.toggleFavorite(product);

    product.isFavorited = isFavorited;
    notifyListeners();
  }

  List<Product> favItems = [];
  Future getFavourites() async {
    favItems = await DB.instance.getFavorites();
  }
}

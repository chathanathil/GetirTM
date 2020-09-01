import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:getirtm/models/http_exception.dart';
import 'package:getirtm/models/popular_search.dart';
import 'package:getirtm/models/product.dart';
import 'package:getirtm/provider/provider.dart';

class SearchProvider with ChangeNotifier {
  List<Product> products;
  List<PopularSearch> popularSearches;
  final Firestore _db = Firestore.instance;

  setEmpty() {
    products = null;
    notifyListeners();
  }

  Future search(String query, {num number = 30}) async {
    try {
      final response =
          await RootProvider.http.get('/search?q=$query&number=$number');
      final List<Product> loadedResult = [];
      response.data['products']
          .forEach((element) => loadedResult.add(Product.fromJson(element)));
      products = loadedResult;
      notifyListeners();
    } on DioError catch (error) {
      throw HttpException(error.response.data['message']);
    }
  }

  Future popularSearch() async {
    final snapshot = await _db.collection('searches').getDocuments();
    final List<PopularSearch> loadedResult = [];

    snapshot.documents.forEach(
        (element) => loadedResult.add(PopularSearch.fromJson(element.data)));
    popularSearches = loadedResult;
    notifyListeners();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:getirtm/helpers/shared_preferences_helper.dart';
import 'package:getirtm/models/user.dart';
import './provider.dart';
import '../models/order.dart';

final Firestore _db = Firestore.instance;

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders {
    return [..._orders];
  }

  /// Fetch current user orders
  Future fetchAllOrders() async {
    User user = await SharedPreferencesHelper.getUserDetails();
    final snapshot = await _db
        .collection('users')
        .document(user.id.toString())
        .collection('orders')
        .orderBy('created_at', descending: true)
        .getDocuments();
    snapshot.documents
        .map((item) => _orders.add(Order.fromJson(item.data)))
        .toList();
    notifyListeners();
  }

  static Future<Order> getOrder(int id) async {
    final response = await RootProvider.http.get('/orders/$id');

    return Order.fromJson(response.data);
  }
}

import 'package:flutter/foundation.dart';
import 'package:getirtm/models/address.dart';
import 'package:getirtm/models/checkout.dart';
import './provider.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders {
    return [..._orders];
  }

  /// Fetch current user orders
  Future<List<Order>> fetchAllOrders() async {
    // final response = await RootProvider.http.get('/orders');
    print("fetch Orders");
    notifyListeners();
    // return (response.data['orders'] as List)
    //     .map((item) => Order.fromJson(item))
    //     .where((o) => o.status != "" && o.status != "pay")
    //     .toList();
  }

  static Future<Order> getOrder(int id) async {
    final response = await RootProvider.http.get('/orders/$id');

    return Order.fromJson(response.data);
  }

  Future<Checkout> checkout(
    int address,
    String type, 
    String description,
    bool usePoint,
    List<Map<String, dynamic>> products,
  ) async{
     // write http request here
     if (type == 'online') {
      // return Checkout.fromJson(response.data);
      print("online");
    }

    return Checkout(type: 'cash');
  }
}

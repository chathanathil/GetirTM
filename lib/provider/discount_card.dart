import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:getirtm/helpers/shared_preferences_helper.dart';
import 'package:getirtm/models/discount_card.dart';
import 'package:getirtm/models/order.dart';
import 'package:getirtm/models/user.dart';
import 'package:getirtm/provider/provider.dart';

class DiscountCardProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;

  DiscountCard _discountCard;
  List<Order> _orderHistory;
  DiscountCard get discountCard {
    return _discountCard;
  }

  List<Order> get orderHistory {
    return _orderHistory;
  }

  Future createDiscountCard(Map data) async {
    try {
      print('data');
      print(data);
      var response = await RootProvider.http.post('/card', data: data);

      print(response);
    } on DioError catch (error) {
      print('on dio');
      print(error.response);
      throw error.response;
    }
  }

  Future fetchDiscountCards() async {
    User user = await SharedPreferencesHelper.getUserDetails();
    print('tssssssssss');

    final snapshot = _db.collection('users').document(user.id.toString());
    final discountCard = await snapshot.get();
    _discountCard = DiscountCard.fromJson(discountCard.data['discount_card']);
    final history =
        await snapshot.collection('discount_card_history').getDocuments();
    final List<Order> loadedOrders = [];

    history.documents.map((item) {
      print('descrip');
      print(item['description']);
      loadedOrders.add(Order.fromJson(item.data));
    }).toList();

    _orderHistory = loadedOrders;
    notifyListeners();
  }
}

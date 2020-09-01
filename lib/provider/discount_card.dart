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
  List<Order> _discountCardHistory;
  DiscountCard get discountCard {
    return _discountCard;
  }

  List<Order> get orderHistory {
    return _discountCardHistory;
  }

  Future createDiscountCard(Map data) async {
    try {
      var response = await RootProvider.http.post('/card', data: data);
    } on DioError catch (error) {
      throw error.response;
    }
  }

  Future fetchDiscountCards() async {
    User user = await SharedPreferencesHelper.getUserDetails();
    final snapshot = _db.collection('users').document(user.id.toString());
    final discountCard = await snapshot.get();
    _discountCard = DiscountCard.fromJson(discountCard.data['discount_card']);
    final history =
        await snapshot.collection('discount_card_history').getDocuments();
    final List<Order> loadedOrders = [];

    history.documents.map((item) {
      loadedOrders.add(Order.fromJson(item.data));
    }).toList();

    _discountCardHistory = loadedOrders;
    notifyListeners();
  }
}

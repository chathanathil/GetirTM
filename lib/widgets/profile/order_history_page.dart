import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/order.dart';
import '../../utils/utils.dart';
import '../../models/order.dart';
import '../../widgets/common/common.dart';

class OrderHistoryPage extends StatefulWidget {
  static const routeName = 'orderHistory';

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
        Provider.of<OrderProvider>(context, listen: false)
            .fetchAllOrders()
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _isInit = false;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    Navigator.pop(context);
    return true;
  }

  Color _statusColor(status) {
    switch (status) {
      case 'new':
        return Colors.yellow;
      case 'payment':
        return Colors.yellow;
      case 'pending':
        return Colors.yellow;
      case 'completed':
        return Colors.green;
      case 'declined':
        return Colors.red;
      case 'cancelled':
        return Colors.red;
      case 'accepted':
        return Colors.blue;
      case 'delivering':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).orderHistoryPage_title,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR_BIG,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (ctx, orderData, child) {
          if (_isLoading) {
            return LoadingPage();
          }

          if (orderData.orders.length == 0) {
            return EmptyPage(
              title: S.of(context).notFound,
              message: S.of(context).orderHistoryPage_empty,
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(color: Colors.grey, height: 0);
            },
            itemCount: orderData.orders.length,
            itemBuilder: (BuildContext context, index) {
              Order order = orderData.orders[index];

              return InkWell(
                onTap: () {
                  NavigatorUtils.goOrderDetails(context, order);
                },
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        'Order #${order.id}',
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR_BIG,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '|  ' + order.status,
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR_BIG,
                        style: TextStyle(
                          color: _statusColor(order.statusType),
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                  subtitle: Text(
                    getDateWithFormat(order.createdAt),
                    textScaleFactor: Dimens.TEXT_SCALE_FACTOR_BIG,
                  ),
                  trailing: Image.asset(
                    "assets/images/revenue.png",
                    width: 30,
                    height: 30,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

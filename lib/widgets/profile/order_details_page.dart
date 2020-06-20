// // TODO: complete onpressed fn on line 234

// import 'package:flutter/material.dart';
// import 'package:getirtm/provider/provider.dart';
// import '../../models/order.dart';
// import '../../models/product.dart';
// import '../../utils/utils.dart';
// import '../../widgets/common/common.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class OrderDetailsPage extends StatelessWidget {
//   static const routeName = 'orderDetails';

//   final Order order;

//   OrderDetailsPage({Key key, this.order}) : super(key: key);
//   final String locale = RootProvider.locale;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           S.of(context).orderDetailsPage_title,
//           textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: ListView(
//         children: <Widget>[
//           ListTile(
//             title: Text(
//               (order.type == "online")
//                   ? S.of(context).orderDetailsPage_onlinePay
//                   : S.of(context).orderDetailsPage_cashPay,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//               style: TextStyle(fontWeight: FontWeight.w500),
//             ),
//             subtitle: Text(
//               "№ ${order.id}",
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//             ),
//             trailing: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   getCurrency(
//                     order.totalPrice,
//                     S.of(context).symbol,
//                   ),
//                   textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   getDateWithFormat(order.createdAt),
//                   textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                   style: TextStyle(color: Colors.black45),
//                 )
//               ],
//             ),
//           ),
//           Divider(
//             color: Colors.grey,
//           ),
//           Container(
//             padding: EdgeInsets.only(left: 15, top: 10),
//             child: Text(
//               S.of(context).orderDetailsPage_address,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           ListTile(
//             title: Text(
//               'some state',
//               // "${order.address.state?.title}, ${order.address.region?.title} ",
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//               style: TextStyle(fontWeight: FontWeight.w300),
//             ),
//             subtitle: Text(
//               "${order.address.address}",
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//             ),
//           ),
//           ConditionalBuilder(
//             condition: order.hasCardInfo,
//             builder: (BuildContext context) {
//               return Container(
//                 padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Divider(
//                       color: Colors.grey,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       S.of(context).orderDetailsPage_cardInfo,
//                       textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16,
//                       ),
//                     ),
//                     ListTile(
//                       contentPadding: EdgeInsets.zero,
//                       title: Text(
//                         S.of(context).orderDetailsPage_cardHolder,
//                         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w300,
//                           fontSize: 14,
//                         ),
//                       ),
//                       subtitle: Text(
//                         "${order.payment?.info?.cardholderName}".toUpperCase(),
//                         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     ListTile(
//                       contentPadding: EdgeInsets.zero,
//                       title: Text(
//                         S.of(context).orderDetailsPage_cardNumber,
//                         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w300,
//                           fontSize: 14,
//                         ),
//                       ),
//                       subtitle: Text(
//                         "${order.payment?.info?.pan}".toUpperCase(),
//                         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     ListTile(
//                       contentPadding: EdgeInsets.zero,
//                       title: Text(
//                         S.of(context).orderDetailsPage_expire,
//                         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w300,
//                           fontSize: 14,
//                         ),
//                       ),
//                       subtitle: Text(
//                         "${order.payment?.info?.expiration}".toUpperCase(),
//                         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           ExpansionTile(
//             title: Text(
//               S.of(context).orderDetailsPage_products,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//             ),
//             initiallyExpanded: true,
//             children: _buildExpandableContent(
//               order.products,
//               S.of(context).symbol,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//             child: RaisedButton(
//               padding: EdgeInsets.symmetric(vertical: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.repeat,
//                     color: Colors.white,
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     S.of(context).repeat_order,
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ],
//               ),
//               color: AppColors.MAIN_LIGHT,
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext dialogContext) {
//                     return AlertDialog(
//                       title: Text(
//                         S.of(context).warning,
//                         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                       ),
//                       content: Text(
//                         S.of(context).repeat_order_content,
//                         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                       ),
//                       actions: <Widget>[
//                         FlatButton(
//                           child: Text(
//                             S.of(context).no,
//                             textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                           ),
//                           onPressed: () {
//                             Navigator.of(dialogContext).pop();
//                           },
//                         ),
//                         FlatButton(
//                           child: Text(
//                             S.of(context).yes,
//                             textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                           ),
//                           onPressed: () async {
//                             // await DB.instance.repeatOrder(order);
//                             // BlocProvider.of<KartBloc>(context).add(LoadKart());
//                             Navigator.of(dialogContext).pop();
//                             Scaffold.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   S.of(context).repeat_order_message,
//                                   textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _buildExpandableContent(List<Product> products, String symbol) {
//     return products.map((Product product) {
//       return new ListTile(
//         title: new Container(
//             padding: new EdgeInsets.only(right: 20.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 new CachedNetworkImage(
//                   fit: BoxFit.cover,
//                   imageUrl: product.image,
//                   width: 40,
//                   height: 40,
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: new Text(
//                     product.name,
//                     textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                     style: new TextStyle(fontSize: 15.0),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                   ),
//                 ),
//               ],
//             )),
//         dense: true,
//         trailing: Text(
//           "${product.quantity} x ${getCurrency(product.price, symbol)}",
//           textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//           style: TextStyle(
//             fontWeight: FontWeight.w400,
//             fontSize: 15,
//           ),
//         ),
//       );
//     }).toList();
//   }
// }

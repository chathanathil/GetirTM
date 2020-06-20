// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../helpers/shared_preferences_helper.dart';

// import '../../utils/utils.dart';
// import '../../bloc/kart/kart.dart';
// import '../../bloc/auth/auth.dart';
// import '../../widgets/common/common.dart';
// import '../../widgets/cart/payment_page.dart';
// import '../../widgets/profile/address_page.dart';

// enum CellType {
//   textField,
//   plain,
//   plusButton,
//   TaC,
//   radioBtn,
//   usePointsRadio,
// }

// enum Identifier {
//   textArea,
//   subTotal,
//   total,
//   delivery,
//   balance,
//   earnPoints,
//   address,
//   TaC,
//   paymentType,
//   usePoints,
// }

// class CheckoutPage extends StatefulWidget {
//   static const routeName = "checkout";

//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   bool _termsAndConditions = false;
//   bool _usePoints = false;
//   TextEditingController _descriptionController = TextEditingController();

//   List<ListItem> items = [];
//   bool isBackButtonActivated = true;
//   num balance = 0.0;
//   int discountPerc = 0;
//   num skidka = 0.0;

//   KartBloc kartBloc;

//   @override
//   void initState() {
//     super.initState();
//     skidka = 0.0;
//     kartBloc = BlocProvider.of<KartBloc>(context);
//     kartBloc.kart.balancePoints = 0.0;
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       systemNavigationBarColor: Colors.blue, // navigation bar color
//       statusBarColor: Colors.pink, // status bar color
//     ));
//     SharedPreferencesHelper.getUserBalance().then((val) {
//       setState(() {
//         balance = val;
//       });
//     });
//     SharedPreferencesHelper.getUserDiscountPercentage().then((val) {
//       setState(() {
//         discountPerc = val;
//       });
//     });

//     AuthState auth = BlocProvider.of<AuthBloc>(context).state;
//     if (auth is AuthAuthenticated &&
//         auth.user != null &&
//         auth.user.address != null) {
//       kartBloc.add(SelectAddress(auth.user.address));
//     }
//   }

//   void _termsAndConditionsChanged(bool value, {BuildContext context}) {
//     setState(() {
//       _termsAndConditions = value;
//       if (value && context != null) {
//         NavigatorUtils.goAboutPage(
//           context,
//           Constants.TERMS,
//           S.of(context).termsPage_title,
//         );
//       }
//     });
//   }

//   void _usePointChanged(bool value, {BuildContext context}) {
//     setState(() {
//       _usePoints = value;
//       if (value) {
//         // if total cost less or equal to balance then just add negative sign else show balance with negative sign
//         if ((kartBloc.kart.totalCost) <= balance) {
//           skidka = -(kartBloc.kart.totalCost);
//         } else {
//           skidka = -balance;
//         }
//         // if use point true then we calculate total cost with balance
//         kartBloc.kart.balancePoints = balance;
//       } else {
//         kartBloc.kart.balancePoints = 0.0;
//         skidka = 0.0;
//       }
//     });
//   }

//   void showAlertDialog(BuildContext context) {
//     // set up the button
//     Widget okButton = FlatButton(
//       child: Text(
//         S.of(context).checkoutPage_close,
//         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//       ),
//       onPressed: () {
//         Navigator.of(context, rootNavigator: true).pop('dialog');
//         Navigator.of(context).popUntil((r) => r.isFirst);
//         // kartBloc.add(CompleteCheckout());
//       },
//     );

//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text(
//         S.of(context).checkoutPage_success,
//         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//       ),
//       content: Text(
//         S.of(context).checkoutPage_successMessage,
//         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//       ),
//       actions: [okButton],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   didPopRoute() {
//     bool override;
//     if (isBackButtonActivated)
//       override = false;
//     else
//       override = true;
//     return new Future<bool>.value(override);
//   }

//   void _awaitReturnValueFromSecondScreen(BuildContext context) async {
//     // start the SecondScreen and wait for it to finish with a result
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         settings: RouteSettings(name: AddressesPage.routeName),
//         builder: (context) => AddressesPage(forSelect: true),
//       ),
//     );

//     // after the SecondScreen result comes back update the Text widget with it
//     // kartBloc.add(SelectAddress(result));   Do here , ithink passing address
//   }

//   _buildHeadingItem(item) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).requestFocus(new FocusNode());
//       },
//       child: Container(
//         height: 45,
//         color: AppColors.BLUE_GRAY,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             Text(
//               item.heading,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//               style: TextStyle(
//                 fontSize: 14.0,
//                 color: Colors.black45,
//               ),
//             ),
//           ],
//         ),
//         padding: EdgeInsets.only(
//           top: 10.0,
//           left: 10.0,
//         ),
//       ),
//     );
//   }

//   _buildPlusButton(item) {
//     return Container(
//       height: 60,
//       color: Colors.white,
//       child: Row(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 12.0,
//               right: 12.0,
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(3),
//                 ),
//                 boxShadow: <BoxShadow>[
//                   new BoxShadow(
//                     color: AppColors.CATEGORY_SHADOW,
//                     blurRadius: 4.0,
//                   ),
//                 ],
//               ),
//               width: 45,
//               height: 30,
//               child: FlatButton(
//                 onPressed: () {
//                   _awaitReturnValueFromSecondScreen(context);
//                 },
//                 padding: EdgeInsets.symmetric(horizontal: 4),
//                 child: Icon(
//                   Icons.add,
//                   color: AppColors.MAIN,
//                 ),
//               ),
//             ),
//           ),
//           ConditionalBuilder(
//             condition: kartBloc.kart.address == null,
//             builder: (BuildContext context) {
//               return Text(
//                 item.body,
//                 textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                 style: TextStyle(
//                   color: AppColors.MAIN,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               );
//             },
//             fallback: (BuildContext context) {
//               return Text(
//                 kartBloc.kart.address != null
//                     ? kartBloc.kart.address.address
//                     : '',
//                 textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                 style: TextStyle(
//                   color: AppColors.MAIN,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }

//   _buildTextField() {
//     return Container(
//       decoration: BoxDecoration(
//         //border: Border.all(color: Colors.blue, width: 2.0),
//         color: Colors.white,
//         borderRadius: BorderRadius.all(
//           Radius.circular(Dimens.BORDER_RADIUS),
//         ),
//       ),
//       child: Card(
//         color: Colors.white,
//         child: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: TextField(
//             controller: _descriptionController,
//             maxLines: 3,
//             decoration: InputDecoration.collapsed(
//               hintText: S.of(context).checkoutPage_additionalInfo,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _buildPlain(item) {
//     String text = '000';

//     if (item.id == Identifier.subTotal) {
//       text = getCurrency(
//         kartBloc.kart.subtotalCost,
//         S.of(context).symbol,
//       );
//     }
//     if (item.id == Identifier.delivery) {
//       text = getCurrency(
//         kartBloc.kart.shippingCost,
//         S.of(context).symbol,
//       );
//     }
//     if (item.id == Identifier.balance) {
//       text = getCurrency(
//         skidka,
//         S.of(context).symbol,
//       );
//     }
//     if (item.id == Identifier.earnPoints) {
//       text = getCurrency(
//         (kartBloc.kart.pureProductTotal * discountPerc) / 100,
//         S.of(context).symbol,
//       );
//     }
//     if (item.id == Identifier.total) {
//       text = getCurrency(
//         kartBloc.kart.totalCost,
//         S.of(context).symbol,
//       );
//     }
//     return Container(
//       padding: EdgeInsets.only(
//         left: 12.0,
//         right: 12,
//         top: 8,
//         bottom: 8,
//       ),
//       height: (item.id == Identifier.total) ? 42 : 40,
//       color: Colors.white,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             item.body,
//             textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//             style: (item.id == Identifier.total)
//                 ? TextStyle(
//                     color: AppColors.MAIN,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   )
//                 : TextStyle(
//                     color: (item.id == Identifier.earnPoints)
//                         ? Colors.green
//                         : Colors.black54,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//           ),
//           Text(
//             text,
//             textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//             style: (item.id == Identifier.total)
//                 ? TextStyle(
//                     color: AppColors.MAIN,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   )
//                 : TextStyle(
//                     color: (item.id == Identifier.earnPoints)
//                         ? Colors.green
//                         : Colors.black54,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   _buildRadioBtn(item) {
//     return Container(
//       color: Colors.white,
//       child: // This goes to the build method
//           Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.all(12.0),
//             child: Text(
//               item.body,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black54,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           RadioListTile(
//             value: 'cash',
//             groupValue: kartBloc.kart.type,
//             title: Text(
//               S.of(context).checkoutPage_cash,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//             ),
//             subtitle: Text(
//               S.of(context).checkoutPage_payCash,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//             ),
//             onChanged: (val) {
//               kartBloc.add(SelectType('cash'));
//             },
//             activeColor: AppColors.MAIN,
//             // selected: kartBloc.kart.type == 'cash',
//           ),
//           RadioListTile(
//             value: 'terminal',
//             groupValue: kartBloc.kart.type,
//             title: Text(
//               S.of(context).terminal,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//             ),
//             subtitle: Text(
//               S.of(context).pay_with_terminal_text,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//             ),
//             onChanged: (val) {
//               kartBloc.add(SelectType('terminal'));
//             },
//             activeColor: AppColors.MAIN,
//             // selected: kartBloc.kart.type == 'cash',
//           ),
//           RadioListTile(
//             value: 'online',
//             groupValue: kartBloc.kart.type,
//             title: Text(
//               S.of(context).checkoutPage_online,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//             ),
//             subtitle: Text(
//               S.of(context).checkoutPage_payOnline,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//             ),
//             onChanged: (val) {
//               kartBloc.add(SelectType('online'));
//             },
//             activeColor: AppColors.MAIN,
//             // selected: kartBloc.kart.type == 'online',
//           ),
//         ],
//       ),
//     );
//   }

//   _buildPointsCheckboxBtn(item) {
//     return Container(
//       color: Colors.white,
//       child: // This goes to the build method
//           Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.all(12.0),
//             child: Text(
//               item.body,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black54,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 23.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Container(
//                   width: 30,
//                   child: new Checkbox(
//                     value: _usePoints,
//                     onChanged: _usePointChanged,
//                     activeColor: AppColors.MAIN,
//                   ),
//                 ),
//                 Center(
//                     child: Container(
//                   width: 300,
//                   child: ListTile(
//                     title: Text(
//                       "${(balance > 1) ? "$balance ${S.of(context).point}" : "$balance ${S.of(context).point_plural}"}  (${getCurrency(balance, S.of(context).symbol)})",
//                       textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     subtitle: Text(
//                       S.of(context).use_points,
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ),
//                 )),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _buildTac(item, {BuildContext context}) {
//     return Container(
//       padding: EdgeInsets.only(
//         top: 12.0,
//         right: 12.0,
//         bottom: 12.0,
//       ),
//       height: (item.id == Identifier.total) ? 60 : 50,
//       color: Colors.white,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           new Checkbox(
//             value: _termsAndConditions,
//             onChanged: _termsAndConditionsChanged,
//             activeColor: AppColors.MAIN,
//           ),
//           InkWell(
//             onTap: () {
//               _termsAndConditionsChanged(!_termsAndConditions,
//                   context: context);
//             },
//             child: Center(
//               child: Text(
//                 item.body,
//                 textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                 style: (item.id == Identifier.total)
//                     ? TextStyle(
//                         color: AppColors.MAIN,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       )
//                     : TextStyle(
//                         color: Colors.black54,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _buildButton(BuildContext context, KartState state) {
//     return Positioned(
//       bottom: 0.0,
//       left: 0.0,
//       right: 0.0,
//       child: Container(
//         height: 64,
//         color: AppColors.BLUE_GRAY,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ClipRRect(
//             borderRadius: BorderRadius.all(
//               Radius.circular(Dimens.BORDER_RADIUS / 2),
//             ),
//             child: FlatButton(
//               onPressed: () {
//                 if (state is Checkingout) return;
//                 if (!_termsAndConditions) return;
//                 if (kartBloc.kart.address == null) {
//                   Scaffold.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         S.of(context).checkoutPage_addressNotSelected,
//                         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                       ),
//                       duration: Duration(seconds: 3),
//                     ),
//                   );
//                   return;
//                 }

//                 kartBloc.add(
//                   Checkout(
//                     address: kartBloc.kart.address,
//                     type: kartBloc.kart.type,
//                     description: _descriptionController.text,
//                     usePoint: _usePoints,
//                   ),
//                 );
//               },
//               color: (!_termsAndConditions) ? Colors.grey : AppColors.MAIN,
//               splashColor:
//                   (!_termsAndConditions) ? Colors.grey : AppColors.MAIN_LIGHT,
//               child: ConditionalBuilder(
//                 condition: state is Checkingout,
//                 builder: (BuildContext context) {
//                   return GLoading();
//                 },
//                 fallback: (BuildContext contex) {
//                   return Text(
//                     S.of(context).checkoutPage_orderNow,
//                     textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     items = [
//       HeadingItem(S.of(context).checkoutPage_additionalInfo),
//       BodyItem('', CellType.textField, Identifier.textArea),
//       HeadingItem(S.of(context).checkoutPage_address),
//       BodyItem(
//         S.of(context).checkoutPage_addressSelect,
//         CellType.plusButton,
//         Identifier.address,
//       ),
//       HeadingItem(S.of(context).checkoutPage_toPay),
//       BodyItem(
//         S.of(context).checkoutPage_productTotal,
//         CellType.plain,
//         Identifier.subTotal,
//       ),
//       BodyItem(
//         S.of(context).checkoutPage_deliveryService,
//         CellType.plain,
//         Identifier.delivery,
//       ),
//       BodyItem(
//         S.of(context).checkoutPage_toPay,
//         CellType.plain,
//         Identifier.total,
//       ),
//       BodyItem(
//         S.of(context).checkoutPage_payType,
//         CellType.radioBtn,
//         Identifier.paymentType,
//       ),
//       BodyItem(
//         S.of(context).checkoutPage_TaC,
//         CellType.TaC,
//         Identifier.TaC,
//       ),
//     ];

//     // Here, very unprofessional code. please, increment or decrement index if you will add or remove item

//     if (balance != null) {
//       items.insert(
//         7,
//         BodyItem(
//           (skidka > 1) ? S.of(context).used_points : S.of(context).used_points,
//           CellType.plain,
//           Identifier.balance,
//         ),
//       );
//       items.insert(
//         9,
//         BodyItem(
//           S.of(context).earn_points + " ($discountPerc%)",
//           CellType.plain,
//           Identifier.earnPoints,
//         ),
//       );
//       if (balance != 0) {
//         items.insert(
//           10,
//           BodyItem(
//             S.of(context).getir_point,
//             CellType.usePointsRadio,
//             Identifier.usePoints,
//           ),
//         );
//       }
//       if (_usePoints && kartBloc.kart.totalCost <= 0.0) {
//         kartBloc.add(SelectType('cash'));
//         items.removeAt(
//             11); // remove payment methods if sum less or equal to zero
//       }
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           S.of(context).checkoutPage_title,
//           textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: SafeArea(
//         child: BlocListener(
//           bloc: kartBloc,
//           listener: (BuildContext context, KartState state) {
//             if (state is Checkouted) {
//               if (state.checkout != null) {
//                 if (state.checkout.type != "online") {
//                   showAlertDialog(context);
//                 } else {
//                   Navigator.of(context, rootNavigator: true).push(
//                     MaterialPageRoute(
//                       fullscreenDialog: true,
//                       settings: RouteSettings(name: PaymentPage.routeName),
//                       builder: (context) {
//                         return PaymentPage(checkout: state.checkout);
//                       },
//                     ),
//                   );
//                 }
//               } else {
//                 Scaffold.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       S.of(context).checkoutPage_error,
//                       textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                     ),
//                     duration: Duration(seconds: 3),
//                   ),
//                 );
//               }
//             }

//             // if (state is CheckoutCompleted) {
//             //   Navigator.of(context).popUntil(ModalRoute.withName('/'));
//             // }

//             if (state is KartError) {
//               Scaffold.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     S.of(context).checkoutPage_error,
//                     textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//                   ),
//                   duration: Duration(seconds: 3),
//                 ),
//               );
//             }
//           },
//           child: BlocBuilder(
//             bloc: kartBloc,
//             builder: (BuildContext context, KartState state) {
//               return Stack(
//                 children: [
//                   ListView.builder(
//                     itemCount: items.length,
//                     padding: EdgeInsets.only(bottom: 72),
//                     itemBuilder: (BuildContext context, index) {
//                       final item = items[index];
//                       if (item is HeadingItem) {
//                         return _buildHeadingItem(item);
//                       }
//                       if (item is BodyItem) {
//                         Widget child;
//                         if (item.type == CellType.plusButton) {
//                           child = _buildPlusButton(item);
//                         } else if (item.type == CellType.textField) {
//                           child = _buildTextField();
//                         } else if (item.type == CellType.plain) {
//                           child = _buildPlain(item);
//                         } else if (item.type == CellType.radioBtn) {
//                           child = _buildRadioBtn(item);
//                         } else if (item.type == CellType.usePointsRadio) {
//                           child = _buildPointsCheckboxBtn(item);
//                         } else if (item.type == CellType.TaC) {
//                           child = _buildTac(item, context: context);
//                         }
//                         return child;
//                       }
//                       return Container();
//                     },
//                   ),
//                   _buildButton(context, state),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// abstract class ListItem {}

// // A ListItem that contains data to display a heading
// class HeadingItem extends ListItem {
//   final String heading;

//   HeadingItem(this.heading);
// }

// class BodyItem extends ListItem {
//   final String body;
//   final CellType type;
//   final Identifier id;

//   BodyItem(this.body, this.type, this.id);
// }
import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  static const routeName = 'checkout';
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

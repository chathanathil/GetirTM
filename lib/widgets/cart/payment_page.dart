// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// import '../../bloc/kart/kart.dart';
// import '../../models/checkout.dart' as CheckoutModel;
// import '../../utils/utils.dart';
// import 'dart:io' show Platform;

// class PaymentPage extends StatefulWidget {
//   static const routeName = "payment";
//   final CheckoutModel.Checkout checkout;

//   const PaymentPage({Key key, this.checkout}) : super(key: key);

//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   final flutterWebviewPlugin = new FlutterWebviewPlugin();
//   bool dialog = false;
//   KartBloc kartBloc;

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       kartBloc = BlocProvider.of<KartBloc>(context);

//       flutterWebviewPlugin.onUrlChanged.listen((String url) {
//         if (url.contains('success')) {
//           Future.delayed(Duration(seconds: 3), () {
//             Navigator.of(context).pop();
//           });
//           kartBloc.add(CompletePayment(success: true));
//         } else if (url.contains('error')) {
//           Navigator.of(context).pop();
//           kartBloc.add(CompletePayment(success: false));
//         }
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool showZoomControls = false;

//     if (Platform.isAndroid) {
//       showZoomControls = true;
//     } else if (Platform.isIOS) {
//       showZoomControls = false;
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           S.of(context).paymentPage_title,
//           textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//         ),
//         backgroundColor: AppColors.MAIN,
//         leading: FlatButton(
//           child: Icon(
//             Icons.close,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             flutterWebviewPlugin.hide();
//             showAlertDialog(context);
//           },
//         ),
//       ),
//       body: new WebviewScaffold(
//         url: widget.checkout.formUrl,
//         withZoom: true,
//         withLocalStorage: true,
//         hidden: true,
//         displayZoomControls: showZoomControls,
//         initialChild: Container(
//           child: Center(
//             child: Text(
//               S.of(context).paymentPage_loading,
//               textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   showAlertDialog(BuildContext context) {
//     // set up the button
//     Widget okButton = FlatButton(
//       child: Text(
//         S.of(context).paymentPage_pay,
//         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//       ),
//       onPressed: () {
//         Navigator.of(context, rootNavigator: true).pop('dialog');
//         flutterWebviewPlugin.show();
//       },
//     );
//     Widget cancel = FlatButton(
//       child: Text(
//         S.of(context).paymentPage_cancel,
//         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//         style: TextStyle(color: Colors.red),
//       ),
//       onPressed: () {
//         Navigator.of(context, rootNavigator: true).pop('dialog');
//         Navigator.of(context).pop();
//       },
//     );
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text(
//         S.of(context).paymentPage_warning,
//         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//       ),
//       content: Text(
//         S.of(context).paymentPage_warningMessage,
//         textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
//       ),
//       actions: [
//         Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[okButton, cancel],
//           ),
//         )
//       ],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }

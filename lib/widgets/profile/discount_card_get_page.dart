import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../../widgets/common/common.dart';
import '../../provider/discount_card.dart';

class DiscountCardGetPage extends StatefulWidget {
  static const routeName = 'discount_card_get';

  @override
  _DiscountCardGetPageState createState() => _DiscountCardGetPageState();
}

class _DiscountCardGetPageState extends State<DiscountCardGetPage> {
  final _nameTextController = TextEditingController();
  final _surnameTextController = TextEditingController();
  final _dobTextController = TextEditingController();
  String gender = "male";

  bool isLoading = false;

  var dobFormatter = new MaskTextInputFormatter(
      mask: '####-##-##', filter: {"#": RegExp(r'[0-9]')});
  List formErrors = [];
  final _nameFocus = FocusNode();
  final _surnameFocus = FocusNode();
  final _dobFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _surnameTextController.dispose();
    _dobTextController.dispose();
    _nameFocus.dispose();
    _surnameFocus.dispose();
    _dobFocus.dispose();
    super.dispose();
  }

  void onSubmit() {
    final discountCardProvider =
        Provider.of<DiscountCardProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    discountCardProvider.createDiscountCard({
      'name': _nameTextController.text.trim(),
      'surname': _surnameTextController.text.trim(),
      // 'phone': "+993${phoneFormatter.getUnmaskedText()}",
      'birthday': dobFormatter.getMaskedText(),
      'gender': gender
    }).then(
      (response) {
        showDialog(
          context: context,
          builder: (BuildContext childContext) {
            return AlertDialog(
              title: Text(S.of(context).checkoutPage_success),
              content: Text(S.of(context).discount_card_order_success),
              actions: <Widget>[
                FlatButton(
                  child: Text(S.of(context).close),
                  onPressed: () {
                    Navigator.of(childContext).pop();
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        isLoading = false;
        formErrors = [];
      });
    }).catchError((error) {
      if (error?.data['errors'] != null) {
        setState(() {
          formErrors = List.from((error?.data['errors'] as Map).keys);
        });
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).error),
            content: Text('Error occured try again later'),
          );
        },
      );
    });
  }

  errorText(field) {
    return formErrors.indexOf(field) != -1
        ? (field == 'birthday')
            ? S.of(context).invalid_field
            : S.of(context).createAddressPage_required
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: ListView(
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).discount_card_get_rule,
              style: TextStyle(fontSize: 15),
              textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
            ),
          ),
          SizedBox(
            height: 9,
          ),
          TextField(
            focusNode: _nameFocus,
            controller: _nameTextController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(30.0),
                ),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: S.of(context).enter_discount_card_name,
              fillColor: Colors.white70,
              errorText: errorText('name'),
            ),
            style: TextStyle(fontSize: 13),
            onSubmitted: (String value) {
              FocusScope.of(context).requestFocus(_surnameFocus);
            },
          ),
          SizedBox(
            height: 9,
          ),
          TextField(
            focusNode: _surnameFocus,
            controller: _surnameTextController,
            maxLength: 16,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(30.0),
                ),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: S.of(context).enter_discount_card_surname,
              fillColor: Colors.white70,
              errorText: errorText('surname'),
            ),
            style: TextStyle(fontSize: 13),
            onSubmitted: (String value) {
              FocusScope.of(context).requestFocus(_dobFocus);
            },
          ),
          SizedBox(
            height: 9,
          ),
          TextField(
            focusNode: _dobFocus,
            controller: _dobTextController,
            maxLength: 16,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(30.0),
                ),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: S.of(context).enter_discount_card_birthday + ' (Y-m-d)',
              fillColor: Colors.white70,
              errorText: errorText('birthday'),
            ),
            style: TextStyle(fontSize: 13),
            inputFormatters: [dobFormatter],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Radio(
                      value: "male",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      }),
                  Text("Male")
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                      value: "female",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      }),
                  Text("Female")
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              height: 50,
              width: 200,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                onPressed: onSubmit,
                child: ConditionalBuilder(
                  condition: isLoading,
                  builder: (BuildContext context) {
                    return CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    );
                  },
                  fallback: (BuildContext context) {
                    return Text(
                      S.of(context).verify,
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
                color: AppColors.MAIN,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

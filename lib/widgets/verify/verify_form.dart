//TODO:find the turkmen and rus of name and change the label text in name field alse for error message
import 'dart:async';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../provider/auth.dart';
import '../../models/http_exception.dart';
import '../../utils/colors.dart';
import '../../generated/i18n.dart';
import '../../utils/dimens.dart';

enum FormValidation { phoneInvalid, nameInvalid, codeInvalid, valid }

class VerifyForm extends StatefulWidget {
  VerifyForm({Key key}) : super(key: key);

  _VerifyFormState createState() => _VerifyFormState();
}

class _VerifyFormState extends State<VerifyForm> {
  final _phoneController = TextEditingController(text: '+993 ');
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  var maskFormatter = new MaskTextInputFormatter(
      mask: '+993 ## ##-##-##', filter: {"#": RegExp(r'[0-9]')});
  Timer _timerController;
  int _timer = 60;
  bool _codeSent = false;
  FormValidation _validate;
  var _verifyLoading = false;

  @override
  void dispose() {
    if (_timerController != null) _timerController.cancel();
    _nameController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  _startTimer() {
    _timerController = Timer.periodic(new Duration(seconds: 1), (time) {
      setState(() {
        _timer -= 1;
      });

      if (_timer <= 0) {
        time.cancel();
      }
    });
  }

  _showErrorMessage(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  _onSendCodeButtonPressed() async {
    String phone = "+993${maskFormatter.getUnmaskedText()}";
    if (phone.length < 12) {
      setState(() {
        _validate = FormValidation.phoneInvalid;
      });
      return;
    }
    if (_nameController.text.length < 1) {
      setState(() {
        _validate = FormValidation.nameInvalid;
      });
      return;
    }
    setState(() {
      _verifyLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(phone: phone, name: "Maksat");

      setState(() {
        _validate = FormValidation.valid;
        _codeSent = true;
        _timer = 60;
        _verifyLoading = false;
      });

      _startTimer();
    } on HttpException catch (error) {
      _showErrorMessage(error.toString());
      setState(() {
        _verifyLoading = false;
      });
    } catch (err) {
      throw err;
    }
  }

  _onVerifyButtonPressed() async {
    String phone = "+993${maskFormatter.getUnmaskedText()}";
    String code = _codeController.text.trim();

    if (code.length != 6) {
      setState(() {
        _validate = FormValidation.codeInvalid;
      });
      return;
    }

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .verify(phone: phone, otp: code);
      Navigator.of(context).pop();
    } on HttpException catch (error) {
      _showErrorMessage(error.toString());
    } catch (err) {
      throw err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          left: 20.0,
          right: 20.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Theme(
                data: new ThemeData(
                  //this changes the colour
                  hintColor: Colors.grey,
                  inputDecorationTheme: new InputDecorationTheme(
                    labelStyle: new TextStyle(color: AppColors.MAIN),
                  ),
                ),
                child: TextField(
                  controller: _phoneController,
                  inputFormatters: [maskFormatter],
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 0.3,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 0.3,
                      ),
                    ),
                    errorText: (_validate == FormValidation.phoneInvalid)
                        ? S.of(context).verifyPage_phoneInvalid
                        : null,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.MAIN_LIGHT,
                        width: 0.3,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.MAIN,
                        width: 1,
                      ),
                    ),
                    labelText: S.of(context).verifyPage_phoneField,
                    hintStyle: TextStyle(color: AppColors.MAIN_LIGHT),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Theme(
                data: new ThemeData(
                  //this changes the colour
                  hintColor: Colors.grey,
                  inputDecorationTheme: new InputDecorationTheme(
                    labelStyle: new TextStyle(color: AppColors.MAIN),
                  ),
                ),
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 0.3,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 0.3,
                      ),
                    ),
                    errorText: (_validate == FormValidation.nameInvalid)
                        ? S.of(context).verifyPage_phoneInvalid
                        : null,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.MAIN_LIGHT,
                        width: 0.3,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.MAIN,
                        width: 1,
                      ),
                    ),
                    labelText: S.of(context).verifyPage_phoneField,
                    hintStyle: TextStyle(color: AppColors.MAIN_LIGHT),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: _codeSent,
                child: Theme(
                  data: new ThemeData(
                    //this changes the colour
                    hintColor: Colors.grey,
                    inputDecorationTheme: new InputDecorationTheme(
                      labelStyle: new TextStyle(color: AppColors.MAIN),
                    ),
                  ),
                  child: TextField(
                    maxLength: 6,
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    obscureText: false,
                    enabled: _codeSent,
                    decoration: new InputDecoration(
                      errorText: (_validate == FormValidation.codeInvalid)
                          ? S.of(context).verifyPage_codeInvalid
                          : null,
                      errorBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 0.3,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.MAIN_LIGHT,
                          width: 0.3,
                        ),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 0.3,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.MAIN,
                          width: 1,
                        ),
                      ),
                      hintText: "xxxxxx",
                      labelText: S.of(context).verifyPage_codeField,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 38,
                height: 45.0,
                child: RaisedButton(
                  color: AppColors.MAIN,
                  onPressed: () {
                    if (_verifyLoading) return;
                    if (!_codeSent) {
                      _onSendCodeButtonPressed();
                    } else if (_codeSent) {
                      _onVerifyButtonPressed();
                    }
                  },
                  child: ConditionalBuilder(
                    condition: _verifyLoading,
                    builder: (BuildContext context) {
                      return CircularProgressIndicator();
                    },
                    fallback: (BuildContext context) {
                      return Text(
                        _codeSent == true
                            ? S.of(context).verifyPage_verify
                            : S.of(context).verifyPage_sendCode,
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Visibility(
                visible: _codeSent,
                child: Container(
                  width: MediaQuery.of(context).size.width - 38,
                  height: 45.0,
                  child: RaisedButton(
                    onPressed: _timer == 0
                        ? () {
                            _onSendCodeButtonPressed();
                          }
                        : null,
                    disabledColor: Theme.of(context).canvasColor,
                    child: Text(
                      _timer == 0
                          ? S.of(context).verifyPage_resendCode
                          : S.of(context).verifyPage_resendCodeIn('$_timer'),
                      textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

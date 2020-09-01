import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';
import '../../provider/address.dart';
import '../../models/address.dart' as Model;
import '../../utils/utils.dart';
import '../../widgets/common/common.dart';

enum FormValidation {
  titleInValid,
  textInValid,
  typeInValid,
  cityInValid,
  valid
}

class AddressCreatePage extends StatefulWidget {
  final bool isEditing;
  final Model.Address item;

  AddressCreatePage({
    this.item,
    this.isEditing = false,
  }) : super();

  @override
  _AddressCreatePageState createState() => _AddressCreatePageState();
}

class _AddressCreatePageState extends State<AddressCreatePage> {
  bool get isEditing => widget.isEditing;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textController = TextEditingController();

  List<Model.City> _cities = [];
  List<Model.AddressType> _addressTypes = [];
  Model.City _selectedCity;
  Model.AddressType _selectedType;
  FormValidation _validate;
  var _addLoading = false;
  var _loadCities = false;
  var _loadTypes = false;
  var _isInit = true;
  bool _isDefault = false;
  String _text;

  @override
  void didChangeDependencies() async {
    final _provider = Provider.of<AddressProvider>(context, listen: false);
    super.didChangeDependencies();
    if (_isInit) {
      _textController.text = (isEditing) ? widget.item.address : '';
      _isDefault = isEditing ? widget.item.isDefault : false;

      setState(() {
        _loadCities = true;
      });
      _cities = await _provider.fetchCities();

      if (isEditing) {
        _cities.replaceRange(
            _cities.indexWhere((element) => element.id == widget.item.city.id),
            _cities.indexWhere((element) => element.id == widget.item.city.id) +
                1,
            [widget.item.city]);
        _selectedCity = widget.item.city;
      } else {
        _selectedCity = _cities[0];
      }
      setState(() {
        _loadCities = false;
      });

      setState(() {
        _loadTypes = true;
      });
      _addressTypes = await _provider.fetchAddressTypes();
      if (isEditing) {
        _addressTypes.replaceRange(
            _addressTypes
                .indexWhere((element) => element.id == widget.item.type.id),
            _addressTypes.indexWhere(
                    (element) => element.id == widget.item.type.id) +
                1,
            [widget.item.type]);
        _selectedType = widget.item.type;
      } else {
        _selectedType = _addressTypes[0];
      }
      setState(() {
        _loadTypes = false;
      });
    }

    _isInit = false;
  }

  void _onSelectedCity(Model.City value) {
    setState(() {
      _selectedCity = value;
      _validate = FormValidation.valid;
    });
  }

  void _onSelectedType(Model.AddressType value) {
    setState(() {
      _selectedType = value;
      _validate = FormValidation.valid;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Widget _buildCitySelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        new DropdownButton<Model.City>(
          isExpanded: true,
          value: _selectedCity,
          hint: Text(
            S.of(context).createAddressPage_selectState,
            textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          ),
          items: _cities.map(
            (Model.City item) {
              return new DropdownMenuItem<Model.City>(
                value: item,
                child: new Text(
                  item.name,
                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            },
          ).toList(),
          onChanged: (value) => _onSelectedCity(value),
        ),
        Text(
          (_validate == FormValidation.cityInValid)
              ? S.of(context).createAddressPage_stateNotSelected
              : '',
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          style: TextStyle(
            color: Colors.redAccent.shade700,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        new DropdownButton<Model.AddressType>(
          isExpanded: true,
          value: _selectedType,
          hint: Text(S.of(context).createAddressPage_selectRegion),
          items: _addressTypes.map((Model.AddressType item) {
            return new DropdownMenuItem<Model.AddressType>(
              value: item,
              child: new Text(
                item.name,
                style: new TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (value) => _onSelectedType(value),
        ),
        Text(
          (_validate == FormValidation.typeInValid)
              ? S.of(context).createAddressPage_regionNotSelected
              : '',
          style: TextStyle(
            color: Colors.redAccent.shade700,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _buildExtraInput() {
    return Container(
      height: 150,
      child: TextFormField(
        initialValue: isEditing ? widget.item.address : '',
        minLines: 3,
        maxLines: 6,
        keyboardType: TextInputType.multiline,
        style: new TextStyle(color: Colors.black54),
        decoration: InputDecoration(
          labelText: S.of(context).createAddressPage_address,
          labelStyle: TextStyle(color: Colors.grey),
          helperStyle: TextStyle(color: Colors.grey),
          errorBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 0.3),
          ),
          errorText: (_validate == FormValidation.textInValid)
              ? S.of(context).createAddressPage_required
              : null,
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          ),
          hintStyle: TextStyle(color: Colors.black26),
          hintText: S.of(context).createAddressPage_addressHint,
          border: const OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        validator: (val) {
          return val.trim().isEmpty
              ? S.of(context).createAddressPage_required
              : null;
        },
        onSaved: (val) {
          _text = val;
        },
      ),
    );
  }

  Widget _buildButton() {
    return Positioned(
      bottom: 35,
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width - 30,
          child: FlatButton(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(Dimens.BORDER_RADIUS / 2),
            ),
            onPressed: () async {
              final _addProvider =
                  Provider.of<AddressProvider>(context, listen: false);

              if (_selectedCity == null) {
                setState(() {
                  _validate = FormValidation.cityInValid;
                });
              } else if (_selectedType == null) {
                setState(() {
                  _validate = FormValidation.typeInValid;
                });
              } else {
                _validate = FormValidation.valid;
              }

              if (_validate == FormValidation.valid) {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  if (isEditing) {
                    Map body = {
                      'id': widget.item.id,
                      "type_id":
                          (_selectedType != null) ? _selectedType.id : '',
                      "city_id":
                          (_selectedCity != null) ? _selectedCity.id : '',
                      'address': (_text != null) ? _text : '',
                      "is_default": _isDefault
                    };
                    setState(() {
                      _addLoading = true;
                    });

                    try {
                      await _addProvider.updateAddress(body);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          _addProvider.addressMsg.length != 0
                              ? _addProvider.addressMsg
                              : S.of(context).addressPage_updated,
                          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                        ),
                        duration: Duration(seconds: 3),
                      ));
                      Navigator.of(context).pop();
                      setState(() {
                        _addLoading = false;
                      });
                    } on HttpException catch (error) {
                      setState(() {
                        _addLoading = false;
                      });
                      showMessageDialog(context, error.toString());
                    } catch (err) {
                      setState(() {
                        _addLoading = false;
                      });
                      showMessageDialog(
                          context, 'Error occured try again later');
                    }
                  } else {
                    Map body = {
                      "type_id":
                          (_selectedType != null) ? _selectedType.id : '',
                      "city_id":
                          (_selectedCity != null) ? _selectedCity.id : '',
                      "address": (_text != null) ? _text : '',
                      "is_default": _isDefault
                    };
                    setState(() {
                      _addLoading = true;
                    });
                    try {
                      await _addProvider.addAddress(body);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          _addProvider.addressMsg.length != 0
                              ? _addProvider.addressMsg
                              : S.of(context).addressPage_updated,
                          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                        ),
                        duration: Duration(seconds: 3),
                      ));

                      Navigator.of(context).pop();
                      setState(() {
                        _addLoading = false;
                      });
                    } on HttpException catch (error) {
                      showMessageDialog(context, error.toString());
                      setState(() {
                        _addLoading = false;
                      });
                    } catch (err) {
                      setState(() {
                        _addLoading = false;
                      });
                      Navigator.of(context).pop();
                    }
                  }
                }
              }
            },
            child: ConditionalBuilder(
              condition: _addLoading,
              builder: (BuildContext context) {
                return CircularProgressIndicator();
              },
              fallback: (BuildContext context) {
                return Text(
                  widget.isEditing
                      ? S.of(context).createAddressPage_update
                      : S.of(context).createAddressPage_create,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.isEditing
              ? S.of(context).createAddressPage_editAddress
              : S.of(context).createAddressPage_createAddress,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: _loadCities || _loadTypes
            ? LoadingPage()
            : Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 15.0,
                  right: 15.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: <Widget>[
                      ListView(
                        padding: EdgeInsets.only(bottom: 15),
                        children: <Widget>[
                          _buildCitySelect(),
                          SizedBox(height: 15),
                          _buildTypeSelect(),
                          SizedBox(height: 20),
                          _buildExtraInput(),
                          CheckboxListTile(
                            title: Text("Is default"),
                            value: _isDefault,
                            onChanged: (newValue) {
                              setState(() {
                                _isDefault = newValue;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ],
                      ),
                      _buildButton(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

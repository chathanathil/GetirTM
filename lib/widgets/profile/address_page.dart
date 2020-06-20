import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/http_exception.dart';
import '../../utils/utils.dart';
import '../../widgets/common/common.dart';
import '../../models/address.dart' as Model;
import '../../widgets/profile/address_create_page.dart';
import 'package:provider/provider.dart';
import '../../provider/address.dart';

class AddressesPage extends StatefulWidget {
  static const routeName = 'addresses';
  final bool forSelect;

  const AddressesPage({Key key, this.forSelect = false}) : super(key: key);

  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final SlidableController slidableController = SlidableController();
  var _addressLoading = false;

  @override
  void initState() {
    final _provider = Provider.of<AddressProvider>(context, listen: false);
    if (_provider.addresses.isEmpty) {
      setState(() {
        _addressLoading = true;
      });
      _provider.fetchAddresses().then((value) => setState(() {
            _addressLoading = false;
            print(
                Provider.of<AddressProvider>(context, listen: false).addresses);
          }));
    }
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).addressPage_title,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<AddressProvider>(
        builder: (ctx, addressData, child) {
          if (_addressLoading) {
            return LoadingPage();
          }

          if (addressData.addresses.isEmpty) {
            return EmptyPage(
              title: S.of(context).notFound,
              message: S.of(context).addressPage_empty,
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(color: Colors.grey, height: 0);
            },
            itemCount: addressData.addresses.length,
            itemBuilder: (BuildContext context, index) {
              Model.Address address = addressData.addresses[index];
              return Slidable(
                controller: slidableController,
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: InkWell(
                  onTap: () {
                    if (widget.forSelect) {
                      Navigator.pop(context, address);
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute<AddressCreatePage>(
                          builder: (context) {
                            return AddressCreatePage(
                              item: address,
                              isEditing: true,
                            );
                          },
                        ),
                      );
                    }
                  },
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        address.address,
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    trailing: Text(
                        address.isDefault
                            ? S.of(context).addressPage_defaulted
                            : '',
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR),
                  ),
                ),
                secondaryActions: address.isDefault || widget.forSelect
                    ? []
                    : <Widget>[
                        IconSlideAction(
                          caption: S.of(context).addressPage_delete,
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            if (address.isDefault) {
                              showMessageDialog(
                                  context, 'Default address cannot be deleted');
                              return;
                            }
                            try {
                              addressData.deleteAddress(address.id);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  S.of(context).addressPage_deleted,
                                  textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                                ),
                                duration: Duration(seconds: 3),
                              ));
                            } on HttpException catch (error) {
                              showMessageDialog(context, error.toString());
                            } catch (err) {
                              showMessageDialog(
                                  context, 'Error occured try again later');
                            }
                          },
                        ),
                      ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppColors.MAIN,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<AddressCreatePage>(
              builder: (context) {
                return AddressCreatePage();
              },
            ),
          );
        },
      ),
    );
  }
}

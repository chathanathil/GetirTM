import 'dart:io';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:getirtm/models/feedback.dart';
import 'package:getirtm/provider/home.dart';
import 'package:getirtm/utils/utils.dart';

import 'package:image_picker/image_picker.dart';

class FeedbackPage extends StatefulWidget {
  static const routeName = 'feedback';

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _contentTextController = TextEditingController();
  final _contentFocus = FocusNode();
  var _isLoading = false;
  List<FeedBackType> types = [];
  List<Map<String, dynamic>> images = [
    {'type': 'String', 'url': 'Add Image'}
  ];
  int type = 0;
  @override
  void initState() {
    HomeProvider.fetchFeedbackTypes().then((value) => {
          setState(() {
            types = value;
            type = value[0].id;
          }),
        });
    super.initState();
  }

  Widget generateTypes() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(types.length, (index) {
          return Row(
            children: <Widget>[
              Radio(
                  value: types[index].id,
                  groupValue: type,
                  onChanged: (value) {
                    setState(() {
                      type = value;
                    });
                  }),
              Text(types[index].name)
            ],
          );
        }));
  }

  Widget buildGridView(context) {
    return Wrap(
      runSpacing: 10,
      spacing: 5,
      alignment: WrapAlignment.spaceEvenly,
      children: List.generate(images.length, (index) {
        if (images[index]['type'] == 'File') {
          File uploadFile = images[index]['url'];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadFile,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.removeAt(index);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            child: SizedBox(
              height: 100,
              width: 100,
              child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => {
                        showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return UploadImage(
                                setImage: (x) => {
                                  setState(() {
                                    images.add({'type': 'File', 'url': x});
                                  })
                                },
                              );
                            })
                      }),
            ),
          );
        }
      }),
    );
  }

  onSubmit() async {
    if (_titleTextController.text.trim().length == 0 ||
        _contentTextController.text.trim().length == 0) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    List<File> img = [];
    images.forEach((item) {
      if (item['type'] == "File") {
        img.add(item['url']);
      }
    });

    try {
      final res = await HomeProvider.addFeedback(
          _titleTextController.text, _contentTextController.text, type, img);

      setState(() {
        _isLoading = false;
        _titleTextController.text = "";
        _contentTextController.text = "";
        images = [
          {'type': 'String', 'url': 'Add Image'}
        ];
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      throw e;
    }
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback',
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildGridView(context),
              SizedBox(
                height: 15,
              ),
              generateTypes(),
              TextField(
                controller: _titleTextController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: 'Title',
                  fillColor: Colors.white70,
                ),
                style: TextStyle(fontSize: 13),
                onSubmitted: (String value) {
                  FocusScope.of(context).requestFocus(_contentFocus);
                },
              ),
              SizedBox(
                height: 9,
              ),
              TextField(
                minLines: 3,
                maxLines: 6,
                focusNode: _contentFocus,
                controller: _contentTextController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: 'Content',
                  fillColor: Colors.white70,
                ),
                style: TextStyle(fontSize: 13),
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
                      condition: _isLoading,
                      builder: (BuildContext context) {
                        return CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        );
                      },
                      fallback: (BuildContext context) {
                        return Text(
                          'Submit',
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
        ),
      ),
    );
  }
}

class UploadImage extends StatelessWidget {
  final Function setImage;

  const UploadImage({
    Key key,
    @required this.setImage,
  }) : super(key: key);

  void getImageFile(ImageSource source, context) async {
    var image = await ImagePicker.pickImage(source: source);

    setImage(image);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: () => getImageFile(ImageSource.camera, context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                    ),
                    Text("Camera"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                onPressed: () => getImageFile(ImageSource.gallery, context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.file_upload,
                    ),
                    Text("Gallery"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

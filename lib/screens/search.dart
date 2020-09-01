import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'
    show CupertinoTextField, OverlayVisibilityMode;
import 'package:getirtm/widgets/product/product_widget.dart';
import 'package:provider/provider.dart';

import '../provider/search.dart';
import '../models/popular_search.dart';
import '../utils/utils.dart';
import '../utils/link_container.dart';
import '../widgets/product/product_details_page.dart';
import '../widgets/common/common.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "search";

  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = new TextEditingController();
  static final _inputKey = new GlobalKey<FormState>();

  List<PopularSearch> recomendWords = [];

  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      await Provider.of<SearchProvider>(context, listen: false).popularSearch();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.GRAY_LIGHT,
      appBar: AppBar(
        title: Text(
          S.of(context).searchPage_title,
          textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: searchResult(),
    );
  }

  String searchTerm = '';
  _search(String keyWord) async {
    setState(() {
      searchTerm = keyWord;
    });

    final _provider = Provider.of<SearchProvider>(context, listen: false);
    if (keyWord.length < 2) {
      return _provider.setEmpty();
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await _provider.search(keyWord);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      throw err;
    }
  }

  goSearchList(String keyWord) {
    _textController.text = keyWord;
    _search(keyWord);
  }

  Widget searchResult() {
    return Column(
      children: <Widget>[
        _buildInput(),
        Consumer<SearchProvider>(
          builder: (context, search, _) {
            if (_isLoading) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (searchTerm.length == 0) {
              recomendWords = search.popularSearches;

              return HotSugWidget(
                hotWords: recomendWords,
                goSearchList: goSearchList,
              );
            }

            if (search.products == null && search.popularSearches != null) {
              recomendWords = search.popularSearches;
              return HotSugWidget(
                hotWords: recomendWords,
                goSearchList: goSearchList,
              );
            }

            if (search.products != null) {
              if (search.products.length == 0) {
                return EmptyPage(
                  title: S.of(context).notFound,
                  message: S.of(context).searchPage_notFound,
                );
              }

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      padding: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).searchPage_searchResult,
                        textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(10.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, //Column
                          mainAxisSpacing: 10.0, //spaceTopBottom
                          crossAxisSpacing: 10.0, //spaceLeftRight
                          childAspectRatio: 0.76,
                        ),
                        itemCount: search.products.length,
                        itemBuilder: (context, index) {
                          return createModalLinkContainer(
                            context,
                            ProductWidget(
                              search.products[index],
                              search: 1,
                            ),
                            () => ProductDetailsPage(search.products[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container();
          },
        ),
      ],
    );
  }

  Widget _buildInput() {
    return Container(
      color: Colors.white,
      child: CupertinoTextField(
        key: _inputKey,
        prefix: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.search,
            color: AppColors.MAIN,
            size: 28.0,
          ),
        ),
        padding: EdgeInsets.all(10),
        //key: _inputKey,
        placeholder: S.of(context).searchPage_placeholder,
        controller: _textController,
        clearButtonMode: OverlayVisibilityMode.never,
        onSubmitted: (text) {
          if (text != null && text.isEmpty) {
            _search('');
          }
        },
        onChanged: (text) {
          _search(text);
        },
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class HotSugWidget extends StatelessWidget {
  final List<PopularSearch> hotWords;
  final ValueChanged<String> goSearchList;

  HotSugWidget({Key key, this.hotWords, this.goSearchList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hotWords == null || hotWords.isEmpty) {
      return Container();
    }
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).searchPage_popularSearch,
            textScaleFactor: Dimens.TEXT_SCALE_FACTOR,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        Container(
          color: Colors.white,
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: hotWords.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    goSearchList(hotWords[index].query);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: new Border.all(color: AppColors.GRAY_LIGHT),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        hotWords[index].query,
                        textScaleFactor: 1.0,
                        style: TextStyle(color: AppColors.MAIN),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

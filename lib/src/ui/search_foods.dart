import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutritionfacts/src/ui/widget/empty.dart';
import 'package:nutritionfacts/src/ui/widget/loading.dart';

import '../blocs/food_detail_bloc_provider.dart';
import '../blocs/foods_bloc.dart';
import '../constants/constants.dart' as Constants;
import '../enum/sort_by_enum.dart';
import '../enum/sort_order_enum.dart';
import '../extension/extension.dart';
import '../models/search_item.dart';
import 'food_detail.dart';
import 'widget/error.dart';

class SearchFoods extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchFoodsState();
  }
}

class SearchFoodsState extends State<SearchFoods> {
  final searchController = TextEditingController();
  final brandNameController = TextEditingController();
  bool hasSearchableQuery = false;
  String sortBy = SortByEnum.score.name;
  String sortOrder = SortOrderEnum.asc.name;
  bool isBrandedSelected = false;
  bool isFoundationSelected = false;
  bool isSRLegacySelected = false;
  bool isSurveySelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    foodsBloc.dispose();
    super.dispose();
  }

  void _searchFoods() {
    if (hasSearchableQuery) {
      var dataTypes = new List();
      if (isBrandedSelected) dataTypes.add('Branded');
      if (isFoundationSelected) dataTypes.add('Foundation');
      if (isSRLegacySelected) dataTypes.add('SR Legacy');
      if (isSurveySelected) dataTypes.add('Survey');

      String body = jsonEncode({
        'query': searchController.text,
        'pageSize': Constants.PAGE_SIZE,
        'pageNumber': Constants.PAGE_NUMBER,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
        'brandOwner': brandNameController.text,
        'dataType': dataTypes,
      });

      foodsBloc.fetchSearchItem(body);
    }
  }

  void _sortingModalBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: Wrap(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Sort',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    ListTile(
                        trailing: Icon(Icons.keyboard_arrow_right),
                        dense: true,
                        title: Text('A-Z (Name)'),
                        selected:
                            sortBy == SortByEnum.lowercaseDescription.name &&
                                sortOrder == SortOrderEnum.asc.name,
                        onTap: () => {
                              setState(() {
                                sortBy = SortByEnum.lowercaseDescription.name;
                                sortOrder = SortOrderEnum.asc.name;
                              }),
                              _searchFoods(),
                              Navigator.pop(context)
                            }),
                    ListTile(
                        trailing: Icon(Icons.keyboard_arrow_right),
                        dense: true,
                        title: Text('Z-A (Name)'),
                        selected:
                            sortBy == SortByEnum.lowercaseDescription.name &&
                                sortOrder == SortOrderEnum.desc.name,
                        onTap: () => {
                              setState(() {
                                sortBy = SortByEnum.lowercaseDescription.name;
                                sortOrder = SortOrderEnum.desc.name;
                              }),
                              _searchFoods(),
                              Navigator.pop(context)
                            }),
                    ListTile(
                        trailing: Icon(Icons.keyboard_arrow_right),
                        dense: true,
                        title: Text('A-Z (Brand Name)'),
                        selected: sortBy == SortByEnum.brandOwner.name &&
                            sortOrder == SortOrderEnum.asc.name,
                        onTap: () => {
                              setState(() {
                                sortBy = SortByEnum.brandOwner.name;
                                sortOrder = SortOrderEnum.asc.name;
                              }),
                              _searchFoods(),
                              Navigator.pop(context)
                            }),
                    ListTile(
                        trailing: Icon(Icons.keyboard_arrow_right),
                        dense: true,
                        title: Text('Z-A (Brand Name)'),
                        selected: sortBy == SortByEnum.brandOwner.name &&
                            sortOrder == SortOrderEnum.desc.name,
                        onTap: () => {
                              setState(() {
                                sortBy = SortByEnum.brandOwner.name;
                                sortOrder = SortOrderEnum.desc.name;
                              }),
                              _searchFoods(),
                              Navigator.pop(context)
                            }),
                    ListTile(
                        trailing: Icon(Icons.keyboard_arrow_right),
                        dense: true,
                        title: Text('A-Z (Score)'),
                        selected: sortBy == SortByEnum.score.name &&
                            sortOrder == SortOrderEnum.asc.name,
                        onTap: () => {
                              setState(() {
                                sortBy = SortByEnum.score.name;
                                sortOrder = SortOrderEnum.asc.name;
                              }),
                              _searchFoods(),
                              Navigator.pop(context)
                            }),
                    ListTile(
                        trailing: Icon(Icons.keyboard_arrow_right),
                        dense: true,
                        title: Text('Z-A (Score)'),
                        selected: sortBy == SortByEnum.score.name &&
                            sortOrder == SortOrderEnum.desc.name,
                        onTap: () => {
                              setState(() {
                                sortBy = SortByEnum.score.name;
                                sortOrder = SortOrderEnum.desc.name;
                              }),
                              _searchFoods(),
                              Navigator.pop(context)
                            }),
                  ],
                ),
              );
            },
          );
        });
  }

  void _filteringModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom),
                child: Wrap(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Filter',
                        style: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 16.0),
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 16,
                            children: [
                              FilterChip(
                                label: Text("Branded"),
                                padding: EdgeInsets.all(0.0),
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                backgroundColor: Theme.of(context).accentColor,
                                selectedColor: Theme.of(context).accentColor,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                selected: isBrandedSelected,
                                onSelected: (bool selected) {
                                  setState(() {
                                    isBrandedSelected = selected;
                                  });
                                },
                              ),
                              FilterChip(
                                label: Text("Foundation"),
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                backgroundColor: Theme.of(context).accentColor,
                                selectedColor: Theme.of(context).accentColor,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                selected: isFoundationSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    isFoundationSelected = selected;
                                  });
                                },
                              ),
                              FilterChip(
                                label: Text("SR Legacy"),
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                backgroundColor: Theme.of(context).accentColor,
                                selectedColor: Theme.of(context).accentColor,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                selected: isSRLegacySelected,
                                onSelected: (selected) {
                                  setState(() {
                                    isSRLegacySelected = selected;
                                  });
                                },
                              ),
                              FilterChip(
                                label: Text("Survey (FNDDS)"),
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                backgroundColor: Theme.of(context).accentColor,
                                selectedColor: Theme.of(context).accentColor,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                selected: isSurveySelected,
                                onSelected: (selected) {
                                  setState(() {
                                    isSurveySelected = selected;
                                  });
                                },
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: TextField(
                              onEditingComplete: () =>
                                  {FocusScope.of(context).unfocus()},
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(4.0),
                                    ),
                                  ),
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () => {
                                      brandNameController.clear(),
                                      hasSearchableQuery = false
                                    },
                                    icon: Icon(Icons.clear,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  hintText: "Type a brand name(Optional)",
                                  fillColor: Theme.of(context).accentColor),
                              controller: brandNameController,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(16.0),
                            alignment: Alignment.center,
                            child: RaisedButton(
                              onPressed: () => {
                                _searchFoods(),
                                Navigator.pop(context),
                                FocusScope.of(context).previousFocus()
                              },
                              textColor: Theme.of(context).accentColor,
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Search",
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void _helpModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context,
                StateSetter setState /*You can rename this!*/) {
              return Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Wrap(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Help',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 16.0),
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Branded Foods',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' formerly hosted on the USDA Food Composition Databases website, are data from a public-private partnership that provides values for nutrients in branded and private label foods that appear on the product label. Information in Branded Foods is received from food industry data providers.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal))
                                ]),
                          ),
                          Padding(padding: EdgeInsets.only(top: 16)),
                          RichText(
                            text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Foundation Foods',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' includes values for nutrients and other food components on a diverse range of foods and ingredients as well as extensive underlying metadata. These metadata include the number of samples, sampling location, date of collection, analytical approaches used, and if appropriate, agricultural information such as genotype and production practices.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal))
                                ]),
                          ),
                          Padding(padding: EdgeInsets.only(top: 16)),
                          RichText(
                            text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'SR Legacy',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' provides nutrient and food component values that are derived from analyses, calculations, and the published literature. SR Legacy, released in April 2018, is the final release of this data type and will not be updated.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal))
                                ]),
                          ),
                          Padding(padding: EdgeInsets.only(top: 16)),
                          RichText(
                            text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'Survey (FNDDS - Food and Nutrient Database for Dietary Studies)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' contains data on the nutrient and food component values and weights for foods and beverages reported in the What We Eat in America dietary survey component of the National Health and Nutrition Examination Survey.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal))
                                ]),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            if (hasSearchableQuery)
              IconButton(
                icon: Stack(children: <Widget>[
                  Icon(
                    Icons.sort,
                    color: Colors.white,
                  ),
                  if (sortBy != SortByEnum.score.name ||
                      sortOrder != SortOrderEnum.asc.name)
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Icon(Icons.brightness_1,
                          size: 8.0, color: Colors.redAccent),
                    )
                ]),
                onPressed: () {
                  _sortingModalBottomSheet(context);
                },
              ),
            if (hasSearchableQuery)
              IconButton(
                icon: Stack(children: <Widget>[
                  Icon(
                    Icons.filter_list_alt,
                    color: Colors.white,
                  ),
                  if (isBrandedSelected ||
                      isFoundationSelected ||
                      isSRLegacySelected ||
                      isSurveySelected ||
                      brandNameController.text.isNotEmpty)
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Icon(Icons.brightness_1,
                          size: 8.0, color: Colors.redAccent),
                    )
                ]),
                onPressed: () {
                  _filteringModalBottomSheet(context);
                },
              ),
            IconButton(
              icon: Icon(
                Icons.help_center,
                color: Colors.white,
              ),
              onPressed: () {
                _helpModalBottomSheet(context);
              },
            )
          ],
          title: Text('Nutrition Facts',
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold))),
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              onEditingComplete: () => {
                hasSearchableQuery = searchController.text.isNotEmpty &&
                    searchController.text.length > 3,
                _searchFoods(),
                FocusScope.of(context).unfocus()
              },
              style: TextStyle(color: Theme.of(context).primaryColor),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(4.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(4.0),
                    ),
                  ),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        {hasSearchableQuery = false, searchController.clear()},
                    icon: Icon(Icons.clear,
                        color: Theme.of(context).primaryColor),
                  ),
                  hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                  hintText: "Search a food",
                  fillColor: Theme.of(context).accentColor),
              controller: searchController,
            ),
            if (hasSearchableQuery)
              StreamBuilder(
                stream: foodsBloc.searchFoods,
                builder: (context, AsyncSnapshot<SearchItem> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.currentPage == 1 &&
                        snapshot.data.foods.isEmpty) {
                      return emptyWidget(context);
                    } else {
                      return buildList(snapshot);
                    }
                  } else if (snapshot.hasError) {
                    return errorWidget(snapshot.error);
                  }

                  // By default, show a loading spinner.
                  return Container(
                      margin: EdgeInsets.only(top: 150.0),
                      child: loadingWidget(context));
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<SearchItem> snapshot) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 16.0),
          child: SizedBox(
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.foods.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () => openDetailPage(snapshot.data, index),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(4.0),
                      )),
                  margin: EdgeInsets.only(bottom: 8.0),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.data.foods[index].lowercaseDescription
                              .ignoreNull,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 16.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data.foods[index].brandOwner.ignoreNull,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.0),
                            ),
                            Text(
                              'Score: ' +
                                  snapshot.data.foods[index].score.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  openDetailPage(SearchItem data, int index) {
    final page = FoodDetailBlocProvider(
      child: FoodDetail(id: data.foods[index].fdcId),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return page;
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:searchbase/searchbase.dart';
import 'package:flutter_searchbox/flutter_searchbox.dart';
import 'results.dart';
import 'author_filter.dart';
import 'publication_year_filter.dart';
import 'ratings_filter.dart';
import 'drawer_buttons.dart';
import 'custom_theme.dart';

void main() {
  runApp(FlutterSearchBoxApp());
}

class FlutterSearchBoxApp extends StatelessWidget {
  final SearchBase searchbase;
  final index = 'good-books-ds';
  final credentials = 'a03a1cb71321:75b6603d-9456-4a5a-af6b-a487b309eb61';
  final url = 'https://arc-cluster-appbase-demo-6pjy6z.searchbase.io';

  FlutterSearchBoxApp({Key key, this.searchbase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The StoreProvider should wrap your MaterialApp or WidgetsApp. This will
    // ensure all routes have access to the store.
    return SearchBaseProvider(
      // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
      // Widgets will find and use this value as the `Store`.
      searchbase: SearchBase(index, url, credentials,
          appbaseConfig: AppbaseSettings(recordAnalytics: true)),
      child: MaterialApp(
        theme: CustomTheme().theme,
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var panelState = {};
  var searchWidgetState = {};
  var activeWidgets;

  @override
  void initState() {
    super.initState();
    panelState = {
      'author-filter': false,
      'author-data': [],
      'ratings-filter': false,
      'ratings-data': {},
      'publication-year-filter': false,
      'publication-year-data': {},
    };
  }

  void setPanelState(id, value) {
    switch (id) {
      case 'author-filter':
        {
          if (value) {
            setState(() {
              panelState['ratings-filter'] = false;
              panelState['publication-year-filter'] = false;
            });
          }
          setState(() {
            panelState['author-filter'] = value;
          });
          break;
        }
      case 'ratings-filter':
        {
          if (value) {
            setState(() {
              panelState['author-filter'] = false;
              panelState['publication-year-filter'] = false;
            });
          }
          setState(() {
            panelState['ratings-filter'] = value;
          });
          break;
        }
      case 'publication-year-filter':
        {
          if (value) {
            setState(() {
              panelState['author-filter'] = false;
              panelState['ratings-filter'] = false;
            });
          }
          setState(() {
            panelState['publication-year-filter'] = value;
          });
          break;
        }
      case 'author-data':
        {
          setState(() {
            panelState['author-data'] = value;
          });
          break;
        }
      case 'ratings-data':
        {
          setState(() {
            panelState['ratings-data'] = value;
          });
          break;
        }
      case 'publication-year-data':
        {
          setState(() {
            panelState['publication-year-data'] = value;
          });
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SearchBox Demo',
      theme: CustomTheme().theme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // key: _scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // Invoke the Search Delegate to display search UI with autosuggestions
                  showSearch(
                      context: context,
                      // SearchBox widget from flutter searchbox
                      delegate: SearchBox(
                        // A unique identifier that can be used by other widgetss to reactively update data
                        id: 'search-widget',
                        enableRecentSearches: true,
                        enablePopularSuggestions: true,
                        showAutoFill: true,
                        maxPopularSuggestions: 3,
                        size: 10,
                        dataField: [
                          {'field': 'original_title', 'weight': 1},
                          {'field': 'original_title.search', 'weight': 3}
                        ],
                      ));
                }),
                         id: 'ratings-filter',
                        type: QueryType.range,
                        dataField: "average_rating",
                        value: Map<String, String>(),
                        builder: (context, searchWidget) {
                          return RatingsFilter(
                              searchWidget,
                              setPanelState,
                              panelState['ratings-filter'],
                              panelState['ratings-data']);
                        },
                        triggerQueryOnInit: false,
                        destroyOnDispose: false,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: DrawerButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

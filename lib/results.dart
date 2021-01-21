import 'package:flutter/material.dart';
import 'package:flutter_searchbox/flutter_searchbox.dart';
import 'package:searchbase/searchbase.dart';
import 'star_display.dart';
import 'result_card.dart';
import 'selected_filters.dart';

class ResultsWidget extends StatelessWidget {
  final SearchWidget searchWidget;

  ResultsWidget(this.searchWidget);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectedFilters(),
        Card(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 20,
              child: Text(
                  '${searchWidget.results.numberOfResults} results found in ${searchWidget.results.time.toString()} ms'),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                var offset =
                    (searchWidget.from != null ? searchWidget.from : 0) +
                        searchWidget.size;
                if (index == offset - 1) {
                  if (searchWidget.results.numberOfResults > offset) {
                    // Load next set of results
                    searchWidget.setFrom(offset,
                        options: Options(triggerDefaultQuery: true));
                  }
                }
              });

              return Container(
                  child: (index < searchWidget.results.data.length)
                      ? Container(
                          margin: const EdgeInsets.all(0.5),
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          decoration: new BoxDecoration(
                              border: Border.all(
                                  color:
                                      Theme.of(context).unselectedWidgetColor)),
                          height: 200,
                          child: GestureDetector(
                            onTap: () {
                              String objectId;
                              if (searchWidget.results.data[index] != null &&
                                  searchWidget.results.data[index]['_id']
                                      is String) {
                                objectId =
                                    searchWidget.results.data[index]['_id'];
                              }
                              if (objectId != null &&
                                  searchWidget.results.data[index]
                                          ['_click_id'] !=
                                      null) {
                                // Record click analytics
                                searchWidget.recordClick({
                                  objectId: searchWidget.results.data[index]
                                      ['_click_id']
                                }, isSuggestionClick: true);
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultCard(
                                      searchWidget.results.data[index]),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Card(
                                        semanticContainer: true,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Image.network(
                                          searchWidget.results.data[index]
                                              ["image_medium"],
                                          fit: BoxFit.fill,
                                        ),
                                        elevation: 5,
                                        margin: EdgeInsets.all(10),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 110,
                                            width: 280,
                                            child: ListTile(
                                              title: Tooltip(
                                                padding: EdgeInsets.all(5),
                                                height: 35,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .shadowColor,
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                message:
                                                    'By: ${searchWidget.results.data[index]["original_title"]}',
                                                child: Text(
                                                  searchWidget
                                                              .results
                                                              .data[index][
                                                                  "original_title"]
                                                              .length <
                                                          40
                                                      ? searchWidget.results
                                                              .data[index]
                                                          ["original_title"]
                                                      : '${searchWidget.results.data[index]["original_title"].substring(0, 39)}...',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                              ),
                                              subtitle: Tooltip(
                                                padding: EdgeInsets.all(5),
                                                height: 35,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .shadowColor,
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                message:
                                                    'By: ${searchWidget.results.data[index]["authors"]}',
                                                child: Text(
                                                  searchWidget
                                                              .results
                                                              .data[index]
                                                                  ["authors"]
                                                              .length >
                                                          50
                                                      ? 'By: ${searchWidget.results.data[index]["authors"].substring(0, 49)}...'
                                                      : 'By: ${searchWidget.results.data[index]["authors"]}',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ),
                                              isThreeLine: true,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        25, 0, 0, 0),
                                                child: IconTheme(
                                                  data: Theme.of(context)
                                                      .iconTheme,
                                                  child: StarDisplay(
                                                      value: searchWidget
                                                              .results
                                                              .data[index][
                                                          "average_rating_rounded"]),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 0, 0),
                                                child: Text(
                                                  '(${searchWidget.results.data[index]["average_rating"]} avg)',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        27, 10, 0, 0),
                                                child: Text(
                                                  'Pub: ${searchWidget.results.data[index]["original_publication_year"]}',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : (searchWidget.requestPending
                          ? Center(child: CircularProgressIndicator())
                          : ListTile(
                              title: Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: searchWidget.results.data.length > 0
                                        ? "No more results"
                                        : 'No results found',
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                              ),
                            )));
            },
            itemCount: searchWidget.results.data.length + 1,
          ),
        ),
      ],
    );
  }
}

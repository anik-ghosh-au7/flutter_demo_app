import 'package:flutter/material.dart';
import 'package:flutter_searchbox/flutter_searchbox.dart';

import 'filter_chip.dart';

class SelectedFilters extends StatefulWidget {
  @override
  _SelectedFiltersState createState() => _SelectedFiltersState();
}

class _SelectedFiltersState extends State<SelectedFilters> {
  List selectedFilters;
  List toBeRemovedFilters;
  Map activeWidgets;

  @override
  void initState() {
    selectedFilters = [];
    toBeRemovedFilters = [];
    super.initState();
  }

  // @override
  // void didUpdateWidget(SelectedFilters oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (identical(oldWidget.activeWidgets, widget.activeWidgets)) {
  //     print('SelectedFilters changed');
  //   }
  // }

  void setSelectedFilters() {
    selectedFilters = [];
    activeWidgets = SearchBaseProvider.of(context).getActiveWidgets();
    if (activeWidgets['author-filter'] != null) {
      activeWidgets['author-filter'].componentQuery['value'].forEach((element) {
        setState(() {
          selectedFilters.add({
            'key': 'author-filter',
            'value': element,
            'data': element,
          });
        });
      });
    }
    if (activeWidgets['publication-year-filter'] != null &&
        activeWidgets['publication-year-filter'].componentQuery['value']
                ['start'] !=
            null) {
      setState(() {
        selectedFilters.add({
          'key': 'publication-year-filter',
          'value':
              activeWidgets['publication-year-filter'].componentQuery['value'],
          'data':
              '${activeWidgets['publication-year-filter'].componentQuery['value']['start']} - ${activeWidgets['publication-year-filter'].componentQuery['value']['end']}',
        });
      });
    }
    if (activeWidgets['ratings-filter'] != null &&
        activeWidgets['ratings-filter'].componentQuery['value']['start'] !=
            null) {
      setState(() {
        selectedFilters.add({
          'key': 'ratings-filter',
          'value': activeWidgets['ratings-filter'].componentQuery['value'],
          'data':
              '${activeWidgets['ratings-filter'].componentQuery['value']['start']} - ${activeWidgets['ratings-filter'].componentQuery['value']['end']}',
        });
      });
    }
  }

  void setToBeRemovedFilters(String key, value) {
    switch (key) {
      case 'author-filter':
        {
          var itemIndex = toBeRemovedFilters.indexWhere((filter) =>
              (filter['key'] == 'author-filter' && filter['value'] == value));
          if (itemIndex == -1) {
            setState(() {
              toBeRemovedFilters.add({
                'key': key,
                'value': value,
              });
            });
          } else {
            setState(() {
              toBeRemovedFilters.removeAt(itemIndex);
            });
          }
          break;
        }
      case 'ratings-filter':
        {
          var itemIndex = toBeRemovedFilters.indexWhere((filter) =>
              (filter['key'] == 'ratings-filter' &&
                  filter['value']['start'] == value['start']));
          if (itemIndex == -1) {
            setState(() {
              toBeRemovedFilters.add({
                'key': key,
                'value': {
                  'start': value['start'],
                  'end': value['end'],
                },
              });
            });
          } else {
            setState(() {
              toBeRemovedFilters.removeAt(itemIndex);
            });
          }
          break;
        }
      case 'publication-year-filter':
        {
          var itemIndex = toBeRemovedFilters.indexWhere((filter) =>
              (filter['key'] == 'publication-year-filter' &&
                  filter['value']['start'] == value['start'] &&
                  filter['value']['end'] == value['end']));
          if (itemIndex == -1) {
            setState(() {
              toBeRemovedFilters.add({
                'key': key,
                'value': {
                  'start': value['start'],
                  'end': value['end'],
                },
              });
            });
          } else {
            setState(() {
              toBeRemovedFilters.removeAt(itemIndex);
            });
          }
          break;
        }
    }
  }

  void removeFilters() {
    toBeRemovedFilters.forEach((filter) {
      if (filter['key'] == 'author-filter') {
        final List<String> values = activeWidgets['author-filter'].value == null
            ? []
            : activeWidgets['author-filter'].value;
        values.remove(filter['value']);
        activeWidgets['author-filter'].setValue(values);
        activeWidgets['author-filter'].triggerCustomQuery();
      } else if (filter['key'] == 'ratings-filter') {
        activeWidgets['ratings-filter'].setValue({});
        activeWidgets['ratings-filter'].triggerCustomQuery();
      } else if (filter['key'] == 'publication-year-filter') {
        activeWidgets['publication-year-filter'].setValue({});
        activeWidgets['publication-year-filter'].triggerCustomQuery();
      }
    });
    setState(() {
      toBeRemovedFilters = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    this.setSelectedFilters();
    return Visibility(
      visible: selectedFilters.length > 0,
      child: Container(
        height: 90,
        child: Column(
          children: [
            SizedBox(
              height: 90,
              width: double.infinity,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Wrap(
                        spacing: 5.0,
                        runSpacing: 1.0,
                        children: selectedFilters
                            .map(
                              (element) => FilterChipWidget(
                                chipName: element['data'],
                                chipType: element['key'],
                                chipValue: element['value'],
                                removeFiltersCb: setToBeRemovedFilters,
                                selected: (() {
                                  var flag = false;
                                  toBeRemovedFilters.forEach((filter) {
                                    if (filter['key'] == element['key']) {
                                      if (filter['key'] == 'author-filter' &&
                                          filter['value'] == element['value']) {
                                        flag = true;
                                      }
                                      if (filter['key'] == 'ratings-filter' ||
                                          filter['key'] ==
                                              'publication-year-filter') {
                                        if (filter['value']['start'] ==
                                                element['value']['start'] &&
                                            filter['value']['end'] ==
                                                element['value']['end']) {
                                          flag = true;
                                        }
                                      }
                                    }
                                  });
                                  return flag;
                                })(),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: toBeRemovedFilters.length > 0,
                    child: Positioned(
                      right: 0,
                      bottom: 0,
                      child: RawMaterialButton(
                        onPressed: () {
                          removeFilters();
                        },
                        elevation: 5.0,
                        fillColor: Theme.of(context).accentColor,
                        child: IconTheme(
                          data: Theme.of(context).accentIconTheme,
                          child: Icon(
                            Icons.delete_forever_rounded,
                          ),
                        ),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                        splashColor: Theme.of(context).splashColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

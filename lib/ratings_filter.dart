import 'dart:math';

import 'star_display.dart';
import 'package:flutter/material.dart';
import 'package:searchbase/searchbase.dart';

typedef void SetStateCb(String id, data);

class RatingsFilter extends StatefulWidget {
  final SearchWidget searchWidget;
  final SetStateCb callback;
  final bool panelState;
  final Map panelData;

  const RatingsFilter(
      this.searchWidget, this.callback, this.panelState, this.panelData);

  @override
  _RatingsFilterState createState() => _RatingsFilterState();
}

class _RatingsFilterState extends State<RatingsFilter> {
  Map<String, String> range = {'start': '0', 'end': '5'};
  int _key;

  void _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
  }

  @override
  void initState() {
    if (widget.searchWidget.value.isNotEmpty) {
      range['start'] = widget.searchWidget.value['start'];
      range['end'] = widget.searchWidget.value['end'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.panelState) {
      _collapse();
    }
    return widget.searchWidget.requestPending
        ? Center(child: CircularProgressIndicator())
        : ExpansionTile(
            key: new Key(_key.toString()),
            initiallyExpanded: widget.panelState,
            onExpansionChanged: ((newState) {
              widget.callback('ratings-filter', newState);
            }),
            title: RichText(
              text: TextSpan(
                  text: 'Select Ratings',
                  style: widget.panelState
                      ? Theme.of(context).textTheme.headline1
                      : Theme.of(context).textTheme.headline2),
            ),
            children: [
              Container(
                child: Column(
                  children: List.generate(4, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          range = {
                            'start': (index + 1).toString(),
                            'end': '5',
                          };
                          widget.searchWidget.setValue(range);
                        });
                        widget.callback('ratings-data', range);
                      },
                      child: Container(
                        decoration: new BoxDecoration(
                          color: (int.parse(range['start']) == (index + 1))
                              ? Theme.of(context).selectedRowColor
                              : Theme.of(context).primaryColorLight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: IconTheme(
                                  data: Theme.of(context).iconTheme,
                                  child: StarDisplay(value: index + 1),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: RichText(
                                    text: TextSpan(
                                      text: '(${index + 1} stars or above)',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
  }
}

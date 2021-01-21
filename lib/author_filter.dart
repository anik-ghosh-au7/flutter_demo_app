import 'dart:math';

import 'package:flutter/material.dart';
import 'package:searchbase/searchbase.dart';

class FilterHeader extends PreferredSize {
  final double height;
  final Widget child;

  FilterHeader({@required this.child, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      alignment: Alignment.centerLeft,
      child: child,
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

typedef void SetStateCb(String id, data);

class AuthorFilter extends StatefulWidget {
  final SearchWidget searchWidget;
  final SetStateCb callback;
  final bool panelState;
  final List panelData;

  AuthorFilter(
      this.searchWidget, this.callback, this.panelState, this.panelData);

  @override
  _AuthorFilterState createState() => _AuthorFilterState();
}

class _AuthorFilterState extends State<AuthorFilter> {
  int _key;

  void _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
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
              widget.callback('author-filter', newState);
            }),
            title: RichText(
              text: TextSpan(
                  text: 'Select Authors',
                  style: widget.panelState
                      ? Theme.of(context).textTheme.headline1
                      : Theme.of(context).textTheme.headline2),
            ),
            children: [
              SizedBox(
                height: 275,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children:
                        widget.searchWidget.aggregationData.data.map((bucket) {
                      return new CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Theme.of(context).secondaryHeaderColor,
                        dense: true,
                        title: RichText(
                          text: TextSpan(
                            text: "${bucket['_key']} (${bucket['_doc_count']})",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        value: (widget.searchWidget.value == null
                                ? []
                                : widget.searchWidget.value)
                            .contains(bucket['_key']),
                        onChanged: (bool value) {
                          final List<String> values =
                              widget.searchWidget.value == null
                                  ? []
                                  : widget.searchWidget.value;
                          if (values.contains(bucket['_key'])) {
                            values.remove(bucket['_key']);
                          } else {
                            values.add(bucket['_key']);
                          }
                          widget.searchWidget.setValue(values);
                          widget.callback('author-data', values);
                          // widget.searchWidget.triggerCustomQuery();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
  }
}

import 'package:flutter/material.dart';

typedef void RemoveFiltersCb(String key, dynamic value);

class FilterChipWidget extends StatefulWidget {
  final String chipName;
  final String chipType;
  final chipValue;
  final RemoveFiltersCb removeFiltersCb;
  final bool selected;

  FilterChipWidget({
    Key key,
    @required this.chipName,
    @required this.chipType,
    @required this.chipValue,
    this.removeFiltersCb,
    this.selected,
  }) : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;

  Icon getIcon(String chipType) {
    switch (chipType) {
      case 'author-filter':
        {
          return Icon(
            Icons.account_circle_outlined,
            color: Theme.of(context).secondaryHeaderColor,
          );
        }
      case 'ratings-filter':
        {
          return Icon(
            Icons.star_border_outlined,
            color: Theme.of(context).secondaryHeaderColor,
          );
        }
      case 'publication-year-filter':
        {
          return Icon(
            Icons.date_range_outlined,
            color: Theme.of(context).secondaryHeaderColor,
          );
        }
    }
    return null;
  }

  @override
  void initState() {
    _isSelected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isSelected = widget.selected;
    return FilterChip(
      showCheckmark: false,
      avatar: _isSelected
          ? Icon(
              Icons.clear_outlined,
              color: Colors.black54,
            )
          : getIcon(widget.chipType),
      label: Text(widget.chipName),
      labelStyle: Theme.of(context).textTheme.headline6,
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Theme.of(context).unselectedWidgetColor,
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
        if (widget.chipType == 'author-filter') {
          widget.removeFiltersCb(widget.chipType, widget.chipValue);
        } else {
          var range = {
            'start': widget.chipValue['start'],
            'end': widget.chipValue['end'],
          };
          widget.removeFiltersCb(widget.chipType, range);
        }
      },
      selectedColor: Theme.of(context).indicatorColor,
    );
  }
}

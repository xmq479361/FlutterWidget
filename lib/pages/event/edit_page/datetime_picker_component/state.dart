import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';

import '../../../../ui/theme.dart';

class DatetimePickerState implements Cloneable<DatetimePickerState> {
  DatetimePickerState([this.startDateTime, this.endDateTime]);
  Color startTextColor, endTextColor;

  DateTime startDateTime;
  DateTime endDateTime;
  DateTime minDate, maxDate;
  bool isStartSelected;
  bool isEndSelected;

  @override
  DatetimePickerState clone() {
    return DatetimePickerState()
      ..startDateTime = startDateTime
      ..endDateTime = endDateTime
      ..minDate = minDate
      ..maxDate = maxDate
      ..setEndSelected(false)
      ..setStartSelected(false);
  }

  setEndSelected(isSelected) {
    this.isEndSelected = isSelected;
    endTextColor = isSelected ? YColors.colorPrimaryDark : this.endTextColor;
  }

  setStartSelected(isSelected) {
    this.isStartSelected = isSelected;
    startTextColor =
        isSelected ? YColors.colorPrimaryDark : this.startTextColor;
  }
}

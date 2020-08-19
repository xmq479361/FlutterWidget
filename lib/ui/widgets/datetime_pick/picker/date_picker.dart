import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'date_picker_theme.dart';
import 'date_picker_constants.dart';
import 'date_picker_time_formatter.dart';
import 'date_picker_title_widget.dart';
import 'dart:math';

import 'date_picker_widget.dart';
import 'date_picker_widget_datetime.dart';
import 'date_picker_widget_time.dart';

enum DateTimePickerMode {
  /// Display DatePicker
  date,

  /// Display TimePicker
  time,

  /// Display DateTimePicker
  datetime,
  datetime_support
}

///
/// author: Dylan Wu
/// since: 2018/06/21
class DatePicker {
  /// Display date picker in bottom sheet.
  ///
  /// context: [BuildContext]
  /// minDateTime: [DateTime] minimum date time
  /// maxDateTime: [DateTime] maximum date time
  /// initialDateTime: [DateTime] initial date time for selected
  /// dateFormat: [String] date format pattern
  /// pickerMode: [DateTimePickerMode] display mode: date(DatePicker)、time(TimePicker)、datetime(DateTimePicker)
  /// pickerTheme: [DateTimePickerTheme] the theme of date time picker
  /// onCancel: [DateVoidCallback] pressed title cancel widget event
  /// onClose: [DateVoidCallback] date picker closed event
  /// onChange: [DateValueCallback] selected date time changed event
  /// onConfirm: [DateValueCallback] pressed title confirm widget event
  static Future<DateTime> showDatePickerAsync(BuildContext context,
      {DateTime minDateTime,
      DateTime maxDateTime,
      DateTime initialDateTime,
      String dateFormat,
      DateTimePickerMode pickerMode: DateTimePickerMode.date,
      DateTimePickerTheme pickerTheme: DateTimePickerTheme.Default,
      bool isPopResult}) async {
    // handle the range of datetime
    if (minDateTime == null) {
      minDateTime = DateTime.parse(DATE_PICKER_MIN_DATETIME);
    }
    if (maxDateTime == null) {
      maxDateTime = DateTime.parse(DATE_PICKER_MAX_DATETIME);
    }

    // handle initial DateTime
    if (initialDateTime == null) {
      initialDateTime = DateTime.now();
    }

    // Set value of date format
    dateFormat = DateTimeFormatter.generateDateFormat(dateFormat, pickerMode);

    final DateTime result = await Navigator.push(
      context,
      new _DatePickerRoute(
        minDateTime: minDateTime,
        maxDateTime: maxDateTime,
        initialDateTime: initialDateTime,
        dateFormat: dateFormat,
        pickerMode: pickerMode,
        pickerTheme: pickerTheme,
        onCancel: () {
          Navigator.pop(context, null);
          print("DateTimeSelectState onCancel: ");
          return true;
        },
        onConfirm: (DateTime datetime, List<int> indexs) {
          Navigator.pop(context, datetime);
          print("DateTimeSelectState onConfirm: $datetime");
          return true;
        },
        theme: Theme.of(context, shadowThemeOnly: true),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ),
    );
    return result;
  }

  static void showDatePicker(
    BuildContext context, {
    DateTime minDateTime,
    DateTime maxDateTime,
    DateTime initialDateTime,
    String dateFormat,
    DateTimePickerMode pickerMode: DateTimePickerMode.date,
    DateTimePickerTheme pickerTheme: DateTimePickerTheme.Default,
    DateVoidCallback onCancel,
    DateVoidCallback onClose,
    DateValueCallback onChange,
    DateValueCallback onConfirm,
  }) {
    // handle the range of datetime
    if (minDateTime == null) {
      minDateTime = DateTime.parse(DATE_PICKER_MIN_DATETIME);
    }
    if (maxDateTime == null) {
      maxDateTime = DateTime.parse(DATE_PICKER_MAX_DATETIME);
    }

    // handle initial DateTime
    if (initialDateTime == null) {
      initialDateTime = DateTime.now();
    }

    // Set value of date format
    dateFormat = DateTimeFormatter.generateDateFormat(dateFormat, pickerMode);

    final result = Navigator.push(
      context,
      new _DatePickerRoute(
        minDateTime: minDateTime,
        maxDateTime: maxDateTime,
        initialDateTime: initialDateTime,
        dateFormat: dateFormat,
        pickerMode: pickerMode,
        pickerTheme: pickerTheme,
        onCancel: onCancel,
        onChange: onChange,
        onConfirm: onConfirm,
        theme: Theme.of(context, shadowThemeOnly: true),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ),
    ).whenComplete(onClose ?? () => {});
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.minDateTime,
    this.maxDateTime,
    this.initialDateTime,
    this.dateFormat,
    this.pickerMode,
    this.pickerTheme,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings);

  final DateTime minDateTime, maxDateTime, initialDateTime;
  final String dateFormat;
  final DateTimePickerMode pickerMode;
  final DateTimePickerTheme pickerTheme;
  final VoidCallback onCancel;
  final DateValueCallback onChange;
  final DateValueCallback onConfirm;

  final ThemeData theme;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    double height = pickerTheme.pickerHeight;
    if (pickerTheme.title != null || pickerTheme.showTitle) {
      height += pickerTheme.titleHeight;
    }

    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(route: this, pickerHeight: height),
    );

    if (theme != null) {
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _DatePickerComponent extends StatelessWidget {
  final _DatePickerRoute route;
  final double _pickerHeight;

  _DatePickerComponent({Key key, @required this.route, @required pickerHeight})
      : this._pickerHeight = pickerHeight;

  @override
  Widget build(BuildContext context) {
    Widget pickerWidget;
    switch (route.pickerMode) {
      case DateTimePickerMode.date:
        pickerWidget = DatePickerWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initialDateTime: route.initialDateTime,
          dateFormat: route.dateFormat,
          pickerTheme: route.pickerTheme,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
        );
        break;
      case DateTimePickerMode.time:
        pickerWidget = TimePickerWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initDateTime: route.initialDateTime,
          dateFormat: route.dateFormat,
          pickerTheme: route.pickerTheme,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
        );
        break;
      case DateTimePickerMode.datetime:
        pickerWidget = DateTimePickerWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initDateTime: route.initialDateTime,
          dateFormat: route.dateFormat,
          pickerTheme: route.pickerTheme,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
        );
        break;
      case DateTimePickerMode.datetime_support:
        pickerWidget = DateTimePickerExtendWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initDateTime: route.initialDateTime,
          dateFormat: route.dateFormat,
          pickerTheme: route.pickerTheme,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
        );
        break;
    }
    return new GestureDetector(
      child: new AnimatedBuilder(
        animation: route.animation,
        builder: (BuildContext context, Widget child) {
          return new ClipRect(
            child: new CustomSingleChildLayout(
              delegate: new _BottomPickerLayout(route.animation.value,
                  contentHeight: _pickerHeight),
              child: pickerWidget,
            ),
          );
        },
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {this.contentHeight});

  final double progress;
  final double contentHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return new BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: contentHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class DateTimePickerExtendWidget extends StatefulWidget {
  DateTimePickerExtendWidget(
      {Key key,
      this.minDateTime,
      this.maxDateTime,
      this.initDateTime,
      this.dateFormat: DATETIME_PICKER_TIME_FORMAT,
      this.pickerTheme: DateTimePickerTheme.Default,
      this.onCancel,
      this.onChange,
      this.onConfirm})
      : super(key: key) {
    DateTime minTime = minDateTime ?? DateTime.parse(DATE_PICKER_MIN_DATETIME);
    DateTime maxTime = maxDateTime ?? DateTime.parse(DATE_PICKER_MAX_DATETIME);
    assert(minTime.compareTo(maxTime) < 0);
  }

  final DateTime minDateTime, maxDateTime, initDateTime;
  final String dateFormat;
  final DateTimePickerTheme pickerTheme;
  final DateVoidCallback onCancel;
  final DateValueCallback onChange, onConfirm;

  @override
  State<StatefulWidget> createState() => _DateTimePickerExtendWidgetState(
      this.minDateTime, this.maxDateTime, this.initDateTime);
}

/// Solar months of 31 days.
const List<int> _solarMonthsOf31Days = const <int>[1, 3, 5, 7, 8, 10, 12];

class _DateTimePickerExtendWidgetState
    extends State<DateTimePickerExtendWidget> {
  DateTime _minTime, _maxTime;
  int _currYear, _currMonth, _currDay, _currHour, _currMinute, _currSecond;
  List<int> _yearRange,
      _monthRange,
      _dayRange,
      _hourRange,
      _minuteRange,
      _secondRange;
  FixedExtentScrollController _yearScrollCtrl,
      _monthScrollCtrl,
      _dayScrollCtrl,
      _hourScrollCtrl,
      _minuteScrollCtrl,
      _secondScrollCtrl;

  Map<String, FixedExtentScrollController> _scrollCtrlMap;
  Map<String, List<int>> _valueRangeMap;

  bool _isChangeTimeRange = false;

  _DateTimePickerExtendWidgetState(
      DateTime minTime, DateTime maxTime, DateTime initTime) {
    // check minTime value
    if (minTime == null) {
      minTime = DateTime.parse(DATE_PICKER_MIN_DATETIME);
    }
    // check maxTime value
    if (maxTime == null) {
      maxTime = DateTime.parse(DATE_PICKER_MAX_DATETIME);
    }
    // check initTime value
    if (initTime == null) {
      initTime = DateTime.now();
    }
    // limit initTime value
    if (initTime.compareTo(minTime) < 0) {
      initTime = minTime;
    }
    if (initTime.compareTo(maxTime) > 0) {
      initTime = maxTime;
    }

    this._minTime = minTime;
    this._maxTime = maxTime;
    this._currYear = initTime.year;
    this._currMonth = initTime.month;
    this._currDay = initTime.day;
    this._currHour = initTime.hour;
    this._currMinute = initTime.minute;
    this._currSecond = initTime.second;

    // limit the range of year
    this._yearRange = _calcYearRange();
    this._currYear = min(max(_minTime.year, _currYear), _maxTime.year);

    // limit the range of month
    this._monthRange = _calcMonthRange();
    this._currMonth = min(max(_monthRange.first, _currMonth), _monthRange.last);

    // limit the range of date
    this._dayRange = _calcDayRange();
    // int currDate = initTime.difference(_baselineDate).inDays;
    this._currDay = min(max(_dayRange.first, _currDay), _dayRange.last);

    // limit the range of hour
    this._hourRange = _calcHourRange();
    this._currHour = min(max(_hourRange.first, _currHour), _hourRange.last);

    // limit the range of minute
    this._minuteRange = _calcMinuteRange();
    this._currMinute =
        min(max(_minuteRange.first, _currMinute), _minuteRange.last);

    // limit the range of second
    this._secondRange = _calcSecondRange();
    this._currSecond =
        min(max(_secondRange.first, _currSecond), _secondRange.last);

    // create scroll controller
    _yearScrollCtrl =
        FixedExtentScrollController(initialItem: _currYear - _yearRange.first);
    _monthScrollCtrl = FixedExtentScrollController(
        initialItem: _currMonth - _monthRange.first);
    _dayScrollCtrl =
        FixedExtentScrollController(initialItem: _currDay - _dayRange.first);
    _hourScrollCtrl =
        FixedExtentScrollController(initialItem: _currHour - _hourRange.first);
    _minuteScrollCtrl = FixedExtentScrollController(
        initialItem: _currMinute - _minuteRange.first);
    _secondScrollCtrl = FixedExtentScrollController(
        initialItem: _currSecond - _secondRange.first);

    _scrollCtrlMap = {
      'y': _yearScrollCtrl,
      'M': _monthScrollCtrl,
      'd': _dayScrollCtrl,
      'H': _hourScrollCtrl,
      'm': _minuteScrollCtrl,
      's': _secondScrollCtrl
    };
    _valueRangeMap = {
      'y': _yearRange,
      'M': _monthRange,
      'd': _dayRange,
      'H': _hourRange,
      'm': _minuteRange,
      's': _secondRange
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
          color: Colors.transparent, child: _renderPickerView(context)),
    );
  }

  /// render time picker widgets
  Widget _renderPickerView(BuildContext context) {
    Widget pickerWidget = _renderDatePickerWidget();

    // display the title widget
    if (widget.pickerTheme.title != null || widget.pickerTheme.showTitle) {
      Widget titleWidget = DatePickerTitleWidget(
        pickerTheme: widget.pickerTheme,
        onCancel: () => _onPressedCancel(),
        onConfirm: () => _onPressedConfirm(),
      );
      return Column(children: <Widget>[titleWidget, pickerWidget]);
    }
    return pickerWidget;
  }

  /// pressed cancel widget
  void _onPressedCancel() {
    if (widget.onCancel != null) {
      if (widget.onCancel()) return;
    }
    Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    print("_onPressedConfirm: ${widget.onConfirm}");
    if (widget.onConfirm != null) {
      // DateTime day = _baselineDate.add(Duration(days: _currDay));
      DateTime dateTime = DateTime(
          _currYear, _currMonth, _currDay, _currHour, _currMinute, _currSecond);

      print("_onPressedConfirm onConfirm: $dateTime");
      if (widget.onConfirm(dateTime, _calcSelectIndexList())) return;
    }
    Navigator.pop(context);
  }

  bool _isChangeDateRange = false;

  /// change range of month and day
  void _changeDateRange() {
    if (_isChangeDateRange) {
      return;
    }
    _isChangeDateRange = true;

    List<int> monthRange = _calcMonthRange();
    bool monthRangeChanged = _monthRange.first != monthRange.first ||
        _monthRange.last != monthRange.last;
    if (monthRangeChanged) {
      // selected year changed
      _currMonth = max(min(_currMonth, monthRange.last), monthRange.first);
    }

    List<int> dayRange = _calcDayRange();
    bool dayRangeChanged =
        _dayRange.first != dayRange.first || _dayRange.last != dayRange.last;
    if (dayRangeChanged) {
      // day range changed, need limit the value of selected day
      _currDay = max(min(_currDay, dayRange.last), dayRange.first);
    }

    setState(() {
      _monthRange = monthRange;
      _dayRange = dayRange;

      _valueRangeMap['M'] = monthRange;
      _valueRangeMap['d'] = dayRange;
    });

    if (monthRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMonth = _currMonth;
      _monthScrollCtrl.jumpToItem(monthRange.last - monthRange.first);
      if (currMonth < monthRange.last) {
        _monthScrollCtrl.jumpToItem(currMonth - monthRange.first);
      }
    }

    if (dayRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currDay = _currDay;
      _dayScrollCtrl.jumpToItem(dayRange.last - dayRange.first);
      if (currDay < dayRange.last) {
        _dayScrollCtrl.jumpToItem(currDay - dayRange.first);
      }
    }

    _isChangeDateRange = false;
  }

  /// notify selected datetime changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      // DateTime day = _baselineDate.add(Duration(days: _currDay));
      // DateTime dateTime = DateTime(day.year, day.month, day.day, _currHour, _currMinute, _currSecond);
      DateTime dateTime = DateTime(
          _currYear, _currMonth, _currDay, _currHour, _currMinute, _currSecond);
      widget.onChange(dateTime, _calcSelectIndexList());
    }
  }

  /// find scroll controller by specified format
  FixedExtentScrollController _findScrollCtrl(String format) {
    FixedExtentScrollController scrollCtrl;
    _scrollCtrlMap.forEach((key, value) {
      if (format.contains(key)) {
        scrollCtrl = value;
      }
    });
    return scrollCtrl;
  }

  /// find item value range by specified format
  List<int> _findPickerItemRange(String format) {
    List<int> valueRange;
    _valueRangeMap.forEach((key, value) {
      if (format.contains(key)) {
        valueRange = value;
      }
    });
    return valueRange;
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    List<Widget> pickers = List<Widget>();
    List<String> formatArr = DateTimeFormatter.splitDateFormat(
        widget.dateFormat,
        mode: DateTimePickerMode.datetime_support);
    // int count = formatArr.length;
    // int dayFlex = count > 3 ? count - 1 : count;

    // render day picker column
    // String dayFormat = formatArr.removeAt(0);
    // Widget dayPickerColumn = _renderDatePickerColumnComponent(
    //   scrollCtrl: _dayScrollCtrl,
    //   valueRange: _dayRange,
    //   format: dayFormat,
    //   valueChanged: (value) {
    //     _changeDaySelection(value);
    //   },
    //   flex: dayFlex,
    //   itemBuilder: (BuildContext context, int index) =>
    //       _renderDayPickerItemComponent(_dayRange.first + index, dayFormat),
    // );
    // pickers.add(dayPickerColumn);

    // render time picker column
    formatArr.forEach((format) {
      List<int> valueRange = _findPickerItemRange(format);

      Widget pickerColumn = _renderDatePickerColumnComponent(
        scrollCtrl: _findScrollCtrl(format),
        valueRange: valueRange,
        format: format,
        flex: 1,
        valueChanged: (value) {
          if (format.contains('y')) {
            _changeYearSelection(value);
          } else if (format.contains('M')) {
            _changeMonthSelection(value);
          } else if (format.contains('d')) {
            _changeDaySelection(value);
          } else if (format.contains('H')) {
            _changeHourSelection(value);
          } else if (format.contains('m')) {
            _changeMinuteSelection(value);
          } else if (format.contains('s')) {
            _changeSecondSelection(value);
          }
        },
      );
      pickers.add(pickerColumn);
    });
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: pickers);
  }

  Widget _renderDatePickerColumnComponent({
    @required FixedExtentScrollController scrollCtrl,
    @required List<int> valueRange,
    @required String format,
    @required ValueChanged<int> valueChanged,
    int flex,
    IndexedWidgetBuilder itemBuilder,
  }) {
    Widget columnWidget = Container(
      padding: EdgeInsets.all(8.0),
      width: double.infinity,
      height: widget.pickerTheme.pickerHeight,
      decoration: BoxDecoration(color: widget.pickerTheme.backgroundColor),
      child: CupertinoPicker.builder(
        backgroundColor: widget.pickerTheme.backgroundColor,
        scrollController: scrollCtrl,
        itemExtent: widget.pickerTheme.itemHeight,
        onSelectedItemChanged: valueChanged,
        childCount: valueRange.last - valueRange.first + 1,
        itemBuilder: itemBuilder ??
            (context, index) => _renderDatePickerItemComponent(
                valueRange.first + index, format),
      ),
    );
    return Expanded(
      flex: flex,
      child: columnWidget,
    );
  }

  /// render day picker item
  Widget _renderDayPickerItemComponent(int value, String format) {
    // DateTime dateTime = _baselineDate.add(Duration(days: value));
    DateTime dateTime = DateTime(
        _currYear, _currMonth, _currDay, _currHour, _currMinute, _currSecond);
    return Container(
      height: widget.pickerTheme.itemHeight,
      alignment: Alignment.center,
      child: Text(
        DateTimeFormatter.formatDate(dateTime, format),
        style:
            widget.pickerTheme.itemTextStyle ?? DATETIME_PICKER_ITEM_TEXT_STYLE,
      ),
    );
  }

  /// render hour、minute、second picker item
  Widget _renderDatePickerItemComponent(int value, String format) {
    return Container(
      height: widget.pickerTheme.itemHeight,
      alignment: Alignment.center,
      child: Text(
        DateTimeFormatter.formatDateTime(value, format),
        style:
            widget.pickerTheme.itemTextStyle ?? DATETIME_PICKER_ITEM_TEXT_STYLE,
      ),
    );
  }

  /// change the selection of year picker
  void _changeYearSelection(int index) {
    int year = _yearRange.first + index;
    if (_currYear != year) {
      _currYear = year;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change the selection of month picker
  void _changeMonthSelection(int index) {
    int month = _monthRange.first + index;
    if (_currMonth != month) {
      _currMonth = month;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change the selection of day picker
  void _changeDaySelection(int days) {
    int value = _dayRange.first + days;
    if (_currDay != value) {
      _currDay = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of hour picker
  void _changeHourSelection(int index) {
    int value = _hourRange.first + index;
    if (_currHour != value) {
      _currHour = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of month picker
  void _changeMinuteSelection(int index) {
    int value = _minuteRange.first + index;
    if (_currMinute != value) {
      _currMinute = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of second picker
  void _changeSecondSelection(int index) {
    int value = _secondRange.first + index;
    if (_currSecond != value) {
      _currSecond = value;
      _onSelectedChange();
    }
  }

  /// change range of minute and second
  void _changeTimeRange() {
    if (_isChangeTimeRange) {
      return;
    }
    _isChangeTimeRange = true;

    List<int> hourRange = _calcHourRange();
    bool hourRangeChanged = _hourRange.first != hourRange.first ||
        _hourRange.last != hourRange.last;
    if (hourRangeChanged) {
      // selected day changed
      _currHour = max(min(_currHour, hourRange.last), hourRange.first);
    }

    List<int> minuteRange = _calcMinuteRange();
    bool minuteRangeChanged = _minuteRange.first != minuteRange.first ||
        _minuteRange.last != minuteRange.last;
    if (minuteRangeChanged) {
      // selected hour changed
      _currMinute = max(min(_currMinute, minuteRange.last), minuteRange.first);
    }

    List<int> secondRange = _calcSecondRange();
    bool secondRangeChanged = _secondRange.first != secondRange.first ||
        _secondRange.last != secondRange.last;
    if (secondRangeChanged) {
      // second range changed, need limit the value of selected second
      _currSecond = max(min(_currSecond, secondRange.last), secondRange.first);
    }

    setState(() {
      _hourRange = hourRange;
      _minuteRange = minuteRange;
      _secondRange = secondRange;

      _valueRangeMap['H'] = hourRange;
      _valueRangeMap['m'] = minuteRange;
      _valueRangeMap['s'] = secondRange;
    });

    if (hourRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currHour = _currHour;
      _hourScrollCtrl.jumpToItem(hourRange.last - hourRange.first);
      if (currHour < hourRange.last) {
        _hourScrollCtrl.jumpToItem(currHour - hourRange.first);
      }
    }

    if (minuteRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMinute = _currMinute;
      _minuteScrollCtrl.jumpToItem(minuteRange.last - minuteRange.first);
      if (currMinute < minuteRange.last) {
        _minuteScrollCtrl.jumpToItem(currMinute - minuteRange.first);
      }
    }

    if (secondRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currSecond = _currSecond;
      _secondScrollCtrl.jumpToItem(secondRange.last - secondRange.first);
      if (currSecond < secondRange.last) {
        _secondScrollCtrl.jumpToItem(currSecond - secondRange.first);
      }
    }

    _isChangeTimeRange = false;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    int yearIndex = _currYear - _minTime.year;
    int monthIndex = _currMonth - _monthRange.first;
    int dayIndex = _currDay - _dayRange.first;
    // return [yearIndex, monthIndex, dayIndex];
    int hourIndex = _currHour - _hourRange.first;
    int minuteIndex = _currMinute - _minuteRange.first;
    int secondIndex = _currSecond - _secondRange.first;
    return [
      yearIndex,
      monthIndex,
      dayIndex,
      hourIndex,
      minuteIndex,
      secondIndex
    ];
  }

  /// calculate the range of year
  List<int> _calcYearRange() {
    return [_minTime.year, _maxTime.year];
  }

  /// calculate the range of month
  List<int> _calcMonthRange() {
    int minMonth = 1, maxMonth = 12;
    int minYear = _minTime.year;
    int maxYear = _maxTime.year;
    if (minYear == _currYear) {
      // selected minimum year, limit month range
      minMonth = _minTime.month;
    }
    if (maxYear == _currYear) {
      // selected maximum year, limit month range
      maxMonth = _maxTime.month;
    }
    return [minMonth, maxMonth];
  }

  /// whether or not is leap year
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// calculate the count of day in current month
  int _calcDayCountOfMonth() {
    if (_currMonth == 2) {
      return isLeapYear(_currYear) ? 29 : 28;
    } else if (_solarMonthsOf31Days.contains(_currMonth)) {
      return 31;
    }
    return 30;
  }

  /// calculate the range of day
  List<int> _calcDayRange({currMonth}) {
    int minDay = 1, maxDay = _calcDayCountOfMonth();
    int minYear = _minTime.year;
    int maxYear = _maxTime.year;
    int minMonth = _minTime.month;
    int maxMonth = _maxTime.month;
    if (currMonth == null) {
      currMonth = _currMonth;
    }
    if (minYear == _currYear && minMonth == currMonth) {
      // selected minimum year and month, limit day range
      minDay = _minTime.day;
    }
    if (maxYear == _currYear && maxMonth == currMonth) {
      // selected maximum year and month, limit day range
      maxDay = _maxTime.day;
    }
    return [minDay, maxDay];
  }

  /// calculate the range of hour
  List<int> _calcHourRange() {
    int minHour = 0, maxHour = 23;
    // if (_currDay == _dayRange.first) {
    //   minHour = _minTime.hour;
    // }
    // if (_currDay == _dayRange.last) {
    //   maxHour = _maxTime.hour;
    // }
    return [minHour, maxHour];
  }

  /// calculate the range of minute
  List<int> _calcMinuteRange({currHour}) {
    int minMinute = 0, maxMinute = 59;
    // if (currHour == null) {
    //   currHour = _currHour;
    // }

    // if (_currDay == _dayRange.first && currHour == _minTime.hour) {
    //   // selected minimum day、hour, limit minute range
    //   minMinute = _minTime.minute;
    // }
    // if (_currDay == _dayRange.last && currHour == _maxTime.hour) {
    //   // selected maximum day、hour, limit minute range
    //   maxMinute = _maxTime.minute;
    // }
    return [minMinute, maxMinute];
  }

  /// calculate the range of second
  List<int> _calcSecondRange({currHour, currMinute}) {
    int minSecond = 0, maxSecond = 59;

    // if (currHour == null) {
    //   currHour = _currHour;
    // }
    // if (currMinute == null) {
    //   currMinute = _currMinute;
    // }

    // if (_currDay == _dayRange.first &&
    //     currHour == _minTime.hour &&
    //     currMinute == _minTime.minute) {
    //   // selected minimum hour and minute, limit second range
    //   minSecond = _minTime.second;
    // }
    // if (_currDay == _dayRange.last &&
    //     currHour == _maxTime.hour &&
    //     currMinute == _maxTime.minute) {
    //   // selected maximum hour and minute, limit second range
    //   maxSecond = _maxTime.second;
    // }
    return [minSecond, maxSecond];
  }
}

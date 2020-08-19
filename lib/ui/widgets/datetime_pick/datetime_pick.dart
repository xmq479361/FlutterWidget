import "package:flutter/material.dart";
import 'package:quicklibs/quicklibs.dart';

import '../../theme.dart';
import 'picker/date_picker.dart';
// import '../../../ui/theme/color.dart';
// import '../../../utils/views.dart';
// import '../../../utils/datetime.dart';

typedef OnChanged(DateTime dateTime);

formatDateTime(DateTime dateTime) {
  return Time.format(dateTime, "yyyy-MM-dd HH:mm");
}

class DateTimeSelectWidget extends StatefulWidget {
  Color textColor;
  String titleText;
  OnChanged onChanged;
  DateTime dateTime, minDate, maxDate;
  DateTimeSelectWidget(this.titleText, this.dateTime,
      {this.minDate, this.maxDate, this.onChanged}) {
    textColor = YColors.primaryText;
  }

  OnChangedValue(DateTime dateTime) {
    this.dateTime = dateTime;
    if (onChanged != null) onChanged(dateTime);
  }

  @override
  DateTimeSelectState createState() {
    return DateTimeSelectState(formatDateTime(this.dateTime), this.textColor);
  }
}

typedef buildTextFuction(text, textColor);

Widget buildText(String text, Color textColor, {double fontSize = 14.0}) {
  return Text(text,
      style: TextStyle(color: textColor, fontSize: fontSize, height: 1.4));
}

Widget buildTextDefault(String text, Color textColor,
    {double fontSize = 14.0, TextAlign textAlign = TextAlign.left}) {
  return Text(text,
      textAlign: textAlign,
      style: TextStyle(color: textColor, fontSize: fontSize, height: 1.4));
}

// class DateTimeWin extends BottomDialog {}

Widget buildTimeArea(String title, String value, Color textColor,
    {Function buildText = buildTextDefault}) {
  return Expanded(
      child: Container(
          color: YColors.thirdColor,
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildText(title, textColor),
                buildText(value, textColor),
              ])));
}

class DateTimeSelectState extends State<DateTimeSelectWidget> {
  bool isSelected = false;
  Color textColor;
  String dateTimeText;
  DateTimeSelectState(this.dateTimeText, this.textColor);

  onConfirm(DateTime dateTime, List<int> indexs) {
    if (widget.OnChangedValue != null) widget.OnChangedValue(dateTime);
    setState(() {
      dateTimeText = formatDateTime(dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color tColor = isSelected ? YColors.colorPrimaryDark : this.textColor;
    return Expanded(
        child: GestureDetector(
            onTapUp: onTapUp,
            child: Container(
                color: YColors.thirdColor,
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      buildTextDefault(widget.titleText, tColor),
                      buildTextDefault(dateTimeText, tColor),
                    ]))));
  }

  void onTapUp(TapUpDetails details) {
    setState(() {
      isSelected = !isSelected;
    });
    const String DATETIME_PICKER_DATE_FORMAT = 'yyyy-MM-dd HH:mm';
    DateTime currDate = widget.dateTime;
    print("DateTimeSelectState onTapUp: ${dateTimeText}, ${currDate}");
    DatePicker.showDatePicker(context,
        minDateTime: widget.minDate,
        maxDateTime: widget.maxDate,
        initialDateTime: currDate,
        pickerMode: DateTimePickerMode.datetime_support,
        dateFormat: DATETIME_PICKER_DATE_FORMAT,
        onClose: () => {
              setState(() {
                isSelected = false;
              })
            },
        onConfirm: onConfirm);
  }
}

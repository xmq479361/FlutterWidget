import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget/utils/TimeFormatter.dart';
import 'action.dart';
import 'state.dart';
import '../../../../ui/theme.dart';

typedef OnChanged(DateTime dateTime);

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
                buildText(value, textColor)
              ])));
}

Widget buildView(
    DatetimePickerState state, Dispatch dispatch, ViewService viewService) {
  return Row(children: <Widget>[
    Expanded(
        child: GestureDetector(
            onTapUp: (details) =>
                dispatch(DatetimePickerActionCreator.onTapUpStartAction()),
            child: Container(
                color: YColors.thirdColor,
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      buildTextDefault("开始", state.startTextColor),
                      buildTextDefault(
                          formatDate(state.startDateTime), state.startTextColor)
                    ])))),
    VerticalDivider(width: 80.0, color: Colors.grey),
    Expanded(
        child: GestureDetector(
            onTapUp: (details) =>
                dispatch(DatetimePickerActionCreator.onTapUpEndAction()),
            child: Container(
                color: YColors.thirdColor,
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      buildTextDefault("结束", state.endTextColor),
                      buildTextDefault(
                          formatDate(state.endDateTime), state.endTextColor)
                    ]))))
  ]);
}

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../ui/widgets/datetime_pick/picker/date_picker.dart';
import 'action.dart';
import 'state.dart';

Effect<DatetimePickerState> buildEffect() {
  return combineEffects(<Object, Effect<DatetimePickerState>>{
    DatetimePickerAction.onTapUpStart: _onTapUpStart,
    DatetimePickerAction.onTapUpEnd: _onTapUpEnd,
  });
}

const String DATETIME_PICKER_DATE_FORMAT = 'yyyy-MM-dd HH:mm';
void _onTapUpStart(Action action, Context<DatetimePickerState> ctx) async {
  ctx.dispatch(DatetimePickerActionCreator.onUpdateStartAction());
  print("DateTimeSelectState _onTapUpStart: ${action.payload}, ${ctx.state}");
  var result = await DatePicker.showDatePickerAsync(ctx.context,
      minDateTime: ctx.state.minDate,
      maxDateTime: ctx.state.maxDate,
      initialDateTime: ctx.state.startDateTime,
      pickerMode: DateTimePickerMode.datetime_support,
      dateFormat: DATETIME_PICKER_DATE_FORMAT);
  print("DateTimeSelectState updateStartAction $result");
  if (result != null && !result.isBefore(ctx.state.endDateTime)) {
    Fluttertoast.showToast(
        msg: "开始时间必须小于结束时间",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black87,
        textColor: Colors.white);
    result = null;
  }
  ctx.dispatch(DatetimePickerActionCreator.updateStartAction(result));
}

void _onTapUpEnd(Action action, Context<DatetimePickerState> ctx) async {
  ctx.dispatch(DatetimePickerActionCreator.onUpdateEndAction());
  print("DateTimeSelectState _onTapUpEnd: ${action.payload}, ${ctx.state}");
  var result = await DatePicker.showDatePickerAsync(ctx.context,
      minDateTime: ctx.state.minDate,
      maxDateTime: ctx.state.maxDate,
      initialDateTime: ctx.state.endDateTime,
      pickerMode: DateTimePickerMode.datetime_support,
      dateFormat: DATETIME_PICKER_DATE_FORMAT);

  print("DateTimeSelectState _onTapUpEnd: $result");
  if (result != null && !ctx.state.startDateTime.isBefore(result)) {
    Fluttertoast.showToast(
        msg: "结束时间必须大于开始时间",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black87,
        textColor: Colors.white);
    result = null;
  }
  ctx.dispatch(DatetimePickerActionCreator.updateEndAction(result));
}

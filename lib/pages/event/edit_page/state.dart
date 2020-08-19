import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action, Page;

import '../../../store/global/state.dart';
import '../event_component/state.dart';
import 'datetime_picker_component/state.dart';

class EditState implements GlobalBaseState, Cloneable<EditState> {
  String id;
  bool isEdit;
  TextEditingController titleEtCtrl;
  TextEditingController contentEdCtrl;
  DatetimePickerState componentState;
  @override
  EditState clone() {
    return EditState()
      ..id = id
      ..isEdit = isEdit
      ..titleEtCtrl = titleEtCtrl
      ..contentEdCtrl = contentEdCtrl
      ..componentState = componentState;
  }

  @override
  String toString() {
    return "EditState[title: ${titleEtCtrl.text}, content: ${contentEdCtrl.text}, start: ${componentState.startDateTime}, end: ${componentState.endDateTime}]";
  }
}

EditState initState(EventState event) {
  DateTime now = DateTime.now();
  DateTime start = event.startTime ??
      now.add(Duration(seconds: 60 - now.second, minutes: 59 - now.minute));
  DateTime end = event.endTime ?? start.add(Duration(hours: 1));
  print("initState:: $now -- $start : $end, ${event.startTime} $event");
  EditState state = EditState()
    ..id = event.id
    ..isEdit = event.title != null
    ..titleEtCtrl = TextEditingController(text: event.title ?? "")
    ..contentEdCtrl = TextEditingController(text: event.desc ?? "");
  if (state.componentState == null) {
    state.componentState = DatetimePickerState();
  }
  state.componentState
    ..startDateTime = start
    ..endDateTime = end;
  return state;
}

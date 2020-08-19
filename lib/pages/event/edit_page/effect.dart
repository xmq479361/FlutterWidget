import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_widget/pages/event/event_component/state.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'action.dart';
import 'state.dart';

Effect<EditState> buildEffect() {
  return combineEffects(<Object, Effect<EditState>>{
    EditAction.onCommit: _onCommitAction,
  });
}

void _onCommitAction(Action action, Context<EditState> ctx) {
  print("_onCommitAction: ${ctx.state}");
  EditState state = ctx.state;
  if (state.titleEtCtrl.text.isEmpty) {
    Fluttertoast.showToast(
        msg: "主题不能为空!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black87,
        textColor: Colors.white);
    return;
  }
  Navigator.of(ctx.context).pop(EventState(
      id: state.id,
      title: state.titleEtCtrl.text,
      desc: state.contentEdCtrl.text,
      startTime: state.componentState.startDateTime,
      endTime: state.componentState.endDateTime));
}

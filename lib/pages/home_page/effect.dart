import 'dart:io';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'action.dart';
import 'state.dart';

Effect<HomeState> buildEffect() {
  return combineEffects(<Object, Effect<HomeState>>{
    HomeAction.event: _onEventAction,
  });
}

void _onEventAction(Action action, Context<HomeState> ctx) async {
  // FocusScope.of(ctx.context).requestFocus(FocusNode());
  // FocusScope.of(ctx.context).unfocus();
  print(
      "_onEventAction ${DateTime.now()} viewInsets: ${MediaQuery.of(ctx.context).viewInsets.bottom}");
  // final result = await SystemChannels.textInput.invokeMethod('TextInput.hide');
  print("_onEventAction invokeMethod  ${DateTime.now()}");
  // sleep(Duration(milliseconds: 100));
  Navigator.of(ctx.context)
      .pushNamed("event_list", arguments: null)
      .then((dynamic obj) {});
}

// void hideInput() async {
//   await
// }

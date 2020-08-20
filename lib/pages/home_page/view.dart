import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(HomeState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Flutter Widget"),
      centerTitle: true,
      backgroundColor: Colors.blue,
    ),
    body: SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
            onTapUp: (s) => dispatch(HomeActionCreator.enterEventAction()),
            child: Container(
                height: 60,
                color: Colors.cyan,
                child: Row(children: [
                  Expanded(
                    child: Text("Calendar Widget", textAlign: TextAlign.center),
                  )
                ])))
      ],
    )),
  );
}

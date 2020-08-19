import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_widget/utils/TimeFormatter.dart';
import 'action.dart';
import 'state.dart';
import '../event_component/state.dart';
import '../event_component/action.dart';

Effect<ListState> buildEffect() {
  return combineEffects(<Object, Effect<ListState>>{
    Lifecycle.initState: _initEvents,
    EventAction.onEdit: _onEditAction,
  });
}

void _onEditAction(Action action, Context<ListState> ctx) async {
  println("_onEditAction: ${action.payload}, ${action.payload.startTime}");
  Navigator.of(ctx.context)
      .pushNamed('event_edit', arguments: action.payload)
      .then((dynamic event) {
    println("_onEditAction result: $event");
    if (event != null) {
      ctx.dispatch(ListActionCreator.editAction(event));
    }
  });
}

void _initEvents(Action action, Context<ListState> ctx) {
  DateTime nowDate = DateTime.now();
  final List<EventState> events = <EventState>[
    EventState(
        title: "Event1",
        startTime: nowDate,
        endTime: nowDate.add(Duration(hours: 1))),
  ];
  for (var day = -15; day < 25; day += 3) {
    DateTime date = nowDate.add(Duration(days: day, minutes: day * 6));
    events.add(EventState(
        title: "Event1 ${formatDate(date)}",
        startTime: date,
        endTime: date.add(Duration(hours: 1))));
  }
  for (var day = -15; day < 25; day += 5) {
    DateTime date = nowDate.add(Duration(days: day, minutes: day * 4));
    events.add(EventState(
        title: "Event2 ${formatDate(date)}",
        startTime: date,
        endTime: date.add(Duration(hours: 1))));
  }
  events.sort((e1, e2) => e1.startTime.isBefore(e2.startTime) ? -1 : 1);
  ctx.dispatch(ListActionCreator.initAction(events));
}

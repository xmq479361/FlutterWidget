import 'dart:math';

import 'package:fish_redux/fish_redux.dart';

class EventState implements Cloneable<EventState> {
  String id;
  String title;
  String desc;
  DateTime startTime;
  DateTime endTime;
  EventState({this.id, this.title, this.desc, this.startTime, this.endTime}) {
    // id ??= Uuid().v4();t
    id ??= Random.secure().nextInt(10000000).toString();
  }
  @override
  EventState clone() {
    return EventState()
      ..id = id
      ..title = title
      ..desc = desc
      ..startTime = startTime
      ..endTime = endTime;
  }

  @override
  String toString() {
    return "EventState[$id, title: $title]";
  }
}

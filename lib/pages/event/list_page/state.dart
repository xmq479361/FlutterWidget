import 'dart:async';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'calendar_list/QCalHolder.dart';
import 'calendar_list/QCalModel.dart';

import '../event_component/state.dart';

class ListState implements Cloneable<ListState> {
  List<EventState> events;
  List<EventState> curDateEvents;
  DateTime selectDate;
  ScrollController scrollCtrl;
  Key scrollViewKey;
  QCalHolder model;

  @override
  ListState clone() {
    return ListState()
      ..events = events
      ..selectDate = selectDate
      ..scrollCtrl = scrollCtrl
      ..scrollViewKey = scrollViewKey
      ..curDateEvents = curDateEvents
      ..model = model;
  }

  void focusWeek() {
    modifyMode();
  }

  modifyMode() {
    switch (model.mode) {
      case Mode.MONTH:
        _scroll(model.fullHeight - model.centerHeight);
        break;
      case Mode.WEEK:
        _scroll(model.fullHeight - model.minHeight);
        break;
      case Mode.DETAIL:
      default:
        _scroll(-(scrollCtrl.offset));
    }
  }

  /**
   * 延时检查 是否模式切换
   */
  Timer _timer;
  _scroll(offset) {
    print("State _scroll: ${offset}");
    if (_timer != null) _timer.cancel();
    _timer = Timer(Duration(milliseconds: 2), () {
      scrollCtrl.animateTo(offset,
          duration: Duration(milliseconds: 120), curve: Curves.linear);
    });
  }

  List<EventState> dateEvents(Date date) {
    return events.where((event) {
      return Date.from(event.startTime).isEquals(date);
    }).toList();
  }
}

ListState initState(Map<String, dynamic> args) {
  DateTime now = DateTime.now();
  DateTime nextHour =
      now.add(Duration(seconds: 60 - now.second, minutes: 59 - now.minute));
  return ListState()
    ..scrollViewKey = GlobalKey()
    ..model = QCalHolder(mode: Mode.WEEK)
    ..scrollCtrl = ScrollController()
    ..selectDate = nextHour
    ..events = <EventState>[]
    ..curDateEvents = <EventState>[];
}

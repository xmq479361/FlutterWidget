import 'package:fish_redux/fish_redux.dart';
import 'calendar_list/QCalHolder.dart';

import '../event_component/state.dart';
import 'action.dart';
import 'state.dart';

Reducer<ListState> buildReducer() {
  return asReducer(
    <Object, Reducer<ListState>>{
      ListAction.initEvent: _onInitEventAction,
      ListAction.edit: _onEditAction,
      ListAction.onFocusDate: _onFocusDate,
      ListAction.onPageChanged: _onPageChanged,
    },
  );
}

bool isSameDate(DateTime dateTime, DateTime dateTime2) {
  return (dateTime.year == dateTime2.year) &&
      (dateTime.month == dateTime2.month) &&
      (dateTime.day == dateTime2.day);
}

ListState _onInitEventAction(ListState state, Action action) {
  List<EventState> events = action.payload;
  DateTime dateTime = state.selectDate;
  var curDateEvents = events.where((event) {
    return isSameDate(event.startTime, dateTime);
  }).toList();
  print("reducer: _onInitEventAction: $curDateEvents");
  final ListState newState = state.clone()
    ..events = events
    ..curDateEvents = curDateEvents;
  return newState;
}

ListState _onEditAction(ListState state, Action action) {
  final EventState event = action.payload;
  final ListState newState = state.clone();
  print("reducer: _onEditAction: ${action.payload}, ${newState.events.length}");
  newState.events.removeWhere((_event) => _event.id == event.id);
  final index = newState.events
      .indexWhere((_event) => _event.startTime.isAfter(event.startTime));
  newState.events.insert(index > 0 ? index : 0, event);
  DateTime dateTime = newState.selectDate;
  return newState
    ..curDateEvents = newState.events
        .where((event) => isSameDate(event.startTime, dateTime))
        .toList();
}

ListState _onPageChanged(ListState state, Action action) {
  print("reducer: _onPageChanged: ${action.payload} : ${state}");
  DateTime dateTime =
      action.payload.add(Duration(hours: DateTime.now().hour + 1));

  final ListState newState = state.clone()
    ..selectDate = dateTime
    ..curDateEvents = state.events
        .where((event) => isSameDate(event.startTime, dateTime))
        .toList()
    // ..model.mode = state.model.mode
    // ..model.mode = Mode.MONTH
    // ..model.mode = Mode.WEEK
    // ..modifyMode()
  ;
  // newState.focusDate(action., action.payload);
  return newState;
}

ListState _onFocusDate(ListState state, Action action) {
  print("reducer: _onFocusDate: ${action.payload}");
  DateTime dateTime =
      action.payload.add(Duration(hours: DateTime.now().hour + 1));

  final ListState newState = state.clone()
    ..selectDate = dateTime
    ..curDateEvents = state.events
        .where((event) => isSameDate(event.startTime, dateTime))
        .toList()
    ..model.mode = Mode.WEEK
    ..modifyMode()
  ;
  // newState.focusDate(action., action.payload);
  return newState;
}

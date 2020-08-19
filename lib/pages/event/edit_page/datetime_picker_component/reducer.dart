import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<DatetimePickerState> buildReducer() {
  return asReducer(
    <Object, Reducer<DatetimePickerState>>{
      DatetimePickerAction.updateStart: _updateStart,
      DatetimePickerAction.updateEnd: _updateEnd,
      DatetimePickerAction.onFocusStart: _onFocusStart,
      DatetimePickerAction.onFocusEnd: _onFocusEnd
    },
  );
}

DatetimePickerState _onFocusStart(DatetimePickerState state, Action action) {
  return state.clone()..setStartSelected(true);
}

DatetimePickerState _onFocusEnd(DatetimePickerState state, Action action) {
  return state.clone()..setEndSelected(true);
}

DatetimePickerState _updateStart(DatetimePickerState state, Action action) {
  DatetimePickerState newState = state.clone();
  print("_updateStart: ${action.payload}, ${state.endDateTime}");
  if (action.payload != null) newState.startDateTime = action.payload;
  return newState;
}

DatetimePickerState _updateEnd(DatetimePickerState state, Action action) {
  DatetimePickerState newState = state.clone();
  print("_updateEnd: ${action.payload}, ${state.startDateTime}");
  if (action.payload != null) newState.endDateTime = action.payload;
  return newState;
}

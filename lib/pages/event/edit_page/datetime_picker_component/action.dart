import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum DatetimePickerAction {
  onTapUpStart,
  onTapUpEnd,
  onFocusStart,
  onFocusEnd,
  updateStart,
  updateEnd
}

class DatetimePickerActionCreator {
  // static Action onTapUpAction(DateTime dateTime) {
  //   return Action(DatetimePickerAction.onTapUp, payload: dateTime);
  // }
  static Action onTapUpEndAction() {
    return const Action(DatetimePickerAction.onTapUpEnd);
  }

  static Action onTapUpStartAction() {
    return const Action(DatetimePickerAction.onTapUpStart);
  }

  static Action onUpdateStartAction() {
    return const Action(DatetimePickerAction.onFocusStart);
  }

  static Action onUpdateEndAction() {
    return const Action(DatetimePickerAction.onFocusEnd);
  }

  static Action updateStartAction(DateTime dateTime) {
    print("DateTimeSelectState updateStartAction: ${dateTime}");
    return Action(DatetimePickerAction.updateStart, payload: dateTime);
  }

  static Action updateEndAction(DateTime dateTime) {
    print("DateTimeSelectState updateEndAction: ${dateTime}");
    return Action(DatetimePickerAction.updateEnd, payload: dateTime);
  }
}

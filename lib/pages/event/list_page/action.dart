import 'package:fish_redux/fish_redux.dart';
import 'calendar_list/QCalModel.dart';
import '../event_component/state.dart';

//TODO replace with your own action
enum ListAction { initEvent, edit, focusDate, onFocusDate }

class ListActionCreator {
  static Action initAction(List<EventState> events) {
    return Action(ListAction.initEvent, payload: events);
  }

  static Action editAction(EventState event) {
    return Action(ListAction.edit, payload: event);
  }

  static Action focusDateAction(DateTime dateTime) {
    return Action(ListAction.focusDate, payload: dateTime);
  }

  static Action onFocusDateAction(DateTime dateTime) {
    return Action(ListAction.onFocusDate, payload: dateTime);
  }
}

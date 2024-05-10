import 'package:fish_redux/fish_redux.dart';
import '../event_component/state.dart';

enum ListAction { initEvent, edit, onFocusDate, onPageChanged }

class ListActionCreator {
  static Action initAction(List<EventState> events) {
    return Action(ListAction.initEvent, payload: events);
  }

  static Action editAction(EventState event) {
    return Action(ListAction.edit, payload: event);
  }

  static Action onPageChangedAction(DateTime dateTime) {
    return Action(ListAction.onPageChanged, payload: dateTime);
  }

  static Action onFocusDateAction(DateTime dateTime) {
    return Action(ListAction.onFocusDate, payload: dateTime);
  }
}

import 'package:fish_redux/fish_redux.dart';
import '../list_page/calendar_list/QCalModel.dart';

import 'state.dart';

//TODO replace with your own action
enum EventAction { onEdit, edit, remove }

class EventActionCreator {
  static Action onEditAction(EventState event) {
    return Action(EventAction.onEdit, payload: event);
  }

  static Action editAction(EventState event) {
    return Action(EventAction.edit, payload: event);
  }
}
